local L = SigmaProfessionFilter.L;

function GetTradeSkillName()
	local skillName = GetTradeSkillLine();
	
	return L[skillName.."_SpellName"] or skillName;
end

local SPF2 = SigmaProfessionFilter[2];

SPF2.INV = {
	["INVTYPE_AMMO"] = AMMOSLOT;
	["INVTYPE_BAG"] = BAGSLOT;
	["INVTYPE_BODY"] = SHIRTSLOT;
	["INVTYPE_CHEST"] = CHESTSLOT;
	["INVTYPE_CLOAK"] = BACKSLOT;
	["INVTYPE_FEET"] = FEETSLOT;
	["INVTYPE_FINGER"] = FINGER0SLOT;
	["INVTYPE_HAND"] = HANDSSLOT;
	["INVTYPE_HEAD"] = HEADSLOT;
	["INVTYPE_HOLDABLE"] = SECONDARYHANDSLOT;
	["INVTYPE_LEGS"] = LEGSSLOT;
	["INVTYPE_NECK"] = NECKSLOT;
	["INVTYPE_QUIVER"] = BAGSLOT;
	["INVTYPE_RANGED"] = RANGEDSLOT;
	["INVTYPE_RANGEDRIGHT"] = RANGEDSLOT;
	["INVTYPE_RELIC"] = RELICSLOT;
	["INVTYPE_ROBE"] = CHESTSLOT;
	["INVTYPE_SHIELD"] = SHIELDSLOT;
	["INVTYPE_SHOULDER"] = SHOULDERSLOT;
	["INVTYPE_TABARD"] = TABARDSLOT;
	["INVTYPE_THROWN"] = RANGEDSLOT;
	["INVTYPE_TRINKET"] = TRINKET0SLOT;
	["INVTYPE_WAIST"] = WAISTSLOT;
	["INVTYPE_WEAPON"] = SECONDARYHANDSLOT;
	["INVTYPE_WEAPONMAINHAND"] = MAINHANDSLOT;
	["INVTYPE_WEAPONOFFHAND"] = SECONDARYHANDSLOT;
	["INVTYPE_2HWEAPON"] = MAINHANDSLOT;
	["INVTYPE_WRIST"] = WRISTSLOT;
}

function SPF2:GetSlot(TYPE)
	return SPF2.INV[TYPE] or NONEQUIPSLOT;
end

function SPF2:SavedData(professionSpecific)
	if not SigmaProfessionFilter_SavedVariables then
		SigmaProfessionFilter_SavedVariables = {};
	end
	
	local professionName = GetTradeSkillName();
	
	if professionSpecific == false then
		professionName = "ALL_PROFESSIONS";
	end
	
	if not SigmaProfessionFilter_SavedVariables[professionName] then
		SigmaProfessionFilter_SavedVariables[professionName] = {};
	end
	
	return SigmaProfessionFilter_SavedVariables[professionName];
end

function SPF2:GetMenu(side)
	if SigmaProfessionFilter[GetTradeSkillName()] and SigmaProfessionFilter[GetTradeSkillName()][side] then
		return SigmaProfessionFilter[GetTradeSkillName()][side];
	end
end

function SPF2:GetSelected(side)
	if not SigmaProfessionFilter[GetTradeSkillName()] then
		SigmaProfessionFilter[GetTradeSkillName()] = {};
	end
	if SigmaProfessionFilter[GetTradeSkillName()]["Selected"] then
		return SigmaProfessionFilter[GetTradeSkillName()]["Selected"][side] or 0;
	end
	return 0;
end

function SPF2:SetSelected(side, id)
	if not SigmaProfessionFilter[GetTradeSkillName()] then
		SigmaProfessionFilter[GetTradeSkillName()] = {};
	end
	if not SigmaProfessionFilter[GetTradeSkillName()]["Selected"] then
		SigmaProfessionFilter[GetTradeSkillName()]["Selected"] = {};
	end
	SigmaProfessionFilter[GetTradeSkillName()]["Selected"][side] = id;
end

function SPF2:Custom(target)
	if SigmaProfessionFilter[GetTradeSkillName()] then
		if SigmaProfessionFilter[GetTradeSkillName()][target] then
			return SigmaProfessionFilter[GetTradeSkillName()][target];
		end
	end
	return {};
end

function SPF2.trim(str)
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function SPF2.match(str, filter)
	if str and filter then
		if #filter == 0 then
			return true;
		end
		for f in string.gmatch(filter:lower(), "[^%;]+") do
			if string.find(str:lower(), f) then
				return true;
			end
		end
	end
end

-- Return the group index if the skill matches the filter
-- Return 0 to disable the filter
-- Otherwise return nil
function SPF2:GetGroup(side, skillIndex, groupIndex)
	if SPF2:Custom(side.."Menu")["disabled"] then
		return 0;
	else
		local targetValue = SPF2.baseGetTradeSkillInfo(skillIndex);
		for i = 1, #SPF2:GetMenu(side), 1 do
			if groupIndex > 0 then
				i = groupIndex;
			end
			
			local button = SPF2:GetMenu(side)[i];
			
			if SPF2.match(targetValue, button.filter) then
				return i;
			end
			
			if groupIndex > 0 then
				return nil;
			end
		end
	end
	return nil;
end
function SPF2:GetGroupSpell(side, spellID, groupIndex)
	if SPF2:Custom(side.."Menu")["disabled"] then
		return 0;
	else
		local spellName = GetSpellInfo(spellID);
		for i = 1, #SPF2:GetMenu(side), 1 do
			if groupIndex > 0 then
				i = groupIndex;
			end
			
			local button = SPF2:GetMenu(side)[i];
			
			if SPF2.match(spellName, button.filter) then
				return i;
			end
			
			if groupIndex > 0 then
				return nil;
			end
		end
	end
	return nil;
end

function SPF2:FilterWithSearchBox(skillIndex)
	
	if SPF2.SearchBox ~= nil then
		local searchFilter = SPF2.trim(SPF2.SearchBox:GetText():lower());
		local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = SPF2.baseGetTradeSkillInfo(skillIndex);
		
		-- Check the Name
		if (SPF2:SavedData()["SearchNames"] ~= false) then
			if strmatch(skillName:lower(), searchFilter) ~= nil then
				return true;
			end
		end
		
		-- Check the Headers
		if (SPF2:SavedData()["SearchHeaders"] ~= false) then
			
			-- Check the LeftMenu
			if not SPF2:Custom("LeftMenu")["disabled"] then
				if SPF2:GetMenu("Left") then
					for	i,button in ipairs(SPF2:GetMenu("Left")) do
						if strmatch(button.name:lower(), searchFilter) ~= nil then
							local groupIndex = SPF2.LeftMenu:Filter(craftIndex, i) or 0;
							if groupIndex > 0 then
								return true;
							end
						end
					end
				else
					if SPF2.OriginalHeaders then
						if strmatch(SPF2.OriginalHeaders[skillIndex]:lower(), searchFilter) ~= nil then
							return true;
						end
					end
				end
			end
			
			-- Check the RightMenu
			if not SPF2:Custom("RightMenu")["disabled"] then
				if SPF2:GetMenu("Right") then
					for	i,button in ipairs(SPF2:GetMenu("Right")) do
						if strmatch(button.name:lower(), searchFilter) ~= nil then
							local groupIndex = SPF2.RightMenu:Filter(craftIndex, i) or 0;
							if groupIndex > 0 then
								return true;
							end
						end
					end
				else
					local groupIndex = SPF2.RightMenu:Filter(skillIndex, 0);
					local groupName = select(groupIndex, GetTradeSkillInvSlots());						
					if strmatch(groupName:lower(), searchFilter) ~= nil then
						return true;
					end
				end
			end
		end
		
		-- Check the Reagents
		if (SPF2:SavedData()["SearchReagents"] ~= false) then
			for i = 1, SPF2.baseGetTradeSkillNumReagents(skillIndex), 1 do
				local reagentName, reagentTexture, reagentCount, playerReagentCount = SPF2.baseGetTradeSkillReagentInfo(skillIndex, i);
				
				if (reagentName and strmatch(reagentName:lower(), searchFilter)) then
					return true
				end
			end
		end
	end
	
	return false;
end

function SPF2:FilterSpellWithSearchBox(spellID)
	
	if SPF2.SearchBox ~= nil then
		local searchFilter = SPF2.trim(SPF2.SearchBox:GetText():lower());
		local spellName = GetSpellInfo(spellID);
		
		-- Check the Name
		if (SPF2:SavedData()["SearchNames"] ~= false) then
			if strmatch(spellName:lower(), searchFilter) ~= nil then
				return true;
			end
		end
		
		-- Check the Headers
		if (SPF2:SavedData()["SearchHeaders"] ~= false) then
			
			-- Check the LeftMenu
			if not SPF2:Custom("LeftMenu")["disabled"] then
				if SPF2:GetMenu("Left") then
					for	i,button in ipairs(SPF2:GetMenu("Left")) do
						if strmatch(button.name:lower(), searchFilter) ~= nil then
							local groupIndex = SPF2.LeftMenu:FilterSpell(spellID, i) or 0;
							if groupIndex > 0 then
								return true;
							end
						end
					end
				else
					-- if SPF2.OriginalHeaders then
						-- if strmatch(SPF2.OriginalHeaders[skillIndex]:lower(), searchFilter) ~= nil then
							-- return true;
						-- end
					-- end
				end
			end
			
			-- Check the RightMenu
			if not SPF2:Custom("RightMenu")["disabled"] then
				if SPF2:GetMenu("Right") then
					for	i,button in ipairs(SPF2:GetMenu("Right")) do
						if strmatch(button.name:lower(), searchFilter) ~= nil then
							local groupIndex = SPF2.RightMenu:FilterSpell(spellID, i) or 0;
							if groupIndex > 0 then
								return true;
							end
						end
					end
				else
					local groupIndex = SPF2.RightMenu:FilterSpell(spellID, 0);
					local groupName = select(groupIndex, GetTradeSkillInvSlots());						
					if strmatch(groupName:lower(), searchFilter) ~= nil then
						return true;
					end
				end
			end
		end
		
		-- Check the Reagents
		if (SPF2:SavedData()["SearchReagents"] ~= false) then
			
			local reagents = SPF2.GetRecipeInfo(spellID, "reagents") or {};
			
			for i,reagentInfo in ipairs(reagents) do
				local itemID = reagentInfo["itemID"];
				if itemID then
					local itemName = GetItemInfo(itemID);
					
					if (itemName and strmatch(itemName:lower(), searchFilter)) then
						return true
					end
				end
			end
		end
	end
	
	return false;
end

function SPF2.TradeSkillFrame_PostUpdate()
	
	-- Check if there are any headers
	if SPF2.Headers then
		-- If has headers show the expand all button
		if #SPF2.Headers > 0 then
			-- If has headers then move all the names to the right
			for i=1, TRADE_SKILLS_DISPLAYED, 1 do
				_G["TradeSkillSkill"..i.."Text"]:ClearAllPoints();
				if i == SPF2.ONCLICK then
					SPF2.ONCLICK = nil;
					_G["TradeSkillSkill"..i.."Text"]:SetPoint("LEFT", "TradeSkillSkill"..i, "LEFT", 22.65, -1.65);
				else
					_G["TradeSkillSkill"..i.."Text"]:SetPoint("LEFT", "TradeSkillSkill"..i, "LEFT", 21, 0);
				end
			end
			TradeSkillExpandButtonFrame:Show();
		else
			-- If no headers then move all the names to the left
			for i=1, TRADE_SKILLS_DISPLAYED, 1 do
				_G["TradeSkillSkill"..i.."Text"]:ClearAllPoints();
				if i == SPF2.ONCLICK then
					SPF2.ONCLICK = nil;
					_G["TradeSkillSkill"..i.."Text"]:SetPoint("LEFT", "TradeSkillSkill"..i, "LEFT", 4.65, -1.65);
				else
					_G["TradeSkillSkill"..i.."Text"]:SetPoint("LEFT", "TradeSkillSkill"..i, "LEFT", 3, 0);
				end
			end
			TradeSkillExpandButtonFrame:Hide();
		end
	end
	
	if not SPF2.FIRST then
		SPF2.ClearTradeSkill();
	end
	
	-- LeatrixPlus compatibility
    if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On" and TradeSkillSkill23) then
		if SPF2.Headers and #SPF2.Headers == 0 and SPF2.FIRST then
			TradeSkillSkill1:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 22, -81);
			if SPF2.Data and #SPF2.Data > 22  then
				TradeSkillSkill23:Show();
			end
		else
			TradeSkillSkill23:Hide();
			TradeSkillSkill1:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 22, -96);
		end
    end
	
	if SPF2.TradeSkillName ~= GetTradeSkillName() then
		SPF2.TradeSkillName = GetTradeSkillName();
		SPF2.FullUpdate();
	end
	
end

hooksecurefunc("TradeSkillFrame_Update", SPF2.TradeSkillFrame_PostUpdate);

function SPF2.TradeSkillReagent_OnClick(self, button, down)
	if button ~= "LeftButton" or IsShiftKeyDown() or IsControlKeyDown() or IsAltKeyDown() then
		return;
	end
	for i=1, MAX_TRADE_SKILL_REAGENTS do
		if _G["TradeSkillReagent"..i] == self then
			local reagentName = GetTradeSkillReagentInfo(SPF2.SELECTED, i);
			local reagentSkill = SPF2.GetTradeSkillFromName(reagentName);
			if reagentSkill then
				TradeSkillFrame_SetSelection(reagentSkill);
				TradeSkillFrame_Update();
				return;
			end
		end
	end
end

function SPF2.GetTradeSkillFromName(targetName)
	for j=1, GetNumTradeSkills() do
		local skillName = GetTradeSkillInfo(j);
		if targetName == skillName then
			return j;
		end
	end
end

for i=1, MAX_TRADE_SKILL_REAGENTS do
	local reagentButton = _G["TradeSkillReagent"..i];
	local createButton = CreateFrame("Button", "TradeSkillReagent"..i.."CreateButton", reagentButton, "MagicButtonTemplate");
	
	reagentButton:HookScript("OnClick", SPF2.TradeSkillReagent_OnClick);
	
	-- Create the Button
	_G["TradeSkillReagent"..i.."CreateButton"] = createButton;
	createButton.LeftSeparator:Hide();
	createButton.RightSeparator:Hide();
	-- Set size and position
	createButton:SetHeight(18);
	createButton:SetWidth(reagentButton:GetWidth());
	createButton:SetPoint("TOPLEFT", reagentButton, "BOTTOMLEFT", 0, 2);
	-- Set the text
	createButton:SetText(L["CRAFT_REAGENT"]);
	-- Set Scripts
	createButton.id = i;
	
	function createButton:OnClick()
		local reagentName, _, reagentCount, playerReagentCount = SPF2.GetTradeSkillReagentInfo(SPF2.SELECTED, createButton.id);
		
		local skillIndex = SPF2.CraftedItems[reagentName];
		if skillIndex then
			DoTradeSkill(skillIndex, reagentCount * TradeSkillInputBox:GetNumber() - playerReagentCount);
		end
	end
	
	createButton:SetScript("OnClick", createButton.OnClick);
	
	function createButton:Update()
		if not TradeSkillFrame:IsVisible() then return; end
		local reagentName, reagentCount, playerReagentCount;
		if SPF2.SELECTED then
			reagentName, _, reagentCount, playerReagentCount = SPF2.GetTradeSkillReagentInfo(SPF2.SELECTED, createButton.id);
		end
		if not SPF2.CraftedItems[reagentName] then
			createButton:Hide();
		else
			createButton:Show();
			local createAmount = reagentCount * TradeSkillInputBox:GetNumber() - playerReagentCount;
			
			if createAmount < 0 then
				createAmount = 0;
			end
			
			local _,_, numAvailable = SPF2.baseGetTradeSkillInfo(SPF2.CraftedItems[reagentName]);
			
			createButton:SetEnabled(numAvailable >= createAmount and createAmount > 0);
			createButton:SetText(L["CRAFT_REAGENT"]..": "..createAmount);
		end
		
		if createButton.id == MAX_TRADE_SKILL_REAGENTS then
			for i=4,MAX_TRADE_SKILL_REAGENTS,2 do
				local leftReagent = _G["TradeSkillReagent"..(i-1)];
				local rightReagent = _G["TradeSkillReagent"..(i)];
				if _G["TradeSkillReagent"..(i-3).."CreateButton"]:IsVisible() or _G["TradeSkillReagent"..(i-2).."CreateButton"]:IsVisible() then
					leftReagent:SetPoint("TOPLEFT", _G["TradeSkillReagent"..(i-3)], "BOTTOMLEFT", 0, -20);
					rightReagent:SetPoint("TOPLEFT", _G["TradeSkillReagent"..(i-2)], "BOTTOMLEFT", 0, -20);
				else
					leftReagent:SetPoint("TOPLEFT", _G["TradeSkillReagent"..(i-3)], "BOTTOMLEFT", 0, -2);
					rightReagent:SetPoint("TOPLEFT", _G["TradeSkillReagent"..(i-2)], "BOTTOMLEFT", 0, -2);
				end
			end
		end
	end
	hooksecurefunc("TradeSkillFrame_Update", createButton.Update);
end

function SPF2.ClearTradeSkill()
	TradeSkillSkillName:Hide();
	TradeSkillSkillIcon:Hide();
	TradeSkillRequirementLabel:Hide();
	TradeSkillRequirementText:SetText("");
	for i=1, MAX_TRADE_SKILL_REAGENTS, 1 do
		_G["TradeSkillReagent"..i]:Hide();
	end
	TradeSkillDetailScrollFrameScrollBar:Hide();
	TradeSkillDetailScrollFrameTop:Hide();
	TradeSkillDetailScrollFrameBottom:Hide();
	TradeSkillHighlightFrame:Hide();
	TradeSkillCreateButton:Disable();
	TradeSkillCreateAllButton:Disable();
	TradeSkillReagentLabel:Hide();
end

function SPF2.FullUpdate(keepCollapsed)
	if not keepCollapsed then
		SPF2.Collapsed = nil;
	end
	
	SPF2.FILTERED = nil;
	SPF2.GetNumTradeSkills();
	TradeSkillListScrollFrameScrollBar:SetValue(0);
	if SPF2.FIRST then
		FauxScrollFrame_SetOffset(TradeSkillListScrollFrame, 0);
		SPF2.TradeSkillFrame_SetSelection(SPF2.FIRST);
	end
	TradeSkillFrame_Update();
end

function SPF2.GetRecipeInfo(spellID, infoType)
	
	if not(spellID) and infoType then
		return;
	end
	
	local RI = SigmaProfessionFilter_RecipeInfo;
	
	if RI and RI.Data then
		local professionName = GetTradeSkillName();
		if professionName then
			local Recipes = RI.Data[professionName];
			if Recipes then
				if spellID then
					if  Recipes[spellID] then
						if infoType then
							return Recipes[spellID][infoType];
						else
							return Recipes[spellID];
						end
					end
				else
					return Recipes;
				end
			end
		end
	end
end
