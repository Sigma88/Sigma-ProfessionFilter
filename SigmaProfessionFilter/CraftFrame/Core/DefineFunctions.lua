local SPF1 = SigmaProfessionFilter[1];

-- Set up data table
function SPF1.GetNumCrafts()
	
	if not CraftFrame:IsVisible() then
		return SPF1.baseGetNumCrafts();
	end
	
	if not SPF1.FILTERED then
		
		if not SPF1:GetMenu("Right") then
			SPF1:SavedData()["GroupBy"] = nil;
			SPF1.LeftSort:OnShow();
		end
		
		local LeftSelection = SPF1:GetSelected("Left");
		if not SPF1:GetMenu("Left") and LeftSelection > 0 and #({GetCraftSubClasses()}) > 1 and GetCraftSubClassFilter(0) then
			UIDropDownMenu_SetSelectedID(CraftSubClassDropDown, LeftSelection + 1);
			SetCraftSubClassFilter(LeftSelection, 1, 1);
		end
		
		local RightSelection = SPF1:GetSelected("Right");
		if not SPF1:GetMenu("Right") and RightSelection > 0 and #({GetCraftInvSlots()}) > 1 and GetCraftInvSlotFilter(0) then
			UIDropDownMenu_SetSelectedID(CraftInvSlotDropDown, RightSelection + 1)
			SetCraftInvSlotFilter(RightSelection, 1, 1);
		end
		
		-- Reset the Data
		SPF1.FIRST = nil;
		SPF1.Data = {};
		SPF1.Recipes = {};
		SPF1.Headers = {};
		--SPF1.OriginalHeaders = {};
		
		-- Start ordering the recipes
		local CraftTypes = { [1] = "difficult"; [2] = "optimal"; [3] = "medium"; [4] = "easy"; [5] = "trivial"; [6] = "none"; };
		local ByType = { ["header"] = {}; ["difficult"] = {}; ["optimal"] = {}; ["medium"] = {}; ["easy"] = {}; ["trivial"] = {}; ["none"] = {} };
		local Names = { ["header"] = {}; ["difficult"] = {}; ["optimal"] = {}; ["medium"] = {}; ["easy"] = {}; ["trivial"] = {}; ["none"] = {} };
		local headerIndex = 0;
		
		for i=1, SPF1.baseGetNumCrafts() do
			
			--local craftName, craftType, numAvailable = SPF1.baseGetCraftInfo(i);
			local craftName, craftSubSpellName, craftType, numAvailable = SPF1.baseGetCraftInfo(i);
			SPF1.Recipes[craftName] = i; -- { craftIndex = i; }; -- numAvailable = numAvailable; };
			
			if craftType == "header" then
				headerIndex = headerIndex + 1;
				ByType["header"][headerIndex] = { name = craftName };
			else
				--SPF1.OriginalHeaders[i] = ByType["header"][headerIndex].name;
				
				-- IMPLEMENT CHECKS LATER
				local leftGroupID = SPF1.LeftMenu:Filter(i, SPF1:GetSelected("Left")) or headerIndex;
				local rightGroupID = SPF1.RightMenu:Filter(i, SPF1:GetSelected("Right")) or 0;
				
				-- FILTER_1
				if (not SPF1.Filter1:Filter(i))
				-- FILTER_2
					or (not SPF1.Filter2:Filter(i))
				-- SEARCH_BOX
					or not(SPF1.SearchBox:Filter(i))
				-- LEFT_DROPDOWN
					or not (SPF1:GetSelected("Left") == 0 or leftGroupID > 0)
				-- RIGHT_DROPDOWN
					or not (SPF1:GetSelected("Right") == 0 or rightGroupID > 0)
				then
					-- SKIP ELEMENTS THAT FAIL TO MATCH ALL FILTERS
				else
					local nameWithLevel = string.format("%04d", i)..craftName;
					local info = {
						["original"] = i;
						["Left"] = leftGroupID;
						["Right"] = rightGroupID;
					};
					if not ByType[craftType] then
						table.insert(CraftTypes, craftType);
						ByType[craftType] = {};
						Names[craftType] = {};
					end
					ByType[craftType][nameWithLevel] = info;
					table.insert(Names[craftType], nameWithLevel);
				end
			end
		end
		
		-- Check the Chosen Grouping Scheme
		local groupBy = SPF1:SavedData()["GroupBy"] or "Left";
		
		if (groupBy == "Right" and (not SPF1:GetMenu("Right"))) then
			groupBy = "Left";
		end
		
		local Ordered = {};
		
		-- Divide the filtered recipes in groups
		for i,craftType in ipairs(CraftTypes) do
			table.sort(Names[craftType]);
			for j,nameWithLevel in ipairs(Names[craftType]) do
				
				local craftInfo = ByType[craftType][nameWithLevel];
				local groupIndex = craftInfo[groupBy];
				
				if not Ordered[groupIndex] then
					Ordered[groupIndex] = {};
				end
				
				table.insert(Ordered[groupIndex], craftInfo);
			end
		end
		
		local totalCount = 0;
		local headerCount = 0;
		
		-- Build the final order with headers
		if Ordered then
			
			local Pairs = SPF1:GetMenu(groupBy) or ByType["header"];
			
			if (groupBy == "Right" and not SPF1:GetMenu("Right")) then
				Pairs = {};
				for i,slot in ipairs({GetCraftInvSlots()}) do
					table.insert( Pairs, { name = slot; } );
				end
			end
			
			if (groupBy == "Left" and (not SPF1:GetMenu("Left"))) then
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
						SPF1.Headers[headerCount] = totalCount;
					
						SPF1.Data[totalCount] = {
							["craftName"] = group;
							["craftSubSpellName"] = "";
							["craftType"] = "header";
							["headerIndex"] = headerCount;
							["numAvailable"] = 0;
						};
					end
					
					if (SPF1.Collapsed and SPF1.Collapsed[headerCount]) then
						SPF1.Data[totalCount]["isExpanded"] = false;
					else
						if (#group > 0) then
							SPF1.Data[totalCount]["isExpanded"] = true;
						end
						
						for j,craftInfo in ipairs(items) do
							totalCount = totalCount + 1;
							
							if (not SPF1.FIRST) then
								SPF1.FIRST = totalCount;
							end
							
							SPF1.Data[totalCount] = craftInfo;
						end
					end
				end
			end
		end
		
		-- Leatrix Plus Compatibility
		if LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On" then
			if SPF1.FIRST and #SPF1.Headers == 0 then
				TRADE_SKILLS_DISPLAYED = 23;
			else
				TRADE_SKILLS_DISPLAYED = 22;
			end
		end
		
		if totalCount > 0 then
			SPF1.FILTERED = totalCount;
		end
		
	end
	
	return SPF1.FILTERED or 0;
end

-- Get Craft Info
function SPF1.GetCraftInfo(craftIndex)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			return SPF1.Data[craftIndex]["craftName"], SPF1.Data[craftIndex]["craftSubSpellName"], SPF1.Data[craftIndex]["craftType"], SPF1.Data[craftIndex]["numAvailable"], SPF1.Data[craftIndex]["isExpanded"];
		else
			return SPF1.baseGetCraftInfo(SPF1.Data[craftIndex]["original"]);
		end
	end
	
	return SPF1.baseGetCraftInfo(craftIndex);
end

-- Expand
function SPF1.ExpandCraftSkillLine(craftIndex, skipUpdate)
	
	-- if the craftIndex is zero we need to expand all headers
	if (craftIndex == 0) then
		-- Expand in reverse order otherwise it's a mess
		for i=#SPF1.Headers, 1, -1 do
			SPF1.ExpandCraftSkillLine(SPF1.Headers[i], true);
		end
		SPF1.FullUpdate(true);
		return;
		
	-- otherwise expand this header
	elseif (SPF1.Data and SPF1.Data[craftIndex]) then
		-- if this is a header
		local craftType = SPF1.Data[craftIndex]["craftType"];
		local craftName = SPF1.Data[craftIndex]["craftName"];
		
		if (craftType == "header") then
			-- Remove if fom the list of collapsed headers
			
			if (SPF1.Collapsed == nil) then
				SPF1.Collapsed = {};
			end
			
			SPF1.Collapsed[SPF1.Data[craftIndex]["headerIndex"]] = nil;
		end
	end
	
	if not skipUpdate then
		SPF1.FullUpdate(true);
		SPF1.ONCLICK = craftIndex;
	end
end

-- Collapse
function SPF1.CollapseCraftSkillLine(craftIndex, skipUpdate)
	
	-- if the craftIndex is zero we need to collapse all headers
	if (craftIndex == 0) then
		-- Collapse in reverse order otherwise it's a mess
		for i=#SPF1.Headers, 1, -1 do
			SPF1.CollapseCraftSkillLine(SPF1.Headers[i], true);
		end
		
		SPF1.FullUpdate(true);
		return;
		
	-- otherwise collapse this header
	elseif (SPF1.Data and SPF1.Data[craftIndex]) then
		-- if this is a header
		local craftType = SPF1.Data[craftIndex]["craftType"];
		
		if (craftType == "header") then
			-- Set Collapsed To False
			
			if (SPF1.Collapsed == nil) then
				SPF1.Collapsed = {};
			end
			
			SPF1.Collapsed[SPF1.Data[craftIndex]["headerIndex"]] = true;
		end
	end
	
	if not skipUpdate then
		SPF1.FullUpdate(true);
		SPF1.ONCLICK = craftIndex;
	end
end

-- Select Craft
function SPF1.CraftFrame_SetSelection(craftIndex)
	SPF1.SELECTED = craftIndex;
	CraftFrame.selectedCraft = craftIndex;
	
	return SPF1.baseCraftFrame_SetSelection(craftIndex);
end

function SPF1.GetCraftSelectionIndex()
	
	if SPF1.SELECTED then
		return SPF1.SELECTED;
	end
	return SPF1.baseGetCraftSelectionIndex();
end

function SPF1.CraftButton_OnClick(self, ...)
	SPF1.ONCLICK = self:GetID();
	SPF1.baseCraftButton_OnClick(self, ...);
end

-- Crafting
function SPF1.GetCraftNumReagents(craftIndex)
	if SPF1.Data and SPF1.Data[craftIndex] then
		if SPF1.Data[craftIndex]["original"] then
			return SPF1.baseGetCraftNumReagents(SPF1.Data[craftIndex]["original"]);
		else
			return 0;
		end
	end
	return SPF1.baseGetCraftNumReagents(craftIndex);
end

function SPF1.CraftCreateAllButton_OnClick()
	CraftInputBox:SetNumber(CraftFrame.numAvailable);
	
	if SPF1.Data and SPF1.SELECTED and SPF1.Data[SPF1.SELECTED] and SPF1.Data[SPF1.SELECTED]["original"] then
		DoCraft(SPF1.Data[SPF1.SELECTED]["original"], CraftInputBox:GetNumber());
	else
		DoCraft(CraftFrame.selectedCraft, CraftInputBox:GetNumber());
	end
	CraftInputBox:ClearFocus();
end

function SPF1.GetCraftReagentInfo(craftIndex, i)
	if SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseGetCraftReagentInfo(SPF1.Data[craftIndex]["original"], i);
	end
	return SPF1.baseGetCraftReagentInfo(craftIndex, i);
end

function SPF1.GetCraftCooldown(craftIndex)
	if SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseGetCraftCooldown(SPF1.Data[craftIndex]["original"]);
	end
	return SPF1.baseGetCraftCooldown(craftIndex, i);
end

function SPF1.GetCraftIcon(craftIndex)
	if SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseGetCraftIcon(SPF1.Data[craftIndex]["original"]);
	end
	return SPF1.baseGetCraftIcon(craftIndex);
end

function SPF1.GetCraftNumMade(craftIndex)
	if SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseGetCraftNumMade(SPF1.Data[craftIndex]["original"]);
	end
	return SPF1.baseGetCraftNumMade(craftIndex);
end

function SPF1.GetCraftTools(craftIndex)
	if SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseGetCraftTools(SPF1.Data[craftIndex]["original"]);
	end
	return SPF1.baseGetCraftTools(craftIndex);
end

function SPF1.GetTradecraftRepeatCount()
	
	if not CraftFrame.numAvailable then
		return 1;
	end
	
	if CraftFrame.numAvailable < 1 then
		return 1;
	end
	
	local requiredNumber = CraftInputBox:GetNumber();
	
	if CraftFrame.numAvailable < requiredNumber then
		CraftInputBox:SetNumber(CraftFrame.numAvailable);
	end
	
	return CraftInputBox:GetNumber();
end

function SPF1.CraftFrame_OnShow(self)
	SPF1.FullUpdate();
end

function SPF1.GetCraftItemLink(craftIndex)
	if SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseGetCraftItemLink(SPF1.Data[craftIndex]["original"]);
	end
	return SPF1.baseGetCraftItemLink(craftIndex);
end

function SPF1.GetCraftReagentItemLink(craftIndex, reagentIndex)
	if SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseGetCraftReagentItemLink(SPF1.Data[craftIndex]["original"], reagentIndex);
	end
	return SPF1.baseGetCraftReagentItemLink(craftIndex, reagentIndex);
end

function SPF1.GetCraftRecipeLink(craftIndex)
	if SPF1.Data and SPF1.Data[craftIndex] then
		return SPF1.baseGetCraftRecipeLink(SPF1.Data[craftIndex]["original"]);
	end
	return SPF1.baseGetCraftRecipeLink(craftIndex);
end

function SPF1.GetFirstCraft()
	
	if not (SPF1.Data and #SPF1.Data > 0) then
		SPF1.GetNumCrafts();
	end
	
	if SPF1.FIRST then
		return SPF1.FIRST;
	end
	
	return SPF1.baseGetFirstCraft();
end

function SPF1.GetCraftItemInfo(craftIndex)
	return GetItemInfo(SPF1.GetCraftItemLink(craftIndex));
end

function SPF1.baseGetCraftItemInfo(craftIndex)
	local itemLink = SPF1.baseGetCraftItemLink(craftIndex);
	return GetItemInfo(itemLink);
end

function SPF1.GetCraftItemSubClass(craftIndex)
	local itemLink = SPF1.GetCraftItemLink(craftIndex);
	return select(6,GetItemInfo(itemLink)).."_"..select(7,GetItemInfo(itemLink));
end

function SPF1.baseGetCraftItemSubClass(craftIndex)
	local itemLink = SPF1.baseGetCraftItemLink(craftIndex);
	return select(6,GetItemInfo(itemLink)).."_"..select(7,GetItemInfo(itemLink));
end

function SPF1.SetCraftItem(obj, id, reagId)
	
	-- If The Profession is supported
	local craftIndex = SPF1.GetCraftSelectionIndex();
	
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseSetCraftItem(obj, SPF1.Data[craftIndex]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseSetCraftItem(obj, id, reagId);
end

-- Crafting
function SPF1.CraftCreateButton_OnMouseDown(self, mouseBtn)
	if CraftCreateButton:IsEnabled() and mouseBtn == "LeftButton" then
		SPF1.CRAFTING = true;
		SPF1.SelectCraft(SPF1.GetCraftSelectionIndex());
	end
end

function SPF1.CraftCreateButton_OnMouseUp()
	if SPF1.CRAFTING then
		if not CraftCreateButton:IsMouseOver() then
			SPF1.CRAFTING = nil;
			SPF1.SelectCraft(SPF1.GetCraftSelectionIndex());
		end
	end
end

function SPF1.CraftCreateButton_OnClick()
	if SPF1.CRAFTING then
		SPF1.CRAFTING = nil;
		SPF1.SelectCraft(SPF1.GetCraftSelectionIndex());
	end
end

function SPF1.SelectCraft(id)
	if SPF1.Data and SPF1.Data[id] and SPF1.CRAFTING then
		if not SPF1.Data[id]["original"] then
			return;
		end
		SPF1.baseSelectCraft(SPF1.Data[id]["original"]);
	else
		SPF1.baseSelectCraft(id);
	end
end

function SPF1.GetCraftDescription(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
		return SPF1.baseGetCraftDescription(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftDescription(id);
end

function SPF1.GetCraftSpellFocus(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
		return SPF1.baseGetCraftSpellFocus(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftSpellFocus(id);
end

function SPF1.SetCraftSpell(obj, id)
	
	local craftIndex = SPF1.GetCraftSelectionIndex();
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseSetCraftSpell(obj, SPF1.Data[craftIndex]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseSetCraftSpell(obj, id);
end
