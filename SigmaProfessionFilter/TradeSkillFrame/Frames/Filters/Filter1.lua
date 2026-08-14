local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.Filter1 = CreateFrame("CheckButton", "TradeSkillFilter1Button", TradeSkillFrame, "UICheckButtonTemplate");
SPF2.Filter1.text = SPF2.Filter1:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
SPF2.Filter1.text:SetPoint("LEFT", SPF2.Filter1, "RIGHT", 0, 0);

function SPF2.Filter1.OnLoad()
	SPF2.Filter1:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	
	SPF2.Filter1:SetWidth(15);
	SPF2.Filter1:SetHeight(15);
	SPF2.Filter1:SetFrameLevel(4);
	SPF2.CheckBoxBar:AddButton(SPF2.Filter1);
	
	SPF2.Filter1:SetScript("OnShow", SPF2.Filter1.OnShow);
	SPF2["TSFOnShow"]["SPF2.Filter1.OnShow"] = SPF2.Filter1.OnShow;
	
	SPF2.Filter1:SetScript("OnClick", SPF2.Filter1.OnClick);
	SPF2.Filter1:SetScript("OnEnter", SPF2.Filter1.OnEnter);
	SPF2.Filter1:SetScript("OnLeave", SPF2.Filter1.OnLeave);
	
	SPF2.Filter1.Status = {};
end

function SPF2.Filter1:OnShow()
	SPF2.Filter1:Show();
	SPF2.Filter1.text:SetWidth(0); -- reset width to automatic
	
	SPF2.Filter1.text:SetText(SPF2:Custom("Filter1")["text"] or L["HAS_SKILL_UP"]);
	SPF2.Filter1.tooltipText = SPF2:Custom("Filter1")["tooltip"] or L["HAS_SKILL_UP_TOOLTIP"];
	
	if GetTradeSkillName() then
		SPF2.Filter1:SetChecked(SPF2.Filter1.Status[GetTradeSkillName()]);
	end
end

function SPF2.Filter1.OnClick()
	if (arg1 == "RightButton") then
		SPF2.Filter1:SetChecked(not(SPF2.Filter1:GetChecked()));
		if SPF2:Custom("Filter1")["OnRightClick"] then
			SPF2:Custom("Filter1")["OnRightClick"]();
		else
			SPF2.Filter1:OnRightClick();
		end
	else
		if GetTradeSkillName() then
			SPF2.Filter1.Status[GetTradeSkillName()] = SPF2.Filter1:GetChecked();
		end
	end
	if (SPF2.Filter1:GetChecked()) then
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		PlaySound("igMainMenuOptionCheckBoxOff");
	end
    SPF2.FullUpdate();
end

function SPF2.Filter1:OnRightClick()
	if not SPF2:SavedData()["IncludedSkillTypes"] then
		SPF2:SavedData()["IncludedSkillTypes"] = 0;
	end
	
	SPF2:SavedData()["IncludedSkillTypes"] = (SPF2:SavedData()["IncludedSkillTypes"] + 1);
	if SPF2:SavedData()["IncludedSkillTypes"] >= 3 then
		SPF2:SavedData()["IncludedSkillTypes"] = 0;
	end
	
	local message = "|cffbc5ff4[SPF]|r|cffffcf00["..GetTradeSkillName().."]|r: "..L["Filter1RightClick"].."|cffff8040["..L["ORANGE"].."] |r";
	
	if SPF2:SavedData()["IncludedSkillTypes"] < 2 then
		message = message.."|cffffff00["..L["YELLOW"].."] |r";
	end
	if SPF2:SavedData()["IncludedSkillTypes"] < 1 then
		message = message.."|cff40bf40["..L["GREEN"].."]|r";
	end
	DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
end

function SPF2.Filter1:OnEnter()
    if (SPF2.Filter1.tooltipText) then
        GameTooltip:SetOwner(SPF2.Filter1, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Filter1.tooltipText, nil, nil, nil, nil, true);
    end
	if (SPF2:Custom("Filter1")["Tooltip_OnEnter"]) then
		SPF2:Custom("Filter1")["Tooltip_OnEnter"]();
	else
		GameTooltip:AddLine(L["MORE_OPTIONS"], 0.69, 0.69, 0.69, 1);
		GameTooltip:Show();
	end
end

function SPF2.Filter1:OnLeave()
    GameTooltip:Hide();
end

-- Return True if the skill matches the filter
function SPF2.Filter1:Filter(skillIndex)
	if SPF2:Custom("Filter1").Filter then
		return (not SPF2.Filter1:GetChecked() or SPF2:Custom("Filter1").Filter(skillIndex));
	else
		if not SPF2.Filter1:GetChecked() then
			return true;
		end
		
		local _, skillType = SPF2.baseGetTradeSkillInfo(skillIndex);
		
		if skillType == "trivial" then
			return false;
		end
		
		if SPF2:SavedData()["IncludedSkillTypes"] then
			if skillType == "medium" then
				return SPF2:SavedData()["IncludedSkillTypes"] < 2;
			end
			
			if skillType == "easy" then
				return SPF2:SavedData()["IncludedSkillTypes"] < 1;
			end
		end
		
		return true;
	end
end

-- Return True if the skill matches the filter
function SPF2.Filter1:FilterSpell(spellID)
	if SPF2:Custom("Filter1").FilterSpell then
		return (not SPF2.Filter1:GetChecked() or SPF2:Custom("Filter1").FilterSpell(spellID));
	else
		return not SPF2.Filter1:GetChecked();
	end
end

SPF2.Filter1:OnLoad();
