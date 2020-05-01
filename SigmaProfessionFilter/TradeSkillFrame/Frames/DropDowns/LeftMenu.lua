SPF2.LeftMenu = CreateFrame("Frame", nil, TradeSkillFrame, "UIDropDownMenuTemplate");

function SPF2.LeftMenu:OnLoad()
	SPF2.LeftMenu:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -160, -66);
	
	SPF2.LeftMenu:SetScript("OnShow", SPF2.LeftMenu.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.LeftMenu.OnShow);
	
	UIDropDownMenu_SetWidth(SPF2.LeftMenu, 120);
	
	-- LeatrixPlus compatibility
	if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF2.LeftMenu:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -204, -40);
	end
end

function SPF2.LeftMenu:OnShow()
	SPF2.LeftMenu:Show();
	TradeSkillSubClassDropDown:Show();
	
	if SPF2:Custom("LeftMenu")["disabled"] then
		SPF2.LeftMenu:Hide();
		TradeSkillSubClassDropDown:Hide();
		
		if SPF2:Custom("RightMenu")["disabled"] then
			SPF2:SavedData()["SearchBox"] = true;
		end
	else
		if SPF2:GetMenu("Left") then
			TradeSkillSubClassDropDown:Hide();
			UIDropDownMenu_Initialize(SPF2.LeftMenu, SPF2:Custom("LeftMenu")["Initialize"] or SPF2.LeftMenu.Initialize);
			UIDropDownMenu_SetSelectedID(SPF2.LeftMenu, 1);
		else
			SPF2.LeftMenu:Hide();
		end
	end
	
    if SPF2:SavedData()["SearchBox"] then
        SPF2.LeftMenu:Hide();
		TradeSkillSubClassDropDown:Hide();
    end
end

function SPF2.LeftMenu:Initialize()
	if not SPF2:Custom("LeftMenu")["disabled"] then
		if (SPF2:GetMenu("Left")) then
			local info = {};
			info.text = SPF2:GetTitle("Left");
			info.func = SPF2.LeftMenu.OnClick;
			info.checked = false;
			
			UIDropDownMenu_AddButton(info);
			
			for i,button in ipairs(SPF2:GetMenu("Left")) do
				info = {};
				info.text = button.name;
				info.func = SPF2.LeftMenu.OnClick;
				info.checked = false;
				UIDropDownMenu_AddButton(info);
			end
		end
	end
end

function SPF2.LeftMenu:OnClick(arg1, arg2, checked)
	
	UIDropDownMenu_SetSelectedID(SPF2.LeftMenu, self:GetID());
	
	if not SPF2:GetMenu("Left") then
		TradeSkillSubClassDropDownButton_OnClick(self);
	end

	SPF2:SetSelected("Left", self:GetID() - 1);
    
    SPF2.FullUpdate();
end

-- Return the group index if the skill matches the filter
-- Return nil to disable the filter
-- Otherwise return 0
function SPF2.LeftMenu:Filter(skillIndex, groupIndex)
	if SPF2:Custom("LeftMenu")["Filter"] then
		return SPF2:Custom("LeftMenu")["Filter"](skillIndex, groupIndex);
	else
		if SPF2:Custom("LeftMenu")["disabled"] then
			return 1;
		elseif SPF2:GetMenu("Left") then
			local firstGroup = SPF2:GetGroup("Left", skillIndex, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF2:GetGroup("Left", skillIndex, groupIndex);
			
			if (firstGroup == requiredGroup) then
				return firstGroup;
			end
		else
			return nil;
		end
		
		return 0;
	end
end

SPF2.LeftMenu.OnLoad();
