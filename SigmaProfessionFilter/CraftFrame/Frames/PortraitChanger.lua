SPF.PortraitChanger = CreateFrame("Frame", nil, CraftFrame);

function SPF.PortraitChanger:OnLoad()
	SPF.PortraitChanger:SetWidth(CraftFramePortrait:GetWidth());
	SPF.PortraitChanger:SetHeight(CraftFramePortrait:GetHeight());
	SPF.PortraitChanger:SetPoint("TOPLEFT", CraftFramePortrait, "TOPLEFT", 0, 0);
	
	SPF.PortraitChanger:RegisterEvent("UNIT_PET");
	SPF.PortraitChanger:SetScript("OnEvent", SPF.PortraitChanger.OnEvent);
	SPF.PortraitChanger:SetScript("OnMouseDown", SPF.PortraitChanger.OnMouseDown);
	SPF.PortraitChanger:SetScript("OnEnter", SPF.PortraitChanger.OnEnter);
	SPF.PortraitChanger:SetScript("OnLeave", SPF.PortraitChanger.OnLeave);
	
	hooksecurefunc("CraftFrame_Update", SPF.PortraitChanger.OnUpdate);
end

function SPF.PortraitChanger:OnMouseDown()
	SPF:SavedData()["ReplacePortrait"] = not (SPF:SavedData()["ReplacePortrait"] ~= false);
	CraftFrame_Update();
end

function SPF.PortraitChanger:OnUpdate()
	-- Replace the Portrait Icon
	if SPF:SavedData()["ReplacePortrait"] ~= false then
		CraftFramePortrait:SetTexCoord(0.02,0.96,0.05,0.97);
		local icon = SPF.PortraitChanger:GetIcon();
		if icon then
			SetPortraitToTexture(CraftFramePortrait, icon);
			return;
		end
	end
	CraftFramePortrait:SetTexCoord(0,1,0,1);
end

function SPF.PortraitChanger:OnEvent(event, arg1, ...)
	if (event == "UNIT_PET" and arg1 == "player") then
		SPF.FullUpdate();
	end
end

function SPF.PortraitChanger:OnEnter()
	GameTooltip:SetOwner(SPF.PortraitChanger, "ANCHOR_TOPLEFT");
	SPF.PortraitChanger:SetTooltip();
end

function SPF.PortraitChanger:OnLeave()
    GameTooltip:Hide();
end

function SPF.PortraitChanger:GetIcon()
	
	if SPF:Custom("Portrait")["Icon"] then
		return SPF:Custom("Portrait"):Icon();
	end
	
	if SPF[GetCraftName()] and SPF[GetCraftName()]["icon"] then
		return SPF[GetCraftName()]["icon"];
	end
	
	local _,_,icon = GetSpellInfo(GetCraftName());
	return icon;
end

function SPF.PortraitChanger:SetTooltip()
	if SPF:Custom("Tooltip")["Set"] then
		SPF:Custom("Tooltip")["Set"]();
	else
		SPF.PortraitChanger:DefaultTooltip();
	end
end

function SPF.PortraitChanger:DefaultTooltip()
	local spellBookIndex, spellRank = SPF.PortraitChanger.GetTooltipInfo();
	
	GameTooltip:SetSpellBookItem(spellBookIndex, BOOKTYPE_SPELL);
	GameTooltipTextRight1:SetText(spellRank);
	GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5, 1);
	GameTooltipTextRight1:Show();
	GameTooltipTextRight1:ClearAllPoints();
	GameTooltipTextRight1:SetPoint("RIGHT", GameTooltipTextLeft1, "LEFT", GameTooltip:GetWidth() - 20, 0);
end

function SPF.PortraitChanger.GetTooltipInfo()
	
	local craftName = GetCraftName();
	local spellRank = GetSpellSubtext(craftName);
	local spellBookIndex = 0;
	local spellName = true;
	
	while spellName and spellBookIndex < 500 do
		spellBookIndex = spellBookIndex + 1;
		spellName = GetSpellBookItemName(spellBookIndex, BOOKTYPE_SPELL);
		if craftName == spellName then
			return spellBookIndex, spellRank;
		end
	end
end

SPF.PortraitChanger:OnLoad();
