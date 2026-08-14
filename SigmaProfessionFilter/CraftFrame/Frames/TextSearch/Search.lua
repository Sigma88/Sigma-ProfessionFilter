local L = SigmaProfessionFilter.L;
local SPF1 = SigmaProfessionFilter[1];

SPF1.Search = CreateFrame("CheckButton", "CraftFrameSearchButton", CraftFrame, "UICheckButtonTemplate");
SPF1.Search.text = SPF1.Search:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
SPF1.Search.text:SetPoint("LEFT", SPF1.Search, "RIGHT", 0, 0);

function SPF1.Search.OnLoad()
	SPF1.Search:SetWidth(15);
	SPF1.Search:SetHeight(15);
	SPF1.Search:SetFrameLevel(4);
	SPF1.CheckBoxBar:AddButton(SPF1.Search);
	
	SPF1.Search:SetScript("OnShow", SPF1.Search.OnShow);
	SPF1["CFOnShow"]["SPF1.Search.OnShow"] = SPF1.Search.OnShow;
	
	SPF1.Search:SetScript("OnClick", SPF1.Search.OnClick);
	SPF1.Search:SetScript("OnEnter", SPF1.Search.OnEnter);
	SPF1.Search:SetScript("OnLeave", SPF1.Search.OnLeave);
end

function SPF1.Search:OnShow()
	SPF1.Search:Show();
	SPF1.Search.text:SetWidth(0); -- reset width to automatic
	SPF1.Search.text:SetText(L["SEARCH"]); -- set the text even when hidden
	
	if (SPF1:GetMenu("Left") or SPF1:GetMenu("Right")) then
		SPF1.Search.tooltipText = L["SEARCH_TOOLTIP"];
		SPF1.Search:SetChecked(SPF1:SavedData()["SearchBox"]);
		SPF1.Search.disabled = nil;
	else
		SPF1.Search:Hide();
		SPF1.Search.disabled = true;
	end
end

function SPF1.Search.OnClick()
	
	if (SPF1.Search:GetChecked()) then
        --PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		PlaySound("igMainMenuOptionCheckBoxOn");
		SPF1:SavedData()["SearchBox"] = true;
    else
        --PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		PlaySound("igMainMenuOptionCheckBoxOff");
		SPF1:SavedData()["SearchBox"] = nil;
	end
	
	SPF1.SearchBox:SetText("");
	
	SPF1.CraftFrame_OnShow(CraftFrame, true);
	
	-- SPF1.FullUpdate();
end

function SPF1.Search.OnEnter()
    if (SPF1.Search.tooltipText) then
        GameTooltip:SetOwner(SPF1.Search, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF1.Search.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF1.Search.OnLeave()
    GameTooltip:Hide();
end

SPF1.Search.OnLoad();
