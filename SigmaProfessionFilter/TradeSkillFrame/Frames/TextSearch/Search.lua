local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.Search = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate");

function SPF2.Search.OnLoad()
	SPF2.Search:SetWidth(15);
	SPF2.Search:SetHeight(15);
	SPF2.Search:SetFrameLevel(4);
	SPF2.CheckBoxBar:AddButton(SPF2.Search);
	
	SPF2.Search:SetScript("OnShow", SPF2.Search.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.Search.OnShow);
	
	SPF2.Search:SetScript("OnClick", SPF2.Search.OnClick);
	SPF2.Search:SetScript("OnEnter", SPF2.Search.OnEnter);
	SPF2.Search:SetScript("OnLeave", SPF2.Search.OnLeave);
end

function SPF2.Search:OnShow()
	SPF2.Search:Show();
	SPF2.Search.text:SetWidth(0); -- reset width to automatic
	SPF2.Search.text:SetText(L["SEARCH"]); -- set the text even when hidden
	
	if not(SPF2:Custom("LeftMenu")["disabled"] and SPF2:Custom("RightMenu")["disabled"]) then
		SPF2.Search.tooltipText = L["SEARCH_TOOLTIP"];
		SPF2.Search:SetChecked(SPF2:SavedData()["SearchBox"]);
		SPF2.Search.disabled = nil;
	else
		SPF2.Search:Hide();
		SPF2.Search.disabled = true;
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
