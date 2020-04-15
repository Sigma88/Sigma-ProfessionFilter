function SPF_Option1_OnLoad()
	SPF_Option1.text:SetText("Has Skill Up");
	SPF_Option1.tooltipText = "Only show the recipes that can make your skill go up.";
end

function SPF_Option1_OnClick()
	if (SPF_Option1:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX")
		Sigma_ProfessionFilter_HasSkillUp = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX")
		Sigma_ProfessionFilter_HasSkillUp = false;
    end
    SPF_FullUpdate();
end

function SPF_Option1_OnEnter()
    if (SPF_Option1.tooltipText) then
        GameTooltip:SetOwner(SPF_Option1, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF_Option1.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF_Option1_OnLeave()
    GameTooltip:Hide();
end
