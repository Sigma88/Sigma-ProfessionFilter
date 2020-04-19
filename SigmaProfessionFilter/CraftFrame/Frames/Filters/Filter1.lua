SPF.Filter1 = CreateFrame("CheckButton", nil, CraftFrame, "UICheckButtonTemplate");

function SPF.Filter1.OnLoad()
	SPF.Filter1:SetWidth(15);
	SPF.Filter1:SetHeight(15);
	SPF.Filter1:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 135, -54);
	SPF.Filter1:SetHitRectInsets(0, -60, 0, 0);
	SPF.Filter1:SetFrameLevel(4);
	
	SPF.Filter1:SetScript("OnShow", SPF.Filter1.OnShow);
	SPF.Filter1:SetScript("OnClick", SPF.Filter1.OnClick);
	SPF.Filter1:SetScript("OnEnter", SPF.Filter1.OnEnter);
	SPF.Filter1:SetScript("OnLeave", SPF.Filter1.OnLeave);
	
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF.Filter1:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 135, -57);
    end
end

function SPF.Filter1:OnShow()
	SPF.Filter1.text:SetText(SPF:Custom("Filter1")["text"] or "Has Skill Up");
	SPF.Filter1.tooltipText = SPF:Custom("Filter1")["tooltip"] or "Only show the recipes that can make your skill go up.";
end

function SPF.Filter1:OnClick()
	if (SPF.Filter1:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		
		SPF:SavedData()["Filter1"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF:SavedData()["Filter1"] = nil;
    end
    SPF.FullUpdate();
end

function SPF.Filter1:OnEnter()
    if (SPF.Filter1.tooltipText) then
        GameTooltip:SetOwner(SPF.Filter1, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF.Filter1.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF.Filter1:OnLeave()
    GameTooltip:Hide();
end

-- Return True if the craft matches the filter
function SPF.Filter1:Filter(craftIndex)
	if SPF:Custom("Filter1").Filter then
		return (not SPF.Filter1:GetChecked() or SPF:Custom("Filter1").Filter(craftIndex));
	else
		local _, _, craftType = SPF.baseGetCraftInfo(craftIndex);
		return (not SPF.Filter1:GetChecked() or craftType ~= "trivial");
	end
end

SPF.Filter1:OnLoad();
