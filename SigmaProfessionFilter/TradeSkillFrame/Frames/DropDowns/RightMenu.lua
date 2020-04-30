SPF2.RightMenu = CreateFrame("Frame", nil, TradeSkillFrame, "UIDropDownMenuTemplate");

function SPF2.RightMenu.OnLoad()
	SPF2.RightMenu:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -25, -66);
	
	SPF2.RightMenu:SetScript("OnShow", SPF2.RightMenu.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.RightMenu.OnShow);
	
	UIDropDownMenu_SetWidth(SPF2.RightMenu, 120);
	
	-- LeatrixPlus compatibility
	if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF2.RightMenu:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -34, -40);
	end
end

function SPF2.RightMenu:OnShow()
	SPF2.RightMenu:Show();
	TradeSkillInvSlotDropDown:Show();
	
	if SPF2:Custom("RightMenu")["disabled"] then
		SPF2.RightMenu:Hide();
		TradeSkillInvSlotDropDown:Hide();
		
		if SPF2:Custom("LeftMenu")["disabled"] then
			SPF2:SavedData()["SearchBox"] = true;
		end
	else
		if SPF2:GetMenu("Right") then
			TradeSkillInvSlotDropDown:Hide();
			UIDropDownMenu_Initialize(SPF2.RightMenu, SPF2:Custom("RightMenu")["Initialize"] or SPF2.RightMenu.Initialize);
			UIDropDownMenu_SetSelectedID(SPF2.RightMenu, 1);
		else
			SPF2.RightMenu:Hide();
		end
	end
	
	if SPF2:SavedData()["SearchBox"] then
        SPF2.RightMenu:Hide();
		TradeSkillInvSlotDropDown:Hide();
    end
end

function SPF2.RightMenu.Initialize()
	if not SPF2:Custom("RightMenu")["disabled"] then
		if (SPF2:GetMenu("Right")) then
			local info = {};
			info.text = SPF2:GetTitle("Right");
			info.func = SPF2.RightMenu.OnClick;
			info.checked = false;
			
			UIDropDownMenu_AddButton(info);
			
			for i,button in ipairs(SPF2:GetMenu("Right")) do
				info = {};
				info.text = button.name;
				info.func = SPF2.RightMenu.OnClick;
				info.checked = false;
				UIDropDownMenu_AddButton(info);
			end
		end
	end
end

function SPF2.RightMenu:OnClick(arg1, arg2, checked)
    
    UIDropDownMenu_SetSelectedID(SPF2.RightMenu, self:GetID());
    
	SPF2:SetSelected("Right", self:GetID() - 1);
    
    SPF2.FullUpdate();
end

-- Return the group index if the skill matches the filter
-- Return nil to disable the filter
-- Otherwise return 0
function SPF2.RightMenu:Filter(skillIndex, groupIndex)
	if SPF2:Custom("RightMenu")["Filter"] then
		return SPF2:Custom("RightMenu")["Filter"](skillIndex, groupIndex);
	else
		if SPF2:Custom("RightMenu")["disabled"] then
			return 1;
		elseif SPF2:GetMenu("Right") then
			local firstGroup = SPF2:GetGroup("Right", skillIndex, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF2:GetGroup("Right", skillIndex, groupIndex);
			
			if (firstGroup == requiredGroup) then
				return firstGroup;
			end
		else
			local slotName = getglobal(select(9, SPF2.baseGetTradeSkillItemInfo(skillIndex)));
			local lastID = 0;
			for i,slot in ipairs({GetTradeSkillInvSlots()}) do
				lastID = i;
				if slotName then
					if slotName == slot or slotName.."s" == slot or slotName == slot.."s" then
						return i;
					end
				end
			end
			return lastID;
		end
		
		return 0;
	end
end

SPF2.RightMenu.OnLoad();
