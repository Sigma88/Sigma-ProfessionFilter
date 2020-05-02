local SPF2 = SigmaProfessionFilter[2];

SPF2.Search = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate");

function SPF2.Search.OnLoad()
	SPF2.Search:SetWidth(15);
	SPF2.Search:SetHeight(15);
	SPF2.Search:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 72, -54);
	SPF2.Search:SetHitRectInsets(0, -32, 0, 0);
	SPF2.Search:SetFrameLevel(4);
	
	SPF2.Search:SetScript("OnShow", SPF2.Search.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.Search.OnShow);
	
	SPF2.Search:SetScript("OnClick", SPF2.Search.OnClick);
	SPF2.Search:SetScript("OnEnter", SPF2.Search.OnEnter);
	SPF2.Search:SetScript("OnLeave", SPF2.Search.OnLeave);
	
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF2.Search:SetPoint("TOPLEFT", TradeSkillFrame, 72, -57);
    end
end

function SPF2.Search:OnShow()
	
	SPF2.Search:Show();
	
	if not(SPF2:Custom("LeftMenu")["disabled"] and SPF2:Custom("RightMenu")["disabled"]) then
		SPF2.Search.text:SetText("Search");
		SPF2.Search.tooltipText = "Toggle the Search Box.";
		SPF2.Search:SetChecked(SPF2:SavedData()["SearchBox"]);
	else
		SPF2.Search:Hide();
	end
end

function SPF2.Search.OnClick()
	
	if (SPF2.Search:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF2:SavedData()["SearchBox"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF2:SavedData()["SearchBox"] = nil;
	end
	
	SPF2.SearchBox:SetText("");
	
	TradeSkillFrame_OnShow();
	
	SPF2.FullUpdate();
end

function SPF2.Search.OnEnter()
    if (SPF2.Search.tooltipText) then
        GameTooltip:SetOwner(SPF2.Search, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Search.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF2.Search.OnLeave()
    GameTooltip:Hide();
end

SPF2.Search.OnLoad();
