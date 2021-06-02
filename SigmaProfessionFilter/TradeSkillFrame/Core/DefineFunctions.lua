local SPF2 = SigmaProfessionFilter[2];

--Set up data table
function SPF2.GetNumTradeSkills()

	if not TradeSkillFrame:IsVisible() then
		return SPF2.baseGetNumTradeSkills();
	end
	
	local LeftSelection = SPF2:GetSelected("Left");
	if not SPF2:GetMenu("Left") and LeftSelection > 0 and #({GetTradeSkillSubClasses()}) > 1 and GetTradeSkillSubClassFilter(0) then
		UIDropDownMenu_SetSelectedID(TradeSkillSubClassDropDown, LeftSelection + 1);
		SetTradeSkillSubClassFilter(LeftSelection, 1, 1);
	end
	
	local RightSelection = SPF2:GetSelected("Right");
	if not SPF2:GetMenu("Right") and RightSelection > 0 and #({GetTradeSkillInvSlots()}) > 1 and GetTradeSkillInvSlotFilter(0) then
		UIDropDownMenu_SetSelectedID(TradeSkillInvSlotDropDown, RightSelection + 1)
		SetTradeSkillInvSlotFilter(RightSelection, 1, 1);
	end

	-- Reset the Data
	SPF2.FIRST = nil;
	SPF2.Data = {};
	SPF2.Recipes = SPF2.Recipes or {};
	SPF2.Headers = {};
	SPF2.OriginalHeaders = {};
	
	-- Start ordering the recipes
	local SkillTypes = { [1] = "difficult"; [2] = "optimal"; [3] = "medium"; [4] = "easy"; [5] = "trivial" };
	local ByType = { ["header"] = {}; ["difficult"] = {}; ["optimal"] = {}; ["medium"] = {}; ["easy"] = {}; ["trivial"] = {} };
	local Names = { ["header"] = {}; ["difficult"] = {}; ["optimal"] = {}; ["medium"] = {}; ["easy"] = {}; ["trivial"] = {} };
	local headerIndex = 0;
	
	for i=1, SPF2.baseGetNumTradeSkills() do
		
		local skillName, skillType, numAvailable = SPF2.baseGetTradeSkillInfo(i);
		SPF2.Recipes[skillName] = i; --{ skillIndex = i; }; --numAvailable = numAvailable; };
		
		if skillType == "header" then
			headerIndex = headerIndex + 1;
			ByType["header"][headerIndex] = { name = skillName };
		else
			SPF2.OriginalHeaders[i] = ByType["header"][headerIndex].name;
			
			-- IMPLEMENT CHECKS LATER
			local leftGroupID = SPF2.LeftMenu:Filter(i, SPF2:GetSelected("Left")) or headerIndex;
			local rightGroupID = SPF2.RightMenu:Filter(i, SPF2:GetSelected("Right")) or 0;
			
			-- FILTER_1
			if (not SPF2.Filter1:Filter(i))
			-- FILTER_2
				or (not SPF2.Filter2:Filter(i))
			-- SEARCH_BOX
				or not(SPF2.SearchBox:Filter(i))
			-- LEFT_DROPDOWN
				or not (SPF2:GetSelected("Left") == 0 or leftGroupID > 0)
			-- RIGHT_DROPDOWN
				or not (SPF2:GetSelected("Right") == 0 or rightGroupID > 0)
			then
				-- SKIP ELEMENTS THAT FAIL TO MATCH ALL FILTERS
			else
				local itemLink = SPF2.baseGetTradeSkillItemLink(i);
				
				if itemLink then
					local _,_,_, itemLevel, _,_, itemSubType, _, itemEquipLoc = GetItemInfo(itemLink);
					local nameWithLevel = string.format("%04d", 500 - itemLevel)..skillName;
					local info = {
						["original"] = i;
						["Left"] = leftGroupID;
						["Right"] = rightGroupID;
					};
					
					ByType[skillType][nameWithLevel] = info;
					table.insert(Names[skillType], nameWithLevel);
				end
			end
		end
	end
	
	-- Check the Chosen Grouping Scheme
	local groupBy = SPF2:SavedData()["GroupBy"] or "Left";
	
	if (groupBy == "Right" and SPF2:Custom("RightMenu")["disabled"]) then
		groupBy = "Left";
	end
	
	local Ordered = {};
	
	-- Divide the filtered recipes in groups
	for i,skillType in ipairs(SkillTypes) do
		table.sort(Names[skillType]);
		for j,skillName in ipairs(Names[skillType]) do
			
			local nameWithLevel = Names[skillType][j];
			local skillInfo = ByType[skillType][nameWithLevel];
			local groupIndex = skillInfo[groupBy];
			
			if not Ordered[groupIndex] then
				Ordered[groupIndex] = {};
			end
			
			table.insert(Ordered[groupIndex], skillInfo);
		end
	end
	
	local totalCount = 0;
	local headerCount = 0;
	
	-- Build the final order with headers
	if Ordered then
		
		local Pairs = SPF2:GetMenu(groupBy) or ByType["header"];
		
		if (groupBy == "Right" and not SPF2:GetMenu("Right")) then
			Pairs = {};
			for i,slot in ipairs({GetTradeSkillInvSlots()}) do
				table.insert( Pairs, { name = slot; } );
			end
		end
		
		if (groupBy == "Left" and SPF2:Custom("LeftMenu")["disabled"]) then
			Pairs = { [1] = { name = ""; } };
		end
		
		for i,button in ipairs(Pairs) do
			local group = button.name;
			local items = Ordered[i];
			
			if items then
				-- Add the Header
				if (#group > 0) then
					headerCount = headerCount + 1;
					totalCount = totalCount + 1;
					SPF2.Headers[headerCount] = totalCount;
				
					SPF2.Data[totalCount] = {
						["skillName"] = group;
						["skillType"] = "header";
						["numAvailable"] = 0;
					};
				end
				
				if (SPF2.Collapsed and SPF2.Collapsed[group]) then
					SPF2.Data[totalCount]["isExpanded"] = false;
				else
					if (#group > 0) then
						SPF2.Data[totalCount]["isExpanded"] = true;
					end
					
					for j,skillInfo in ipairs(items) do
						totalCount = totalCount + 1;
						
						if (not SPF2.FIRST) then 
							SPF2.FIRST = totalCount;
						end
						
						SPF2.Data[totalCount] = skillInfo;
					end
				end
			end
		end
	end
	
	-- Leatrix Plus Compatibility
	if LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On" then
		if SPF2.FIRST and #SPF2.Headers == 0 then
			TRADE_SKILLS_DISPLAYED = 23;
		else 
			TRADE_SKILLS_DISPLAYED = 22;
		end
	end
	
	return totalCount;
end

-- Get TradeSkill Info
function SPF2.GetTradeSkillInfo(skillIndex)
	
	-- If The Profession is supported
	if (SPF2.Data and SPF2.Data[skillIndex]) then
		if not SPF2.Data[skillIndex]["original"] then
			return SPF2.Data[skillIndex]["skillName"], SPF2.Data[skillIndex]["skillType"], SPF2.Data[skillIndex]["numAvailable"], SPF2.Data[skillIndex]["isExpanded"];
		else
			return SPF2.baseGetTradeSkillInfo(SPF2.Data[skillIndex]["original"]);
		end
	end
	
	return SPF2.baseGetTradeSkillInfo(skillIndex);
end

-- Expand
function SPF2.ExpandTradeSkillSubClass(skillIndex)
	
	-- if the skillIndex is zero we need to expand all headers
	if (skillIndex == 0) then
		-- Expand in reverse order otherwise it's a mess
		for i=#SPF2.Headers, 1, -1 do
			SPF2.ExpandTradeSkillSubClass(SPF2.Headers[i]);
		end
		
	-- otherwise expand this header
	elseif (SPF2.Data and SPF2.Data[skillIndex]) then
		-- if this is a header
		local skillType = SPF2.Data[skillIndex]["skillType"];
		local skillName = SPF2.Data[skillIndex]["skillName"];
		
		if (skillType == "header") then
			-- Remove if fom the list of collapsed headers
			
			if (SPF2.Collapsed == nil) then
				SPF2.Collapsed = {};
			end
			
			SPF2.Collapsed[skillName] = nil;
		end
	end
	
    SPF2.FullUpdate();
end

-- Collapse
function SPF2.CollapseTradeSkillSubClass(skillIndex)
	
	-- if the skillIndex is zero we need to collapse all headers
	if (skillIndex == 0) then
		-- Collapse in reverse order otherwise it's a mess
		for i=#SPF2.Headers, 1, -1 do
			SPF2.CollapseTradeSkillSubClass(SPF2.Headers[i]);
		end
		
	-- otherwise collapse this header
	elseif (SPF2.Data and SPF2.Data[skillIndex]) then
		-- if this is a header
		local skillType = SPF2.Data[skillIndex]["skillType"];
		local skillName = SPF2.Data[skillIndex]["skillName"];
		
		if (skillType == "header") then
			-- Set Collapsed To False
			
			if (SPF2.Collapsed == nil) then
				SPF2.Collapsed = {};
			end
			
			SPF2.Collapsed[skillName] = true;
		end
	end
	
    SPF2.FullUpdate();
end

-- Select TradeSkill
function SPF2.TradeSkillFrame_SetSelection(skillIndex)
	SPF2.SELECTED = skillIndex;
	TradeSkillFrame.selectedSkill = skillIndex;
	
	return SPF2.baseTradeSkillFrame_SetSelection(skillIndex);
end

function SPF2.GetTradeSkillSelectionIndex()
	
	if SPF2.SELECTED then
		return SPF2.SELECTED;
	end
	return SPF2.baseGetTradeSkillSelectionIndex();
end

-- Crafting
function SPF2.GetTradeSkillNumReagents(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] then
		if SPF2.Data[skillIndex]["original"] then
			return SPF2.baseGetTradeSkillNumReagents(SPF2.Data[skillIndex]["original"]);
		else
			return 0;
		end
	end
	return SPF2.baseGetTradeSkillNumReagents(skillIndex);
end

function SPF2.TradeSkillCreateButton_OnClick()

	if SPF2.Data and SPF2.SELECTED and SPF2.Data[SPF2.SELECTED] then
		DoTradeSkill(SPF2.Data[SPF2.SELECTED]["original"], SPF2.GetTradeskillRepeatCount());
	else
		DoTradeSkill(TradeSkillFrame.selectedSkill, SPF2.GetTradeskillRepeatCount());
	end
	TradeSkillInputBox:ClearFocus();
end

function SPF2.TradeSkillCreateAllButton_OnClick()
	TradeSkillInputBox:SetNumber(TradeSkillFrame.numAvailable);
	
	if SPF2.Data and SPF2.SELECTED and SPF2.Data[SPF2.SELECTED] then
		DoTradeSkill(SPF2.Data[SPF2.SELECTED]["original"], TradeSkillInputBox:GetNumber());
	else
		DoTradeSkill(TradeSkillFrame.selectedSkill, TradeSkillInputBox:GetNumber());
	end
	TradeSkillInputBox:ClearFocus();
end

function SPF2.GetTradeSkillReagentInfo(skillIndex, i)
	if SPF2.Data and SPF2.Data[skillIndex] and SPF2.Data[skillIndex]["original"] then
		return SPF2.baseGetTradeSkillReagentInfo(SPF2.Data[skillIndex]["original"], i);
	end
	return SPF2.baseGetTradeSkillReagentInfo(skillIndex, i);
end

function SPF2.GetTradeSkillIcon(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] and SPF2.Data[skillIndex]["original"] then
		return SPF2.baseGetTradeSkillIcon(SPF2.Data[skillIndex]["original"]);
	end
	return SPF2.baseGetTradeSkillIcon(skillIndex);
end

function SPF2.GetTradeSkillNumMade(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] and SPF2.Data[skillIndex]["original"] then
		return SPF2.baseGetTradeSkillNumMade(SPF2.Data[skillIndex]["original"]);
	end
	return SPF2.baseGetTradeSkillNumMade(skillIndex);
end

function SPF2.GetTradeSkillTools(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] and SPF2.Data[skillIndex]["original"] then
		return SPF2.baseGetTradeSkillTools(SPF2.Data[skillIndex]["original"]);
	end
	return SPF2.baseGetTradeSkillTools(skillIndex);
end

function SPF2.GetTradeskillRepeatCount()
	
	if not TradeSkillFrame.numAvailable then
		return 1;
	end
	
	if TradeSkillFrame.numAvailable < 1 then
		return 1;
	end
	
	local requiredNumber = TradeSkillInputBox:GetNumber();
	
	if TradeSkillFrame.numAvailable < requiredNumber then
		TradeSkillInputBox:SetNumber(TradeSkillFrame.numAvailable);
	end
	
	return TradeSkillInputBox:GetNumber();
end;

function SPF2.TradeSkillFrame_OnShow(self)
	-- Check if the TradeSkill has changed
	if SPF2.TradeSkillName and SPF2.TradeSkillName ~= GetTradeSkillName() then
		SPF2.FullUpdate();
	end
	SPF2.TradeSkillName = GetTradeSkillName();
end

function SPF2.GetTradeSkillItemLink(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] and SPF2.Data[skillIndex]["original"] then
		return SPF2.baseGetTradeSkillItemLink(SPF2.Data[skillIndex]["original"]);
	end
	return SPF2.baseGetTradeSkillItemLink(skillIndex);
end

function SPF2.GetTradeSkillReagentItemLink(skillIndex, reagentIndex)
	if SPF2.Data and SPF2.Data[skillIndex] and SPF2.Data[skillIndex]["original"] then
		return SPF2.baseGetTradeSkillReagentItemLink(SPF2.Data[skillIndex]["original"], reagentIndex);
	end
	return SPF2.baseGetTradeSkillReagentItemLink(skillIndex, reagentIndex);
end

function SPF2.GetFirstTradeSkill()
	
	if not (SPF2.Data and #SPF2.Data > 0)then
		SPF2.GetNumTradeSkills();
	end
	
	if SPF2.FIRST then
		return SPF2.FIRST;
	end
	
	return SPF2.baseGetFirstTradeSkill();
end

function SPF2.GetTradeSkillItemInfo(skillIndex)
	return GetItemInfo(SPF2.GetTradeSkillItemLink(skillIndex));
end

function SPF2.baseGetTradeSkillItemInfo(skillIndex)
	local itemLink = SPF2.baseGetTradeSkillItemLink(skillIndex);
	return GetItemInfo(itemLink);
end

function SPF2.GetTradeSkillItemSubClass(skillIndex)
	local itemLink = SPF2.GetTradeSkillItemLink(skillIndex);
	return select(6,GetItemInfo(itemLink)).."_"..select(7,GetItemInfo(itemLink));
end

function SPF2.baseGetTradeSkillItemSubClass(skillIndex)
	local itemLink = SPF2.baseGetTradeSkillItemLink(skillIndex);
	return select(6,GetItemInfo(itemLink)).."_"..select(7,GetItemInfo(itemLink));
end

SPF2.GameTooltip = {};
function SPF2.GameTooltip.SetTradeSkillItem(this, skillIndex, reagentIndex)
	if SPF2.Data and SPF2.Data[skillIndex] and SPF2.Data[skillIndex]["original"] then
		return SPF2.GameTooltip.baseSetTradeSkillItem(this, SPF2.Data[skillIndex]["original"], reagentIndex);
	end
	return SPF2.GameTooltip.baseSetTradeSkillItem(this, skillIndex, reagentIndex);
end
