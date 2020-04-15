function SPF_Option2_OnLoad()
	SPF_Option2.text:SetText(CRAFT_IS_MAKEABLE);
	SPF_Option2.tooltipText = CRAFT_IS_MAKEABLE_TOOLTIP;
end

function SPF_Option2_OnClick()
	if (SPF_Option2:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX")
		Sigma_ProfessionFilter_HaveMats = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX")
		Sigma_ProfessionFilter_HaveMats = false;
    end
    SPF_FullUpdate();
end

function SPF_Option2_OnEnter()
    if (SPF_Option2.tooltipText) then
        GameTooltip:SetOwner(SPF_Option2, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF_Option2.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF_Option2_OnLeave()
    GameTooltip:Hide();
end
