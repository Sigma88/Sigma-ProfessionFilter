local L = SigmaProfessionFilter.L;
local SPF = SigmaProfessionFilter[2];

function GetTradeSkillName()
	local skillName = GetTradeSkillLine();
	return L[skillName.."_SpellName"] or skillName;
end

function SPF.GetProfessionIcon()
	local spellName = GetTradeSkillName();
	if spellName then
		for i = 1, 200, 1 do
			local buttonName = GetSpellName(i, BOOKTYPE_SPELL)
			if buttonName == spellName then
				return GetSpellTexture(i, BOOKTYPE_SPELL)
			end
		end
	end
end

SPF.INV = {
	["INVTYPE_AMMO"] = 0;
	["INVTYPE_HEAD"] = 1;
	["INVTYPE_NECK"] = 2;
	["INVTYPE_SHOULDER"] = 3;
	["INVTYPE_BODY"] = 4;
	["INVTYPE_ROBE"] = 5;
	["INVTYPE_CHEST"] = 5;
	["INVTYPE_WAIST"] = 6;
	["INVTYPE_LEGS"] = 7;
	["INVTYPE_FEET"] = 8;
	["INVTYPE_WRIST"] = 9;
	["INVTYPE_HAND"] = 10;
	["INVTYPE_FINGER"] = 11;
	["INVTYPE_TRINKET"] = 13;
	["INVTYPE_CLOAK"] = 15;
	["INVTYPE_WEAPONMAINHAND"] = 16;
	["INVTYPE_2HWEAPON"] = 16;
	["INVTYPE_HOLDABLE"] = 17;
	["INVTYPE_WEAPON"] = 17;
	["INVTYPE_WEAPONOFFHAND"] = 17;
	["INVTYPE_SHIELD"] = 17;
	["INVTYPE_RANGED"] = 18;
	["INVTYPE_RANGEDRIGHT"] = 18;
	["INVTYPE_THROWN"] = 18;
	["INVTYPE_RELIC"] = 18;
	["INVTYPE_TABARD"] = 19;
	["INVTYPE_BAG"] = 20;
	["INVTYPE_QUIVER"] = 20;
}

SPF.SLOTS = {
	[0] = AMMOSLOT;
	[1] = HEADSLOT;
	[2] = NECKSLOT;
	[3] = SHOULDERSLOT;
	[4] = SHIRTSLOT;
	[5] = CHESTSLOT;
	[6] = WAISTSLOT;
	[7] = LEGSSLOT;
	[8] = FEETSLOT;
	[9] = WRISTSLOT;
	[10] = HANDSSLOT;
	[11] = FINGER0SLOT;
	[13] = TRINKET0SLOT;
	[15] = BACKSLOT;
	[16] = MAINHANDSLOT;
	[17] = SECONDARYHANDSLOT;
	[18] = RANGEDSLOT;
	[19] = TABARDSLOT;
	[20] = BAGSLOT;
}


function SPF:GetSlot(TYPE)
	if TYPE then
		local invtype = SPF.INV[TYPE];
		if invtype then
			local invslot = SPF.SLOTS[invtype];
			if invslot then
				return invslot;
			end
		end
		return NONEQUIPSLOT;
	end
end

function SPF:SavedData(professionSpecific)
	if not SigmaProfessionFilter_SavedVariables then
		SigmaProfessionFilter_SavedVariables = {};
	end
	
	local professionName = GetTradeSkillName();
	
	if professionSpecific == false then
		professionName = "ALL_PROFESSIONS";
	end
	
	if professionName then
		
		if not SigmaProfessionFilter_SavedVariables[professionName] then
			SigmaProfessionFilter_SavedVariables[professionName] = {};
		end
		
		return SigmaProfessionFilter_SavedVariables[professionName];
	end
end

function SPF:GetMenu(side)
	if SigmaProfessionFilter[GetTradeSkillName()] and SigmaProfessionFilter[GetTradeSkillName()][side] then
		return SigmaProfessionFilter[GetTradeSkillName()][side];
	end
end

function SPF:GetSelected(side)
	local skillName = GetTradeSkillName();
	if skillName then
		if not SigmaProfessionFilter[skillName] then
			SigmaProfessionFilter[skillName] = {};
		end
		if SigmaProfessionFilter[skillName]["Selected"] then
			return SigmaProfessionFilter[skillName]["Selected"][side] or 0;
		end
	end
	return 0;
end

function SPF:SetSelected(side, id)
	local skillName = GetTradeSkillName();
	if skillName then
		if not SigmaProfessionFilter[skillName] then
			SigmaProfessionFilter[skillName] = {};
		end
		if not SigmaProfessionFilter[skillName]["Selected"] then
			SigmaProfessionFilter[skillName]["Selected"] = {};
		end
		SigmaProfessionFilter[skillName]["Selected"][side] = id;
	end
end

function SPF:Custom(target)
	if SigmaProfessionFilter[GetTradeSkillName()] then
		if SigmaProfessionFilter[GetTradeSkillName()][target] then
			return SigmaProfessionFilter[GetTradeSkillName()][target];
		end
	end
	return {};
end

function SPF.trim(str)
	return (string.gsub(str,"^%s*(.-)%s*$", "%1"))
end

function SPF.split(str, sep)
	if not str or strlen(str) == 0 or not sep or strlen(sep) == 0 then
		return str;
	end
	local output = {};
	while string.len(str) > 0 do
		local start,stop = string.find(str, sep);
		if start then
			if start > 1 then
				table.insert(output, string.sub(str,1,start-1));
			end
			str = string.sub(str,stop+1);
		else
			table.insert(output, str);
			str = "";
		end
	end
	return unpack(output);
end

function SPF.match(str, filter)
	if not str or strlen(str) == 0 then
		return false;
	end
	if not filter or strlen(filter) == 0 then
		return true;
	end
	str = strlower(str);
	filter = strlower(string.gsub(filter, ";+", ";"));
	while strlen(filter) > 0 do
		local startPos, endPos = strfind(filter, "[^%;]+");
		if startPos then
			local f = strsub(filter, startPos, endPos);
			if not pcall(strfind, str, f) then
				return true;
			end
			if strfind(str, f) then
				return true;
			end
			filter = strsub(filter,endPos+2);
		else
			-- This only happens when filter == ";"
			return true;
		end
	end
end

-- Return the group index if the skill matches the filter
-- Return 0 to disable the filter
-- Otherwise return nil
function SPF:GetGroup(side, skillIndex, groupIndex)
	if SPF:Custom(side.."Menu")["disabled"] then
		return 0;
	else
		local targetValue = SPF.baseGetTradeSkillInfo(skillIndex);
		for i = 1, getn(SPF:GetMenu(side)), 1 do
			if groupIndex > 0 then
				i = groupIndex;
			end
			
			local button = SPF:GetMenu(side)[i];
			
			if SPF.match(targetValue, button.filter) then
				return i;
			end
			
			if groupIndex > 0 then
				return nil;
			end
		end
	end
	return nil;
end

function SPF:GetGroupSpell(side, spellID, groupIndex)
	if SPF:Custom(side.."Menu")["disabled"] then
		return 0;
	else
		local spellName = SPF.GetRecipeInfo(spellID, "name");
		for i = 1, getn(SPF:GetMenu(side)), 1 do
			if groupIndex > 0 then
				i = groupIndex;
			end
			
			local button = SPF:GetMenu(side)[i];
			
			if SPF.match(spellName, button.filter) then
				return i;
			end
			
			if groupIndex > 0 then
				return nil;
			end
		end
	end
	return nil;
end

function SPF:FilterWithSearchBox(skillIndex)
	
	if SPF.SearchBox ~= nil then
		local searchFilter = SPF.trim(strlower(SPF.SearchBox:GetText()));
		if not searchFilter or strlen(searchFilter) == 0 then
			return true;
		end
		
		local skillName = SPF.baseGetTradeSkillInfo(skillIndex);
		if not skillName or strlen(skillName) == 0 then
			return true;
		end
		
		-- Check the Name
		if (SPF:SavedData()["SearchNames"] ~= false) then
			if SPF.match(skillName, searchFilter) then
				return true;
			end
		end
		
		-- Check the Headers
		if (SPF:SavedData()["SearchHeaders"] ~= false) then
			
			-- Check the LeftMenu
			if not SPF:Custom("LeftMenu")["disabled"] then
				if SPF:GetMenu("Left") then
					local leftHeaderID = SPF.LeftMenu:Filter(skillIndex, 0);
					if leftHeaderID and leftHeaderID > 0 then
						local leftHeaderName = SPF:GetMenu("Left")[leftHeaderID].name;
						if SPF.match(leftHeaderName, searchFilter) then
							return true;
						end
					end
				else
					-- TODO: filter default DropDown
				end
			end
			
			-- Check the RightMenu
			if not SPF:Custom("RightMenu")["disabled"] then
				if SPF:GetMenu("Right") then
					local rightHeaderID = SPF.RightMenu:Filter(skillIndex, 0);
					if rightHeaderID and rightHeaderID > 0 then
						local rightHeaderName = SPF:GetMenu("Right")[rightHeaderID].name;
						if SPF.match(rightHeaderName, searchFilter) then
							return true;
						end
					end
				else
					local groupIndex = SPF.RightMenu:Filter(skillIndex, 0);
					for i,gN in pairs(SPF.GetTradeSkillInvSlots()) do
						if groupIndex == i then
							groupName = gN;
							break;
						end
					end
					
					if groupName and SPF.match(groupName, searchFilter) then
						return true;
					end
				end
			end
		end
		
		-- Check the Reagents
		if (SPF:SavedData()["SearchReagents"] ~= false) then
			for i = 1, SPF.baseGetTradeSkillNumReagents(skillIndex), 1 do
				local reagentName, reagentTexture, reagentCount, playerReagentCount = SPF.baseGetTradeSkillReagentInfo(skillIndex, i);
				
				if (reagentName and SPF.match(reagentName, searchFilter)) then
					return true
				end
			end
		end
	end
	
	return false;
end

function SPF:FilterSpellWithSearchBox(spellID)
	
	if SPF.SearchBox ~= nil then

		local searchFilter = SPF.trim(strlower(SPF.SearchBox:GetText()));
		if not searchFilter or strlen(searchFilter) == 0 then
			return true;
		end
		
		local spellName = SPF.GetRecipeInfo(spellID, "name");
		if not spellName or strlen(spellName) == 0 then
			return true;
		end
		
		-- Check the Name
		if (SPF:SavedData()["SearchNames"] ~= false) then
			if SPF.match(spellName, searchFilter) then
				return true;
			end
		end
		
		-- Check the Headers
		if (SPF:SavedData()["SearchHeaders"] ~= false) then
			
			-- Check the LeftMenu
			if not SPF:Custom("LeftMenu")["disabled"] then
				if SPF:GetMenu("Left") then
					local leftHeaderID = SPF.LeftMenu:FilterSpell(spellID, 0);
					if leftHeaderID and leftHeaderID > 0 then
						local leftHeaderName = SPF:GetMenu("Left")[leftHeaderID].name;
						if SPF.match(leftHeaderName, searchFilter) then
							return true;
						end
					end
				else
					local groupIndex = SPF.LeftMenu:FilterSpell(spellID, 0);
					for i,gN in ipairs(SPF.GetTradeSkillSubClasses()) do
						if groupIndex == i then
							groupName = gN;
							break;
						end
					end
					if groupName and SPF.match(groupName, searchFilter) then
						return true;
					end
				end
			end
			
			-- Check the RightMenu
			if not SPF:Custom("RightMenu")["disabled"] then
				if SPF:GetMenu("Right") then
					local rightHeaderID = SPF.RightMenu:FilterSpell(spellID, 0);
					if rightHeaderID and rightHeaderID > 0 then
						local rightHeaderName = SPF:GetMenu("Right")[rightHeaderID].name;
						if SPF.match(rightHeaderName, searchFilter) then
							return true;
						end
					end
				else
					local groupIndex = SPF.RightMenu:FilterSpell(spellID, 0);
					for i,gN in ipairs(SPF.GetTradeSkillInvSlots()) do
						if groupIndex == i then
							groupName = gN;
							break;
						end
					end
					if groupName and SPF.match(groupName, searchFilter) then
						return true;
					end
				end
			end
		end
		
		-- Check the Reagents
		if (SPF:SavedData()["SearchReagents"] ~= false) then
			
			local reagents = SPF.GetRecipeInfo(spellID, "reagents") or {};
			
			for i,reagentInfo in ipairs(reagents) do
				local itemID = reagentInfo["itemID"];
				if itemID then
					local itemName = SPF.GetItemInfo(itemID);
					
					if (itemName and SPF.match(itemName, searchFilter)) then
						return true;
					end
				end
			end
		end

		return false;
	end
	
	return true;
end

function SPF.TradeSkillReagent_OnClick(self, button, down)
	if button ~= "LeftButton" or IsShiftKeyDown() or IsControlKeyDown() or IsAltKeyDown() then
		return;
	end
	for i=1, MAX_TRADE_SKILL_REAGENTS do
		if getfenv()["TradeSkillReagent"..i] == self then
			local reagentName = GetTradeSkillReagentInfo(SPF.SELECTED, i);
			local reagentSkill = SPF.GetTradeSkillFromName(reagentName);
			if reagentSkill then
				TradeSkillFrame_SetSelection(reagentSkill);
				TradeSkillFrame_Update();
				return;
			end
		end
	end
end

function SPF.GetTradeSkillFromName(targetName)
	for j=1, GetNumTradeSkills() do
		local skillName = GetTradeSkillInfo(j);
		if targetName == skillName then
			return j;
		end
	end
end
--[[
for i=1, MAX_TRADE_SKILL_REAGENTS do
	local reagentButton = getfenv()["TradeSkillReagent"..i];
	local createButton = CreateFrame("Button", "TradeSkillReagent"..i.."CreateButton", reagentButton, "MagicButtonTemplate");
	
	reagentButton:HookScript("OnClick", SPF.TradeSkillReagent_OnClick);
	
	-- Create the Button
	getfenv()["TradeSkillReagent"..i.."CreateButton"] = createButton;
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
		local reagentName, _, reagentCount, playerReagentCount = SPF.GetTradeSkillReagentInfo(SPF.SELECTED, createButton.id);
		
		local skillIndex = SPF.CraftedItems[reagentName];
		if skillIndex then
			DoTradeSkill(skillIndex, reagentCount * TradeSkillInputBox:GetNumber() - playerReagentCount);
		end
	end
	
	createButton:SetScript("OnClick", createButton.OnClick);
	
	function createButton:Update()
		if not TradeSkillFrame:IsVisible() then return; end
		local reagentName, reagentCount, playerReagentCount;
		if SPF.SELECTED then
			reagentName, _, reagentCount, playerReagentCount = SPF.GetTradeSkillReagentInfo(SPF.SELECTED, createButton.id);
		end
		if not SPF.CraftedItems[reagentName] then
			createButton:Hide();
		else
			createButton:Show();
			local createAmount = reagentCount * TradeSkillInputBox:GetNumber() - playerReagentCount;
			
			if createAmount < 0 then
				createAmount = 0;
			end
			
			local _,_, numAvailable = SPF.baseGetTradeSkillInfo(SPF.CraftedItems[reagentName]);
			
			createButton:SetEnabled(numAvailable >= createAmount and createAmount > 0);
			createButton:SetText(L["CRAFT_REAGENT"]..": "..createAmount);
		end
		
		if createButton.id == MAX_TRADE_SKILL_REAGENTS then
			for i=4,MAX_TRADE_SKILL_REAGENTS,2 do
				local leftReagent = getfenv()["TradeSkillReagent"..(i-1)];
				local rightReagent = getfenv()["TradeSkillReagent"..(i)];
				if getfenv()["TradeSkillReagent"..(i-3).."CreateButton"]:IsVisible() or getfenv()["TradeSkillReagent"..(i-2).."CreateButton"]:IsVisible() then
					leftReagent:SetPoint("TOPLEFT", getfenv()["TradeSkillReagent"..(i-3)], "BOTTOMLEFT", 0, -20);
					rightReagent:SetPoint("TOPLEFT", getfenv()["TradeSkillReagent"..(i-2)], "BOTTOMLEFT", 0, -20);
				else
					leftReagent:SetPoint("TOPLEFT", getfenv()["TradeSkillReagent"..(i-3)], "BOTTOMLEFT", 0, -2);
					rightReagent:SetPoint("TOPLEFT", getfenv()["TradeSkillReagent"..(i-2)], "BOTTOMLEFT", 0, -2);
				end
			end
		end
	end
	SPF.hooksecurefunc("TradeSkillFrame_Update", createButton.Update);
end
]]--
function SPF.ClearTradeSkill()
	TradeSkillSkillName:Hide();
	TradeSkillSkillIcon:Hide();
	TradeSkillRequirementLabel:Hide();
	TradeSkillRequirementText:SetText("");
	for i=1, MAX_TRADE_SKILL_REAGENTS, 1 do
		getfenv()["TradeSkillReagent"..i]:Hide();
	end
	TradeSkillDetailScrollFrameScrollBar:Hide();
	TradeSkillDetailScrollFrameTop:Hide();
	TradeSkillDetailScrollFrameBottom:Hide();
	TradeSkillHighlightFrame:Hide();
	TradeSkillCreateButton:Disable();
	TradeSkillCreateAllButton:Disable();
	TradeSkillReagentLabel:Hide();
	-- TradeSkillDescription:Hide();
	-- TradeSkillCost:Hide();
end

function SPF.ClearNewFeatures()
	if TradeSkillFrameAvailableFilterCheckButton then
		TradeSkillFrameAvailableFilterCheckButton:SetChecked(false);
		TradeSkillFrameAvailableFilterCheckButton:Hide();
	end
	if TradeSkillOnlyShowMakeable then
		TradeSkillOnlyShowMakeable(false);
	end
end

if TradeSkillFrameAvailableFilterCheckButton then
	TradeSkillFrameAvailableFilterCheckButton:SetScript("OnShow", SPF.ClearNewFeatures);
end

function SPF.FullUpdate(keepCollapsed)
	if not TradeSkillFrame:IsVisible() then
		return;
	end

	if not keepCollapsed then
		SPF.Collapsed = nil;
	end
	
	SPF.FILTERED = nil;
	
	SPF.GetNumTradeSkills();
	TradeSkillListScrollFrameScrollBar:SetValue(0);
	if SPF.FIRST then
		FauxScrollFrame_SetOffset(TradeSkillListScrollFrame, 0);
		SPF.TradeSkillFrame_SetSelection(SPF.FIRST);
	end
	TradeSkillFrame_Update();
	SPF.PortraitChanger.OnShow();
	SPF.CheckBoxBar.OnShow();
end

function SPF.GetRecipeInfo(spellID, infoType1, infoType2)
	
	if not(spellID) and (infoType1 or infoType2) then
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
						if infoType1 then
							if infoType2 then
								return Recipes[spellID][infoType1], Recipes[spellID][infoType2];
							else
								return Recipes[spellID][infoType1];
							end
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

function SPF.GetRecipeSpellID(spellName)
	
	if not(spellName) then
		return;
	end
	
	local RI = SigmaProfessionFilter_RecipeInfo;
	
	if RI and RI.Data then
		local professionName = GetTradeSkillName();
		if professionName then
			local Recipes = RI.Data[professionName];
			if Recipes then
				for id,spell in pairs(Recipes) do
					if spell and spell.name == spellName then
						return id;
					end
				end
			end
		end
	end
end

function SPF.baseGetTradeSkillItemLevel(index)
	for i,value in pairs({GetTradeSkillItemStats(index)}) do
		if strfind(value, "^Level (%d+)$") then
			return string.gsub(value, "^Level (%d+)$", "%1");
		end
	end

end

function SPF.GetRequiresText(skillIndex)
	local learnedAt = SPF.Data[skillIndex]["learnedAt"];
	if learnedAt then
		if SPF:Custom("Functions")["requiresText"] then
			return SPF:Custom("Functions")["requiresText"](learnedAt);
		else
			if learnedAt then
				local color = "|cffffffff";
				_, currentLevel = GetTradeSkillLine();
				if currentLevel < learnedAt then
					color = "|cffff0000";
				end
				local requiresText = "Requires "..GetTradeSkillName().." ("..learnedAt..")";
				return color..requiresText.."|r\n\n";
			end
		end
	end
end
