local SPF = SigmaProfessionFilter[2];

TradeSkillTypeColor["unlearned"] = { r = 1.00, g = 0, b = 0, font = "GameFontNormalLeftRed" };

-- Set up data table
function SPF.GetNumTradeSkills()
	
	if not TradeSkillFrame:IsVisible() then
		return SPF.baseGetNumTradeSkills();
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
		
		for i=1, SPF.baseGetNumTradeSkills() do
			
			local skillName, skillType = SPF.baseGetTradeSkillInfo(i);
			SPF.Recipes[skillName] = i;
			
			local craftedItem = SPF.baseGetTradeSkillItemInfo(i);
			
			if craftedItem then
				SPF.CraftedItems[craftedItem] = i;
			end
		end
		
		for i=1, SPF.baseGetNumTradeSkills() do
			
			local skillName, skillType = SPF.baseGetTradeSkillInfo(i);
			
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
					or not (SPF.Starred:Filter(skillName))
				-- SEARCH_BOX
					or not (SPF.SearchBox:Filter(i))
				-- LEFT_DROPDOWN
					or not (LeftSelection == 0 or LeftSelection == leftGroupID)
				-- RIGHT_DROPDOWN
					or not (RightSelection == 0 or RightSelection == rightGroupID)
				then
					-- SKIP ELEMENTS THAT FAIL TO MATCH ALL FILTERS
				else
					local itemLink = SPF.baseGetTradeSkillItemLink(i);
					local itemLevel = SPF.baseGetTradeSkillItemLevel(i) or 0;
					
					if itemLevel then
						
						local nameWithLevel = "";
						if SPF:Custom("Functions")["nameWithLevel"] then
							nameWithLevel = SPF:Custom("Functions")["nameWithLevel"](i);
						else
							nameWithLevel = string.format("%04d", 500 - itemLevel)..skillName;
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
					end
				end
			end
		end
		
		if SPF:SavedData()["Unlearned"] then
			
			for spellID,spellData in pairs(SPF.GetRecipeInfo() or {}) do
				local skillName = SPF.GetRecipeInfo(spellID, "name");
				local icon = SPF.GetRecipeInfo(spellID, "icon");
				
				if not SPF.Recipes[skillName] and SPF.Starred:Filter(skillName) then
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
							-- ["rank"] = spellData["rank"];
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
		
		if (groupBy == "Right" and SPF:Custom("RightMenu")["disabled"]) then
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
				for i,slot in ipairs(SPF.GetTradeSkillSubClasses()) do
					table.insert( Pairs, { name = slot; } );
				end
			end
			if (groupBy == "Right" and not SPF:GetMenu("Right")) then
				Pairs = {};
				for i,slot in ipairs(SPF.GetTradeSkillInvSlots()) do
					table.insert( Pairs, { name = slot; } );
				end
			end
			
			if (groupBy == "Left" and SPF:Custom("LeftMenu")["disabled"]) then
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
				TRADE_SKILLS_DISPLAYED = 23;
			else
				TRADE_SKILLS_DISPLAYED = 22;
			end
		end
		
		if totalCount > 0 then
			SPF.FILTERED = totalCount;
		end
		
	end
	
	return SPF.FILTERED or 0;
end

-- Get TradeSkill Info
function SPF.GetTradeSkillInfo(skillIndex)
	
	-- If The Profession is supported
	if (SPF.Data and SPF.Data[skillIndex]) then
		if not SPF.Data[skillIndex]["original"] then
			return SPF.Data[skillIndex]["skillName"], SPF.Data[skillIndex]["skillType"], SPF.Data[skillIndex]["numAvailable"], SPF.Data[skillIndex]["isExpanded"];
		else
			return SPF.baseGetTradeSkillInfo(SPF.Data[skillIndex]["original"]);
		end
	end
	
	return SPF.baseGetTradeSkillInfo(skillIndex);
end

-- Expand
function SPF.ExpandTradeSkillSubClass(skillIndex, skipUpdate)
	
	-- if the skillIndex is zero we need to expand all headers
	if (skillIndex == 0) then
		-- Expand in reverse order otherwise it's a mess
		for i=getn(SPF.Headers), 1, -1 do
			SPF.ExpandTradeSkillSubClass(SPF.Headers[i], true);
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
function SPF.CollapseTradeSkillSubClass(skillIndex, skipUpdate)
	
	-- if the skillIndex is zero we need to collapse all headers
	if (skillIndex == 0) then
		-- Collapse in reverse order otherwise it's a mess
		for i=getn(SPF.Headers), 1, -1 do
			SPF.CollapseTradeSkillSubClass(SPF.Headers[i], true);
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

-- Select TradeSkill
function SPF.TradeSkillFrame_SetSelection(skillIndex)
	SPF.SELECTED = skillIndex;
	TradeSkillFrame.selectedSkill = skillIndex;
	
	SPF.baseTradeSkillFrame_SetSelection(skillIndex);
	SPF.SetTradeSkillDescription(skillIndex);
	
	if (SPF.Data and SPF.Data[skillIndex]) then
		if not SPF.Data[skillIndex]["original"] then
			TradeSkillCreateButton:Disable();
			TradeSkillCreateAllButton:Disable();
			-- TradeSkillFrame does not have any spells that would be affected by this
			-- if SPF.Data[skillIndex]["spellID"] and not SPF.Data[skillIndex]["creates"] then
				-- local spellID = SPF.Data[skillIndex]["spellID"];
				-- local link = "enchant:"..spellID
				-- SPF.LocalTooltip:SetHyperlink(link);
				-- CraftRequirements:SetText((SPFTradeSkillLocalTooltipTextLeft3:GetText() or ""));
			-- end
		end
	end
end

function SPF.GetTradeSkillSelectionIndex()
	
	if SPF.SELECTED then
		return SPF.SELECTED;
	end
	return SPF.baseGetTradeSkillSelectionIndex();
end

function SPF.TradeSkillSkillButton_OnClick(self, button)
	if CraftFrame then
		SPF.ONCLICK = this:GetID();
		SPF.baseTradeSkillSkillButton_OnClick(self);
	else
		SPF.ONCLICK = self:GetID();
		SPF.baseTradeSkillSkillButton_OnClick(self, button);
	end
end

-- Crafting
function SPF.GetTradeSkillNumReagents(skillIndex, base)
	if base ~= true and SPF.Data and SPF.Data[skillIndex] then
		if SPF.Data[skillIndex]["original"] then
			return SPF.baseGetTradeSkillNumReagents(SPF.Data[skillIndex]["original"]);
		else
			return SPF.Data[skillIndex]["numReagents"] or 0;
		end
	end
	return SPF.baseGetTradeSkillNumReagents(skillIndex);
end

function SPF.TradeSkillCreateButton_OnClick()

	if SPF.Data and SPF.SELECTED and SPF.Data[SPF.SELECTED] and SPF.Data[SPF.SELECTED]["original"] then
		DoTradeSkill(SPF.Data[SPF.SELECTED]["original"], SPF.GetTradeskillRepeatCount());
	else
		DoTradeSkill(TradeSkillFrame.selectedSkill, SPF.GetTradeskillRepeatCount());
	end
	TradeSkillInputBox:ClearFocus();
end

function SPF.TradeSkillCreateAllButton_OnClick()
	TradeSkillInputBox:SetNumber(TradeSkillFrame.numAvailable);
	
	if SPF.Data and SPF.SELECTED and SPF.Data[SPF.SELECTED] and SPF.Data[SPF.SELECTED]["original"] then
		DoTradeSkill(SPF.Data[SPF.SELECTED]["original"], TradeSkillInputBox:GetNumber());
	else
		DoTradeSkill(TradeSkillFrame.selectedSkill, TradeSkillInputBox:GetNumber());
	end
	TradeSkillInputBox:ClearFocus();
end

function SPF.GetTradeSkillReagentInfo(skillIndex, reagentIndex, base)
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
		return SPF.baseGetTradeSkillReagentInfo(SPF.Data[skillIndex]["original"], reagentIndex);
	end
	return SPF.baseGetTradeSkillReagentInfo(skillIndex, reagentIndex);
end

function SPF.GetTradeSkillCooldown(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			return;
		end
		return SPF.baseGetTradeSkillCooldown(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetTradeSkillCooldown(skillIndex, i);
end

function SPF.GetTradeSkillIcon(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			return SPF.Data[skillIndex]["icon"];
		end
		return SPF.baseGetTradeSkillIcon(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetTradeSkillIcon(skillIndex);
end

function SPF.GetTradeSkillNumMade(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			return 0, 0;
		end
		return SPF.baseGetTradeSkillNumMade(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetTradeSkillNumMade(skillIndex);
end

function SPF.GetTradeSkillTools(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			if SPF.Data[skillIndex]["tools"] then
				local tools = {};
				for i,toolID in ipairs(SPF.Data[skillIndex]["tools"]) do
					local toolName = SPF.GetItemInfo(toolID);
					table.insert(tools, toolName);
					table.insert(tools, GetItemCount(toolID));
				end
				return unpack(tools);
			end
			return;
		end
		return SPF.baseGetTradeSkillTools(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetTradeSkillTools(skillIndex);
end

function SPF.GetTradeskillRepeatCount()
	
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

function SPF.TradeSkillFrame_OnShow(self, silent)
	TradeSkillInputBox:SetNumber(1);
	if not silent then
		PlaySound("igCharacterInfoOpen");
	end
	SPF.FullUpdate();
	for i,func in pairs(SPF["TSFOnShow"]) do
		func();
	end
end

function SPF.GetTradeSkillItemLink(skillIndex)
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
		return SPF.baseGetTradeSkillItemLink(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetTradeSkillItemLink(skillIndex);
end

function SPF.GetTradeSkillReagentItemLink(skillIndex, reagentIndex, base)
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
		return SPF.baseGetTradeSkillReagentItemLink(SPF.Data[skillIndex]["original"], reagentIndex);
	end
	return SPF.baseGetTradeSkillReagentItemLink(skillIndex, reagentIndex);
end

function SPF.GetTradeSkillRecipeLink(skillIndex)
	if SPF.Data and SPF.Data[skillIndex] then
		if not SPF.Data[skillIndex]["original"] then
			local spellID = SPF.Data[skillIndex]["spellID"];
			if spellID then
				local spellName = SPF.GetRecipeInfo(spellID, "name");
				return "|cffffd000|Henchant:"..spellID.."|h["..GetTradeSkillName()..": "..spellName.."]|h|r";
			end
			return;
		end
		
		return SPF.baseGetTradeSkillRecipeLink(SPF.Data[skillIndex]["original"]);
	end
	return SPF.baseGetTradeSkillRecipeLink(skillIndex);
end

function SPF.GetFirstTradeSkill()
	
	if not (SPF.Data and getn(SPF.Data) > 0)then
		SPF.GetNumTradeSkills();
	end
	
	if SPF.FIRST then
		return SPF.FIRST;
	end
	
	return SPF.baseGetFirstTradeSkill();
end

function SPF.GetTradeSkillItemInfo(skillIndex)
	return SPF.GetItemInfo(SPF.GetTradeSkillItemLink(skillIndex));
end

function SPF.baseGetTradeSkillItemInfo(skillIndex)
	local itemLink = SPF.baseGetTradeSkillItemLink(skillIndex);
	if itemLink then
		return SPF.GetItemInfo(itemLink);
	end
end

function SPF.GetTradeSkillItemSubClass(skillIndex)
	local itemLink = SPF.GetTradeSkillItemLink(skillIndex);
	local _,_,_,_,_, itemType, itemSubType = SPF.GetItemInfo(itemLink)
	return itemType.."_"..itemSubType;
end

function SPF.baseGetTradeSkillItemSubClass(skillIndex)
	local itemLink = SPF.baseGetTradeSkillItemLink(skillIndex);
	local _,_,_,_,_, itemType, itemSubType = SPF.GetItemInfo(itemLink)
	return itemType.."_"..itemSubType;
end

function SPF.SetTradeSkillItem(this, skillIndex, reagentIndex)
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
				-- if not SPF.Data[skillIndex]["skillSubSpellName"] then
					if SPF.Data[skillIndex]["creates"] then
						this:SetHyperlink("item:"..SPF.Data[skillIndex]["creates"]);
					else
						-- return this:SetHyperlink("enchant:"..SPF.Data[skillIndex]["spellID"]);
					end
				-- end
			end
		else
			-- if reagentIndex then
				SPF.baseSetTradeSkillItem(this, SPF.Data[skillIndex]["original"], reagentIndex);
			-- else
				-- SPF.baseSetTradeSkillItem(this, SPF.Data[skillIndex]["original"], reagentIndex);
			-- end
		end
		if SPF:Custom("Functions")["SetCraftItem"] then
			SPF:Custom("Functions")["SetCraftItem"](this, skillIndex, reagentIndex);
		end
	else
	-- if reagentIndex then
		SPF.baseSetTradeSkillItem(this, skillIndex, reagentIndex);
	-- else
		-- return SPF.baseSetTradeSkillItem(this, skillIndex, reagentIndex);
	-- end
	end
end

function SPF.SetTradeSkillDescription(skillIndex)
	-- local TradeSkillReagentLabelText = SPELL_REAGENTS;
	-- if not TradeSkillReagentLabel:IsVisible() then
		-- TradeSkillReagentLabelText = "";
		TradeSkillReagentLabel:Show();
	-- end
	TradeSkillReagentLabel:SetText("|cffffffff"..SPF.GetTradeSkillDescription(skillIndex).."|r"..SPELL_REAGENTS);
	TradeSkillReagentLabel:SetJustifyH("LEFT");
end

function SPF.GetTradeSkillDescription(skillIndex)

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
		local spellName = SPF.baseGetTradeSkillInfo(SPF.Data[skillIndex]["original"]);
		
		if spellName then
			local spellID = SPF.GetRecipeSpellID(spellName);
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
	if itemLink then
		if strfind(itemLink, "item:") then
			local id = string.gsub(itemLink, ".*\124Hitem:(%d+).*", "%1");
			if id then
				if not(GetItemInfo(id)) then
					GameTooltip:SetHyperlink("item:"..id);
					GameTooltip:Hide();
				end
				return GetItemInfo(id);
			end
		elseif strfind(itemLink, "enchant:") then
			local id = string.gsub(itemLink, ".*\124Henchant:(%d+).*", "%1");
			if id then
				if not(GetItemInfo(id)) then
					GameTooltip:SetHyperlink("enchant:"..id);
					GameTooltip:Hide();
				end
				return GetItemInfo(id);
			end
		end
		return GetItemInfo(itemLink);
	end
end

function SPF.GetTradeSkillInvSlots()
	local originalSlots = {GetTradeSkillInvSlots()};
	if not SPF:GetMenu("Right") then
		if SigmaProfessionFilter_RecipeInfo and SPF:SavedData()["Unlearned"] then
			if SPF.RightMenu.LAST_CHECKED ~= time() then
				SPF.RightMenu.LAST_CHECKED = time();
				local neededSlots = {};
				for spellID,spellData in pairs(SPF.GetRecipeInfo() or {}) do
					if spellData then
						local itemID = spellData["creates"];
						if itemID then
							local _,_,_,_,_,_,_,invSlot = GetItemInfo(itemID);
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

function SPF.GetTradeSkillSubClasses()
	local originalSubClasses = {GetTradeSkillSubClasses()};
	
	if not SPF:GetMenu("Left") then
		if SigmaProfessionFilter_RecipeInfo and SPF:SavedData()["Unlearned"] then
			if SPF.LeftMenu.LAST_CHECKED ~= time() then
				SPF.LeftMenu.LAST_CHECKED = time();
				local neededClasses = {};
				local addFirstOriginal = false;
				
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
							addFirstOriginal = true;
						end
					end
				end
				
				SPF.LeftMenu.newClasses = {};
				
				if addFirstOriginal and originalSubClasses[1] then
					table.insert(SPF.LeftMenu.newClasses, originalSubClasses[1]);
				end
				
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

function SPF.TradeSkillFrame_Update()
	
	-- for i=1, CRAFTS_DISPLAYED, 1 do
		-- getfenv()["Craft"..i.."Cost"]:SetText("");
	-- end
	
	SPF.baseTradeSkillFrame_Update();
	
	-- Check if there are any headers
	if SPF.Headers then
		-- If has headers show the expand all button
		if getn(SPF.Headers) > 0 then
			-- If has headers then move all the names to the right
			for i=1, TRADE_SKILLS_DISPLAYED, 1 do
				getfenv()["TradeSkillSkill"..i.."Text"]:ClearAllPoints();
				if i == SPF.ONCLICK then
					SPF.ONCLICK = nil;
					getfenv()["TradeSkillSkill"..i.."Text"]:SetPoint("LEFT", "TradeSkillSkill"..i, "LEFT", 22.65, -1.65);
				else
					getfenv()["TradeSkillSkill"..i.."Text"]:SetPoint("LEFT", "TradeSkillSkill"..i, "LEFT", 21, 0);
				end
			end
			TradeSkillExpandButtonFrame:Show();
		else
			-- If no headers then move all the names to the left
			for i=1, TRADE_SKILLS_DISPLAYED, 1 do
				getfenv()["TradeSkillSkill"..i.."Text"]:ClearAllPoints();
				if i == SPF.ONCLICK then
					SPF.ONCLICK = nil;
					getfenv()["TradeSkillSkill"..i.."Text"]:SetPoint("LEFT", "TradeSkillSkill"..i, "LEFT", 4.65, -1.65);
				else
					getfenv()["TradeSkillSkill"..i.."Text"]:SetPoint("LEFT", "TradeSkillSkill"..i, "LEFT", 3, 0);
				end
			end
			TradeSkillExpandButtonFrame:Hide();
		end
	end
	
	if not SPF.FIRST then
		SPF.ClearTradeSkill();
	end
	
	-- LeatrixPlus compatibility
    if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On" and TradeSkillSkill23) then
		if SPF.Headers and getn(SPF.Headers) == 0 and SPF.FIRST then
			TradeSkillSkill1:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 22, -81);
			if SPF.Data and getn(SPF.Data) > 22  then
				TradeSkillSkill23:Show();
			end
		else
			TradeSkillSkill23:Hide();
			TradeSkillSkill1:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 22, -96);
		end
    end
	
	if SPF.TradeSkillName ~= GetTradeSkillName() then
		SPF.TradeSkillName = GetTradeSkillName();
		SPF.TradeSkillFrame_OnShow(TradeSkillFrame, true);
	end
	
	SPF.Starred.OnUpdate();
end
