local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.Filter1 = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate");

function SPF2.Filter1.OnLoad()
	SPF2.Filter1:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	
	SPF2.Filter1:SetWidth(15);
	SPF2.Filter1:SetHeight(15);
	SPF2.Filter1:SetPoint("LEFT", SPF2.Search.text, "RIGHT", 15, 0);
	SPF2.Filter1:SetFrameLevel(4);
	
	SPF2.Filter1:SetScript("OnShow", SPF2.Filter1.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.Filter1.OnShow);
	
	SPF2.Filter1:SetScript("OnClick", SPF2.Filter1.OnClick);
	SPF2.Filter1:SetScript("OnEnter", SPF2.Filter1.OnEnter);
	SPF2.Filter1:SetScript("OnLeave", SPF2.Filter1.OnLeave);
end

function SPF2.Filter1:OnShow()
	SPF2.Filter1:Show();
	SPF2.Filter1.text:SetWidth(0); -- reset width to automatic
	
	SPF2.Filter1.text:SetText(SPF2:Custom("Filter1")["text"] or L["HAS_SKILL_UP"]);
	SPF2.Filter1.tooltipText = SPF2:Custom("Filter1")["tooltip"] or L["HAS_SKILL_UP_TOOLTIP"];
	
	SPF2.Filter1:SetHitRectInsets(0, -SPF2.Filter1.text:GetWidth(), 0, 0);
end

function SPF2.Filter1:OnClick(button)
	if (button == "LeftButton") then
		if (SPF2.Filter1:GetChecked()) then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
			SPF2:SavedData()["Filter1"] = true;
		else
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
			SPF2:SavedData()["Filter1"] = nil;
		end
	else
		SPF2.Filter1:SetChecked(not(SPF2.Filter1:GetChecked()));
		if SPF2:Custom("Filter1")["OnRightClick"] then
			SPF2:Custom("Filter1")["OnRightClick"]();
		else
			SPF2.Filter1:OnRightClick();
		end
	end
    SPF2.FullUpdate();
end

function SPF2.Filter1:OnRightClick()
	if not SPF2:SavedData()["IncludedSkillTypes"] then
		SPF2:SavedData()["IncludedSkillTypes"] = 0;
	end
	
	SPF2:SavedData()["IncludedSkillTypes"] = (SPF2:SavedData()["IncludedSkillTypes"] + 1) % 3;
	
	local message = "|cffbc5ff4[SPF]|r|cffffcf00["..GetTradeSkillName().."]|r: "..L["TradeSkillFilter1RightClick"].."|cffff7f3f["..L["ORANGE"].."] |r";
	
	if SPF2:SavedData()["IncludedSkillTypes"] < 2 then
		message = message.."|cffffff00["..L["YELLOW"].."] |r";
	end
	if SPF2:SavedData()["IncludedSkillTypes"] < 1 then
		message = message.."|cff3fbf3f["..L["GREEN"].."]|r";
	end
	
	print(message);
end

function SPF2.Filter1:OnEnter()
    if (SPF2.Filter1.tooltipText) then
        GameTooltip:SetOwner(SPF2.Filter1, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Filter1.tooltipText, nil, nil, nil, nil, true);
    end
	if (SPF2:Custom("Filter1")["Tooltip_OnEnter"]) then
		SPF2:Custom("Filter1")["Tooltip_OnEnter"]();
	else
		GameTooltip:AddLine(L["MORE_OPTIONS"], 0.69, 0.69, 0.69, 1);
		GameTooltip:Show();
	end
end

function SPF2.Filter1:OnLeave()
    GameTooltip:Hide();
end

-- Return True if the skill matches the filter
function SPF2.Filter1:Filter(skillIndex)
	if SPF2:Custom("Filter1").Filter then
		return (not SPF2.Filter1:GetChecked() or SPF2:Custom("Filter1").Filter(skillIndex));
	else
		local _, skillType = SPF2.baseGetTradeSkillInfo(skillIndex);
		
		if not SPF2.Filter1:GetChecked() then
			return true;
		end
		
		if skillType == "trivial" then
			return false;
		end
		
		if SPF2:SavedData()["IncludedSkillTypes"] then
			if skillType == "medium" then
				return SPF2:SavedData()["IncludedSkillTypes"] < 2;
			end
			
			if skillType == "easy" then
				return SPF2:SavedData()["IncludedSkillTypes"] < 1;
			end
		end
		
		return true;
	end
end

SPF2.Filter1:OnLoad();
