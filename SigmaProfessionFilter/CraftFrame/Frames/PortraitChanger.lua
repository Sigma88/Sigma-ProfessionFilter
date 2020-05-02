SPF1.PortraitChanger = CreateFrame("Frame", nil, CraftFrame);

function SPF1.PortraitChanger:OnLoad()
	SPF1.PortraitChanger:SetWidth(CraftFramePortrait:GetWidth());
	SPF1.PortraitChanger:SetHeight(CraftFramePortrait:GetHeight());
	SPF1.PortraitChanger:SetPoint("TOPLEFT", CraftFramePortrait, "TOPLEFT", 0, 0);
	
	SPF1.PortraitChanger:RegisterEvent("UNIT_PET");
	SPF1.PortraitChanger:SetScript("OnEvent", SPF1.PortraitChanger.OnEvent);
	SPF1.PortraitChanger:SetScript("OnMouseDown", SPF1.PortraitChanger.OnMouseDown);
	SPF1.PortraitChanger:SetScript("OnEnter", SPF1.PortraitChanger.OnEnter);
	SPF1.PortraitChanger:SetScript("OnLeave", SPF1.PortraitChanger.OnLeave);
	
	hooksecurefunc("CraftFrame_Update", SPF1.PortraitChanger.OnUpdate);
end

function SPF1.PortraitChanger:OnMouseDown()
	SPF1:SavedData()["ReplacePortrait"] = not (SPF1:SavedData()["ReplacePortrait"] ~= false);
	CraftFrame_Update();
end

function SPF1.PortraitChanger:OnUpdate()
	-- Replace the Portrait Icon
	if SPF1:SavedData()["ReplacePortrait"] ~= false then
		CraftFramePortrait:SetTexCoord(0.02,0.96,0.05,0.97);
		local icon = SPF1.PortraitChanger:GetIcon();
		if icon then
			SetPortraitToTexture(CraftFramePortrait, icon);
			return;
		end
	end
	CraftFramePortrait:SetTexCoord(0,1,0,1);
end

function SPF1.PortraitChanger:OnEvent(event, arg1, ...)
	if (event == "UNIT_PET" and arg1 == "player") then
		SPF1.FullUpdate();
	end
end

function SPF1.PortraitChanger:OnEnter()
	GameTooltip:SetOwner(SPF1.PortraitChanger, "ANCHOR_TOPLEFT");
	SPF1.PortraitChanger:SetTooltip();
end

function SPF1.PortraitChanger:OnLeave()
    GameTooltip:Hide();
end

function SPF1.PortraitChanger:GetIcon()
	
	if SPF1:Custom("Portrait")["Icon"] then
		return SPF1:Custom("Portrait"):Icon();
	end
	
	if SigmaProfessionFilter[GetCraftName()] and SigmaProfessionFilter[GetCraftName()]["icon"] then
		return SigmaProfessionFilter[GetCraftName()]["icon"];
	end
	
	local _,_,icon = GetSpellInfo(GetCraftName());
	return icon;
end

function SPF1.PortraitChanger:SetTooltip()
	if SPF1:Custom("Tooltip")["Set"] then
		SPF1:Custom("Tooltip")["Set"]();
	else
		SPF1.PortraitChanger:DefaultTooltip();
	end
end

function SPF1.PortraitChanger:DefaultTooltip()
	local spellBookIndex, spellRank = SPF1.PortraitChanger.GetTooltipInfo();
	
	GameTooltip:SetSpellBookItem(spellBookIndex, BOOKTYPE_SPELL);
	GameTooltipTextRight1:SetText(spellRank);
	GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5, 1);
	GameTooltipTextRight1:Show();
	GameTooltipTextRight1:ClearAllPoints();
	GameTooltipTextRight1:SetPoint("RIGHT", GameTooltipTextLeft1, "LEFT", GameTooltip:GetWidth() - 20, 0);
end

function SPF1.PortraitChanger.GetTooltipInfo()
	
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

SPF1.PortraitChanger:OnLoad();
