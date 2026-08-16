local L = SigmaProfessionFilter.L;
local SPF1 = SigmaProfessionFilter[1];

SPF1.Filter1 = CreateFrame("CheckButton", "CraftFilter1Button", CraftFrame, "UICheckButtonTemplate");
SPF1.Filter1.text = SPF1.Filter1:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
SPF1.Filter1.text:SetPoint("LEFT", SPF1.Filter1, "RIGHT", 0, 0);

function SPF1.Filter1.OnLoad()
	SPF1.Filter1:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	
	SPF1.Filter1:SetWidth(15);
	SPF1.Filter1:SetHeight(15);
	SPF1.Filter1:SetFrameLevel(4);
	SPF1.CheckBoxBar:AddButton(SPF1.Filter1);
	
	SPF1.Filter1:SetScript("OnShow", SPF1.Filter1.OnShow);
	SPF1["CFOnShow"]["SPF1.Filter1.OnShow"] = SPF1.Filter1.OnShow;
	
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

function SPF1.Filter1.OnClick()
	if (arg1 == "RightButton") then
		SPF1.Filter1:SetChecked(not(SPF1.Filter1:GetChecked()));
		if SPF1:Custom("Filter1")["OnRightClick"] then
			SPF1:Custom("Filter1")["OnRightClick"]();
		else
			SPF1.Filter1:OnRightClick();
		end
	else
		if GetCraftName() then
			SPF1.Filter1.Status[GetCraftName()] = SPF1.Filter1:GetChecked();
		end
	end
	if (SPF1.Filter1:GetChecked()) then
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		PlaySound("igMainMenuOptionCheckBoxOff");
	end
    SPF1.FullUpdate();
end

function SPF1.Filter1:OnRightClick()
	if not SPF1:SavedData()["IncludedSkillTypes"] then
		SPF1:SavedData()["IncludedSkillTypes"] = 0;
	end
	
	SPF1:SavedData()["IncludedSkillTypes"] = (SPF1:SavedData()["IncludedSkillTypes"] + 1);
	if SPF1:SavedData()["IncludedSkillTypes"] >= 3 then
		SPF1:SavedData()["IncludedSkillTypes"] = 0;
	end
	
	local message = "|cffbc5ff4[SPF]|r|cffffcf00["..GetCraftName().."]|r: "..L["Filter1RightClick"].."|cffff8040["..L["ORANGE"].."] |r";
	
	if SPF1:SavedData()["IncludedSkillTypes"] < 2 then
		message = message.."|cffffff00["..L["YELLOW"].."] |r";
	end
	if SPF1:SavedData()["IncludedSkillTypes"] < 1 then
		message = message.."|cff40bf40["..L["GREEN"].."]|r";
	end
	DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
end

function SPF1.Filter1:OnEnter()
    if (SPF1.Filter1.tooltipText) then
        GameTooltip:SetOwner(SPF1.Filter1, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF1.Filter1.tooltipText, nil, nil, nil, nil, true);
    end
	if (SPF1:Custom("Filter1")["Tooltip_OnEnter"]) then
		SPF1:Custom("Filter1")["Tooltip_OnEnter"]();
	else
		GameTooltip:AddLine(L["MORE_OPTIONS"], 0.69, 0.69, 0.69, 1);
		GameTooltip:Show();
	end
end

function SPF1.Filter1:OnLeave()
    GameTooltip:Hide();
end

-- Return True if the skill matches the filter
function SPF1.Filter1:Filter(skillIndex)
	if SPF1:Custom("Filter1").Filter then
		return (not SPF1.Filter1:GetChecked() or SPF1:Custom("Filter1").Filter(skillIndex));
	else
		if not SPF1.Filter1:GetChecked() then
			return true;
		end
		
		local _, _, skillType = SPF1.baseGetCraftInfo(skillIndex);
		
		if skillType == "trivial" then
			return false;
		end
		
		if SPF1:SavedData()["IncludedSkillTypes"] then
			if skillType == "medium" then
				return SPF1:SavedData()["IncludedSkillTypes"] < 2;
			end
			
			if skillType == "easy" then
				return SPF1:SavedData()["IncludedSkillTypes"] < 1;
			end
		end
		
		return true;
	end
end

-- Return True if the skill matches the filter
function SPF1.Filter1:FilterSpell(spellID)
	if SPF1:Custom("Filter1").FilterSpell then
		return (not SPF1.Filter1:GetChecked() or SPF1:Custom("Filter1").FilterSpell(spellID));
	else
		return not SPF1.Filter1:GetChecked();
	end
end

SPF1.Filter1:OnLoad();
