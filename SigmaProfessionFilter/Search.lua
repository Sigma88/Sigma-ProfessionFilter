function SPF_Search_OnLoad()
	SPF_Search.text:SetText("Search");
	SPF_Search.tooltipText = "Toggle the Search Box.";
	SPF_Search:SetChecked(Sigma_ProfessionFilter_SearchBox);
	
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF_Search:SetPoint("TOPLEFT", CraftFrame, 72, -57);
		CraftFramePointsLabel:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 100, -43);
    end
end

function SPF_Search_OnShow()
	
	-- Check if the profession is supported
	local Profession = SPF[GetCraftName()];
	
	-- Toggle the option
	if Profession and (Profession["Left"] or Profession["Right"]) then
		SPF_Search:SetChecked(Sigma_ProfessionFilter_SearchBox);
	else
		Sigma_ProfessionFilter_SearchBox = false;
		SPF_Search:Hide();
	end
end

function SPF_Search_OnClick() -- REMEMBER TO RESET ALL UI ELEMENTS ON THIS CLICK
	if (SPF_Search:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX")
		Sigma_ProfessionFilter_SearchBox = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX")
		Sigma_ProfessionFilter_SearchBox = nil;
		end
	SPF_SearchBox:SetText("");
	
	if Sigma_ProfessionFilter_SearchBox then		
		SPF_SearchBox:Show();
		SPF_LeftMenu:Hide();
		SPF_RightMenu:Hide();
		SPF_LeftSort:Hide();
		SPF_RightSort:Hide();
	else
		SPF_SearchBox:Hide();
		SPF_LeftMenu:Show();
		SPF_RightMenu:Show();
		SPF_LeftSort:Show();
		SPF_RightSort:Show();
	end
	
	SPF_FullUpdate();
end

function SPF_Search_OnEnter()
    if (SPF_Search.tooltipText) then
        GameTooltip:SetOwner(SPF_Search, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF_Search.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF_Search_OnLeave()
    GameTooltip:Hide();
end
