local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.RightSort = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate");

function SPF2.RightSort:OnLoad()
	SPF2.RightSort:SetWidth(15);
	SPF2.RightSort:SetHeight(15);
	SPF2.RightSort:SetPoint("LEFT", SPF2.RightMenu, "LEFT", 23, 2);
	SPF2.RightSort:SetHitRectInsets(0, -90, 0, 0);
	SPF2.RightSort:SetFrameLevel(4);
	
	SPF2.RightSort:SetScript("OnShow", SPF2.RightSort.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.RightSort.OnShow);
	
	SPF2.RightSort:SetScript("OnClick", SPF2.RightSort.OnClick);
	SPF2.RightSort:SetScript("OnEnter", SPF2.RightSort.OnEnter);
	SPF2.RightSort:SetScript("OnLeave", SPF2.RightSort.OnLeave);
end

function SPF2.RightSort:OnShow()
	SPF2.RightSort:Show();
	if SPF2:Custom("RightMenu")["disabled"] then
		SPF2.RightSort:Hide();
	else
		if SPF2:Custom("LeftMenu")["disabled"] then
			SPF2:SavedData()["GroupBy"] = "Right";
		end
		SPF2.RightSort.tooltipText = SPF2:Custom("RightMenu")["tooltip"] or L["ALL_INVENTORY_SLOTS_TOOLTIP"];
		SPF2.RightSort:SetChecked(SPF2:SavedData()["GroupBy"] == "Right");
	end
	
    if SPF2:SavedData()["SearchBox"] then
        SPF2.RightSort:Hide();
    end
end

function SPF2.RightSort.OnClick()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
	SPF2.RightSort:SetChecked(true);
	SPF2:SavedData()["GroupBy"] = "Right";
	SPF2.LeftSort:OnShow();
	SPF2.FullUpdate();
end

function SPF2.RightSort.OnEnter()
    if (SPF2.RightSort.tooltipText) then
        GameTooltip:SetOwner(SPF2.RightSort, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.RightSort.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF2.RightSort.OnLeave()
    GameTooltip:Hide();
end

SPF2.RightSort.OnLoad();
