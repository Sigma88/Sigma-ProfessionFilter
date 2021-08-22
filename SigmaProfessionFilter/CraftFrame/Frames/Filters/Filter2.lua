local L = SigmaProfessionFilter.L;
local SPF1 = SigmaProfessionFilter[1];

SPF1.Filter2 = CreateFrame("CheckButton", nil, CraftFrame, "UICheckButtonTemplate");

function SPF1.Filter2:OnLoad()
	SPF1.Filter2:SetWidth(15);
	SPF1.Filter2:SetHeight(15);
	SPF1.Filter2:SetFrameLevel(4);
	SPF1.CheckBoxBar:AddButton(SPF1.Filter2);
	
	SPF1.Filter2:SetScript("OnShow", SPF1.Filter2.OnShow);
	hooksecurefunc("CraftFrame_OnShow", SPF1.Filter2.OnShow);
	
	SPF1.Filter2:SetScript("OnClick", SPF1.Filter2.OnClick);
	SPF1.Filter2:SetScript("OnEnter", SPF1.Filter2.OnEnter);
	SPF1.Filter2:SetScript("OnLeave", SPF1.Filter2.OnLeave);
	
	SPF1.Filter2.Status = {};
end

function SPF1.Filter2:OnShow()
	SPF1.Filter2:Show();
	SPF1.Filter2.text:SetWidth(0); -- reset width to automatic
	
	SPF1.Filter2.text:SetText(SPF1:Custom("Filter2")["text"] or L["HAVE_MATS"]);
	SPF1.Filter2.tooltipText = SPF1:Custom("Filter2")["tooltip"] or L["HAVE_MATS_TOOLTIP"];
	
	if GetCraftName() then
		SPF1.Filter2:SetChecked(SPF1.Filter2.Status[GetCraftName()]);
	end
end

function SPF1.Filter2:OnClick()
	if (SPF1.Filter2:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
    end
	if GetCraftName() then
		SPF1.Filter2.Status[GetCraftName()] = SPF1.Filter2:GetChecked();
	end
    SPF1.FullUpdate();
end

function SPF1.Filter2:OnEnter()
    if (SPF1.Filter2.tooltipText) then
        GameTooltip:SetOwner(SPF1.Filter2, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF1.Filter2.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF1.Filter2.OnLeave()
    GameTooltip:Hide();
end

-- Return True if the craft matches the filter
function SPF1.Filter2:Filter(craftIndex)
	if SPF1:Custom("Filter2").Filter then
		return (not SPF1.Filter2:GetChecked() or SPF1:Custom("Filter2").Filter(craftIndex));
	else
		local _, _, _, numAvailable = SPF1.baseGetCraftInfo(craftIndex);
		return (not SPF1.Filter2:GetChecked() or numAvailable > 0);
	end
end

-- Return True if the craft matches the filter
function SPF1.Filter2:FilterSpell(spellID)
	if SPF1:Custom("Filter2").FilterSpell then
		return (not SPF1.Filter2:GetChecked() or SPF1:Custom("Filter2").FilterSpell(spellID));
	else
		return not SPF1.Filter2:GetChecked();
	end
end

SPF1.Filter2:OnLoad();
