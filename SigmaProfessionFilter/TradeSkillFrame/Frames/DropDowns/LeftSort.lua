local SPF2 = SigmaProfessionFilter[2];

SPF2.LeftSort = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate");

function SPF2.LeftSort:OnLoad()
	SPF2.LeftSort:SetWidth(15);
	SPF2.LeftSort:SetHeight(15);
	SPF2.LeftSort:SetPoint("LEFT", SPF2.LeftMenu, "LEFT", 23, 2);
	SPF2.LeftSort:SetHitRectInsets(0, -90, 0, 0);
	SPF2.LeftSort:SetFrameLevel(4);
	
	SPF2.LeftSort:SetScript("OnShow", SPF2.LeftSort.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.LeftSort.OnShow);
	
	SPF2.LeftSort:SetScript("OnClick", SPF2.LeftSort.OnClick);
	SPF2.LeftSort:SetScript("OnEnter", SPF2.LeftSort.OnEnter);
	SPF2.LeftSort:SetScript("OnLeave", SPF2.LeftSort.OnLeave);
end

function SPF2.LeftSort:OnShow()
	SPF2.LeftSort:Show();
	
	if SPF2:Custom("LeftMenu")["disabled"] then
		SPF2.LeftSort:Hide();
	else
		if SPF2:Custom("RightMenu")["disabled"] then
			SPF2:SavedData()["GroupBy"] = nil;
		end
		SPF2.LeftSort.tooltipText = SPF2:Custom("LeftMenu")["tooltip"] or "Sort recipes by the sub-class of the crafted item.";
		SPF2.LeftSort:SetChecked(SPF2:SavedData()["GroupBy"] ~= "Right");
	end
	
    if SPF2:SavedData()["SearchBox"] then
        SPF2.LeftSort:Hide();
    end
end

function SPF2.LeftSort:OnClick(mod)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
	SPF2.LeftSort:SetChecked(true);
	SPF2:SavedData()["GroupBy"] = nil;
	SPF2.RightSort:OnShow();
	SPF2.FullUpdate();
end

function SPF2.LeftSort:OnEnter()
    if (SPF2.LeftSort.tooltipText) then
        GameTooltip:SetOwner(SPF2.LeftSort, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.LeftSort.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF2.LeftSort:OnLeave()
    GameTooltip:Hide();
end

SPF2.LeftSort.OnLoad();
