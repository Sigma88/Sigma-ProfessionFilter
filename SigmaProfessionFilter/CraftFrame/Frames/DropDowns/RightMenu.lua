local SPF1 = SigmaProfessionFilter[1];

SPF1.RightMenu = SPF1.DropDownMenu_Create("SPF1RightMenuDropDown", CraftFrame);

function SPF1.RightMenu.OnLoad()
	SPF1.RightMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -25, -66);
	
	SPF1.RightMenu:SetScript("OnShow", SPF1.RightMenu.OnShow);
	hooksecurefunc("CraftFrame_OnShow", SPF1.RightMenu.OnShow);
	
	SPF1.DropDownMenu_SetWidth(SPF1.RightMenu, 120);
	SPF1.DropDownMenu_SetSelectedID(SPF1.RightMenu, 1);
	SPF1:SetSelected("Right", 0);
	
	-- LeatrixPlus compatibility
	if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF1.RightMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -34, -40);
	end
end

function SPF1.RightMenu.OnShow()
    if ((not SPF1:GetMenu("Right")) or (SPF1:SavedData()["SearchBox"])) then
        SPF1.RightMenu:Hide();
	else
		SPF1.DropDownMenu_Initialize(SPF1.RightMenu, SPF1:Custom("RightMenu")["Initialize"] or SPF1.RightMenu.Initialize);
		SPF1.DropDownMenu_SetSelectedID(SPF1.RightMenu, SPF1:GetSelected("Right") + 1);
    end
end

function SPF1.RightMenu.Initialize()
    if (SPF1:GetMenu("Right")) then
        local info = {};
        info.text = SPF1:Custom("RightMenu")["title"];
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
    end
end

function SPF1.RightMenu:OnClick(arg1, arg2, checked)
	
    SPF1.DropDownMenu_SetSelectedID(SPF1.RightMenu, self:GetID());
	
	SPF1:SetSelected("Right", self:GetID() - 1);
	
    SPF1.FullUpdate();
end

-- Return the group name if the craft matches the filter otherwise return ""
function SPF1.RightMenu:Filter(craftIndex, groupIndex)
	if SPF1:Custom("RightMenu")["Filter"] then
		return SPF1:Custom("RightMenu")["Filter"](craftIndex, groupIndex);
	else
		if SPF1:GetMenu("Right") then
			--local craftName = SPF1.baseGetCraftInfo(craftIndex);
			local firstGroup = SPF1:GetGroup("Right", craftIndex, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF1:GetGroup("Right", craftIndex, groupIndex);
			
			if (firstGroup == requiredGroup) then
				return firstGroup;
			end
		else
			return 1;
		end
		
		return 0;
	end
end

-- Return the group name if the craft matches the filter otherwise return ""
function SPF1.RightMenu:FilterSpell(spellID, groupIndex)
	if SPF1:Custom("RightMenu")["FilterSpell"] then
		return SPF1:Custom("RightMenu")["FilterSpell"](spellID, groupIndex);
	else
		if SPF1:GetMenu("Right") then
			local firstGroup = SPF1:GetGroupSpell("Right", spellID, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF1:GetGroupSpell("Right", spellID, groupIndex);
			
			if (firstGroup == requiredGroup) then
				return firstGroup;
			end
		else
			return 1;
		end
		
		return 0;
	end
end

SPF1.RightMenu:OnLoad();
