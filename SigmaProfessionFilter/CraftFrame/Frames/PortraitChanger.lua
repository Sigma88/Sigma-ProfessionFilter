SPF.PortraitChanger = CreateFrame("Frame", nil, CraftFrame);

function SPF.PortraitChanger:OnLoad()
	SPF.PortraitChanger:SetWidth(CraftFramePortrait:GetWidth());
	SPF.PortraitChanger:SetHeight(CraftFramePortrait:GetHeight());
	SPF.PortraitChanger:SetPoint("TOPLEFT", CraftFramePortrait, "TOPLEFT", 0, 0);
	
	SPF.PortraitChanger:RegisterEvent("UNIT_PET");
	SPF.PortraitChanger:SetScript("OnEvent", SPF.PortraitChanger.OnEvent);
	SPF.PortraitChanger:SetScript("OnMouseDown", SPF.PortraitChanger.OnMouseDown);
	
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

function SPF.PortraitChanger:GetIcon()
	if SPF:Custom("Portrait")["Icon"] then
		return SPF:Custom("Portrait"):Icon();
	end
	if SPF[GetCraftName()] then
		return SPF[GetCraftName()]["icon"];
	end
end

SPF.PortraitChanger:OnLoad();
