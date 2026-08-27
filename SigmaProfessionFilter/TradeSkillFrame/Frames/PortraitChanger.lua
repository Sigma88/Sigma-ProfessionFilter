local SPF2 = SigmaProfessionFilter[2];

SPF2.PortraitChanger = CreateFrame("Button", nil, TradeSkillFrame);

function SPF2.PortraitChanger:OnLoad()
	SPF2.PortraitChanger:SetWidth(TradeSkillFramePortrait:GetWidth());
	SPF2.PortraitChanger:SetHeight(TradeSkillFramePortrait:GetHeight());
	SPF2.PortraitChanger:SetPoint("TOPLEFT", TradeSkillFramePortrait, "TOPLEFT", 0, 0);
	SPF2.PortraitChanger:EnableMouse(true);
	SPF2.PortraitChanger:RegisterForDrag("LeftButton");
	SPF2.PortraitChanger:RegisterForClicks("RightButtonUp");
	SPF2.PortraitChanger:SetScript("OnShow", SPF2.PortraitChanger.OnShow);
	SPF2.PortraitChanger:SetScript("OnDragStart", SPF2.PortraitChanger.OnMouseDown);
	SPF2.PortraitChanger:SetScript("OnDragStop", SPF2.PortraitChanger.OnMouseUp);
	SPF2.PortraitChanger:SetScript("OnClick", SPF2.PortraitChanger.OnClick);
	SPF2.PortraitChanger:SetScript("OnEnter", SPF2.PortraitChanger.OnEnter);
	SPF2.PortraitChanger:SetScript("OnLeave", SPF2.PortraitChanger.OnLeave);
	
	SPF2["TSFOnShow"]["SPF2.PortraitChanger.OnShow"] = SPF2.PortraitChanger.OnShow;
	
	-- SPF2.PortraitChanger:SetScript("OnEvent", SPF2.PortraitChanger.OnEvent); -- Keep for debug purposes
end

function SPF2.PortraitChanger:OnMouseUp()
	TradeSkillFrame:StopMovingOrSizing();
end

function SPF2.PortraitChanger:OnMouseDown()
	TradeSkillFrame:StartMoving();
end

function SPF2.PortraitChanger:OnClick()
	SPF2:SavedData()["ReplacePortrait"] = not (SPF2:SavedData()["ReplacePortrait"] ~= false);
	SPF2.PortraitChanger:OnShow();
end

function SPF2.PortraitChanger:OnShow()
	-- Default Portrait Icon
	TradeSkillFramePortrait:SetTexCoord(0,1,0,1);
	SPF2.baseSetPortraitTexture(TradeSkillFramePortrait, "player");
	
	-- Replace Portrait Icon
	if SPF2:SavedData()["ReplacePortrait"] ~= false then
		local icon = SPF2.PortraitChanger:GetIcon();
		if icon then
			TradeSkillFramePortrait:SetTexCoord(0.02,0.96,0.05,0.97);
			SetPortraitToTexture(TradeSkillFramePortrait, icon);
		end
	end
	
	-- Update the Tooltip
	if SPF2.PortraitChanger.IsMouseOver then
		SPF2.PortraitChanger:OnEnter();
	else
		SPF2.PortraitChanger:OnLeave();
	end
end

--[[ Keep For Debug Purposes
function SPF2.PortraitChanger:OnEvent(event, arg1, ...)
	print("OnEvent",event, arg1, ...);
end
--]]

function SPF2.PortraitChanger:OnEnter()
	GameTooltip:SetOwner(SPF2.PortraitChanger, "ANCHOR_TOPLEFT");
	SPF2.PortraitChanger:SetTooltip();
	SPF2.PortraitChanger.IsMouseOver = true;
end

function SPF2.PortraitChanger:OnLeave()
	GameTooltip:Hide();
	SPF2.PortraitChanger.IsMouseOver = false;
end

function SPF2.PortraitChanger:GetIcon()
	
	if SPF2:Custom("Portrait")["Icon"] then
		return SPF2:Custom("Portrait"):Icon();
	end

	if SigmaProfessionFilter[GetTradeSkillName()] and SigmaProfessionFilter[GetTradeSkillName()]["icon"] then
		return SigmaProfessionFilter[GetTradeSkillName()]["icon"];
	end
	
	local icon = SPF2.GetProfessionIcon();
	return icon;
end

function SPF2.PortraitChanger:SetTooltip()
	if SPF2:Custom("Tooltip")["Set"] then
		SPF2:Custom("Tooltip")["Set"]();
	else
		SPF2.PortraitChanger:DefaultTooltip();
	end
end

function SPF2.PortraitChanger:DefaultTooltip()
	local spellBookIndex, spellRank = SPF2.PortraitChanger.GetTooltipInfo();
	
	if spellBookIndex then
		GameTooltip:SetSpell(spellBookIndex, BOOKTYPE_SPELL);
		GameTooltipTextRight1:SetText(spellRank);
		GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5, 1);
		GameTooltipTextRight1:Show();
		GameTooltipTextRight1:ClearAllPoints();
		GameTooltipTextRight1:SetPoint("RIGHT", GameTooltipTextLeft1, "LEFT", GameTooltip:GetWidth() - 20, 0);
	end
end

function SPF2.PortraitChanger.GetTooltipInfo()
	
	local tradeSkillName = GetTradeSkillName();
	if tradeSkillName then
		for i = 1, 200, 1 do
			local spellName, subSpellName = GetSpellName(i, BOOKTYPE_SPELL)
			if spellName == tradeSkillName then
				return i, subSpellName;
			end
		end
	end
end

function SPF2.SetPortraitTexture(frame, arg1, arg2, arg3)
	if frame and frame:GetName() == "TradeSkillFramePortrait" then
		return;
	end
	return SPF2.baseSetPortraitTexture(frame, arg1, arg2, arg3);
end

SPF2.baseSetPortraitTexture = SetPortraitTexture;
SetPortraitTexture = SPF2.SetPortraitTexture;

SPF2.PortraitChanger:OnLoad();
