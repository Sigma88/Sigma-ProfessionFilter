local L = SigmaProfessionFilter.L;
local SPF1 = SigmaProfessionFilter[1];

SPF1.LeftSort = CreateFrame("CheckButton", nil, CraftFrame, "UICheckButtonTemplate");

function SPF1.LeftSort:OnLoad()
	SPF1.LeftSort:SetWidth(15);
	SPF1.LeftSort:SetHeight(15);
	SPF1.LeftSort:SetPoint("LEFT", SPF1.LeftMenu, "LEFT", 23, 2);
	SPF1.LeftSort:SetHitRectInsets(0, -90, 0, 0);
	SPF1.LeftSort:SetFrameLevel(4);
	
	SPF1.LeftSort:SetScript("OnShow", SPF1.LeftSort.OnShow);
	SPF1["CFOnShow"]["SPF1.LeftSort.OnShow"] = SPF1.LeftSort.OnShow;
	
	SPF1.LeftSort:SetScript("OnClick", SPF1.LeftSort.OnClick);
	SPF1.LeftSort:SetScript("OnEnter", SPF1.LeftSort.OnEnter);
	SPF1.LeftSort:SetScript("OnLeave", SPF1.LeftSort.OnLeave);
end

function SPF1.LeftSort:OnShow()
	SPF1.LeftSort:Show();
	
	if not SPF1:GetMenu("Left") then
		SPF1.LeftSort:Hide();
	else
		if not SPF1:GetMenu("Right") then
			SPF1:SavedData()["GroupBy"] = nil;
		end
		SPF1.LeftSort.tooltipText = SPF1:Custom("LeftMenu")["tooltip"] or L["ALL_SUBCLASSES_TOOLTIP"];
		SPF1.LeftSort:SetChecked(SPF1:SavedData()["GroupBy"] ~= "Right");
	end
	
    if SPF1:SavedData()["SearchBox"] then
        SPF1.LeftSort:Hide();
    end
end

function SPF1.LeftSort:OnClick(mod)
	--PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
	PlaySound("igMainMenuOptionCheckBoxOn");
	SPF1.LeftSort:SetChecked(true);
	SPF1:SavedData()["GroupBy"] = nil;
	SPF1.RightSort:OnShow();
	SPF1.FullUpdate();
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

SPF1.LeftSort.OnLoad();
