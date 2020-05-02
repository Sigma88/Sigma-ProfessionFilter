local SPF2 = SigmaProfessionFilter[2];

SPF2.Filter1 = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate");

function SPF2.Filter1.OnLoad()
	SPF2.Filter1:SetWidth(15);
	SPF2.Filter1:SetHeight(15);
	SPF2.Filter1:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 135, -54);
	SPF2.Filter1:SetHitRectInsets(0, -60, 0, 0);
	SPF2.Filter1:SetFrameLevel(4);
	
	SPF2.Filter1:SetScript("OnShow", SPF2.Filter1.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.Filter1.OnShow);
	
	SPF2.Filter1:SetScript("OnClick", SPF2.Filter1.OnClick);
	SPF2.Filter1:SetScript("OnEnter", SPF2.Filter1.OnEnter);
	SPF2.Filter1:SetScript("OnLeave", SPF2.Filter1.OnLeave);
	
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF2.Filter1:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 135, -57);
    end
end

function SPF2.Filter1:OnShow()
	SPF2.Filter1:Show();
	SPF2.Filter1.text:SetText(SPF2:Custom("Filter1")["text"] or "Has Skill Up");
	SPF2.Filter1.tooltipText = SPF2:Custom("Filter1")["tooltip"] or "Only show the recipes that can make your skill go up.";
end

function SPF2.Filter1:OnClick()
	if (SPF2.Filter1:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		
		SPF2:SavedData()["Filter1"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF2:SavedData()["Filter1"] = nil;
    end
    SPF2.FullUpdate();
end

function SPF2.Filter1:OnEnter()
    if (SPF2.Filter1.tooltipText) then
        GameTooltip:SetOwner(SPF2.Filter1, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Filter1.tooltipText, nil, nil, nil, nil, true);
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
		local _, skillType = SPF2.baseGetTradeSkillInfo(skillIndex);
		return (not SPF2.Filter1:GetChecked() or skillType ~= "trivial");
	end
end

SPF2.Filter1:OnLoad();
