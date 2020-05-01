SPF.RightSort = CreateFrame("CheckButton", nil, SPF.RightMenu, "UICheckButtonTemplate");

function SPF.RightSort:OnLoad()
	SPF.RightSort:SetWidth(15);
	SPF.RightSort:SetHeight(15);
	SPF.RightSort:SetPoint("LEFT", SPF.RightMenu, "LEFT", 23, 2);
	SPF.RightSort:SetHitRectInsets(0, -90, 0, 0);
	SPF.RightSort:SetFrameLevel(4);
	
	SPF.RightSort:SetScript("OnShow", SPF.RightSort.OnShow);
	SPF.RightSort:SetScript("OnClick", SPF.RightSort.OnClick);
	SPF.RightSort:SetScript("OnEnter", SPF.RightSort.OnEnter);
	SPF.RightSort:SetScript("OnLeave", SPF.RightSort.OnLeave);
end

function SPF.RightSort.OnShow()
	if (SPF:GetMenu("Right")) then
		SPF.RightSort.tooltipText = SPF:Custom("RightMenu")["tooltip"] or "Sort recipes by the slot they enchant.";
		SPF.RightSort:SetChecked(SPF:SavedData()["GroupBy"] == "Right");
	else
		SPF.RightSort:OnClick("silent");
	end
end

function SPF.RightSort.OnClick()
	if SPF:GetMenu("Right") then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF.RightSort:SetChecked(true);
		SPF:SavedData()["GroupBy"] = "Right";
		SPF.LeftSort.OnShow();
		SPF.FullUpdate();
	end
end

function SPF.RightSort.OnEnter()
    if (SPF.RightSort.tooltipText) then
        GameTooltip:SetOwner(SPF.RightSort, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF.RightSort.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF.RightSort.OnLeave()
    GameTooltip:Hide();
end

SPF.RightSort:OnLoad();
