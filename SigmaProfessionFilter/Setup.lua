
function SPF_LeftMenu_OnLoad()
	UIDropDownMenu:SetWidth(self, 120);
	UIDropDownMenu_Initialize(self, self.Initialize);
	UIDropDownMenu_SetSelectedID(self, 1);
	
	-- LeatrixPlus compatibility
	if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		self:SetPoint("RIGHT", SPF_RightMenu, "LEFT", 0, 0);
	end
end
