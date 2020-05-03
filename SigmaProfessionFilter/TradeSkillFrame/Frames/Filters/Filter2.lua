local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.Filter2 = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate");

function SPF2.Filter2.OnLoad()
	SPF2.Filter2:SetWidth(15);
	SPF2.Filter2:SetHeight(15);
	SPF2.Filter2:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 225, -54);
	SPF2.Filter2:SetHitRectInsets(0, -60, 0, 0);
	SPF2.Filter2:SetFrameLevel(4);
	
	SPF2.Filter2:SetScript("OnShow", SPF2.Filter2.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.Filter2.OnShow);
	
	SPF2.Filter2:SetScript("OnClick", SPF2.Filter2.OnClick);
	SPF2.Filter2:SetScript("OnEnter", SPF2.Filter2.OnEnter);
	SPF2.Filter2:SetScript("OnLeave", SPF2.Filter2.OnLeave);
	
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF2.Filter2:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 225, -57);
    end
end

function SPF2.Filter2:OnShow()
	SPF2.Filter2:Show();
	SPF2.Filter2.text:SetText(SPF2:Custom("Filter2")["text"] or L["HAVE_MATS"]);
	SPF2.Filter2.tooltipText = SPF2:Custom("Filter2")["tooltip"] or L["HAVE_MATS_TOOLTIP"];
end

function SPF2.Filter2:OnClick()
	if (SPF2.Filter2:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF2:SavedData()["Filter2"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF2:SavedData()["Filter2"] = nil;
    end
    SPF2.FullUpdate();
end

function SPF2.Filter2:OnEnter()
    if (SPF2.Filter2.tooltipText) then
        GameTooltip:SetOwner(SPF2.Filter2, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Filter2.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF2.Filter2.OnLeave()
    GameTooltip:Hide();
end

-- Return True if the skill matches the filter
function SPF2.Filter2:Filter(skillIndex)
	if SPF2:Custom("Filter2").Filter then
		return (not SPF2.Filter2:GetChecked() or SPF2:Custom("Filter2").Filter(skillIndex));
	else
		local _,_, numAvailable = SPF2.baseGetTradeSkillInfo(skillIndex);
		return (not SPF2.Filter2:GetChecked() or numAvailable > 0);
	end
end

SPF2.Filter2:OnLoad();
