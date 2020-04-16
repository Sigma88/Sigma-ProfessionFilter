function SPF_PortraitChanger_OnLoad(self)
	hooksecurefunc("CraftFrame_Update", SPF_PortraitChanger_OnUpdate);
	self:SetPoint("TOPLEFT", CraftFramePortrait, "TOPLEFT", 0, 0);
	self:SetHeight(CraftFramePortrait:GetHeight());
	self:SetWidth(CraftFramePortrait:GetWidth());
end

function SPF_PortraitChanger_OnMouseDown()
	-- Check if the profession is supported
	local Profession = SPF[GetCraftName()];
	
	-- Toggle the option
	if Profession and Profession["icon"] then
		Sigma_ProfessionFilter_ReplacePortrait = not (Sigma_ProfessionFilter_ReplacePortrait ~= false);
		CraftFrame_Update();
	end
end

function SPF_PortraitChanger_OnUpdate()
	-- Check if the profession is supported
	local Profession = SPF[GetCraftName()];
	
	-- Replace the Portrait Icon
	if Profession and Profession["icon"] and Sigma_ProfessionFilter_ReplacePortrait ~= false then
		SetPortraitToTexture(CraftFramePortrait, Profession["icon"]); 
	end
end
