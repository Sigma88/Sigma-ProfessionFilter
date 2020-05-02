local SPF1 = SigmaProfessionFilter[1];

SPF1.Filter1 = CreateFrame("CheckButton", nil, CraftFrame, "UICheckButtonTemplate");

function SPF1.Filter1:OnLoad()
	SPF1.Filter1:SetWidth(15);
	SPF1.Filter1:SetHeight(15);
	SPF1.Filter1:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 135, -54);
	SPF1.Filter1:SetHitRectInsets(0, -60, 0, 0);
	SPF1.Filter1:SetFrameLevel(4);
	
	SPF1.Filter1:SetScript("OnShow", SPF1.Filter1.OnShow);
	SPF1.Filter1:SetScript("OnClick", SPF1.Filter1.OnClick);
	SPF1.Filter1:SetScript("OnEnter", SPF1.Filter1.OnEnter);
	SPF1.Filter1:SetScript("OnLeave", SPF1.Filter1.OnLeave);
	
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF1.Filter1:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 135, -57);
    end
end

function SPF1.Filter1:OnShow()
	SPF1.Filter1.text:SetText(SPF1:Custom("Filter1")["text"] or "Has Skill Up");
	SPF1.Filter1.tooltipText = SPF1:Custom("Filter1")["tooltip"] or "Only show the recipes that can make your skill go up.";
end

function SPF1.Filter1:OnClick()
	if (SPF1.Filter1:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		
		SPF1:SavedData()["Filter1"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF1:SavedData()["Filter1"] = nil;
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

SPF1.Filter1:OnLoad();
