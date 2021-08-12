local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.Unlearned = CreateFrame("Frame", nil, TradeSkillFrame);

function SPF2.Unlearned.OnLoad()
	SPF2.Unlearned:SetWidth(27);
	SPF2.Unlearned:SetHeight(15);
	SPF2.Unlearned:SetFrameLevel(4);
	SPF2.CheckBoxBar:AddButton(SPF2.Unlearned);
	
	SPF2.Unlearned:SetScript("OnShow", SPF2.Unlearned.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.Unlearned.OnShow);
	
	local button = CreateFrame("CheckButton", nil, SPF2.Unlearned, "UICheckButtonTemplate");
	button:SetWidth(15);
	button:SetHeight(15);
	button:SetPoint("LEFT", SPF2.Unlearned, "LEFT", 0, 0);
	button:SetHitRectInsets(0, -15, 0, 0);
	
	button:SetScript("OnClick", SPF2.Unlearned.OnClick);
	button:SetScript("OnEnter", SPF2.Unlearned.OnEnter);
	button:SetScript("OnLeave", SPF2.Unlearned.OnLeave);
	
	local icon = CreateFrame("Frame", nil, SPF2.Unlearned);
	icon:SetWidth(14);
	icon:SetHeight(14);
	icon:SetPoint("TOPRIGHT", SPF2.Unlearned, "TOPRIGHT", 0, 0);
	
	local texture = icon:CreateTexture(nil, "ARTWORK");
	texture:SetAllPoints();
	SetPortraitToTexture(texture, "Interface/Spellbook/Spellbook-Icon");
	texture:SetTexCoord(1,0,0,1);
	
	SPF2.Unlearned.button = button;
	SPF2.Unlearned.icon = icon;
	SPF2.Unlearned.texture = texture;
end

function SPF2.Unlearned:OnShow()
	SPF2.Unlearned:Show();
	if not(SPF2:Custom("Unlearned")["disabled"]) and SPF2.GetRecipeInfo() then
		SPF2.Unlearned.tooltipText = SPF2:Custom("Unlearned")["tooltip"] or L["UNLEARNED_TOOLTIP"];
		SPF2.Unlearned.button:SetChecked(SPF2:SavedData()["Unlearned"]);
		SPF2.Unlearned.disabled = nil;
	else
		SPF2.Unlearned:Hide();
		SPF2.Unlearned.disabled = true;
	end
end

function SPF2.Unlearned.OnClick()
	
	if (SPF2.Unlearned.button:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF2:SavedData()["Unlearned"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF2:SavedData()["Unlearned"] = nil;
	end
	
	TradeSkillFrame_OnShow();
	SPF2.FullUpdate();
	SPF2.Unlearned:OnEnter();
end

function SPF2.Unlearned.OnEnter()
    if (SPF2.Unlearned.tooltipText) then
        GameTooltip:SetOwner(SPF2.Unlearned, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Unlearned.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF2.Unlearned.OnLeave()
    GameTooltip:Hide();
end

SPF2.Unlearned.OnLoad();
