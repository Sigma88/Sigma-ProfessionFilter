local SPF1 = SigmaProfessionFilter[1];

SPF1.LeftSort = CreateFrame("CheckButton", nil, SPF1.LeftMenu, "UICheckButtonTemplate");

function SPF1.LeftSort:OnLoad()
	SPF1.LeftSort:SetWidth(15);
	SPF1.LeftSort:SetHeight(15);
	SPF1.LeftSort:SetPoint("LEFT", SPF1.LeftMenu, "LEFT", 23, 2);
	SPF1.LeftSort:SetHitRectInsets(0, -90, 0, 0);
	SPF1.LeftSort:SetFrameLevel(4);
	
	SPF1.LeftSort:SetScript("OnShow", SPF1.LeftSort.OnShow);
	SPF1.LeftSort:SetScript("OnClick", SPF1.LeftSort.OnClick);
	SPF1.LeftSort:SetScript("OnEnter", SPF1.LeftSort.OnEnter);
	SPF1.LeftSort:SetScript("OnLeave", SPF1.LeftSort.OnLeave);
end

function SPF1.LeftSort:OnShow()
	if (SPF1:GetMenu("Left")) then
		SPF1.LeftSort.tooltipText = SPF1:Custom("LeftMenu")["tooltip"] or "Sort recipes by the bonus they provide.";
		SPF1.LeftSort:SetChecked(SPF1:SavedData()["GroupBy"] ~= "Right");
	end
end

function SPF1.LeftSort:OnClick(mod)
	if SPF1:GetMenu("Left") then
		SPF1.LeftSort:SetChecked(true);
		
		SPF1:SavedData()["GroupBy"] = nil;
		
		if (mod ~= "silent") then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
			SPF1.RightSort.OnShow();
			SPF1.FullUpdate();
		end
	end
end

function SPF1.LeftSort:OnEnter()
    if (SPF1.LeftSort.tooltipText) then
        GameTooltip:SetOwner(SPF1.LeftSort, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF1.LeftSort.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF1.LeftSort:OnLeave()
    GameTooltip:Hide();
end

SPF1.LeftSort:OnLoad();
