local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.Filter2 = CreateFrame("CheckButton", "TradeSkillFilter2Button", TradeSkillFrame, "UICheckButtonTemplate");
SPF2.Filter2.text = SPF2.Filter2:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
SPF2.Filter2.text:SetPoint("LEFT", SPF2.Filter2, "RIGHT", 0, 0);

function SPF2.Filter2.OnLoad()
	SPF2.Filter2:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	
	SPF2.Filter2:SetWidth(15);
	SPF2.Filter2:SetHeight(15);
	SPF2.Filter2:SetFrameLevel(4);
	SPF2.CheckBoxBar:AddButton(SPF2.Filter2);
	
	SPF2.Filter2:SetScript("OnShow", SPF2.Filter2.OnShow);
	SPF2["TSFOnShow"]["SPF2.Filter2.OnShow"] = SPF2.Filter2.OnShow;
	
	SPF2.Filter2:SetScript("OnClick", SPF2.Filter2.OnClick);
	SPF2.Filter2:SetScript("OnEnter", SPF2.Filter2.OnEnter);
	SPF2.Filter2:SetScript("OnLeave", SPF2.Filter2.OnLeave);
	
	SPF2.Filter2.Status = {};
end

function SPF2.Filter2:OnShow()
	SPF2.Filter2:Show();
	SPF2.Filter2.text:SetWidth(0); -- reset width to automatic
	
	SPF2.Filter2.text:SetText(SPF2:Custom("Filter2")["text"] or L["HAVE_MATS"]);
	SPF2.Filter2.tooltipText = SPF2:Custom("Filter2")["tooltip"] or L["HAVE_MATS_TOOLTIP"];
	
	if GetTradeSkillName() then
		SPF2.Filter2:SetChecked(SPF2.Filter2.Status[GetTradeSkillName()]);
	end
end

function SPF2.Filter2:OnClick()
	if (arg1 == "RightButton") then
		SPF2.Filter2:SetChecked(not(SPF2.Filter2:GetChecked()));
		if SPF2:Custom("Filter2")["OnRightClick"] then
			SPF2:Custom("Filter2")["OnRightClick"]();
		else
			SPF2.Filter2:OnRightClick();
		end
	else
		if GetTradeSkillName() then
			SPF2.Filter2.Status[GetTradeSkillName()] = SPF2.Filter2:GetChecked();
		end
	end

	if (SPF2.Filter2:GetChecked()) then
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		PlaySound("igMainMenuOptionCheckBoxOff");
	end
    SPF2.FullUpdate();
end

function SPF2.Filter2:OnRightClick()
	if SPF2:SavedData()["IncludeCraftableMats"] ~= false then
		SPF2:SavedData()["IncludeCraftableMats"] = false;
		message = ("|cffbc5ff4[SPF]|r|cffffcf00["..GetTradeSkillName().."]|r: "..L["Filter2RightClickOFF"]);
		DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
	else
		SPF2:SavedData()["IncludeCraftableMats"] = nil;
		message = "|cffbc5ff4[SPF]|r|cffffcf00["..GetTradeSkillName().."]|r: "..L["Filter2RightClickON"];
		DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
	end
end

function SPF2.Filter2:OnEnter()
    if (SPF2.Filter2.tooltipText) then
        GameTooltip:SetOwner(SPF2.Filter2, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Filter2.tooltipText, nil, nil, nil, nil, true);
    end
	if (SPF2:Custom("Filter2")["Tooltip_OnEnter"]) then
		SPF2:Custom("Filter2")["Tooltip_OnEnter"]();
	else
		GameTooltip:AddLine(L["MORE_OPTIONS"], 0.69, 0.69, 0.69, 1);
		GameTooltip:Show();
	end
end

function SPF2.Filter2.OnLeave()
    GameTooltip:Hide();
end

function SPF2.baseTradeSkillHasMats(skillIndex, requiredAmount, layer)
	
	local skillName, _, numAvailable = SPF2.baseGetTradeSkillInfo(skillIndex);
	
	if numAvailable >= requiredAmount then
		return true;
	end
	
	if SPF2:SavedData()["IncludeCraftableMats"] == false then
		return false;
	end
	
	if not layer then
		layer = 0;
	end
	
	layer = layer + 1;
	
	if layer > 10 then
		return false;
	end
	
	local requiredReagents = {};
	
	local numReagents = SPF2.baseGetTradeSkillNumReagents(skillIndex);
	
	for i=1, numReagents do
		
		local reagentName, _, reagentCount, playerReagentCount = SPF2.baseGetTradeSkillReagentInfo(skillIndex, i);
		
		if not reagentName then
			return false;
		end
		
		if not requiredReagents[reagentName] then
			requiredReagents[reagentName] = 0;
		end
		
		requiredReagents[reagentName] = requiredReagents[reagentName] + reagentCount * requiredAmount - playerReagentCount;
		
		if SPF2.CraftedItems[reagentName] then			
			
			local recursiveHasMats = SPF2.baseTradeSkillHasMats(SPF2.CraftedItems[reagentName], requiredReagents[reagentName], layer);
			
			if recursiveHasMats then
				requiredReagents[reagentName] = nil;
			else
				return false;
			end
		end
	end
	
	for a,b in pairs(requiredReagents) do
		if b and b > 0 then
			return false;
		end
	end
	
	return true;
end

-- Return True if the skill matches the filter
function SPF2.Filter2:Filter(skillIndex)
	
	if not SPF2.Filter2:GetChecked() then
		return true;
	end
	
	if SPF2:Custom("Filter2").Filter then
		return SPF2:Custom("Filter2").Filter(skillIndex);
	end
	
	return SPF2.baseTradeSkillHasMats(skillIndex, 1);
end

-- Return True if the skill matches the filter
function SPF2.Filter2:FilterSpell(spellID)
	if SPF2:Custom("Filter2").FilterSpell then
		return (not SPF2.Filter2:GetChecked() or SPF2:Custom("Filter2").FilterSpell(spellID));
	else
		return not SPF2.Filter2:GetChecked();
	end
end

SPF2.Filter2:OnLoad();
