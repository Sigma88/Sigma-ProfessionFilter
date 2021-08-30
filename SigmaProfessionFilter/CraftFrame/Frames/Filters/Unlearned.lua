local L = SigmaProfessionFilter.L;
local SPF1 = SigmaProfessionFilter[1];

SPF1.Unlearned = CreateFrame("Frame", nil, CraftFrame);

function SPF1.Unlearned.OnLoad()
	SPF1.Unlearned:SetWidth(27);
	SPF1.Unlearned:SetHeight(15);
	SPF1.Unlearned:SetFrameLevel(4);
	SPF1.CheckBoxBar:AddButton(SPF1.Unlearned);
	
	SPF1.Unlearned:SetScript("OnShow", SPF1.Unlearned.OnShow);
	hooksecurefunc("CraftFrame_OnShow", SPF1.Unlearned.OnShow);
	
	local button = CreateFrame("CheckButton", nil, SPF1.Unlearned, "UICheckButtonTemplate");
	button:SetWidth(15);
	button:SetHeight(15);
	button:SetPoint("LEFT", SPF1.Unlearned, "LEFT", 0, 0);
	button:SetHitRectInsets(0, -15, 0, 0);
	
	button:SetScript("OnClick", SPF1.Unlearned.OnClick);
	button:SetScript("OnEnter", SPF1.Unlearned.OnEnter);
	button:SetScript("OnLeave", SPF1.Unlearned.OnLeave);
	
	local icon = CreateFrame("Frame", nil, SPF1.Unlearned);
	icon:SetWidth(14);
	icon:SetHeight(14);
	icon:SetPoint("TOPRIGHT", SPF1.Unlearned, "TOPRIGHT", 0, 0);
	
	local texture = icon:CreateTexture(nil, "ARTWORK");
	texture:SetAllPoints();
	SetPortraitToTexture(texture, "Interface/Spellbook/Spellbook-Icon");
	texture:SetTexCoord(1,0,0,1);
	
	SPF1.Unlearned.button = button;
	SPF1.Unlearned.icon = icon;
	SPF1.Unlearned.texture = texture;
end

function SPF1.Unlearned:OnShow()
	SPF1.Unlearned:Show();
	if not(SPF1:Custom("Unlearned")["disabled"]) and SPF1.GetRecipeInfo() and next(SPF1.GetRecipeInfo()) then
		SPF1.Unlearned.tooltipText = SPF1:Custom("Unlearned")["tooltip"] or L["UNLEARNED_TOOLTIP"];
		SPF1.Unlearned.button:SetChecked(SPF1:SavedData()["Unlearned"]);
		SPF1.Unlearned.disabled = nil;
	else
		SPF1.Unlearned:Hide();
		SPF1.Unlearned.disabled = true;
	end
end

function SPF1.Unlearned.OnClick()
	
	if (SPF1.Unlearned.button:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF1:SavedData()["Unlearned"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF1:SavedData()["Unlearned"] = nil;
	end
	
	CraftFrame_OnShow();
	SPF1.FullUpdate();
	SPF1.Unlearned:OnEnter();
end

function SPF1.Unlearned.OnEnter()
    if (SPF1.Unlearned.tooltipText) then
        GameTooltip:SetOwner(SPF1.Unlearned, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF1.Unlearned.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF1.Unlearned.OnLeave()
    GameTooltip:Hide();
end

SPF1.Unlearned.OnLoad();
