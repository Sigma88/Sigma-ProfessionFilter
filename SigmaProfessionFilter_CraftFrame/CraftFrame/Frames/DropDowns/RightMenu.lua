local SPF1 = SigmaProfessionFilter[1];

SPF1.RightMenu = SPF1.DropDownMenu_Create("SPF1RightMenuDropDown", CraftFrame);

function SPF1.RightMenu.OnLoad()
	SPF1.RightMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -25, -66);
	
	SPF1.RightMenu:SetScript("OnShow", SPF1.RightMenu.OnShow);
	SPF1["CFOnShow"]["SPF1.RightMenu.OnShow"] = SPF1.RightMenu.OnShow;
	
	SPF1.DropDownMenu_SetWidth(120, SPF1.RightMenu);
	
	SPF1.DropDownMenu_SetSelectedID(SPF1.RightMenu, 1);
	SPF1:SetSelected("Right", 0);
	
	-- LeatrixPlus compatibility
	if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF1.RightMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -34, -40);
	end
	
	-- CraftInvSlotDropDown:SetScript("OnShow", function() CraftInvSlotDropDown:Hide() end );
end

function SPF1.RightMenu:OnShow()
	SPF1.RightMenu:Show();
	
	if not SPF1:GetMenu("Right") then
		SPF1.RightMenu:Hide();
		
		if not SPF1:GetMenu("Left") then
			SPF1:SavedData()["SearchBox"] = true;
		end
	else
		SPF1.DropDownMenu_Initialize(SPF1.RightMenu, SPF1:Custom("RightMenu")["Initialize"] or SPF1.RightMenu.Initialize);
		SPF1.DropDownMenu_SetSelectedID(SPF1.RightMenu, SPF1:GetSelected("Right") + 1);
	end
	
	if SPF1:SavedData()["SearchBox"] then
        SPF1.RightMenu:Hide();
    end
end

function SPF1.RightMenu.Initialize()
	if SPF1:GetMenu("Right") then
		if (SPF1:GetMenu("Right")) then
			local info = {};
			info.text = SPF1:Custom("RightMenu")["title"] or ALL_INVENTORY_SLOTS;
			info.func = SPF1.RightMenu.OnClick;
			info.checked = false;
			
			SPF1.DropDownMenu_AddButton(info);
			
			for i,button in ipairs(SPF1:GetMenu("Right")) do
				info = {};
				info.text = button.name;
				info.func = SPF1.RightMenu.OnClick;
				info.checked = false;
				SPF1.DropDownMenu_AddButton(info);
			end
		else
			local info = {};
			info.text = ALL_INVENTORY_SLOTS;
			info.func = SPF1.RightMenu.OnClick;
			info.checked = false;
			
			SPF1.DropDownMenu_AddButton(info);
			
			for i,slot in ipairs(SPF1.GetCraftInvSlots()) do
				info = {};
				info.text = slot;
				info.func = SPF1.RightMenu.OnClick;
				info.checked = false;
				SPF1.DropDownMenu_AddButton(info);
			end
		end
	end
end

function SPF1.RightMenu:OnClick(arg1, arg2, checked)
	
	SPF1.DropDownMenu_SetSelectedID(SPF1.RightMenu, this:GetID());
	SPF1:SetSelected("Right", this:GetID() - 1);
	
	SPF1.FullUpdate();
end

-- Return the group index if the skill matches the filter
-- Otherwise return 0
function SPF1.RightMenu:Filter(skillIndex, groupIndex)
	if SPF1:Custom("RightMenu")["Filter"] then
		return SPF1:Custom("RightMenu")["Filter"](skillIndex, groupIndex);
	else
		if not SPF1:GetMenu("Right") then
			return 1;
		elseif SPF1:GetMenu("Right") then
			local firstGroup = SPF1:GetGroup("Right", skillIndex, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF1:GetGroup("Right", skillIndex, groupIndex);
			
			if (firstGroup == requiredGroup) then
				return firstGroup;
			end
		else
			local _,_,_,_,_,_,_,_,invType = SPF1.baseGetCraftItemInfo(skillIndex);
			local itemSlot = SPF1:GetSlot(invType);
			
			if invType then
				local lastID = 0;
				for i,slot in ipairs(SPF1.GetCraftInvSlots()) do
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
function SPF1.RightMenu:FilterSpell(spellID, groupIndex)
	if SPF1:Custom("RightMenu")["FilterSpell"] then
		return SPF1:Custom("RightMenu")["FilterSpell"](spellID, groupIndex);
	else
		if not SPF1:GetMenu("Right") then
			return 1;
		elseif SPF1:GetMenu("Right") then
			local firstGroup = SPF1:GetGroupSpell("Right", spellID, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF1:GetGroupSpell("Right", spellID, groupIndex);
			
			if (firstGroup == requiredGroup) then
				return firstGroup;
			end
		else
			local creates = SPF1.GetRecipeInfo(spellID, "creates");
			if creates then
				local _,_,_,_,_,_,_,_,invType = SPF1.GetItemInfo(creates);
				local itemSlot = SPF1:GetSlot(invType);
				
				if invType then
					local lastID = 0;
					for i,slot in ipairs(SPF1.GetCraftInvSlots()) do
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

SPF1.RightMenu.OnLoad();
