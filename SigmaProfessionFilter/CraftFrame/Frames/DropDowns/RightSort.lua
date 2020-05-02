local SPF1 = SigmaProfessionFilter[1];

SPF1.RightSort = CreateFrame("CheckButton", nil, SPF1.RightMenu, "UICheckButtonTemplate");

function SPF1.RightSort:OnLoad()
	SPF1.RightSort:SetWidth(15);
	SPF1.RightSort:SetHeight(15);
	SPF1.RightSort:SetPoint("LEFT", SPF1.RightMenu, "LEFT", 23, 2);
	SPF1.RightSort:SetHitRectInsets(0, -90, 0, 0);
	SPF1.RightSort:SetFrameLevel(4);
	
	SPF1.RightSort:SetScript("OnShow", SPF1.RightSort.OnShow);
	SPF1.RightSort:SetScript("OnClick", SPF1.RightSort.OnClick);
	SPF1.RightSort:SetScript("OnEnter", SPF1.RightSort.OnEnter);
	SPF1.RightSort:SetScript("OnLeave", SPF1.RightSort.OnLeave);
end

function SPF1.RightSort.OnShow()
	if (SPF1:GetMenu("Right")) then
		SPF1.RightSort.tooltipText = SPF1:Custom("RightMenu")["tooltip"];
		SPF1.RightSort:SetChecked(SPF1:SavedData()["GroupBy"] == "Right");
	else
		SPF1.RightSort:OnClick("silent");
	end
end

function SPF1.RightSort.OnClick()
	if SPF1:GetMenu("Right") then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF1.RightSort:SetChecked(true);
		SPF1:SavedData()["GroupBy"] = "Right";
		SPF1.LeftSort.OnShow();
		SPF1.FullUpdate();
	end
end

function SPF1.RightSort.OnEnter()
    if (SPF1.RightSort.tooltipText) then
        GameTooltip:SetOwner(SPF1.RightSort, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF1.RightSort.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF1.RightSort.OnLeave()
    GameTooltip:Hide();
end

SPF1.RightSort:OnLoad();
