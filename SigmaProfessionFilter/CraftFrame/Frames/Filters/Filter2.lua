local L = SigmaProfessionFilter.L;
local SPF1 = SigmaProfessionFilter[1];

SPF1.Filter2 = CreateFrame("CheckButton", "CraftFilter2Button", CraftFrame, "UICheckButtonTemplate");
SPF1.Filter2.text = SPF1.Filter2:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
SPF1.Filter2.text:SetPoint("LEFT", SPF1.Filter2, "RIGHT", 0, 0);

function SPF1.Filter2.OnLoad()
	SPF1.Filter2:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	
	SPF1.Filter2:SetWidth(15);
	SPF1.Filter2:SetHeight(15);
	SPF1.Filter2:SetFrameLevel(4);
	SPF1.CheckBoxBar:AddButton(SPF1.Filter2);
	
	SPF1.Filter2:SetScript("OnShow", SPF1.Filter2.OnShow);
	SPF1["CFOnShow"]["SPF1.Filter2.OnShow"] = SPF1.Filter2.OnShow;
	
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
	if (arg1 == "RightButton") then
		SPF1.Filter2:SetChecked(not(SPF1.Filter2:GetChecked()));
		if SPF1:Custom("Filter2")["OnRightClick"] then
			SPF1:Custom("Filter2")["OnRightClick"]();
		else
			SPF1.Filter2:OnRightClick();
		end
	else
		if GetCraftName() then
			SPF1.Filter2.Status[GetCraftName()] = SPF1.Filter2:GetChecked();
		end
	end

	if (SPF1.Filter2:GetChecked()) then
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		PlaySound("igMainMenuOptionCheckBoxOff");
	end
    SPF1.FullUpdate();
end

function SPF1.Filter2:OnRightClick()
	if SPF1:SavedData()["IncludeCraftableMats"] ~= false then
		SPF1:SavedData()["IncludeCraftableMats"] = false;
		message = ("|cffbc5ff4[SPF]|r|cffffcf00["..GetCraftName().."]|r: "..L["Filter2RightClickOFF"]);
		DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
	else
		SPF1:SavedData()["IncludeCraftableMats"] = nil;
		message = "|cffbc5ff4[SPF]|r|cffffcf00["..GetCraftName().."]|r: "..L["Filter2RightClickON"];
		DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
	end
end

function SPF1.Filter2:OnEnter()
    if (SPF1.Filter2.tooltipText) then
        GameTooltip:SetOwner(SPF1.Filter2, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF1.Filter2.tooltipText, nil, nil, nil, nil, true);
    end
	if (SPF1:Custom("Filter2")["Tooltip_OnEnter"]) then
		SPF1:Custom("Filter2")["Tooltip_OnEnter"]();
	else
		GameTooltip:AddLine(L["MORE_OPTIONS"], 0.69, 0.69, 0.69, 1);
		GameTooltip:Show();
	end
end

function SPF1.Filter2.OnLeave()
    GameTooltip:Hide();
end

function SPF1.baseCraftHasMats(skillIndex, requiredAmount, layer)
	
	local skillName, _,_, numAvailable = SPF1.baseGetCraftInfo(skillIndex);
	
	if numAvailable >= requiredAmount then
		return true;
	end
	
	if SPF1:SavedData()["IncludeCraftableMats"] == false then
		return false;
	end
	
	if not layer then
		layer = 0;
	end
	
	layer = layer + 1;
	
	if layer > 10 then
		return false;
	end
	
	local requiredReagents = {};
	
	local numReagents = SPF1.baseGetCraftNumReagents(skillIndex);
	
	for i=1, numReagents do
		
		local reagentName, _, reagentCount, playerReagentCount = SPF1.baseGetCraftReagentInfo(skillIndex, i);
		
		if not reagentName then
			return false;
		end
		
		if not requiredReagents[reagentName] then
			requiredReagents[reagentName] = 0;
		end
		
		requiredReagents[reagentName] = requiredReagents[reagentName] + reagentCount * requiredAmount - playerReagentCount;
		
		if SPF1.CraftedItems[reagentName] then			
			
			local recursiveHasMats = SPF1.baseCraftHasMats(SPF1.CraftedItems[reagentName], requiredReagents[reagentName], layer);
			
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
function SPF1.Filter2:Filter(skillIndex)
	
	if not SPF1.Filter2:GetChecked() then
		return true;
	end
	
	if SPF1:Custom("Filter2").Filter then
		return SPF1:Custom("Filter2").Filter(skillIndex);
	end
	
	return SPF1.baseCraftHasMats(skillIndex, 1);
end

-- Return True if the skill matches the filter
function SPF1.Filter2:FilterSpell(spellID)
	if SPF1:Custom("Filter2").FilterSpell then
		return (not SPF1.Filter2:GetChecked() or SPF1:Custom("Filter2").FilterSpell(spellID));
	else
		return not SPF1.Filter2:GetChecked();
	end
end

SPF1.Filter2:OnLoad();
