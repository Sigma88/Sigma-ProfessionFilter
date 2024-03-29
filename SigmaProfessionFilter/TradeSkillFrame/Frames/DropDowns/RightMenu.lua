local SPF2 = SigmaProfessionFilter[2];

SPF2.RightMenu = SPF2.DropDownMenu_Create("SPF2RightMenuDropDown", TradeSkillFrame);

function SPF2.RightMenu.OnLoad()
	SPF2.RightMenu:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -25, -66);
	
	SPF2.RightMenu:SetScript("OnShow", SPF2.RightMenu.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.RightMenu.OnShow);
	
	SPF2.DropDownMenu_SetWidth(SPF2.RightMenu, 120);
	
	SPF2.DropDownMenu_SetSelectedID(SPF2.RightMenu, 1);
	SPF2:SetSelected("Right", 0);
	
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
		TradeSkillInvSlotDropDown:Hide();
		SPF2.DropDownMenu_Initialize(SPF2.RightMenu, SPF2:Custom("RightMenu")["Initialize"] or SPF2.RightMenu.Initialize);
		SPF2.DropDownMenu_SetSelectedID(SPF2.RightMenu, SPF2:GetSelected("Right") + 1);
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
			info.text = SPF2:Custom("RightMenu")["title"] or ALL_INVENTORY_SLOTS;
			info.func = SPF2.RightMenu.OnClick;
			info.checked = false;
			
			SPF2.DropDownMenu_AddButton(info);
			
			for i,button in ipairs(SPF2:GetMenu("Right")) do
				info = {};
				info.text = button.name;
				info.func = SPF2.RightMenu.OnClick;
				info.checked = false;
				SPF2.DropDownMenu_AddButton(info);
			end
		else
			local info = {};
			info.text = ALL_INVENTORY_SLOTS;
			info.func = SPF2.RightMenu.OnClick;
			info.checked = false;
			
			SPF2.DropDownMenu_AddButton(info);
			
			for i,slot in ipairs({GetTradeSkillInvSlots()}) do
				info = {};
				info.text = slot;
				info.func = SPF2.RightMenu.OnClick;
				info.checked = false;
				SPF2.DropDownMenu_AddButton(info);
			end
		end
	end
end

function SPF2.RightMenu:OnClick(arg1, arg2, checked)
	
	SPF2.DropDownMenu_SetSelectedID(SPF2.RightMenu, self:GetID());
	SPF2:SetSelected("Right", self:GetID() - 1);
	
	SPF2.FullUpdate();
end

-- Return the group index if the skill matches the filter
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
			local invType = select(9, SPF2.baseGetTradeSkillItemInfo(skillIndex));
			local itemSlot = SPF2:GetSlot(invType);
			
			if invType then
				local lastID = 0;
				for i,slot in ipairs({GetTradeSkillInvSlots()}) do
					lastID = i;
					if itemSlot == slot then
						if groupIndex == 0 or groupIndex == i then
							return i;
						end
						return 0;
					end
				end
				
				if groupIndex == 0 or groupIndex == lastID then
					return lastID;
				end
			end
		end
		
		return 0;
	end
end

-- Return the group index if the skill matches the filter
-- Otherwise return 0
function SPF2.RightMenu:FilterSpell(spellID, groupIndex)
	if SPF2:Custom("RightMenu")["FilterSpell"] then
		return SPF2:Custom("RightMenu")["FilterSpell"](spellID, groupIndex);
	else
		if SPF2:Custom("RightMenu")["disabled"] then
			return 1;
		elseif SPF2:GetMenu("Right") then
			local firstGroup = SPF2:GetGroupSpell("Right", spellID, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF2:GetGroupSpell("Right", spellID, groupIndex);
			
			if (firstGroup == requiredGroup) then
				return firstGroup;
			end
		else
			local creates = SPF2.GetRecipeInfo(spellID, "creates");
			if creates then
				local invType = select(9, GetItemInfo(creates));
				local itemSlot = SPF2:GetSlot(invType);
				
				if invType then
					local lastID = 0;
					for i,slot in ipairs({GetTradeSkillInvSlots()}) do
						lastID = i;
						if itemSlot == slot then
							if groupIndex == 0 or groupIndex == i then
								return i;
							end
							return 0;
						end
					end
					
					if groupIndex == 0 or groupIndex == lastID then
						return lastID;
					end
				end
			end
		end
		
		return 0;
	end
end

SPF2.RightMenu.OnLoad();
