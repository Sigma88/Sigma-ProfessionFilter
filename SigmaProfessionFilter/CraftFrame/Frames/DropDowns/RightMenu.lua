SPF1.RightMenu = CreateFrame("Frame", nil, CraftFrame, "UIDropDownMenuTemplate");

function SPF1.RightMenu.OnLoad()
	SPF1.RightMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -25, -66);
	
	SPF1.RightMenu:SetScript("OnShow", SPF1.RightMenu.OnShow);
	hooksecurefunc("CraftFrame_OnShow", SPF1.RightMenu.OnShow);
	
	UIDropDownMenu_SetWidth(SPF1.RightMenu, 120);
	
	-- LeatrixPlus compatibility
	if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF1.RightMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -34, -40);
	end
end

function SPF1.RightMenu.OnShow()
    if ((not SPF1:GetMenu("Right")) or (SPF1:SavedData()["SearchBox"])) then
        SPF1.RightMenu:Hide();
	else		
		UIDropDownMenu_Initialize(SPF1.RightMenu, SPF1:Custom("RightMenu")["Initialize"] or SPF1.RightMenu.Initialize);
		UIDropDownMenu_SetSelectedID(SPF1.RightMenu, 1);
    end
end

function SPF1.RightMenu.Initialize()
    if (SPF1:GetMenu("Right")) then
        local info = {};
        info.text = SPF1[GetCraftName()]["RightTitle"];
        info.func = SPF1.RightMenu.OnClick;
        info.checked = false;
        
        UIDropDownMenu_AddButton(info);
        
        for i,button in ipairs(SPF1:GetMenu("Right")) do
            info = {};
            info.text = button.name;
            info.func = SPF1.RightMenu.OnClick;
            info.checked = false;
            UIDropDownMenu_AddButton(info);
        end
    end
end

function SPF1.RightMenu:OnClick(arg1, arg2, checked)
    
    UIDropDownMenu_SetSelectedID(SPF1.RightMenu, self:GetID());
    
	SPF1:SetSelected("Right", self:GetID());
    
    SPF1.FullUpdate();
end

-- Return the group name if the craft matches the filter otherwise return ""
function SPF1.RightMenu:Filter(craftIndex, groupIndex)
	if SPF1:Custom("RightMenu")["Filter"] then
		return SPF1:Custom("RightMenu")["Filter"](craftIndex, groupIndex);
	else
		local firstGroup = SPF1:GetGroup("Right", SPF1.baseGetCraftInfo(craftIndex), 1);
		local requiredGroup = SPF1:GetGroup("Right", SPF1.baseGetCraftInfo(craftIndex), groupIndex);
		
		if (firstGroup == requiredGroup) then
			return firstGroup;
		end
		
		return "";
	end
end

SPF1.RightMenu:OnLoad();
