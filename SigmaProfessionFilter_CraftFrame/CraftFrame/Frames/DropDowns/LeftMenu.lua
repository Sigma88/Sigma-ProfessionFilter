local SPF1 = SigmaProfessionFilter[1];

SPF1.LeftMenu = SPF1.DropDownMenu_Create("SPF1LeftMenuDropDown", CraftFrame);

function SPF1.LeftMenu:OnLoad()
	SPF1.LeftMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -160, -66);
	
	SPF1.LeftMenu:SetScript("OnShow", SPF1.LeftMenu.OnShow);
	SPF1["CFOnShow"]["SPF1.LeftMenu.OnShow"] = SPF1.LeftMenu.OnShow;
	
	SPF1.DropDownMenu_SetWidth(120, SPF1.LeftMenu);

	SPF1.DropDownMenu_SetSelectedID(SPF1.LeftMenu, 1);
	SPF1:SetSelected("Left", 0);
	
	-- LeatrixPlus compatibility
	if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF1.LeftMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -204, -40);
	end
	
	-- CraftSubClassDropDown:SetScript("OnShow", function() CraftSubClassDropDown:Hide() end );
end

function SPF1.LeftMenu:OnShow()
	SPF1.LeftMenu:Show();
	
	if not SPF1:GetMenu("Left") then
		SPF1.LeftMenu:Hide();
		
		if not SPF1:GetMenu("Right") then
			SPF1:SavedData()["SearchBox"] = true;
		end
	else
		SPF1.DropDownMenu_Initialize(SPF1.LeftMenu, SPF1:Custom("LeftMenu")["Initialize"] or SPF1.LeftMenu.Initialize);
		SPF1.DropDownMenu_SetSelectedID(SPF1.LeftMenu, SPF1:GetSelected("Left") + 1);
	end
	
    if SPF1:SavedData()["SearchBox"] then
        SPF1.LeftMenu:Hide();
    end
end

function SPF1.LeftMenu:Initialize()
	if SPF1:GetMenu("Left") then
		if (SPF1:GetMenu("Left")) then
			local info = {};
			info.text = SPF1:Custom("LeftMenu")["title"] or ALL_SUBCLASSES;
			info.func = SPF1.LeftMenu.OnClick;
			info.checked = false;
			
			SPF1.DropDownMenu_AddButton(info);
			
			for i,button in ipairs(SPF1:GetMenu("Left")) do
				info = {};
				info.text = button.name;
				info.func = SPF1.LeftMenu.OnClick;
				info.checked = false;
				SPF1.DropDownMenu_AddButton(info);
			end
		else
			local info = {};
			info.text = ALL_SUBCLASSES;
			info.func = SPF1.LeftMenu.OnClick;
			info.checked = false;
			
			SPF1.DropDownMenu_AddButton(info);
			
			for i,subclass in ipairs(SPF1.GetCraftSubClasses()) do
				info = {};
				info.text = subclass;
				info.func = SPF1.LeftMenu.OnClick;
				info.checked = false;
				SPF1.DropDownMenu_AddButton(info);
			end
		end
	end
end

function SPF1.LeftMenu:OnClick(arg1, arg2, checked)
	
	SPF1.DropDownMenu_SetSelectedID(SPF1.LeftMenu, this:GetID());
	SPF1:SetSelected("Left", this:GetID() - 1);
	
	SPF1.FullUpdate();
end

-- Return the group index if the skill matches the filter
-- Return nil to disable the filter
-- Otherwise return 0
function SPF1.LeftMenu:Filter(skillIndex, groupIndex)
	if SPF1:Custom("LeftMenu")["Filter"] then
		return SPF1:Custom("LeftMenu")["Filter"](skillIndex, groupIndex);
	else
		if not SPF1:GetMenu("Left") then
			return 1;
		elseif SPF1:GetMenu("Left") then
			local firstGroup = SPF1:GetGroup("Left", skillIndex, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF1:GetGroup("Left", skillIndex, groupIndex);
			
			if (firstGroup == requiredGroup) then
				return firstGroup;
			end
		else
			local _,_,_,_,_,_,itemSubClass = SPF1.baseGetCraftItemInfo(skillIndex);
			
			if itemSubClass then
				local lastID = 0;
				for i,subClass in ipairs(SPF1.GetCraftSubClasses()) do
					lastID = i;
					if itemSubClass == subClass then
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
-- Return nil to disable the filter
-- Otherwise return 0
function SPF1.LeftMenu:FilterSpell(spellID, groupIndex)
	if SPF1:Custom("LeftMenu")["FilterSpell"] then
		return SPF1:Custom("LeftMenu")["FilterSpell"](spellID, groupIndex);
	else
		if not SPF1:GetMenu("Left") then
			return 1;
		elseif SPF1:GetMenu("Left") then
			local firstGroup = SPF1:GetGroupSpell("Left", spellID, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF1:GetGroupSpell("Left", spellID, groupIndex);
			
			if (firstGroup == requiredGroup) then
				return firstGroup;
			end
		else
			local creates = SPF1.GetRecipeInfo(spellID, "creates");
			local _,_,_,_,_,_,itemSubClass = SPF1.GetItemInfo(creates);
			local lastID = 0;
			for i,subClass in ipairs(SPF1.GetCraftSubClasses()) do
				lastID = i;
				if creates then
					if itemSubClass == subClass then
						if groupIndex == 0 or groupIndex == i then
							return i;
						end
						return 0;
					end
				end
			end
			
			if groupIndex == 0 or groupIndex == lastID then
				return lastID;
			end
		end
		
		return 0;
	end
end

SPF1.LeftMenu.OnLoad();
