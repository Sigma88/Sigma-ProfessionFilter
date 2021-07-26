local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.Filter2 = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate");

function SPF2.Filter2.OnLoad()
	SPF2.Filter2:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	
	SPF2.Filter2:SetWidth(15);
	SPF2.Filter2:SetHeight(15);
	SPF2.Filter2:SetPoint("LEFT", SPF2.Filter1.text, "RIGHT", 10, 0);
	SPF2.Filter2:SetFrameLevel(4);
	
	SPF2.Filter2:SetScript("OnShow", SPF2.Filter2.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.Filter2.OnShow);
	
	SPF2.Filter2:SetScript("OnClick", SPF2.Filter2.OnClick);
	SPF2.Filter2:SetScript("OnEnter", SPF2.Filter2.OnEnter);
	SPF2.Filter2:SetScript("OnLeave", SPF2.Filter2.OnLeave);
	
	SPF2.Filter2.Status = {};
end

function SPF2.Filter2:OnShow()
	SPF2.Filter2:Show();
	SPF2.Filter2.text:SetWidth(0); -- reset width to automatic
	
	SPF2.Filter2.text:SetText(SPF2:Custom("Filter2")["text"] or L["HAVE_MATS"]);
	SPF2.Filter2.tooltipText = SPF2:Custom("Filter2")["tooltip"] or L["HAVE_MATS_TOOLTIP"];
	
	-- Move the search button if there is no portrait
	local w = 0;
	if TradeSkillFramePortrait:IsVisible() and TradeSkillFramePortrait:GetAlpha() ~= 0 then
		w = TradeSkillFramePortrait:GetWidth();
	else
		local a,b,c,d,e = SPF2.Search:GetPoint();
		SPF2.Search:ClearAllPoints();
		SPF2.Search:SetPoint(a,b,c,12 + w,e);
	end
	
	-- When the text is too big, shrink it
	local x,y,z = SPF2.Search.text:GetWidth(), SPF2.Filter1.text:GetWidth(), SPF2.Filter2.text:GetWidth();
	if (x + y + z > 265 - w) then
		
		-- Block text height
		SPF2.Search.text:SetHeight(SPF2.Search.text:GetHeight());
		SPF2.Filter1.text:SetHeight(SPF2.Filter1.text:GetHeight());
		SPF2.Filter2.text:SetHeight(SPF2.Filter2.text:GetHeight());
		
		-- Calculate relative size of each new text string
		SPF2.Search.text:SetWidth( x / (x + y + z) * (265 - w));
		SPF2.Search:SetHitRectInsets(0, -SPF2.Search.text:GetWidth(), 0, 0);
		
		SPF2.Filter1.text:SetWidth( y / (x + y + z) * (265 - w));
		SPF2.Filter1:SetHitRectInsets(0, -SPF2.Filter1.text:GetWidth(), 0, 0);
		
		SPF2.Filter2.text:SetWidth( z / (x + y + z) * (265 - w));
		SPF2.Filter2:SetHitRectInsets(0, -SPF2.Filter2.text:GetWidth(), 0, 0);
		
	else
		SPF2.Filter2:SetHitRectInsets(0, -SPF2.Filter2.text:GetWidth(), 0, 0);
	end
	
	if GetTradeSkillName() then
		SPF2.Filter2:SetChecked(SPF2.Filter2.Status[GetTradeSkillName()]);
	end
end

function SPF2.Filter2:OnClick(button)
	if (button == "LeftButton") then
		if (SPF2.Filter2:GetChecked()) then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		else
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		end
	
		if GetTradeSkillName() then
			SPF2.Filter2.Status[GetTradeSkillName()] = SPF2.Filter2:GetChecked();
		end
	else
		SPF2.Filter2:SetChecked(not(SPF2.Filter2:GetChecked()));
		if SPF2:Custom("Filter2")["OnRightClick"] then
			SPF2:Custom("Filter2")["OnRightClick"]();
		else
			SPF2.Filter2:OnRightClick();
		end
	end
    SPF2.FullUpdate();
end

function SPF2.Filter2:OnRightClick()
	if SPF2:SavedData()["IncludeCraftableMats"] ~= false then
		SPF2:SavedData()["IncludeCraftableMats"] = false;
		print("|cffbc5ff4[SPF]|r|cffffcf00["..GetTradeSkillName().."]|r: "..L["TradeSkillFilter2RightClickOFF"]);
	else
		SPF2:SavedData()["IncludeCraftableMats"] = nil;
		print("|cffbc5ff4[SPF]|r|cffffcf00["..GetTradeSkillName().."]|r: "..L["TradeSkillFilter2RightClickON"]);
	end
end

function SPF2.Filter2:OnEnter()
    if (SPF2.Filter2.tooltipText) then
        GameTooltip:SetOwner(SPF2.Filter2, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Filter2.tooltipText, nil, nil, nil, nil, true);
    end
	if (SPF2:Custom("Filter2")["Tooltip_OnEnter"]) then
		SPF2:Custom("Filter2")["Tooltip_OnEnter"]();
	else
		GameTooltip:AddLine(L["MORE_OPTIONS"], 0.69, 0.69, 0.69, 1);
		GameTooltip:Show();
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
	
	if SPF2:SavedData()["IncludeCraftableMats"] == false then
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
		
		if SPF2.CraftedItems[reagentName] then			
			
			local recursiveHasMats = SPF2.baseTradeSkillHasMats(SPF2.CraftedItems[reagentName], requiredReagents[reagentName]);
			
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

-- Return True if the skill matches the filter
function SPF2.Filter2:FilterSpell(spellID)
	if SPF2:Custom("Filter2").FilterSpell then
		return (not SPF2.Filter2:GetChecked() or SPF2:Custom("Filter2").FilterSpell(spellID));
	else
		return not SPF2.Filter2:GetChecked();
	end
end

SPF2.Filter2:OnLoad();
