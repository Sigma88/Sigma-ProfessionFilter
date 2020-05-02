local SPF2 = SigmaProfessionFilter[2];

SPF2.PortraitChanger = CreateFrame("Frame", nil, TradeSkillFrame);

function SPF2.PortraitChanger:OnLoad()
	SPF2.PortraitChanger:SetWidth(TradeSkillFramePortrait:GetWidth());
	SPF2.PortraitChanger:SetHeight(TradeSkillFramePortrait:GetHeight());
	SPF2.PortraitChanger:SetPoint("TOPLEFT", TradeSkillFramePortrait, "TOPLEFT", 0, 0);
	SPF2.PortraitChanger:SetScript("OnShow", SPF2.PortraitChanger.OnShow);
	SPF2.PortraitChanger:SetScript("OnMouseDown", SPF2.PortraitChanger.OnMouseDown);
	SPF2.PortraitChanger:SetScript("OnEnter", SPF2.PortraitChanger.OnEnter);
	SPF2.PortraitChanger:SetScript("OnLeave", SPF2.PortraitChanger.OnLeave);
	
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.PortraitChanger.OnShow);
	
	-- SPF2.PortraitChanger:SetScript("OnEvent", SPF2.PortraitChanger.OnEvent); -- Keep for debug purposes
end

function SPF2.PortraitChanger:OnMouseDown()
	SPF2:SavedData()["ReplacePortrait"] = not (SPF2:SavedData()["ReplacePortrait"] ~= false);
	SPF2.PortraitChanger:OnShow();
end

function SPF2.PortraitChanger:OnShow()
	-- Default Portrait Icon
	TradeSkillFramePortrait:SetTexCoord(0,1,0,1);
	SetPortraitTexture(TradeSkillFramePortrait, "player");
	
	-- Replace Portrait Icon
	if SPF2:SavedData()["ReplacePortrait"] ~= false then
		local icon = SPF2.PortraitChanger:GetIcon();
		if icon then
			TradeSkillFramePortrait:SetTexCoord(0.02,0.96,0.05,0.97);
			SetPortraitToTexture(TradeSkillFramePortrait, icon);
		end
	end
	
	-- Update the Tooltip
	if SPF2.PortraitChanger:IsMouseOver() then
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
end

function SPF2.PortraitChanger:OnLeave()
    GameTooltip:Hide();
end

function SPF2.PortraitChanger:GetIcon()
	
	if SPF2:Custom("Portrait")["Icon"] then
		return SPF2:Custom("Portrait"):Icon();
	end

	if SigmaProfessionFilter[GetTradeSkillName()] and SigmaProfessionFilter[GetTradeSkillName()]["icon"] then
		return SigmaProfessionFilter[GetTradeSkillName()]["icon"];
	end
	
	local _,_,icon = GetSpellInfo(GetTradeSkillName());
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
	
	GameTooltip:SetSpellBookItem(spellBookIndex, BOOKTYPE_SPELL);
	GameTooltipTextRight1:SetText(spellRank);
	GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5, 1);
	GameTooltipTextRight1:Show();
	GameTooltipTextRight1:ClearAllPoints();
	GameTooltipTextRight1:SetPoint("RIGHT", GameTooltipTextLeft1, "LEFT", GameTooltip:GetWidth() - 20, 0);
end

function SPF2.PortraitChanger.GetTooltipInfo()
	
	local tradeSkillName = GetTradeSkillName();
	
	local spellRank = GetSpellSubtext(tradeSkillName);
	local spellBookIndex = 0;
	local spellName = true;
	
	while spellName and spellBookIndex < 500 do
		spellBookIndex = spellBookIndex + 1;
		spellName = GetSpellBookItemName(spellBookIndex, BOOKTYPE_SPELL);
		if tradeSkillName == spellName then
			return spellBookIndex, spellRank;
		end
	end
end

SPF2.PortraitChanger:OnLoad();
