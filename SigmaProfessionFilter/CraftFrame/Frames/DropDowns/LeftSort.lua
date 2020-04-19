SPF.LeftSort = CreateFrame("CheckButton", nil, SPF.LeftMenu, "UICheckButtonTemplate");

function SPF.LeftSort:OnLoad()
	SPF.LeftSort:SetWidth(15);
	SPF.LeftSort:SetHeight(15);
	SPF.LeftSort:SetPoint("LEFT", SPF.LeftMenu, "LEFT", 23, 2);
	SPF.LeftSort:SetHitRectInsets(0, -90, 0, 0);
	SPF.LeftSort:SetFrameLevel(4);
	
	SPF.LeftSort:SetScript("OnShow", SPF.LeftSort.OnShow);
	SPF.LeftSort:SetScript("OnClick", SPF.LeftSort.OnClick);
	SPF.LeftSort:SetScript("OnEnter", SPF.LeftSort.OnEnter);
	SPF.LeftSort:SetScript("OnLeave", SPF.LeftSort.OnLeave);
end

function SPF.LeftSort:OnShow()
	if (SPF:GetMenu("Left")) then
		SPF.LeftSort.tooltipText = SPF:Custom("LeftMenu")["tooltip"] or "Sort recipes by the bonus they provide.";
		SPF.LeftSort:SetChecked(SPF:SavedData()["GroupBy"] ~= "Right");
	end
end

function SPF.LeftSort:OnClick(mod)
	if SPF:GetMenu("Left") then
		SPF.LeftSort:SetChecked(true);
		
		SPF:SavedData()["GroupBy"] = nil;
		
		if (mod ~= "silent") then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
			SPF.RightSort.OnShow();
			SPF.FullUpdate();
		end
	end
end

function SPF.LeftSort:OnEnter()
    if (SPF.LeftSort.tooltipText) then
        GameTooltip:SetOwner(SPF.LeftSort, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF.LeftSort.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF.LeftSort:OnLeave()
    GameTooltip:Hide();
end

SPF.LeftSort.OnLoad();
