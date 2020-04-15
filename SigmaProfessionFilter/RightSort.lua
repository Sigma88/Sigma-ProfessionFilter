function SPF_RightSort_OnLoad()
	SPF_RightSort.tooltipText = "Sort recipes by the bonus they provide.";
end

function SPF_RightSort_OnShow()
	local Profession = SPF[GetCraftDisplaySkillLine()];
	
	if (Profession and (not Sigma_ProfessionFilter_SearchBar)) then
		if (Sigma_ProfessionFilter_GroupBy == nil) then
			Sigma_ProfessionFilter_GroupBy = {};
		end
		SPF_RightSort:SetChecked(Sigma_ProfessionFilter_GroupBy[GetCraftDisplaySkillLine()] ~= "Left");
	else
		SPF_RightSort:Hide();
	end
end

function SPF_RightSort_OnClick()
	SPF_RightSort:SetChecked(true);
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
	
	if (Sigma_ProfessionFilter_GroupBy == nil) then
		Sigma_ProfessionFilter_GroupBy = {};
	end
	Sigma_ProfessionFilter_GroupBy[GetCraftDisplaySkillLine()] = "Right";
	
	SPF_LeftSort_OnShow();
    SPF_FullUpdate();
end

function SPF_RightSort_OnEnter()
    if (SPF_RightSort.tooltipText) then
        GameTooltip:SetOwner(SPF_RightSort, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF_RightSort.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF_RightSort_OnLeave()
    GameTooltip:Hide();
end
