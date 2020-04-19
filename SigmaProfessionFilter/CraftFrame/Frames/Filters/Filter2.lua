SPF.Filter2 = CreateFrame("CheckButton", nil, CraftFrame, "UICheckButtonTemplate");

function SPF.Filter2.OnLoad()
	SPF.Filter2:SetWidth(15);
	SPF.Filter2:SetHeight(15);
	SPF.Filter2:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 225, -54);
	SPF.Filter2:SetHitRectInsets(0, -60, 0, 0);
	SPF.Filter2:SetFrameLevel(4);
	
	SPF.Filter2:SetScript("OnShow", SPF.Filter2.OnShow);
	SPF.Filter2:SetScript("OnClick", SPF.Filter2.OnClick);
	SPF.Filter2:SetScript("OnEnter", SPF.Filter2.OnEnter);
	SPF.Filter2:SetScript("OnLeave", SPF.Filter2.OnLeave);
	
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF.Filter2:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 225, -57);
    end
end

function SPF.Filter2:OnShow()
	SPF.Filter2.text:SetText(SPF:Custom("Filter2")["text"] or CRAFT_IS_MAKEABLE);
	SPF.Filter2.tooltipText = SPF:Custom("Filter2")["tooltip"] or CRAFT_IS_MAKEABLE_TOOLTIP;
end

function SPF.Filter2:OnClick()
	if (SPF.Filter2:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF:SavedData()["Filter2"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF:SavedData()["Filter2"] = nil;
    end
    SPF.FullUpdate();
end

function SPF.Filter2:OnEnter()
    if (SPF.Filter2.tooltipText) then
        GameTooltip:SetOwner(SPF.Filter2, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF.Filter2.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF.Filter2.OnLeave()
    GameTooltip:Hide();
end

-- Return True if the craft matches the filter
function SPF.Filter2:Filter(craftIndex)
	if SPF:Custom("Filter2").Filter then
		return (not SPF.Filter2:GetChecked() or SPF:Custom("Filter2").Filter(craftIndex));
	else
		local _, _, _, numAvailable = SPF.baseGetCraftInfo(craftIndex);
		return (not SPF.Filter2:GetChecked() or numAvailable > 0);
	end
end

SPF.Filter2:OnLoad();
