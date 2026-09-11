local L = SigmaProfessionFilter.L;
local SPF = SigmaProfessionFilter[2];

SPF.Filter1 = CreateFrame("CheckButton", "TradeSkillFilter1Button", TradeSkillFrame, "UICheckButtonTemplate");
SPF.Filter1.text = SPF.Filter1:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
SPF.Filter1.text:SetPoint("LEFT", SPF.Filter1, "RIGHT", 0, 0);

function SPF.Filter1.OnLoad()
	SPF.Filter1:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	
	SPF.Filter1:SetWidth(15);
	SPF.Filter1:SetHeight(15);
	SPF.Filter1:SetFrameLevel(4);
	SPF.CheckBoxBar:AddButton(SPF.Filter1);
	
	SPF.Filter1:SetScript("OnShow", SPF.Filter1.OnShow);
	SPF["TSFOnShow"]["SPF.Filter1.OnShow"] = SPF.Filter1.OnShow;
	
	SPF.Filter1:SetScript("OnClick", SPF.Filter1.OnClick);
	SPF.Filter1:SetScript("OnEnter", SPF.Filter1.OnEnter);
	SPF.Filter1:SetScript("OnLeave", SPF.Filter1.OnLeave);
	
	SPF.Filter1.Status = {};
end

function SPF.Filter1:OnShow()
	SPF.Filter1:Show();
	SPF.Filter1.text:SetWidth(0); -- reset width to automatic
	
	SPF.Filter1.text:SetText(SPF:Custom("Filter1")["text"] or L["HAS_SKILL_UP"]);
	SPF.Filter1.tooltipText = SPF:Custom("Filter1")["tooltip"] or L["HAS_SKILL_UP_TOOLTIP"];
	
	if GetTradeSkillName() then
		SPF.Filter1:SetChecked(SPF.Filter1.Status[GetTradeSkillName()]);
	end
end

function SPF.Filter1.OnClick()
	if (arg1 == "RightButton") then
		SPF.Filter1:SetChecked(not(SPF.Filter1:GetChecked()));
		if SPF:Custom("Filter1")["OnRightClick"] then
			SPF:Custom("Filter1")["OnRightClick"]();
		else
			SPF.Filter1:OnRightClick();
		end
	else
		if GetTradeSkillName() then
			SPF.Filter1.Status[GetTradeSkillName()] = SPF.Filter1:GetChecked();
		end
	end
	if (SPF.Filter1:GetChecked()) then
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		PlaySound("igMainMenuOptionCheckBoxOff");
	end
	SPF.FullUpdate();
end

function SPF.Filter1:OnRightClick()
	if not SPF:SavedData()["IncludedSkillTypes"] then
		SPF:SavedData()["IncludedSkillTypes"] = 0;
	end
	
	SPF:SavedData()["IncludedSkillTypes"] = (SPF:SavedData()["IncludedSkillTypes"] + 1);
	if SPF:SavedData()["IncludedSkillTypes"] >= 3 then
		SPF:SavedData()["IncludedSkillTypes"] = 0;
	end
	
	local message = "|cffbc5ff4[SPF]|r|cffffcf00["..GetTradeSkillName().."]|r: "..L["Filter1RightClick"].."|cffff8040["..L["ORANGE"].."] |r";
	
	if SPF:SavedData()["IncludedSkillTypes"] < 2 then
		message = message.."|cffffff00["..L["YELLOW"].."] |r";
	end
	if SPF:SavedData()["IncludedSkillTypes"] < 1 then
		message = message.."|cff40bf40["..L["GREEN"].."]|r";
	end
	DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
end

function SPF.Filter1:OnEnter()
	if (SPF.Filter1.tooltipText) then
		GameTooltip:SetOwner(SPF.Filter1, "ANCHOR_TOPLEFT");
		GameTooltip:SetText(SPF.Filter1.tooltipText, nil, nil, nil, nil, true);
	end
	if (SPF:Custom("Filter1")["Tooltip_OnEnter"]) then
		SPF:Custom("Filter1")["Tooltip_OnEnter"]();
	else
		GameTooltip:AddLine(L["MORE_OPTIONS"], 0.69, 0.69, 0.69, 1);
		GameTooltip:Show();
	end
end

function SPF.Filter1:OnLeave()
	GameTooltip:Hide();
end

-- Return True if the skill matches the filter
function SPF.Filter1:Filter(skillIndex)
	if SPF:Custom("Filter1").Filter then
		return (not SPF.Filter1:GetChecked() or SPF:Custom("Filter1").Filter(skillIndex));
	else
		if not SPF.Filter1:GetChecked() then
			return true;
		end
		
		local _, skillType = SPF.baseGetTradeSkillInfo(skillIndex);
		
		if skillType == "trivial" then
			return false;
		end
		
		if SPF:SavedData()["IncludedSkillTypes"] then
			if skillType == "medium" then
				return SPF:SavedData()["IncludedSkillTypes"] < 2;
			end
			
			if skillType == "easy" then
				return SPF:SavedData()["IncludedSkillTypes"] < 1;
			end
		end
		
		return true;
	end
end

-- Return True if the skill matches the filter
function SPF.Filter1:FilterSpell(spellID)
	
	if not SPF.Filter1:GetChecked() then
		return true;
	end
	
	if SPF:Custom("Filter1").FilterSpell then
		return SPF:Custom("Filter1").FilterSpell(spellID);
	end
	
	local levels = SPF.GetRecipeInfo(spellID, "levels");
	local _, level = GetTradeSkillLine();
	
	local skillType = "trivial";
	if level < levels[1] then
		skillType = "unavailable";
	elseif level < levels[2] then
		skillType = "hard";
	elseif level < levels[3] then
		skillType = "medium";
	elseif level < levels[4] then
		skillType = "easy";
	end
	
	if skillType == "trivial" or skillType == "unavailable"  then
		return false;
	end
	
	if SPF:SavedData()["IncludedSkillTypes"] then
		if skillType == "medium" then
			return SPF:SavedData()["IncludedSkillTypes"] < 2;
		end
		
		if skillType == "easy" then
			return SPF:SavedData()["IncludedSkillTypes"] < 1;
		end
	end
	
	return true;
end

SPF.Filter1:OnLoad();
