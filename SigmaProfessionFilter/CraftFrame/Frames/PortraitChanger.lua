local SPF1 = SigmaProfessionFilter[1];

SPF1.PortraitChanger = CreateFrame("Button", nil, CraftFrame);

function SPF1.PortraitChanger:OnLoad()
	SPF1.PortraitChanger:SetWidth(CraftFramePortrait:GetWidth());
	SPF1.PortraitChanger:SetHeight(CraftFramePortrait:GetHeight());
	SPF1.PortraitChanger:SetPoint("TOPLEFT", CraftFramePortrait, "TOPLEFT", 0, 0);
	SPF1.PortraitChanger:EnableMouse(true);
	SPF1.PortraitChanger:RegisterForDrag("LeftButton");
	SPF1.PortraitChanger:RegisterForClicks("RightButtonUp");
	SPF1.PortraitChanger:SetScript("OnShow", SPF1.PortraitChanger.OnShow);
	SPF1.PortraitChanger:SetScript("OnDragStart", SPF1.PortraitChanger.OnMouseDown);
	SPF1.PortraitChanger:SetScript("OnDragStop", SPF1.PortraitChanger.OnMouseUp);
	SPF1.PortraitChanger:SetScript("OnClick", SPF1.PortraitChanger.OnClick);
	SPF1.PortraitChanger:SetScript("OnEnter", SPF1.PortraitChanger.OnEnter);
	SPF1.PortraitChanger:SetScript("OnLeave", SPF1.PortraitChanger.OnLeave);
	
	SPF1["CFOnShow"]["SPF1.PortraitChanger.OnShow"] = SPF1.PortraitChanger.OnShow;
	
	-- SPF1.PortraitChanger:SetScript("OnEvent", SPF1.PortraitChanger.OnEvent); -- Keep for debug purposes
end

function SPF1.PortraitChanger:OnMouseUp()
	CraftFrame:StopMovingOrSizing();
end

function SPF1.PortraitChanger:OnMouseDown()
	CraftFrame:StartMoving();
end

function SPF1.PortraitChanger:OnClick()
	SPF1:SavedData()["ReplacePortrait"] = not (SPF1:SavedData()["ReplacePortrait"] ~= false);
	SPF1.PortraitChanger:OnShow();
end

function SPF1.PortraitChanger:OnShow()
	-- Default Portrait Icon
	CraftFramePortrait:SetTexCoord(0,1,0,1);
	SPF1.baseSetPortraitTexture(CraftFramePortrait, "player");
	
	-- Replace Portrait Icon
	if SPF1:SavedData()["ReplacePortrait"] ~= false then
		local icon = SPF1.PortraitChanger:GetIcon();
		if icon then
			CraftFramePortrait:SetTexCoord(0.02,0.96,0.05,0.97);
			SetPortraitToTexture(CraftFramePortrait, icon);
		end
	end
	
	-- Update the Tooltip
	if SPF1.PortraitChanger.IsMouseOver then
		SPF1.PortraitChanger:OnEnter();
	else
		SPF1.PortraitChanger:OnLeave();
	end
end

--[[ Keep For Debug Purposes
function SPF1.PortraitChanger:OnEvent(event, arg1, ...)
	print("OnEvent",event, arg1, ...);
end
--]]

function SPF1.PortraitChanger:OnEnter()
	GameTooltip:SetOwner(SPF1.PortraitChanger, "ANCHOR_TOPLEFT");
	SPF1.PortraitChanger:SetTooltip();
	SPF1.PortraitChanger.IsMouseOver = true;
end

function SPF1.PortraitChanger:OnLeave()
    GameTooltip:Hide();
	SPF1.PortraitChanger.IsMouseOver = false;
end

function SPF1.PortraitChanger:GetIcon()
	
	if SPF1:Custom("Portrait")["Icon"] then
		return SPF1:Custom("Portrait"):Icon();
	end

	if SigmaProfessionFilter[GetCraftName()] and SigmaProfessionFilter[GetCraftName()]["icon"] then
		return SigmaProfessionFilter[GetCraftName()]["icon"];
	end
	
	local icon = SPF1.GetProfessionIcon();
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
	
	if spellBookIndex then
		GameTooltip:SetSpell(spellBookIndex, BOOKTYPE_SPELL);
		GameTooltipTextRight1:SetText(spellRank);
		GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5, 1);
		GameTooltipTextRight1:Show();
		GameTooltipTextRight1:ClearAllPoints();
		GameTooltipTextRight1:SetPoint("RIGHT", GameTooltipTextLeft1, "LEFT", GameTooltip:GetWidth() - 20, 0);
	end
end

function SPF1.PortraitChanger.GetTooltipInfo()
	
	local craftName = GetCraftName();
	if craftName then
		for i = 1, 200, 1 do
			local spellName, subSpellName = GetSpellName(i, BOOKTYPE_SPELL)
			if spellName == craftName then
				return i, subSpellName;
			end
		end
	end
end

function SPF1.SetPortraitTexture(frame, arg1, arg2, arg3)
	if frame and frame:GetName() == "CraftFramePortrait" then
		return;
	end
	return SPF1.baseSetPortraitTexture(frame, arg1, arg2, arg3);
end

SPF1.baseSetPortraitTexture = SetPortraitTexture;
SetPortraitTexture = SPF1.SetPortraitTexture;

SPF1.PortraitChanger:OnLoad();
