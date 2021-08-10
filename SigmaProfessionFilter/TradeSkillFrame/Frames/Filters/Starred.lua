local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.Starred = CreateFrame("Frame", nil, TradeSkillFrame);

function SPF2.Starred.OnLoad()
	SPF2.Starred:SetWidth(27);
	SPF2.Starred:SetHeight(15);
	SPF2.Starred:SetFrameLevel(4);
	SPF2.CheckBoxBar:AddButton(SPF2.Starred);
	
	SPF2.Starred:SetScript("OnShow", SPF2.Starred.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.Starred.OnShow);
	
	local button = CreateFrame("CheckButton", nil, SPF2.Starred, "UICheckButtonTemplate");
	button:SetWidth(15);
	button:SetHeight(15);
	button:SetPoint("LEFT", SPF2.Starred, "LEFT", 0, 0);
	button:SetHitRectInsets(0, -15, 0, 0);
	
	button:SetScript("OnClick", SPF2.Starred.OnClick);
	button:SetScript("OnEnter", SPF2.Starred.OnEnter);
	button:SetScript("OnLeave", SPF2.Starred.OnLeave);
	
	local icon = CreateFrame("Frame", nil, SPF2.Starred);
	icon:SetWidth(14);
	icon:SetHeight(14);
	icon:SetPoint("TOPRIGHT", SPF2.Starred, "TOPRIGHT", 0, 0);
	
	local texture = icon:CreateTexture(nil, "ARTWORK");
	texture:SetTexture("Interface/Common/ReputationStar", false);
	texture:SetAllPoints();
	texture:SetTexCoord(0,0.5,0,0.5);
	
	SPF2.Starred.button = button;
	SPF2.Starred.icon = icon;
	SPF2.Starred.texture = texture;
end

function SPF2.Starred:OnShow()
	
	SPF2.Starred:Show();
	
	if not(SPF2:Custom("Starred")["disabled"]) then
		SPF2.Starred.tooltipText = L["STARRED_TOOLTIP"] or "Toggle Starred Recipes Filter";
		SPF2.Starred.button:SetChecked(SPF2:SavedData()["Starred"]);
		SPF2.Starred.disabled = nil;
	else
		SPF2.Starred:Hide();
		SPF2.Starred.disabled = true;
	end
end

function SPF2.Starred.OnClick()
	
	if (SPF2.Starred.button:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF2:SavedData()["Starred"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF2:SavedData()["Starred"] = nil;
	end
	
	TradeSkillFrame_OnShow();
	SPF2.FullUpdate();
end

function SPF2.Starred.OnEnter()
    if (SPF2.Starred.tooltipText) then
        GameTooltip:SetOwner(SPF2.Starred, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Starred.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF2.Starred.OnLeave()
    GameTooltip:Hide();
end

SPF2.Starred.OnLoad();
