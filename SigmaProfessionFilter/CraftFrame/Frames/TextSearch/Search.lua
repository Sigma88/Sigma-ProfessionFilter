local L = SigmaProfessionFilter.L;
local SPF1 = SigmaProfessionFilter[1];

SPF1.Search = CreateFrame("CheckButton", nil, CraftFrame, "UICheckButtonTemplate");

function SPF1.Search.OnLoad()
	SPF1.Search:SetWidth(15);
	SPF1.Search:SetHeight(15);
	SPF1.Search:SetFrameLevel(4);
	SPF1.CheckBoxBar:AddButton(SPF1.Search);
	
	SPF1.Search:SetScript("OnShow", SPF1.Search.OnShow);
	hooksecurefunc("CraftFrame_OnShow", SPF1.Search.OnShow);
	
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
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF1:SavedData()["SearchBox"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF1:SavedData()["SearchBox"] = nil;
	end
	
	SPF1.SearchBox:SetText("");
	
	if SPF1:SavedData()["SearchBox"] then		
		SPF1.SearchBox:Show();
		SPF1.LeftMenu:Hide();
		SPF1.RightMenu:Hide();
	else
		SPF1.SearchBox:Hide();
		SPF1.LeftMenu:Show();
		SPF1.RightMenu:Show();
	end
	
	CraftFrame_OnShow();
	
	SPF1.FullUpdate();
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
