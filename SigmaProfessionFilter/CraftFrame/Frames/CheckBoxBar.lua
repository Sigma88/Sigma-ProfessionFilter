local L = SigmaProfessionFilter.L;
local SPF1 = SigmaProfessionFilter[1];

SPF1.CheckBoxBar = CreateFrame("Frame", "CheckBoxBar", CraftFrame);

function SPF1.CheckBoxBar.OnLoad()
	SPF1.CheckBoxBar:SetScript("OnShow", SPF1.CheckBoxBar.OnShow);
	-- Moved to CraftFrame/Core/ReplaceFunctions --hooksecurefunc("CraftFrame_OnShow", SPF1.CheckBoxBar.OnShow);
	SPF1.CheckBoxBar:SetScript("OnUpdate", SPF1.CheckBoxBar.OnShow);
	SPF1.CheckBoxBar:SetHeight(16);
	
	SPF1.CheckBoxBar.Buttons = {};
	SPF1.CheckBoxBar.numButtons = 0;
	SPF1.CheckBoxBar:SetFrameLevel(4);
end

function SPF1.CheckBoxBar.AddButton(self, frame)
	self.numButtons = self.numButtons + 1;
	local i = self.numButtons;
	
	if i == 1 then
		self.Buttons[1] = CreateFrame("Frame", nil, self);
		self.Buttons[1]:SetPoint("LEFT", self, "LEFT", 0,0);
	else
		self.Buttons[i] = CreateFrame("Frame", nil, self.Buttons[i-1]);
		self.Buttons[i]:SetPoint("LEFT", self.Buttons[i-1], "RIGHT", 0,0);
	end
	
	self.Buttons[i]:SetHeight(15);
	self.Buttons[i].frame = frame;
end

function SPF1.CheckBoxBar.OnShow()
	
	local w = 12;
	if CraftFramePortrait:IsVisible() and CraftFramePortrait:GetAlpha() ~= 0 then
		w = CraftFramePortrait:GetWidth();
	end
	SPF1.CheckBoxBar:SetWidth(337 - w);
	
	
	SPF1.CheckBoxBar:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", w + 5, -54);
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF1.CheckBoxBar:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", w + 5, -57);
    end
	
	
	local maxText = SPF1.CheckBoxBar:GetWidth();
	local textWidth = 0;
	local totWidth = 0;
	
	-- Measure the Buttons
	for i,item in ipairs(SPF1.CheckBoxBar.Buttons) do
		if not item.frame.disabled then
			maxText = maxText - item.frame:GetWidth();
			totWidth = totWidth + item.frame:GetWidth();
			if item.frame.text then
				item.frame.text:SetHeight(0); -- automatic height
				item.frame.text:SetWidth(0); -- automatic width
				textWidth = textWidth + item.frame.text:GetWidth();
				totWidth = totWidth + item.frame.text:GetWidth();
			end
		end
	end
	
	-- Resize the Buttons
	for i,item in ipairs(SPF1.CheckBoxBar.Buttons) do
		
		if item.frame.disabled then
			item:SetWidth(0.001);
		else
		
			if textWidth > maxText then
				local width = item.frame:GetWidth();
				if item.frame.text then
					local label = item.frame.text:GetWidth();
					item.frame.text:SetHeight(item.frame.text:GetHeight()); -- fix height
					item.frame.text:SetWidth(label / textWidth * maxText); -- fix width
					width = width + item.frame.text:GetWidth();
				end
				item:SetWidth(width);
				item.frame:SetPoint("LEFT", item, "CENTER", -width/2, 0);
			else
				local width = item.frame:GetWidth();
				if item.frame.text then
					width = width + item.frame.text:GetWidth();
				end
				item:SetWidth(width / totWidth * SPF1.CheckBoxBar:GetWidth());
				item.frame:SetPoint("LEFT", item, "CENTER", -width/2, 0);
			end
			
			if item.frame.text then
				item.frame:SetHitRectInsets(0, -item.frame.text:GetWidth(), 0, 0);
			end
			
		end
	end
end

SPF1.CheckBoxBar:OnLoad();
