local L = SigmaProfessionFilter.L;
local SPF1 = SigmaProfessionFilter[1];

SPF1.Filter1 = CreateFrame("CheckButton", nil, CraftFrame, "UICheckButtonTemplate");

function SPF1.Filter1:OnLoad()
	SPF1.Filter1:SetWidth(15);
	SPF1.Filter1:SetHeight(15);
	SPF1.Filter1:SetFrameLevel(4);
	SPF1.CheckBoxBar:AddButton(SPF1.Filter1);
	
	SPF1.Filter1:SetScript("OnShow", SPF1.Filter1.OnShow);
	hooksecurefunc("CraftFrame_OnShow", SPF1.Filter1.OnShow);
	
	SPF1.Filter1:SetScript("OnClick", SPF1.Filter1.OnClick);
	SPF1.Filter1:SetScript("OnEnter", SPF1.Filter1.OnEnter);
	SPF1.Filter1:SetScript("OnLeave", SPF1.Filter1.OnLeave);
	
	SPF1.Filter1.Status = {};
end

function SPF1.Filter1:OnShow()
	SPF1.Filter1:Show();
	SPF1.Filter1.text:SetWidth(0); -- reset width to automatic
	
	SPF1.Filter1.text:SetText(SPF1:Custom("Filter1")["text"] or L["HAS_SKILL_UP"]);
	SPF1.Filter1.tooltipText = SPF1:Custom("Filter1")["tooltip"] or L["HAS_SKILL_UP_TOOLTIP"];
	
	if GetCraftName() then
		SPF1.Filter1:SetChecked(SPF1.Filter1.Status[GetCraftName()]);
	end
end

function SPF1.Filter1:OnClick()
	if (SPF1.Filter1:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
    end
	
	if GetCraftName() then
		SPF1.Filter1.Status[GetCraftName()] = SPF1.Filter1:GetChecked();
	end
    SPF1.FullUpdate();
end

function SPF1.Filter1:OnEnter()
    if (SPF1.Filter1.tooltipText) then
        GameTooltip:SetOwner(SPF1.Filter1, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF1.Filter1.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF1.Filter1:OnLeave()
    GameTooltip:Hide();
end

-- Return True if the craft matches the filter
function SPF1.Filter1:Filter(craftIndex)
	if SPF1:Custom("Filter1").Filter then
		return (not SPF1.Filter1:GetChecked() or SPF1:Custom("Filter1").Filter(craftIndex));
	else
		local _, _, craftType = SPF1.baseGetCraftInfo(craftIndex);
		return (not SPF1.Filter1:GetChecked() or craftType ~= "trivial");
	end
end

-- Return True if the craft matches the filter
function SPF1.Filter1:FilterSpell(spellID)
	if SPF1:Custom("Filter1").FilterSpell then
		return (not SPF1.Filter1:GetChecked() or SPF1:Custom("Filter1").FilterSpell(spellID));
	else
		return not SPF1.Filter1:GetChecked();
	end
end

SPF1.Filter1:OnLoad();
