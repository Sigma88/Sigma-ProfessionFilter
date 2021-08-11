local SPF2 = SigmaProfessionFilter[2];

TradeSkillTypeColor["unlearned"] = { r = 1.00, g = 0, b = 0, font = "GameFontNormalLeftRed" };  

-- Set up data table
function SPF2.GetNumTradeSkills()
	
	if not TradeSkillFrame:IsVisible() then
		return SPF2.baseGetNumTradeSkills();
	end
	
	if not SPF2.FILTERED then
		
		local LeftSelection = SPF2:GetSelected("Left");
		local RightSelection = SPF2:GetSelected("Right");
		
		-- Reset the Data
		SPF2.FIRST = nil;
		SPF2.Data = {};
		SPF2.Recipes = {};
		SPF2.CraftedItems = {};
		SPF2.Headers = {};
		SPF2.OriginalHeaders = {};
		
		-- Start ordering the recipes
		local SkillTypes = { [1] = "unlearned"; [2] = "difficult"; [3] = "optimal"; [4] = "medium"; [5] = "easy"; [6] = "trivial"; [7] = "none"; };
		local ByType = { ["header"] = {}; ["unlearned"] = {}; ["difficult"] = {}; ["optimal"] = {}; ["medium"] = {}; ["easy"] = {}; ["trivial"] = {}; ["none"] = {} };
		local Names = { ["header"] = {}; ["unlearned"] = {}; ["difficult"] = {}; ["optimal"] = {}; ["medium"] = {}; ["easy"] = {}; ["trivial"] = {}; ["none"] = {} };
		local headerIndex = 0;
		
		for i=1, SPF2.baseGetNumTradeSkills() do
			
			local skillName, skillType = SPF2.baseGetTradeSkillInfo(i);
			SPF2.Recipes[skillName] = i;
			
			local craftedItem = SPF2.baseGetTradeSkillItemInfo(i);
			
			if craftedItem then
				SPF2.CraftedItems[craftedItem] = i;
			end
		end
		
		for i=1, SPF2.baseGetNumTradeSkills() do
			
			local skillName, skillType = SPF2.baseGetTradeSkillInfo(i);
			
			if skillType == "header" then
				headerIndex = headerIndex + 1;
				ByType["header"][headerIndex] = { name = skillName };
			else
				SPF2.OriginalHeaders[i] = ByType["header"][headerIndex].name;
				
				-- IMPLEMENT CHECKS LATER
				local leftGroupID = SPF2.LeftMenu:Filter(i, LeftSelection) or headerIndex;
				local rightGroupID = SPF2.RightMenu:Filter(i, RightSelection) or 0;
				
				-- FILTER_1
				if (not SPF2.Filter1:Filter(i))
				-- FILTER_2
					or (not SPF2.Filter2:Filter(i))
				-- STARRED
					or (not SPF2.Starred:Filter(skillName))
				-- SEARCH_BOX
					or not(SPF2.SearchBox:Filter(i))
				-- LEFT_DROPDOWN
					or not (LeftSelection == 0 or LeftSelection == leftGroupID)
				-- RIGHT_DROPDOWN
					or not (RightSelection == 0 or RightSelection == rightGroupID)
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
						if not ByType[skillType] then
							table.insert(SkillTypes, skillType);
							ByType[skillType] = {};
							Names[skillType] = {};
						end
						ByType[skillType][nameWithLevel] = info;
						table.insert(Names[skillType], nameWithLevel);
					end
				end
			end
		end
		
		if SPF2:SavedData()["Unlearned"] then
			
			for spellID,spellData in pairs(SPF2.GetRecipeInfo() or {}) do
				local skillName, rank, icon = GetSpellInfo(spellID);
				
				if not SPF2.Recipes[skillName] and SPF2.Starred:Filter(skillName) then
					-- IMPLEMENT CHECKS LATER
					local leftGroupID = SPF2.LeftMenu:FilterSpell(spellID, LeftSelection) or 0;
					local rightGroupID = SPF2.RightMenu:FilterSpell(spellID, RightSelection) or 0;
					
					-- FILTER_1
					if (not SPF2.Filter1:FilterSpell(spellID))
					-- FILTER_2
						or (not SPF2.Filter2:FilterSpell(spellID))
						-- SEARCH_BOX
						or not(SPF2.SearchBox:FilterSpell(spellID))
					-- LEFT_DROPDOWN
						or not (LeftSelection == 0 or LeftSelection == leftGroupID)
					-- RIGHT_DROPDOWN
						or not (RightSelection == 0 or RightSelection == rightGroupID)
					then
						-- SKIP ELEMENTS THAT FAIL TO MATCH ALL FILTERS
					else
						local learnedAt = spellData["learnedAt"] or 0;
						local nameWithLevel = string.format("%04d", 999 - learnedAt)..skillName;
						local skillType = "unlearned";
						local numReagents = 0;
						if spellData["reagents"] then
							numReagents = #spellData["reagents"];
						end
						if spellData["creates"] then
							icon = select(10, GetItemInfo(spellData["creates"]));
						end
						local info = {
							["skillName"] = skillName;
							["rank"] = spellData["rank"];
							["skillType"] = skillType;
							["numAvailable"] = 0;
							["trainingPointCost"] = 0;
							["requiredLevel"] = 0;
							["icon"] = icon;
							["spellID"] = spellID;
							["reagents"] = spellData["reagents"];
							["numReagents"] = numReagents;
							["learnedAt"] = learnedAt;
							["levels"] = spellData["levels"];
							["tools"] = spellData["tools"];
							["creates"] = spellData["creates"];
							["Left"] = leftGroupID;
							["Right"] = rightGroupID;
						};
						if not ByType[skillType] then
							table.insert(SkillTypes, skillType);
							ByType[skillType] = {};
							Names[skillType] = {};
						end
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
			for j,nameWithLevel in ipairs(Names[skillType]) do
				
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
			
			if (groupBy == "Left" and not SPF2:GetMenu("Left")) then
				Pairs = {};
				for i,slot in ipairs({GetTradeSkillSubClasses()}) do
					table.insert( Pairs, { name = slot; } );
				end
			end
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
							["headerIndex"] = headerCount;
							["numAvailable"] = 0;
						};
					end
					
					if (SPF2.Collapsed and SPF2.Collapsed[headerCount]) then
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
		
		if totalCount > 0 then
			SPF2.FILTERED = totalCount;
		end
		
	end
	
	return SPF2.FILTERED or 0;
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
function SPF2.ExpandTradeSkillSubClass(skillIndex, skipUpdate)
	
	-- if the skillIndex is zero we need to expand all headers
	if (skillIndex == 0) then
		-- Expand in reverse order otherwise it's a mess
		for i=#SPF2.Headers, 1, -1 do
			SPF2.ExpandTradeSkillSubClass(SPF2.Headers[i], true);
		end
		SPF2.FullUpdate(true);
		return;
		
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
			
			SPF2.Collapsed[SPF2.Data[skillIndex]["headerIndex"]] = nil;
		end
	end
	
	if not skipUpdate then
		SPF2.FullUpdate(true);
		SPF2.ONCLICK = skillIndex;
	end
end

-- Collapse
function SPF2.CollapseTradeSkillSubClass(skillIndex, skipUpdate)
	
	-- if the skillIndex is zero we need to collapse all headers
	if (skillIndex == 0) then
		-- Collapse in reverse order otherwise it's a mess
		for i=#SPF2.Headers, 1, -1 do
			SPF2.CollapseTradeSkillSubClass(SPF2.Headers[i], true);
		end
		
		SPF2.FullUpdate(true);
		return;
		
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
			
			SPF2.Collapsed[SPF2.Data[skillIndex]["headerIndex"]] = true;
		end
	end
	
	if not skipUpdate then
		SPF2.FullUpdate(true);
		SPF2.ONCLICK = skillIndex;
	end
end

-- Select TradeSkill
function SPF2.TradeSkillFrame_SetSelection(skillIndex)
	SPF2.SELECTED = skillIndex;
	TradeSkillFrame.selectedSkill = skillIndex;
	
	SPF2.baseTradeSkillFrame_SetSelection(skillIndex);
	SPF2.SetTradeSkillDescription(skillIndex);
	
	if (SPF2.Data and SPF2.Data[skillIndex]) then
		if not SPF2.Data[skillIndex]["original"] then
			TradeSkillCreateButton:Disable();
			TradeSkillCreateAllButton:Disable();
		end
	end
end

function SPF2.GetTradeSkillSelectionIndex()
	
	if SPF2.SELECTED then
		return SPF2.SELECTED;
	end
	return SPF2.baseGetTradeSkillSelectionIndex();
end

function SPF2.TradeSkillSkillButton_OnClick(self, ...)
	SPF2.ONCLICK = self:GetID();
	SPF2.baseTradeSkillSkillButton_OnClick(self, ...);
end

-- Crafting
function SPF2.GetTradeSkillNumReagents(skillIndex, base)
	if base ~= true and SPF2.Data and SPF2.Data[skillIndex] then
		if SPF2.Data[skillIndex]["original"] then
			return SPF2.baseGetTradeSkillNumReagents(SPF2.Data[skillIndex]["original"]);
		else
			return SPF2.Data[skillIndex]["numReagents"] or 0;
		end
	end
	return SPF2.baseGetTradeSkillNumReagents(skillIndex);
end

function SPF2.TradeSkillCreateButton_OnClick()

	if SPF2.Data and SPF2.SELECTED and SPF2.Data[SPF2.SELECTED] and SPF2.Data[SPF2.SELECTED]["original"] then
		DoTradeSkill(SPF2.Data[SPF2.SELECTED]["original"], SPF2.GetTradeskillRepeatCount());
	else
		DoTradeSkill(TradeSkillFrame.selectedSkill, SPF2.GetTradeskillRepeatCount());
	end
	TradeSkillInputBox:ClearFocus();
end

function SPF2.TradeSkillCreateAllButton_OnClick()
	TradeSkillInputBox:SetNumber(TradeSkillFrame.numAvailable);
	
	if SPF2.Data and SPF2.SELECTED and SPF2.Data[SPF2.SELECTED] and SPF2.Data[SPF2.SELECTED]["original"] then
		DoTradeSkill(SPF2.Data[SPF2.SELECTED]["original"], TradeSkillInputBox:GetNumber());
	else
		DoTradeSkill(TradeSkillFrame.selectedSkill, TradeSkillInputBox:GetNumber());
	end
	TradeSkillInputBox:ClearFocus();
end

function SPF2.GetTradeSkillReagentInfo(skillIndex, reagentIndex, base)
	if base ~= true and SPF2.Data and SPF2.Data[skillIndex] then
		if not SPF2.Data[skillIndex]["original"] then
			if SPF2.Data[skillIndex]["reagents"] then
				if SPF2.Data[skillIndex]["reagents"][reagentIndex] then
					local reagentID = SPF2.Data[skillIndex]["reagents"][reagentIndex]["itemID"];
					local reagentName, _,_,_,_,_,_,_,_, texturePath = GetItemInfo(reagentID);
					local numRequired = SPF2.Data[skillIndex]["reagents"][reagentIndex]["numRequired"];
					local numHave = GetItemCount(reagentID);
					return reagentName, texturePath, numRequired, numHave;
				end
			end
			return;
		end
		return SPF2.baseGetTradeSkillReagentInfo(SPF2.Data[skillIndex]["original"], reagentIndex);
	end
	return SPF2.baseGetTradeSkillReagentInfo(skillIndex, reagentIndex);
end

function SPF2.GetTradeSkillCooldown(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] then
		if not SPF2.Data[skillIndex]["original"] then
			return;
		end
		return SPF2.baseGetTradeSkillCooldown(SPF2.Data[skillIndex]["original"]);
	end
	return SPF2.baseGetTradeSkillCooldown(skillIndex, i);
end

function SPF2.GetTradeSkillIcon(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] then
		if not SPF2.Data[skillIndex]["original"] then
			return SPF2.Data[skillIndex]["icon"];
		end
		return SPF2.baseGetTradeSkillIcon(SPF2.Data[skillIndex]["original"]);
	end
	return SPF2.baseGetTradeSkillIcon(skillIndex);
end

function SPF2.GetTradeSkillNumMade(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] then
		if not SPF2.Data[skillIndex]["original"] then
			return 0, 0;
		end
		return SPF2.baseGetTradeSkillNumMade(SPF2.Data[skillIndex]["original"]);
	end
	return SPF2.baseGetTradeSkillNumMade(skillIndex);
end

function SPF2.GetTradeSkillTools(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] then
		if not SPF2.Data[skillIndex]["original"] then
			if SPF2.Data[skillIndex]["tools"] then
				local tools = {};
				for i,toolID in ipairs(SPF2.Data[skillIndex]["tools"]) do
					local toolName = GetItemInfo(toolID);
					table.insert(tools, toolName);
					table.insert(tools, GetItemCount(toolID));
				end
				return unpack(tools);
			end
			return;
		end
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
end

function SPF2.TradeSkillFrame_OnShow(self)
	SPF2.FullUpdate();
end

function SPF2.GetTradeSkillItemLink(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] then
		if not SPF2.Data[skillIndex]["original"] then
			if SPF2.Data[skillIndex]["creates"] then
				local itemName, itemLink = GetItemInfo(SPF2.Data[skillIndex]["creates"]);
				return itemLink;
			end
			
			local spellID = SPF2.Data[skillIndex]["spellID"];
			if spellID then
				local spellName = GetSpellInfo(spellID);
				return "|cffffd000|Henchant:"..spellID.."|h["..spellName.."]|h|r";
			end
			return;
		end
		return SPF2.baseGetTradeSkillItemLink(SPF2.Data[skillIndex]["original"]);
	end
	return SPF2.baseGetTradeSkillItemLink(skillIndex);
end

function SPF2.GetTradeSkillReagentItemLink(skillIndex, reagentIndex, base)
	if base ~= true and SPF2.Data and SPF2.Data[skillIndex] then
		if not SPF2.Data[skillIndex]["original"] then

			local reagents = SPF2.Data[skillIndex]["reagents"];
			
			if reagents then
				if reagents[reagentIndex] then
					local itemName, itemLink = GetItemInfo(reagents[reagentIndex]["itemID"]);
					return itemLink;
				end
			end
			
			return;
		end
		return SPF2.baseGetTradeSkillReagentItemLink(SPF2.Data[skillIndex]["original"], reagentIndex);
	end
	return SPF2.baseGetTradeSkillReagentItemLink(skillIndex, reagentIndex);
end

function SPF2.GetTradeSkillRecipeLink(skillIndex)
	if SPF2.Data and SPF2.Data[skillIndex] then
		if not SPF2.Data[skillIndex]["original"] then
			local spellID = SPF2.Data[skillIndex]["spellID"];
			if spellID then
				local spellName = GetSpellInfo(spellID);
				return "|cffffd000|Henchant:"..spellID.."|h["..GetTradeSkillName()..": "..spellName.."]|h|r";
			end
			return;
		end
		
		return SPF2.baseGetTradeSkillRecipeLink(SPF2.Data[skillIndex]["original"]);
	end
	return SPF2.baseGetTradeSkillRecipeLink(skillIndex);
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
	if itemLink then
		return GetItemInfo(itemLink);
	end
end

function SPF2.GetTradeSkillItemSubClass(skillIndex)
	local itemLink = SPF2.GetTradeSkillItemLink(skillIndex);
	return select(6,GetItemInfo(itemLink)).."_"..select(7,GetItemInfo(itemLink));
end

function SPF2.baseGetTradeSkillItemSubClass(skillIndex)
	local itemLink = SPF2.baseGetTradeSkillItemLink(skillIndex);
	return select(6,GetItemInfo(itemLink)).."_"..select(7,GetItemInfo(itemLink));
end

function SPF2.SetTradeSkillItem(this, skillIndex, reagentIndex)
	if SPF2.Data and SPF2.Data[skillIndex] then
		if not SPF2.Data[skillIndex]["original"] then
			if reagentIndex then
				local reagents = SPF2.Data[skillIndex]["reagents"];
				if reagents then
					if reagents[reagentIndex] then
						return this:SetItemByID(reagents[reagentIndex]["itemID"]);
					end
				end
			else
				if SPF2.Data[skillIndex]["creates"] then
					return this:SetItemByID(SPF2.Data[skillIndex]["creates"]);
				end
				if SPF2.Data[skillIndex]["spellID"] then
					return this:SetSpellByID(SPF2.Data[skillIndex]["spellID"]);
				end
			end
			return;
		end
		return SPF2.baseSetTradeSkillItem(this, SPF2.Data[skillIndex]["original"], reagentIndex);
	end
	return SPF2.baseSetTradeSkillItem(this, skillIndex, reagentIndex);
end

function SPF2.SetTradeSkillDescription(skillIndex)
	TradeSkillReagentLabel:Show();
	TradeSkillReagentLabel:SetText("|cffffffff"..SPF2.GetTradeSkillDescription(skillIndex).."|r"..SPELL_REAGENTS);
	TradeSkillReagentLabel:SetJustifyH("LEFT");
end

function SPF2.GetTradeSkillDescription(skillIndex)
	-- If The Profession is supported
	if (SPF2.Data and SPF2.Data[skillIndex]) then
		if not SPF2.Data[skillIndex]["original"] then
			if SPF2.Data[skillIndex]["spellID"] then
				local spellID = SPF2.Data[skillIndex]["spellID"];
				
				local learnedAt = SPF2.Data[skillIndex]["learnedAt"];
				if learnedAt then
					local color = "|cffffffff";
					if select(2,GetTradeSkillLine()) < learnedAt then
						color = "|cffff0000";
					end
					learnedAt = color.."Requires "..GetTradeSkillName().." ("..learnedAt..")|r\n\n";
				end
				
				local levels = SPF2.Data[skillIndex]["levels"];
				local difficulty = nil;
				
				if levels then
					difficulty = "|cffffd100Difficulty:|r |cffff8040"..levels[1].."|r ".."|cffffff00"..levels[2].."|r ".."|cff40bf40"..levels[3].."|r ".."|cff808080"..levels[4].."|r\n\n";
				end
				
				return (learnedAt or "")..(difficulty or "");
			end
			return "";
		end
		
		local difficulty = nil;
		local link = SPF2.baseGetTradeSkillRecipeLink(SPF2.Data[skillIndex]["original"]);
		
		if link then
			local spellID = tonumber(link:match("enchant:(%d*)"));
			
			if spellID then
				local levels = SPF2.GetRecipeInfo(spellID, "levels");
				
				if levels then
					difficulty = "|cffffd100Difficulty:|r |cffff8040"..(levels[1] or "0").."|r ".."|cffffff00"..(levels[2] or "0").."|r ".."|cff40bf40"..(levels[3] or "0").."|r ".."|cff808080"..(levels[4] or "0").."|r\n\n";
				end
			end
		end
		
		return (difficulty or "");
	end
	
	-- Otherwise fall back to the original
    return "";
end
