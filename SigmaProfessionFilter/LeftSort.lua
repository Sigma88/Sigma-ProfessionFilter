function SPF_LeftSort_OnLoad()
	SPF_LeftSort.tooltipText = "Sort recipes by the bonus they provide.";
end

function SPF_LeftSort_OnShow()
	local Profession = SPF[GetCraftDisplaySkillLine()];
	
	if (Profession and (not Sigma_ProfessionFilter_SearchBar)) then
		if (Sigma_ProfessionFilter_GroupBy == nil) then
			Sigma_ProfessionFilter_GroupBy = {};
		end
		SPF_LeftSort:SetChecked(Sigma_ProfessionFilter_GroupBy[GetCraftDisplaySkillLine()] == "Left");
	else
		SPF_LeftSort:Hide();
	end
end

function SPF_LeftSort_OnClick()
	SPF_LeftSort:SetChecked(true);
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
	
	if (Sigma_ProfessionFilter_GroupBy == nil) then
		Sigma_ProfessionFilter_GroupBy = {};
	end
	Sigma_ProfessionFilter_GroupBy[GetCraftDisplaySkillLine()] = "Left";
	
	SPF_RightSort_OnShow();
    SPF_FullUpdate();
end

function SPF_LeftSort_OnEnter()
    if (SPF_LeftSort.tooltipText) then
        GameTooltip:SetOwner(SPF_LeftSort, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF_LeftSort.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF_LeftSort_OnLeave()
    GameTooltip:Hide();
end
