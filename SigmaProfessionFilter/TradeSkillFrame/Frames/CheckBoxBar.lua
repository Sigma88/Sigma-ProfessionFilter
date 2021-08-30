local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.CheckBoxBar = CreateFrame("Frame", "CheckBoxBar", TradeSkillFrame);

function SPF2.CheckBoxBar.OnLoad()
	SPF2.CheckBoxBar:SetScript("OnShow", SPF2.CheckBoxBar.OnShow);
	-- Moved to TradeSkillFrame/Core/ReplaceFunctions --hooksecurefunc("TradeSkillFrame_OnShow", SPF2.CheckBoxBar.OnShow);
	
	SPF2.CheckBoxBar:SetHeight(16);
	
	SPF2.CheckBoxBar.Buttons = {};
	SPF2.CheckBoxBar.numButtons = 0;
	SPF2.CheckBoxBar:SetFrameLevel(4);
end

function SPF2.CheckBoxBar.AddButton(self, frame)
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

function SPF2.CheckBoxBar.OnShow()
	
	local w = 12;
	if TradeSkillFramePortrait:IsVisible() and TradeSkillFramePortrait:GetAlpha() ~= 0 then
		w = TradeSkillFramePortrait:GetWidth();
	end
	SPF2.CheckBoxBar:SetWidth(337 - w);
	
	
	SPF2.CheckBoxBar:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", w + 5, -54);
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF2.CheckBoxBar:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", w + 5, -57);
    end
	
	
	local maxText = SPF2.CheckBoxBar:GetWidth();
	local textWidth = 0;
	local totWidth = 0;
	
	-- Measure the Buttons
	for i,item in ipairs(SPF2.CheckBoxBar.Buttons) do
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
	for i,item in ipairs(SPF2.CheckBoxBar.Buttons) do
		
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
				item:SetWidth(width / totWidth * SPF2.CheckBoxBar:GetWidth());
				item.frame:SetPoint("LEFT", item, "CENTER", -width/2, 0);
			end
			
			if item.frame.text then
				item.frame:SetHitRectInsets(0, -item.frame.text:GetWidth(), 0, 0);
			end
			
		end
	end
end

SPF2.CheckBoxBar:OnLoad();
