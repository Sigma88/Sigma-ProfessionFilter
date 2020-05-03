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

function SPF2:SavedData()
	if not SigmaProfessionFilter_SavedVariables then
		SigmaProfessionFilter_SavedVariables = {};
	end
	if not SigmaProfessionFilter_SavedVariables[GetTradeSkillName()] then
		SigmaProfessionFilter_SavedVariables[GetTradeSkillName()] = {};
	end
	return SigmaProfessionFilter_SavedVariables[GetTradeSkillName()];
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
	if SPF2:GetMenu(side) and SigmaProfessionFilter[GetTradeSkillName()]["Selected"] then
		return SigmaProfessionFilter[GetTradeSkillName()]["Selected"][side] or 0;
	end
	return 0;
end

function SPF2:SetSelected(side, id)
	if not SigmaProfessionFilter[GetTradeSkillName()] then
		SigmaProfessionFilter[GetTradeSkillName()] = {};
	end
	if SPF2:GetMenu(side) then
		if not SigmaProfessionFilter[GetTradeSkillName()]["Selected"] then
			SigmaProfessionFilter[GetTradeSkillName()]["Selected"] = {};
		end
		SigmaProfessionFilter[GetTradeSkillName()]["Selected"][side] = id;
	end
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

-- Return the group index if the skill matches the filter
-- Return 0 when to disable the filter
-- Otherwise return nil
function SPF2:GetGroup(side, skillIndex, groupIndex)
	if (SPF2:GetMenu(side)) then
		local targetValue = SPF2.baseGetTradeSkillInfo(skillIndex);
		for i = 1, #SPF2:GetMenu(side), 1 do
			if groupIndex > 0 then
				i = groupIndex;
			end
			
			local button = SPF2:GetMenu(side)[i];
			
			if string.find(button.filter, ";") then
				for f in string.gmatch(button.filter, "[^%;]+") do
					if string.find(targetValue, f) then
						return i;
					end
				end
			else
				if (string.find(targetValue, button.filter)) then
					return i;
				end
			end
			
			if groupIndex > 0 then
				return nil;
			end
		end
	elseif SPF2:Custom(side.."Menu")["disabled"] then
		return 0;
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
						local groupIndex = SPF2.LeftMenu:Filter(skillIndex, i);
						if groupIndex > 0 then
							if strmatch(button.name:lower(), searchFilter) ~= nil then
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
						local groupIndex = SPF2.RightMenu:Filter(skillIndex, i);
						if groupIndex > 0 then
							if strmatch(button.name:lower(), searchFilter) ~= nil then
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

function SPF2.TradeSkillFrame_PostUpdate()
	
	-- Update the TradeSkillInputBox
	SPF2.GetTradeskillRepeatCount();
	
	-- Check if there are any headers
	if SPF2.Headers then
		-- If has headers show the expand all button
		if #SPF2.Headers > 0 then
			-- If has headers then move all the names to the right
			for i=1, TRADE_SKILLS_DISPLAYED, 1 do
				_G["TradeSkillSkill"..i.."Text"]:SetPoint("TOPLEFT", "TradeSkillSkill"..i, "TOPLEFT", 21, 0);
			end
			TradeSkillExpandButtonFrame:Show();
		else
			-- If no headers then move all the names to the left
			for i=1, TRADE_SKILLS_DISPLAYED, 1 do
				_G["TradeSkillSkill"..i.."Text"]:SetPoint("TOPLEFT", "TradeSkillSkill"..i, "TOPLEFT", 3, 0);
			end
			TradeSkillExpandButtonFrame:Hide();
		end
	end
	
	if not SPF2.FIRST then
		SPF2.ClearTradeSkill();
	end
	
	--LeatrixPlus compatibility
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
end

hooksecurefunc("TradeSkillFrame_Update", SPF2.TradeSkillFrame_PostUpdate);

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
end

function SPF2.FullUpdate()
	SPF2.GetNumTradeSkills();
	TradeSkillListScrollFrameScrollBar:SetValue(0);
	if SPF2.FIRST then
		FauxScrollFrame_SetOffset(TradeSkillListScrollFrame, 0);
		SPF2.TradeSkillFrame_SetSelection(SPF2.FIRST);
	end
	TradeSkillFrame_Update();
end
