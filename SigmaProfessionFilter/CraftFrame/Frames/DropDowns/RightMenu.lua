SPF.RightMenu = CreateFrame("Frame", nil, CraftFrame, "UIDropDownMenuTemplate");

function SPF.RightMenu.OnLoad()
	if not SPF.RightMenu.loaded then
		
		SPF.RightMenu.loaded = true;
		
		SPF.RightMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -25, -66);
		
		SPF.RightMenu:SetScript("OnShow", SPF.RightMenu.OnShow);
		
		UIDropDownMenu_SetWidth(SPF.RightMenu, 120);
		UIDropDownMenu_Initialize(SPF.RightMenu, SPF:Custom("RightMenu")["Initialize"] or SPF.RightMenu.Initialize);
		UIDropDownMenu_SetSelectedID(SPF.RightMenu, 1);
		
		-- LeatrixPlus compatibility
		if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
			SPF.RightMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -34, -40);
		end
	end
end

function SPF.RightMenu.OnShow()
    if ((not SPF:GetMenu("Right")) or (SPF:SavedData()["SearchBox"])) then
        SPF.RightMenu:Hide();
    end
end

function SPF.RightMenu.Initialize()
    if (SPF:GetMenu("Right")) then
        local info = {};
        info.text = SPF[GetCraftName()]["RightTitle"];
        info.func = SPF.RightMenu.OnClick;
        info.checked = false;
        
        UIDropDownMenu_AddButton(info);
        
        for i,button in ipairs(SPF:GetMenu("Right")) do
            info = {};
            info.text = button.name;
            info.func = SPF.RightMenu.OnClick;
            info.checked = false;
            UIDropDownMenu_AddButton(info);
        end
    end
end

function SPF.RightMenu:OnClick(arg1, arg2, checked)
    
    UIDropDownMenu_SetSelectedID(SPF.RightMenu, self:GetID());
    
	SPF:SetSelected("Right", self:GetID());
    
    SPF.FullUpdate();
end

-- Return the group name if the craft matches the filter otherwise return ""
function SPF.RightMenu:Filter(craftIndex, groupIndex)
	if SPF:Custom("RightMenu")["Filter"] then
		return SPF:Custom("RightMenu")["Filter"](craftIndex, groupIndex);
	else
		local firstGroup = SPF:GetGroup("Right", SPF.baseGetCraftInfo(craftIndex), 1);
		local requiredGroup = SPF:GetGroup("Right", SPF.baseGetCraftInfo(craftIndex), groupIndex);
		
		if (firstGroup == requiredGroup) then
			return firstGroup;
		end
		
		return "";
	end
end

hooksecurefunc("CraftFrame_LoadUI", SPF.RightMenu.OnLoad);
