local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.Filter2 = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate");

function SPF2.Filter2.OnLoad()
	SPF2.Filter2:SetWidth(15);
	SPF2.Filter2:SetHeight(15);
	SPF2.Filter2:SetPoint("LEFT", SPF2.Filter1.text, "RIGHT", 10, 0);
	SPF2.Filter2:SetHitRectInsets(0, -60, 0, 0);
	SPF2.Filter2:SetFrameLevel(4);
	
	SPF2.Filter2:SetScript("OnShow", SPF2.Filter2.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.Filter2.OnShow);
	
	SPF2.Filter2:SetScript("OnClick", SPF2.Filter2.OnClick);
	SPF2.Filter2:SetScript("OnEnter", SPF2.Filter2.OnEnter);
	SPF2.Filter2:SetScript("OnLeave", SPF2.Filter2.OnLeave);
end

function SPF2.Filter2:OnShow()
	SPF2.Filter2:Show();
	SPF2.Filter2.text:SetText(SPF2:Custom("Filter2")["text"] or L["HAVE_MATS"]);
	SPF2.Filter2.tooltipText = SPF2:Custom("Filter2")["tooltip"] or L["HAVE_MATS_TOOLTIP"];
	
	-- When the text is too big, shrink it
	if (SPF2.Filter1.text:GetWidth() + SPF2.Filter2.text:GetWidth() > 172) then
		
		-- Block text height
		SPF2.Filter1.text:SetHeight(SPF2.Filter1.text:GetHeight());
		SPF2.Filter2.text:SetHeight(SPF2.Filter2.text:GetHeight());
		
		-- Fancy way of saying (SPF2.Filter1.text:GetWidth() / (SPF2.Filter1.text:GetWidth() + SPF2.Filter2.text:GetWidth()) * 172)
		SPF2.Filter1.text:SetWidth(172 / ( 1 + (SPF2.Filter2.text:GetWidth() / SPF2.Filter1.text:GetWidth())));
		SPF2.Filter2.text:SetWidth(172 - SPF2.Filter1.text:GetWidth());
	end
end

function SPF2.Filter2:OnClick()
	if (SPF2.Filter2:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF2:SavedData()["Filter2"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF2:SavedData()["Filter2"] = nil;
    end
    SPF2.FullUpdate();
end

function SPF2.Filter2:OnEnter()
    if (SPF2.Filter2.tooltipText) then
        GameTooltip:SetOwner(SPF2.Filter2, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Filter2.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF2.Filter2.OnLeave()
    GameTooltip:Hide();
end

function SPF2.baseTradeSkillHasMats(skillIndex, requiredAmount)
	
	local skillName, _, numAvailable = SPF2.baseGetTradeSkillInfo(skillIndex);
	
	if numAvailable >= requiredAmount then
		return true;
	end
	
	if not SPF2:SavedData()["IncludeCraftableMats"] then
		return false;
	end
	
	local numReagents = SPF2.baseGetTradeSkillNumReagents(skillIndex);
	local requiredReagents = {};
	
	for i=1, numReagents do
		local reagentName, _, reagentCount, playerReagentCount = SPF2.baseGetTradeSkillReagentInfo(skillIndex, i);
		
		if not reagentName then
			return false;
		end
		
		if not requiredReagents[reagentName] then
			requiredReagents[reagentName] = 0;
		end
		
		requiredReagents[reagentName] = requiredReagents[reagentName] + reagentCount * requiredAmount - playerReagentCount;
		
		if SPF2.Recipes[reagentName] then			
			
			local recursiveHasMats = SPF2.baseTradeSkillHasMats(SPF2.Recipes[reagentName], requiredReagents[reagentName]);
			
			if recursiveHasMats then
				requiredReagents[reagentName] = nil;
			else
				return false;
			end
		end
	end
	
	for a,b in pairs(requiredReagents) do
		if b and b > 0 then
			return false;
		end
	end
	
	return true;
end

-- Return True if the skill matches the filter
function SPF2.Filter2:Filter(skillIndex)
	
	if not SPF2.Filter2:GetChecked() then
		return true;
	end
	
	if SPF2:Custom("Filter2").Filter then
		return SPF2:Custom("Filter2").Filter(skillIndex);
	end
	
	return SPF2.baseTradeSkillHasMats(skillIndex, 1);
end

SPF2.Filter2:OnLoad();
