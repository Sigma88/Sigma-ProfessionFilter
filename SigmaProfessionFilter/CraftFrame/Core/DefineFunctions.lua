local SPF1 = SigmaProfessionFilter[1];

CraftTypeColor["unlearned"] = { r = 1.00, g = 0, b = 0, font = "GameFontNormalLeftRed" };  

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
		local CraftTypes = { [1] = "unlearned"; [2] = "difficult"; [3] = "optimal"; [4] = "medium"; [5] = "easy"; [6] = "trivial"; [7] = "none"; };
		local ByType = { ["header"] = {}; ["unlearned"] = {}; ["difficult"] = {}; ["optimal"] = {}; ["medium"] = {}; ["easy"] = {}; ["trivial"] = {}; ["none"] = {} };
		local Names = { ["header"] = {}; ["unlearned"] = {}; ["difficult"] = {}; ["optimal"] = {}; ["medium"] = {}; ["easy"] = {}; ["trivial"] = {}; ["none"] = {} };
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
				-- STARRED
					or (not SPF1.Starred:Filter(craftName, craftSubSpellName))
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
		
		if SPF1:SavedData()["Unlearned"] then
		for spellID,spellData in pairs(SPF1.GetRecipeInfo() or {}) do
			local craftName, craftSubSpellName, icon = GetSpellInfo(spellID);
			
			if not SPF1.Recipes[craftName] then
				-- IMPLEMENT CHECKS LATER
				local leftGroupID = SPF1.LeftMenu:FilterSpell(spellID, SPF1:GetSelected("Left")) or 0;
				local rightGroupID = SPF1.RightMenu:FilterSpell(spellID, SPF1:GetSelected("Right")) or 0;
				
				-- FILTER_1
				if (not SPF1.Filter1:FilterSpell(spellID))
				-- FILTER_2
					or (not SPF1.Filter2:FilterSpell(spellID))
					-- SEARCH_BOX
					or not(SPF1.SearchBox:FilterSpell(spellID))
				-- LEFT_DROPDOWN
					or not (SPF1:GetSelected("Left") == 0 or leftGroupID > 0)
				-- RIGHT_DROPDOWN
					or not (SPF1:GetSelected("Right") == 0 or rightGroupID > 0)
				then
					-- SKIP ELEMENTS THAT FAIL TO MATCH ALL FILTERS
				else
					local learnedAt = spellData["learnedAt"] or 0;
					local nameWithLevel = string.format("%04d", 999 - learnedAt)..craftName;
					local craftType = "unlearned";
					local numReagents = 0;
					if spellData["reagents"] then
						numReagents = #spellData["reagents"];
					end
					local info = {
						["craftName"] = craftName;
						["craftSubSpellName"] = spellData["subSpellName"];
						["craftType"] = craftType;
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
				CRAFTS_DISPLAYED = 23;
			else
				CRAFTS_DISPLAYED = 22;
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
			return SPF1.Data[craftIndex]["craftName"], SPF1.Data[craftIndex]["craftSubSpellName"], SPF1.Data[craftIndex]["craftType"], SPF1.Data[craftIndex]["numAvailable"], SPF1.Data[craftIndex]["isExpanded"], SPF1.Data[craftIndex]["trainingPointCost"], SPF1.Data[craftIndex]["requiredLevel"];
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
	
	SPF1.baseCraftFrame_SetSelection(craftIndex);
	
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			CraftCreateButton:Disable();
		end
	end
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
function SPF1.GetCraftNumReagents(craftIndex, base)
	if base ~= true and SPF1.Data and SPF1.Data[craftIndex] then
		if SPF1.Data[craftIndex]["original"] then
			return SPF1.baseGetCraftNumReagents(SPF1.Data[craftIndex]["original"]);
		else
			return SPF1.Data[craftIndex]["numReagents"] or 0;
		end
	end
	return SPF1.baseGetCraftNumReagents(craftIndex);
end

function SPF1.GetCraftReagentInfo(craftIndex, reagentIndex, base)
	if base ~= true and SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			if SPF1.Data[craftIndex]["reagents"] then
				local reagentID = SPF1.Data[craftIndex]["reagents"][reagentIndex]["itemID"];
				local reagentName, _,_,_,_,_,_,_,_, texturePath = GetItemInfo(reagentID);
				local numRequired = SPF1.Data[craftIndex]["reagents"][reagentIndex]["numRequired"];
				local numHave = GetItemCount(reagentID);
				return reagentName, texturePath, numRequired, numHave;
			end
			return;
		end
		return SPF1.baseGetCraftReagentInfo(SPF1.Data[craftIndex]["original"], reagentIndex);
	end
	return SPF1.baseGetCraftReagentInfo(craftIndex, reagentIndex);
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
			return SPF1.Data[craftIndex]["icon"];
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

function SPF1.CraftFrame_OnShow(self)
	SPF1.FullUpdate();
end

function SPF1.GetCraftItemLink(craftIndex)
	if SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			if SPF1.Data[craftIndex]["creates"] then
				local itemName, itemLink = GetItemInfo(SPF1.Data[craftIndex]["creates"]);
				return itemLink;
			end
			
			local spellID = SPF1.Data[craftIndex]["spellID"];
			if spellID then
				local spellName = GetSpellInfo(spellID);
				return "|cffffd000|Henchant:"..spellID.."|h["..spellName.."]|h|r";
			end
			return;
		end
		
		local spellName = SPF1.baseGetCraftInfo(SPF1.Data[craftIndex]["original"]);
		local _,_,_,_,_,_, spellID = GetSpellInfo(spellName);
		local creates = SPF1.GetRecipeInfo(spellID, "creates");
		
		if creates then
			local itemName, itemLink = GetItemInfo(creates);
			return itemLink;
		end
		
		return SPF1.baseGetCraftItemLink(SPF1.Data[craftIndex]["original"]);
	end
	return SPF1.baseGetCraftItemLink(craftIndex);
end

function SPF1.GetCraftReagentItemLink(craftIndex, reagentIndex, base)
	if base ~= true and SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			
			local reagents = SPF1.Data[craftIndex]["reagents"];
			
			if reagents then
				if reagents[reagentIndex] then
					local itemName, itemLink = GetItemInfo(reagents[reagentIndex]["itemID"]);
					return itemLink;
				end
			end
			
			return;
		end
		return SPF1.baseGetCraftReagentItemLink(SPF1.Data[craftIndex]["original"], reagentIndex);
	end
	return SPF1.baseGetCraftReagentItemLink(craftIndex, reagentIndex);
end

function SPF1.GetCraftRecipeLink(craftIndex)
	if SPF1.Data and SPF1.Data[craftIndex] then
		if not SPF1.Data[craftIndex]["original"] then
			local spellID = SPF1.Data[craftIndex]["spellID"];
			if spellID then
				local spellName = GetSpellInfo(spellID);
				return "|cffffd000|Henchant:"..spellID.."|h["..GetCraftName()..": "..spellName.."]|h|r";
			end
			return;
		end
		
		local spellLink = SPF1.baseGetCraftRecipeLink(SPF1.Data[craftIndex]["original"]);
		if spellLink then
			local spellName = SPF1.baseGetCraftInfo(SPF1.Data[craftIndex]["original"]);
			local _,_,_,_,_,_, spellID = GetSpellInfo(spellLink);
			if spellName and spellID then
				return "|cffffd000|Henchant:"..spellID.."|h["..GetCraftName()..": "..spellName.."]|h|r";
			end
		end
		
		return spellLink;
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

function SPF1.SelectCraft(craftIndex)
	if SPF1.Data and SPF1.Data[craftIndex] and SPF1.CRAFTING then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		SPF1.baseSelectCraft(SPF1.Data[craftIndex]["original"]);
	else
		SPF1.baseSelectCraft(craftIndex);
	end
end

function SPF1.GetCraftDescription(craftIndex)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			if SPF1.Data[craftIndex]["spellID"] then
				local spellID = SPF1.Data[craftIndex]["spellID"];
				
				local learnedAt = SPF1.Data[craftIndex]["learnedAt"];
				if learnedAt then
					local color = "|cffffffff";
					if select(2,GetCraftDisplaySkillLine()) < learnedAt then
						color = "|cffff0000";
					end
					learnedAt = color.."Requires "..GetCraftName().." ("..learnedAt..")|r\n\n";
				end
				
				local levels = SPF1.Data[craftIndex]["levels"];
				local difficulty = nil;
				
				if levels then
					difficulty = "|cffffd100Difficulty:|r |cffff8040"..levels[1].."|r ".."|cffffff00"..levels[2].."|r ".."|cff40bf40"..levels[3].."|r ".."|cff808080"..levels[4].."|r\n\n";
				end
				
				return (learnedAt or "")..(difficulty or "")..(GetSpellDescription(SPF1.Data[craftIndex]["spellID"]) or "");
			end
			return;
		end
		
		local difficulty = nil;
		local link = SPF1.baseGetCraftRecipeLink(SPF1.Data[craftIndex]["original"]);
		if link then
			local spellID = tonumber(link:match("enchant:(%d*)"));
			if spellID then
				local levels = SPF1.GetRecipeInfo(spellID, "levels");
				if levels then
					difficulty = "|cffffd100Difficulty:|r |cffff8040"..levels[1].."|r ".."|cffffff00"..levels[2].."|r ".."|cff40bf40"..levels[3].."|r ".."|cff808080"..levels[4].."|r\n\n";
				end
			end
		end
		
		return (difficulty or "")..(SPF1.baseGetCraftDescription(SPF1.Data[craftIndex]["original"]) or "");
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftDescription(craftIndex);
end

-- This will return the "Requires: Runed Copper Rod" text for Enchanting
function SPF1.GetCraftSpellFocus(craftIndex)
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			
			if SPF1.Data[craftIndex]["tools"] then
				local tools = {};
				for i,toolID in ipairs(SPF1.Data[craftIndex]["tools"]) do
					local toolName = GetItemInfo(toolID);
					table.insert(tools, toolName);
					table.insert(tools, GetItemCount(toolID));
				end
				return unpack(tools);
			end
		end
		return SPF1.baseGetCraftSpellFocus(SPF1.Data[craftIndex]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftSpellFocus(craftIndex);
end

function SPF1.SetCraftSpell(obj, id)
	
	local craftIndex = SPF1.GetCraftSelectionIndex();
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			if SPF1.Data[craftIndex]["spellID"] then
				return obj:SetSpellByID(SPF1.Data[craftIndex]["spellID"]);
			end
			return;
		end
		return SPF1.baseSetCraftSpell(obj, SPF1.Data[craftIndex]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseSetCraftSpell(obj, id);
end

function SPF1.SetCraftItem(obj, id, reagId)
	-- If The Profession is supported
	local craftIndex = SPF1.GetCraftSelectionIndex();
	
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			local reagents = SPF1.Data[craftIndex]["reagents"];
			if reagents then
				if reagents[reagId] then
					return obj:SetItemByID(reagents[reagId]["itemID"]);
				end
			end
			return;
		end
		return SPF1.baseSetCraftItem(obj, SPF1.Data[craftIndex]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseSetCraftItem(obj, id, reagId);
end
