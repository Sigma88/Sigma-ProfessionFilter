local SPF = SigmaProfessionFilter[1];

CraftTypeColor["unlearned"] = { r = 1.00, g = 0, b = 0, font = "GameFontNormalLeftRed" };

-- Set up data table
function SPF.GetNumCrafts()
	
	if not CraftFrame:IsVisible() then
		return SPF.baseGetNumCrafts();
	end
	
	if not SPF.FILTERED then
		
		local LeftSelection = SPF:GetSelected("Left");
		local RightSelection = SPF:GetSelected("Right");
		
		-- Reset the Data
		SPF.FIRST = nil;
		SPF.Data = {};
		SPF.Recipes = {};
		SPF.CraftedItems = {};
		SPF.Headers = {};
		
		-- Start ordering the recipes
		local SkillTypes = { [1] = "unlearned"; [2] = "difficult"; [3] = "optimal"; [4] = "medium"; [5] = "easy"; [6] = "trivial"; [7] = "none"; };
		local ByType = { ["header"] = {}; ["unlearned"] = {}; ["difficult"] = {}; ["optimal"] = {}; ["medium"] = {}; ["easy"] = {}; ["trivial"] = {}; ["none"] = {} };
		local Names = { ["header"] = {}; ["unlearned"] = {}; ["difficult"] = {}; ["optimal"] = {}; ["medium"] = {}; ["easy"] = {}; ["trivial"] = {}; ["none"] = {} };
		local headerIndex = 0;
		
		for i=1, SPF.baseGetNumCrafts() do
			
			local skillName, skillSubSpellName, skillType = SPF.baseGetCraftInfo(i);
			SPF.Recipes[skillName..string.gsub(skillSubSpellName or "", "(.+)", " %1")] = i;
			
			local craftedItem = SPF.baseGetCraftItemInfo(i);
			
			if craftedItem then
				SPF.CraftedItems[craftedItem] = i;
			end
		end
		
		for i=1, SPF.baseGetNumCrafts() do
			
			local skillName, skillSubSpellName, skillType = SPF.baseGetCraftInfo(i);
			
			if skillType == "header" then
				headerIndex = headerIndex + 1;
				ByType["header"][headerIndex] = { name = skillName };
			else
				
				-- IMPLEMENT CHECKS LATER
				local leftGroupID = SPF.LeftMenu:Filter(i, LeftSelection) or headerIndex;
				local rightGroupID = SPF.RightMenu:Filter(i, RightSelection) or 0;
				
				-- FILTER_1
				if false
					or not (SPF.Filter1:Filter(i))
				-- FILTER_2
					or not (SPF.Filter2:Filter(i))
				-- STARRED
					or not (SPF.Starred:Filter(skillName, skillSubSpellName))
				-- SEARCH_BOX
					or not (SPF.SearchBox:Filter(i))
				-- LEFT_DROPDOWN
					or not (LeftSelection == 0 or LeftSelection == leftGroupID)
				-- RIGHT_DROPDOWN
					or not (RightSelection == 0 or RightSelection == rightGroupID)
				then
					-- SKIP ELEMENTS THAT FAIL TO MATCH ALL FILTERS
				else
					-- Since the default CraftFrame is already in order
					-- we use the default order as sorting rule for nameWithLevel
					
					-- if itemLevel then
						
						local nameWithLevel = "";
						if SPF:Custom("Functions")["nameWithLevel"] then
							nameWithLevel = SPF:Custom("Functions")["nameWithLevel"](i);
						else
							nameWithLevel = string.format("%04d", i)..skillName..string.gsub(skillSubSpellName or "", "(.+)", " %1");
						end
						
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
					-- end
				end
			end
		end
		
		if SPF:SavedData()["Unlearned"] then
			
			for spellID,spellData in pairs(SPF.GetRecipeInfo() or {}) do
				local skillName, skillSubSpellName = SPF.GetRecipeInfo(spellID, "name","skillSubSpellName");
				local icon = SPF.GetRecipeInfo(spellID, "icon");
				
				if not SPF.Recipes[skillName..string.gsub(skillSubSpellName or "", "(.+)", " %1")] and SPF.Starred:Filter(skillName, skillSubSpellName) then
					-- IMPLEMENT CHECKS LATER
					local leftGroupID = SPF.LeftMenu:FilterSpell(spellID, LeftSelection) or 0;
					local rightGroupID = SPF.RightMenu:FilterSpell(spellID, RightSelection) or 0;
					
					-- FILTER_1
					if (not SPF.Filter1:FilterSpell(spellID))
					-- FILTER_2
						or (not SPF.Filter2:FilterSpell(spellID))
						-- SEARCH_BOX
						or not(SPF.SearchBox:FilterSpell(spellID))
					-- LEFT_DROPDOWN
						or not (LeftSelection == 0 or LeftSelection == leftGroupID)
					-- RIGHT_DROPDOWN
						or not (RightSelection == 0 or RightSelection == rightGroupID)
					then
						-- SKIP ELEMENTS THAT FAIL TO MATCH ALL FILTERS
					else
						local learnedAt = spellData["learnedAt"] or 0;
						local nameWithLevel = "";
						if SPF:Custom("Functions")["nameWithLevel"] then
							nameWithLevel = SPF:Custom("Functions")["nameWithLevel"](spellID, true);
						else
							nameWithLevel = string.format("%04d", 500 - learnedAt)..skillName;
						end
						
						local skillType = "unlearned";
						local numReagents = 0;
						if spellData["reagents"] then
							numReagents = getn(spellData["reagents"]);
						end
						if spellData["creates"] then
							local _,_,_,_,_,_,_,_,_,icon = SPF.GetItemInfo(spellData["creates"]);
						end
						local info = {
							["skillName"] = skillName;
							["skillSubSpellName"] = spellData["skillSubSpellName"];
							["description"] = spellData["description"];
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
		local groupBy = SPF:SavedData()["GroupBy"] or "Left";
		
		if (groupBy == "Right" and not SPF:GetMenu("Right")) then
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
			
			local Pairs = SPF:GetMenu(groupBy) or ByType["header"];
			
			if (groupBy == "Left" and not SPF:GetMenu("Left")) then
				Pairs = {};
				for i,slot in ipairs(SPF.GetCraftSubClasses()) do
					table.insert( Pairs, { name = slot; } );
				end
			end
			if (groupBy == "Right" and not SPF:GetMenu("Right")) then
				Pairs = {};
				for i,slot in ipairs(SPF.GetCraftInvSlots()) do
					table.insert( Pairs, { name = slot; } );
				end
			end
			
			if (groupBy == "Left" and not SPF:GetMenu("Left")) then
				Pairs = { [1] = { name = ""; } };
			end
			
			for i,button in ipairs(Pairs) do
				local group = button.name;
				local items = Ordered[i];
				
				if items then
					-- Add the Header
					if (strlen(group) > 0) then
						headerCount = headerCount + 1;
						totalCount = totalCount + 1;
						SPF.Headers[headerCount] = totalCount;
					
						SPF.Data[totalCount] = {
							["skillName"] = group;
							["skillType"] = "header";
							["headerIndex"] = headerCount;
							["numAvailable"] = 0;
						};
					end
					
					if (SPF.Collapsed and SPF.Collapsed[headerCount]) then
						SPF.Data[totalCount]["isExpanded"] = false;
					else
						if (strlen(group) > 0) then
							SPF.Data[totalCount]["isExpanded"] = true;
						end
						
						for j,skillInfo in ipairs(items) do
							totalCount = totalCount + 1;
							
							if (not SPF.FIRST) then
								SPF.FIRST = totalCount;
							end
							
							SPF.Data[totalCount] = skillInfo;
						end
					end
				end
			end
		end
		
		-- Leatrix Plus Compatibility
		if LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On" then
			if SPF.FIRST and getn(SPF.Headers) == 0 then
				CRAFTS_DISPLAYED = 23;
			else
				CRAFTS_DISPLAYED = 22;
			end
		end
		
		if totalCount > 0 then
			SPF.FILTERED = totalCount;
		end
		
	end
	
	return SPF.FILTERED or 0;
end

-- Get Craft Info
function SPF.GetCraftInfo(skillIndex)
	
	-- If The Profession is supported
	if (SPF.Data and SPF.Data[skillIndex]) then
		if not SPF.Data[skillIndex]["original"] then
			return SPF.Data[skillIndex]["skillName"], SPF.Data[skillIndex]["skillSubSpellName"] or "", SPF.Data[skillIndex]["skillType"], SPF.Data[skillIndex]["numAvailable"], SPF.Data[skillIndex]["isExpanded"], 0, 0;
		else
			return SPF.baseGetCraftInfo(SPF.Data[skillIndex]["original"]);
		end
	end
	
	return SPF.baseGetCraftInfo(skillIndex);
end

-- Expand
function SPF.ExpandCraftSkillLine(skillIndex, skipUpdate)
	
	-- if the skillIndex is zero we need to expand all headers
	if (skillIndex == 0) then
		-- Expand in reverse order otherwise it's a mess
		for i=getn(SPF.Headers), 1, -1 do
			SPF.ExpandCraftSkillLine(SPF.Headers[i], true);
		end
		SPF.FullUpdate(true);
		return;
		
	-- otherwise expand this header
	elseif (SPF.Data and SPF.Data[skillIndex]) then
		-- if this is a header
		local skillType = SPF.Data[skillIndex]["skillType"];
		local skillName = SPF.Data[skillIndex]["skillName"];
		
		if (skillType == "header") then
			-- Remove if fom the list of collapsed headers
			
			if (SPF.Collapsed == nil) then
				SPF.Collapsed = {};
			end
			
			SPF.Collapsed[SPF.Data[skillIndex]["headerIndex"]] = nil;
		end
	end
	
	if not skipUpdate then
		SPF.FullUpdate(true);
		SPF.ONCLICK = skillIndex;
	end
end

-- Collapse
function SPF.CollapseCraftSkillLine(skillIndex, skipUpdate)
	
	-- if the skillIndex is zero we need to collapse all headers
	if (skillIndex == 0) then
		-- Collapse in reverse order otherwise it's a mess
		for i=getn(SPF.Headers), 1, -1 do
			SPF.CollapseCraftSkillLine(SPF.Headers[i], true);
		end
		
		SPF.FullUpdate(true);
		return;
		
	-- otherwise collapse this header
	elseif (SPF.Data and SPF.Data[skillIndex]) then
		-- if this is a header
		local skillType = SPF.Data[skillIndex]["skillType"];
		local skillName = SPF.Data[skillIndex]["skillName"];
		
		if (skillType == "header") then
			-- Set Collapsed To False
			
			if (SPF.Collapsed == nil) then
				SPF.Collapsed = {};
			end
			
			SPF.Collapsed[SPF.Data[skillIndex]["headerIndex"]] = true;
		end
	end
	
	if not skipUpdate then
		SPF.FullUpdate(true);
		SPF.ONCLICK = skillIndex;
	end
end

-- Select Craft
function SPF.CraftFrame_SetSelection(skillIndex)
	SPF.SELECTED = skillIndex;
	CraftFrame.selectedSkill = skillIndex;
	
	SPF.baseCraftFrame_SetSelection(skillIndex);
	SPF.SetCraftReagentLabel(skillIndex);
	
	if (SPF.Data and SPF.Data[skillIndex]) then
		if not SPF.Data[skillIndex]["original"] then
			CraftCreateButton:Disable();
			-- CraftCreateAllButton:Disable();
			-- CraftFrame does not have a CreateAll button
			if SPF.Data[skillIndex]["spellID"] and not SPF.Data[skillIndex]["creates"] and not SPF.Data[skillIndex]["skillSubSpellName"] then
				local spellID = SPF.Data[skillIndex]["spellID"];
				local link = "enchant:"..spellID
				SPF.LocalTooltip:SetHyperlink(link);
				local requiresText = SPF.GetRequiresText(skillIndex)
				CraftRequirements:SetText((requiresText or ""));
			end
		end
	end
end

function SPF.GetCraftSelectionIndex()
	
	if SPF.SELECTED then
		return SPF.SELECTED;
	end
	return SPF.baseGetCraftSelectionIndex();
end

function SPF.CraftButton_OnClick(button)
	SPF.ONCLICK = this:GetID();
	SPF.baseCraftButton_OnClick(button, this);
end

-- Crafting
function SPF.GetCraftNumReagents(skillIndex, base)
	if base ~= true and SPF.Data and SPF.Data[skillIndex] then
		if SPF.Data[skillIndex]["original"] then
			return SPF.baseGetCraftNumReagents(SPF.Data[skillIndex]["original"]);
		else
			return SPF.Data[skillIndex]["numReagents"] or 0;
		end
	end
	return SPF.baseGetCraftNumReagents(skillIndex);
end

function SPF.CraftCreateButton_OnClick()

	if SPF.Data and SPF.SELECTED and SPF.Data[SPF.SELECTED] and SPF.Data[SPF.SELECTED]["original"] then
		DoCraft(SPF.Data[SPF.SELECTED]["original"], SPF.GetCraftRepeatCount());
	else
		DoCraft(CraftFrame.selectedSkill, SPF.GetCraftRepeatCount());
	end
	-- CraftInputBox:ClearFocus();
end

-- function SPF.CraftCreateAllButton_OnClick()
	-- CraftInputBox:SetNumber(CraftFrame.numAvailable);
	
	-- if SPF.Data and SPF.SELECTED and SPF.Data[SPF.SELECTED] and SPF.Data[SPF.SELECTED]["original"] then
		-- DoCraft(SPF.Data[SPF.SELECTED]["original"], CraftInputBox:GetNumber());
	-- else
		-- DoCraft(CraftFrame.selectedSkill, CraftInputBox:GetNumber());
	-- end
	-- CraftInputBox:ClearFocus();
-- end

function SPF.GetCraftReagentInfo(skillIndex, reagentIndex, base)
	if base ~= true and SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			if SPF.Data[skillIndex]["reagents"] then
				if SPF.Data[skillIndex]["reagents"][reagentIndex] then
					local reagentID = SPF.Data[skillIndex]["reagents"][reagentIndex]["itemID"];
					local reagentName = SPF.GetItemInfo(reagentID);
					if reagentName then
						local texturePath = SPF.Data[skillIndex]["reagents"][reagentIndex]["icon"];
						local numRequired = SPF.Data[skillIndex]["reagents"][reagentIndex]["numRequired"];
						local numHave = 0;--GetItemCount(reagentID);
						return reagentName, texturePath, numRequired, numHave;
					end
				end
			end
			return;
		end
		return SPF.baseGetCraftReagentInfo(SPF.Data[skillIndex]["original"], reagentIndex);
	end
	return SPF.baseGetCraftReagentInfo(skillIndex, reagentIndex);
end

function SPF.GetCraftCooldown(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			return;
		end
		return SPF.baseGetCraftCooldown(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetCraftCooldown(skillIndex, i);
end

function SPF.GetCraftIcon(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			return SPF.Data[skillIndex]["icon"];
		end
		return SPF.baseGetCraftIcon(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetCraftIcon(skillIndex);
end

function SPF.GetCraftNumMade(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			return 0, 0;
		end
		return SPF.baseGetCraftNumMade(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetCraftNumMade(skillIndex);
end

function SPF.GetCraftSpellFocus(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			-- if SPF.Data[skillIndex]["tools"] then
				-- local tools = {};
				-- for i,toolID in ipairs(SPF.Data[skillIndex]["tools"]) do
					-- local toolName = SPF.GetItemInfo(toolID);
					-- table.insert(tools, toolName);
					-- table.insert(tools, GetItemCount(toolID));
				-- end
				-- return unpack(tools);
			-- end
			return;
		end
		return SPF.baseGetCraftSpellFocus(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetCraftSpellFocus(skillIndex);
end

function SPF.GetCraftRepeatCount()
	
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

function SPF.PetFrame_OnShow()
	if CraftFrame:IsVisible() and not CraftReagent1:IsVisible() then
		CraftFrame_OnShow(CraftFrame, true);
	end
end

function SPF.CraftFrame_OnShow(self, silent)
	-- CraftInputBox:SetNumber(1);
	if not silent then
		PlaySound("igCharacterInfoOpen");
	end
	SPF.FullUpdate();
	for i,func in pairs(SPF["CFOnShow"]) do
		func();
	end
end

function SPF.GetCraftItemLink(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			if SPF.Data[skillIndex]["creates"] then
				local itemName, itemLink = SPF.GetItemInfo(SPF.Data[skillIndex]["creates"]);
				return itemLink;
			end
			
			local spellID = SPF.Data[skillIndex]["spellID"];
			if spellID then
				local spellName = SPF.GetRecipeInfo(spellID, "name");
				return "|cffffd000|Henchant:"..spellID.."|h["..spellName.."]|h|r";
			end
			return;
		end
		return SPF.baseGetCraftItemLink(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetCraftItemLink(skillIndex);
end

function SPF.GetCraftReagentItemLink(skillIndex, reagentIndex, base)
	if base ~= true and SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then

			local reagents = SPF.Data[skillIndex]["reagents"];
			
			if reagents then
				if reagents[reagentIndex] then
					local itemName, itemLink = SPF.GetItemInfo(reagents[reagentIndex]["itemID"]);
					return itemLink;
				end
			end
			
			return;
		end
		return SPF.baseGetCraftReagentItemLink(SPF.Data[skillIndex]["original"], reagentIndex);
	end
	return SPF.baseGetCraftReagentItemLink(skillIndex, reagentIndex);
end

function SPF.GetCraftRecipeLink(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			local spellID = SPF.Data[skillIndex]["spellID"];
			if spellID then
				local spellName = SPF.GetRecipeInfo(spellID, "name");
				return "|cffffd000|Henchant:"..spellID.."|h["..GetCraftName()..": "..spellName.."]|h|r";
			end
			return;
		end
		
		return SPF.baseGetCraftRecipeLink(SPF.Data[skillIndex]["original"]);
	end
	-- return SPF.baseGetCraftRecipeLink(skillIndex);
end

function SPF.GetFirstCraft()
	
	if not (SPF.Data and getn(SPF.Data) > 0)then
		SPF.GetNumCrafts();
	end
	
	if SPF.FIRST then
		return SPF.FIRST;
	end
	
	return SPF.baseGetFirstCraft();
end

function SPF.GetCraftItemInfo(skillIndex)
	return SPF.GetItemInfo(SPF.GetCraftItemLink(skillIndex));
end

function SPF.baseGetCraftItemInfo(skillIndex)
	local itemLink = SPF.baseGetCraftItemLink(skillIndex);
	if itemLink then
		return SPF.GetItemInfo(itemLink);
	end
end

function SPF.GetCraftItemSubClass(skillIndex)
	local itemLink = SPF.GetCraftItemLink(skillIndex);
	local _,_,_,_,_, itemType, itemSubType = SPF.GetItemInfo(itemLink)
	return itemType.."_"..itemSubType;
end

function SPF.baseGetCraftItemSubClass(skillIndex)
	local itemLink = SPF.baseGetCraftItemLink(skillIndex);
	local _,_,_,_,_, itemType, itemSubType = SPF.GetItemInfo(itemLink)
	return itemType.."_"..itemSubType;
end

function SPF.SetCraftItem(this, skillIndex, reagentIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			if reagentIndex then
				local reagents = SPF.Data[skillIndex]["reagents"];
				if reagents then
					if reagents[reagentIndex] then
						this:SetHyperlink("item:"..reagents[reagentIndex]["itemID"]);
					end
				end
			else
				if not SPF.Data[skillIndex]["skillSubSpellName"] then
					if SPF.Data[skillIndex]["creates"] then
						this:SetHyperlink("item:"..SPF.Data[skillIndex]["creates"]);
					else
						this:SetHyperlink("enchant:"..SPF.Data[skillIndex]["spellID"]);
					end
				end
			end
		else
			if reagentIndex then
				SPF.baseSetCraftItem(this, SPF.Data[skillIndex]["original"], reagentIndex);
			else
				SPF.baseSetCraftSpell(this, SPF.Data[skillIndex]["original"]);
			end
		end
		if SPF:Custom("Functions")["SetCraftItem"] then
			SPF:Custom("Functions")["SetCraftItem"](this, skillIndex, reagentIndex);
		end
	else
		if reagentIndex then
			SPF.baseSetCraftItem(this, skillIndex, reagentIndex);
		else
			SPF.baseSetCraftSpell(this, skillIndex);
		end
	end
end

function SPF.SetCraftReagentLabel(skillIndex)
	local CraftReagentLabelText = SPELL_REAGENTS;
	if not CraftReagentLabel:IsVisible() then
		CraftReagentLabelText = "";
		CraftReagentLabel:Show();
	end
	CraftReagentLabel:SetText("|cffffffff"..SPF.GetCraftReagentLabel(skillIndex).."|r"..CraftReagentLabelText);
	CraftReagentLabel:SetJustifyH("LEFT");
end

function SPF.GetCraftReagentLabel(skillIndex)

	-- If The Profession is supported
	if (SPF.Data and SPF.Data[skillIndex]) then
		if not SPF.Data[skillIndex]["original"] then
			if SPF.Data[skillIndex]["spellID"] then
				local spellID = SPF.Data[skillIndex]["spellID"];
				
				local learnedAt = SPF.GetRequiresText(skillIndex);
				
				local levels = SPF.Data[skillIndex]["levels"];
				local difficulty = nil;
				
				if levels then
					difficulty = "|cffffd100Difficulty:|r |cffff8040"..levels[1].."|r ".."|cffffff00"..levels[2].."|r ".."|cff40bf40"..levels[3].."|r ".."|cff808080"..levels[4].."|r\n\n";
				end
				
				return (learnedAt or "")..(difficulty or "");
			end
			return "";
		end
		
		local difficulty = nil;
		local spellName, subSpellName = SPF.baseGetCraftInfo(SPF.Data[skillIndex]["original"]);
		
		if spellName then
			local spellID = SPF.GetRecipeSpellID(spellName, subSpellName);
			if spellID then
				local levels = SPF.GetRecipeInfo(spellID, "levels");
				
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

function SPF.GetItemInfo(itemLink)
	-- classic: itemName, itemLink, itemQuality,            itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture
	-- tbc:     itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture
	-- wotlk:   itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice
	if itemLink then
		local id = nil;
		if strfind(itemLink, "item:") then
			id = string.gsub(itemLink, ".*\124Hitem:(%d+).*", "%1");
			if id then
				if not(GetItemInfo(id)) then
					SPF.LocalTooltip:SetHyperlink("item:"..id);
					SPF.LocalTooltip:Hide();
				end
			end
		elseif strfind(itemLink, "enchant:") then
			id = string.gsub(itemLink, ".*\124Henchant:(%d+).*", "%1");
			if id then
				if not(GetItemInfo(id)) then
					SPF.LocalTooltip:SetHyperlink("enchant:"..id);
					SPF.LocalTooltip:Hide();
				end
			end
		end
		
		if not TradeSkillFrameAvailableFilterCheckButton then -- classic
			local itemName, itemLink, itemQuality, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(id or itemLink);
			local itemLevel = itemMinLevel;
			return itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture;
		else -- tbc, wotlk
			return GetItemInfo(id or itemLink);
		end
	end
end

function SPF.GetCraftInvSlots()
	local originalSlots = {};
	if not SPF:GetMenu("Right") then
		if SigmaProfessionFilter_RecipeInfo and SPF:SavedData()["Unlearned"] then
			if SPF.RightMenu.LAST_CHECKED ~= time() then
				SPF.RightMenu.LAST_CHECKED = time();
				local neededSlots = {};
				for spellID,spellData in pairs(SPF.GetRecipeInfo() or {}) do
					if spellData then
						local itemID = spellData["creates"];
						if itemID then
							local _,_,_,_,_,_,_,_,invSlot = SPF.GetItemInfo(itemID);
							if invSlot and SPF.INV[invSlot] then
								if not neededSlots[SPF.INV[invSlot]] then
									neededSlots[SPF.INV[invSlot]] = true;
								end
							end
						end
					end
				end
				table.sort(neededSlots);
				
				SPF.RightMenu.newSlots = {};
				for slotID,_ in pairs(neededSlots) do
					table.insert(SPF.RightMenu.newSlots, SPF.SLOTS[slotID]);
				end
				
				table.insert(SPF.RightMenu.newSlots, NONEQUIPSLOT);
			end
			
			return SPF.RightMenu.newSlots;
		end
	end
	
	return originalSlots;
end

function SPF.GetCraftSubClasses()
	local originalSubClasses = {};
	if not SPF:GetMenu("Left") then
		if SigmaProfessionFilter_RecipeInfo and SPF:SavedData()["Unlearned"] then
			if SPF.LeftMenu.LAST_CHECKED ~= time() then
				SPF.LeftMenu.LAST_CHECKED = time();
				local neededClasses = {};
				
				for spellID,spellData in pairs(SPF.GetRecipeInfo() or {}) do
					if spellData then
						local itemID = spellData["creates"];
						if itemID then
							local _,_,_,_,_,class,subClass = GetItemInfo(itemID);
							if class and subClass then
								if not neededClasses[class] then
									neededClasses[class] = {};
								end
								if not neededClasses[class][subClass] then
									neededClasses[class][subClass] = true;
								end
							end
						else
							local lastClass, lastSubClass = "", "";
							for classID,class in ipairs({GetAuctionItemClasses()}) do
								lastClass = class;
								lastSubClass = class;
								for i,subClass in ipairs({GetAuctionItemSubClasses(classID)}) do
									lastSubClass = subClass;
								end
							end
							if not neededClasses[lastClass] then
								neededClasses[lastClass] = {};
							end
							neededClasses[lastClass][lastSubClass] = true;
						end
					end
				end
				
				SPF.LeftMenu.newClasses = {};
				for classID,class in ipairs({GetAuctionItemClasses()}) do
					if neededClasses[class] then
						local subClasses = {GetAuctionItemSubClasses(classID)};
						if getn(subClasses) > 0 then
							for i,subClass in ipairs(subClasses) do
								if neededClasses[class] and neededClasses[class][subClass] then
									table.insert(SPF.LeftMenu.newClasses, subClass);
								end
							end
						else
							if neededClasses[class] and neededClasses[class][class] then
								table.insert(SPF.LeftMenu.newClasses, class);
							end
						end
					end
				end
			end
			return SPF.LeftMenu.newClasses;
		end
	end
	return originalSubClasses;
end

function SPF.CraftFrame_Update()
	
	for i=1, CRAFTS_DISPLAYED, 1 do
		getfenv()["Craft"..i.."Cost"]:SetText("");
	end
	
	SPF.baseCraftFrame_Update();
	
	-- Check if there are any headers
	if SPF.Headers then
		-- If has headers show the expand all button
		if getn(SPF.Headers) > 0 then
			-- If has headers then move all the names to the right
			for i=1, CRAFTS_DISPLAYED, 1 do
				getfenv()["Craft"..i.."Text"]:ClearAllPoints();
				if i == SPF.ONCLICK then
					SPF.ONCLICK = nil;
					getfenv()["Craft"..i.."Text"]:SetPoint("LEFT", "Craft"..i, "LEFT", 22.65, -1.65);
				else
					getfenv()["Craft"..i.."Text"]:SetPoint("LEFT", "Craft"..i, "LEFT", 21, 0);
				end
			end
			CraftExpandButtonFrame:Show();
		else
			-- If no headers then move all the names to the left
			for i=1, CRAFTS_DISPLAYED, 1 do
				getfenv()["Craft"..i.."Text"]:ClearAllPoints();
				if i == SPF.ONCLICK then
					SPF.ONCLICK = nil;
					getfenv()["Craft"..i.."Text"]:SetPoint("LEFT", "Craft"..i, "LEFT", 4.65, -1.65);
				else
					getfenv()["Craft"..i.."Text"]:SetPoint("LEFT", "Craft"..i, "LEFT", 3, 0);
				end
			end
			CraftExpandButtonFrame:Hide();
		end
	end
	
	if not SPF.FIRST then
		SPF.ClearCraft();
	end
	
	-- LeatrixPlus compatibility
    if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On" and Craft23) then
		if SPF.Headers and getn(SPF.Headers) == 0 and SPF.FIRST then
			Craft1:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 22, -81);
			if SPF.Data and getn(SPF.Data) > 22  then
				Craft23:Show();
			end
		else
			Craft23:Hide();
			Craft1:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 22, -96);
		end
    end
	
	if SPF.CraftName ~= GetCraftName() then
		SPF.CraftName = GetCraftName();
		SPF.CraftFrame_OnShow(CraftFrame, true);
	end
	
	SPF.Starred.OnUpdate();
end
