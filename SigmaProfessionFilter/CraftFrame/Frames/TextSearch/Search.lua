SPF.Search = CreateFrame("CheckButton", nil, CraftFrame, "UICheckButtonTemplate");

function SPF.Search:OnLoad()
	SPF.Search:SetWidth(15);
	SPF.Search:SetHeight(15);
	SPF.Search:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 72, -54);
	SPF.Search:SetHitRectInsets(0, -32, 0, 0);
	SPF.Search:SetFrameLevel(4);
	
	SPF.Search:SetScript("OnShow", SPF.Search.OnShow);
	SPF.Search:SetScript("OnClick", SPF.Search.OnClick);
	SPF.Search:SetScript("OnEnter", SPF.Search.OnEnter);
	SPF.Search:SetScript("OnLeave", SPF.Search.OnLeave);
	
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF.Search:SetPoint("TOPLEFT", CraftFrame, 72, -57);
    end
end

function SPF.Search.OnShow()
	if (SPF:GetMenu("Left") or SPF:GetMenu("Right")) then
		SPF.Search.text:SetText("Search");
		SPF.Search.tooltipText = "Toggle the Search Box.";
		SPF.Search:SetChecked(SPF:SavedData()["SearchBox"]);
	else
		SPF.Search:Hide();
	end
end

function SPF.Search.OnClick()
	
	if (SPF.Search:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF:SavedData()["SearchBox"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF:SavedData()["SearchBox"] = nil;
	end
	
	SPF.SearchBox:SetText("");
	
	if SPF:SavedData()["SearchBox"] then		
		SPF.SearchBox:Show();
		SPF.LeftMenu:Hide();
		SPF.RightMenu:Hide();
	else
		SPF.SearchBox:Hide();
		SPF.LeftMenu:Show();
		SPF.RightMenu:Show();
	end
	
	SPF.FullUpdate();
end

function SPF.Search.OnEnter()
    if (SPF.Search.tooltipText) then
        GameTooltip:SetOwner(SPF.Search, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF.Search.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF.Search.OnLeave()
    GameTooltip:Hide();
end

SPF.Search:OnLoad();
