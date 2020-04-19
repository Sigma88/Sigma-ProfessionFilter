SPF.LeftMenu = CreateFrame("Frame", nil, CraftFrame, "UIDropDownMenuTemplate");

function SPF.LeftMenu:OnLoad()
	if not SPF.LeftMenu.loaded then
		
		SPF.LeftMenu.loaded = true;
		
		SPF.LeftMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -160, -66);
		
		SPF.LeftMenu:SetScript("OnShow", SPF.LeftMenu.OnShow);
		
		UIDropDownMenu_SetWidth(SPF.LeftMenu, 120);
		UIDropDownMenu_Initialize(SPF.LeftMenu, SPF:Custom("LeftMenu")["Initialize"] or SPF.LeftMenu.Initialize);
		UIDropDownMenu_SetSelectedID(SPF.LeftMenu, 1);
		
		-- LeatrixPlus compatibility
		if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
			SPF.LeftMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -204, -40);
		end
	end
end

function SPF.LeftMenu:OnShow()
    if ((not SPF:GetMenu("Left")) or (SPF:SavedData()["SearchBox"])) then
        SPF.LeftMenu:Hide();
    end
end

function SPF.LeftMenu:Initialize()
    if (SPF:GetMenu("Left")) then
        local info = {};
        info.text = SPF[GetCraftName()]["LeftTitle"];
        info.func = SPF.LeftMenu.OnClick;
        info.checked = true;
        
        UIDropDownMenu_AddButton(info);
        
        for i,button in ipairs(SPF:GetMenu("Left")) do
            info = {};
            info.text = button.name;
            info.func = SPF.LeftMenu.OnClick;
            info.checked = false;
            UIDropDownMenu_AddButton(info);
		end
    end
end

function SPF.LeftMenu:OnClick(arg1, arg2, checked)
    
    UIDropDownMenu_SetSelectedID(SPF.LeftMenu, self:GetID());
    
	SPF:SetSelected("Left", self:GetID());
    
    SPF.FullUpdate();
end

-- Return the group name if the craft matches the filter otherwise return ""
function SPF.LeftMenu:Filter(craftIndex, groupIndex)
	if SPF:Custom("LeftMenu")["Filter"] then
		return SPF:Custom("LeftMenu")["Filter"](craftIndex, groupIndex);
	else
		local firstGroup = SPF:GetGroup("Left", SPF.baseGetCraftInfo(craftIndex), 1);
		local requiredGroup = SPF:GetGroup("Left", SPF.baseGetCraftInfo(craftIndex), groupIndex);
		
		if (firstGroup == requiredGroup) then
			return firstGroup;
		end
		
		return "";
	end
end

hooksecurefunc("CraftFrame_LoadUI", SPF.LeftMenu.OnLoad);
