local SPF1 = SigmaProfessionFilter[1];

SPF1.LeftMenu = CreateFrame("Frame", nil, CraftFrame, "UIDropDownMenuTemplate");

function SPF1.LeftMenu:OnLoad()
	SPF1.LeftMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -160, -66);

	SPF1.LeftMenu:SetScript("OnShow", SPF1.LeftMenu.OnShow);
	hooksecurefunc("CraftFrame_OnShow", SPF1.LeftMenu.OnShow);

	UIDropDownMenu_SetWidth(SPF1.LeftMenu, 120);
	--UIDropDownMenu_Initialize(SPF1.LeftMenu, SPF1:Custom("LeftMenu")["Initialize"] or SPF1.LeftMenu.Initialize);
	UIDropDownMenu_SetSelectedID(SPF1.LeftMenu, 1);
	SPF1:SetSelected("Left", 0);
	
	-- LeatrixPlus compatibility
	if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF1.LeftMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -204, -40);
	end
end

function SPF1.LeftMenu:OnShow()
    if ((not SPF1:GetMenu("Left")) or (SPF1:SavedData()["SearchBox"])) then
        SPF1.LeftMenu:Hide();
	else
		UIDropDownMenu_Initialize(SPF1.LeftMenu, SPF1:Custom("LeftMenu")["Initialize"] or SPF1.LeftMenu.Initialize);
		UIDropDownMenu_SetSelectedID(SPF1.LeftMenu, SPF1:GetSelected("Left") + 1);
    end
end

function SPF1.LeftMenu:Initialize()
    if (SPF1:GetMenu("Left")) then
        local info = {};
        info.text = SPF1:Custom("LeftMenu")["title"];
        info.func = SPF1.LeftMenu.OnClick;
        info.checked = false;
		
        UIDropDownMenu_AddButton(info);
		
        for i,button in ipairs(SPF1:GetMenu("Left")) do
            info = {};
            info.text = button.name;
            info.func = SPF1.LeftMenu.OnClick;
            info.checked = false;
            UIDropDownMenu_AddButton(info);
		end
    end
end

function SPF1.LeftMenu:OnClick(arg1, arg2, checked)
	
    UIDropDownMenu_SetSelectedID(SPF1.LeftMenu, self:GetID());
	
	SPF1:SetSelected("Left", self:GetID() - 1);
	
    SPF1.FullUpdate();
end

-- Return the group name if the craft matches the filter otherwise return ""
function SPF1.LeftMenu:Filter(craftIndex, groupIndex)
	if SPF1:Custom("LeftMenu")["Filter"] then
		return SPF1:Custom("LeftMenu")["Filter"](craftIndex, groupIndex);
	else
		if SPF1:GetMenu("Left") then
			--local craftName = SPF1.baseGetCraftInfo(craftIndex);
			local firstGroup = SPF1:GetGroup("Left", craftIndex, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF1:GetGroup("Left", craftIndex, groupIndex);
			
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
function SPF1.LeftMenu:FilterSpell(spellID, groupIndex)
	if SPF1:Custom("LeftMenu")["Filter"] then
		return SPF1:Custom("LeftMenu")["Filter"](craftIndex, groupIndex);
	else
		if SPF1:GetMenu("Left") then
			--local craftName = SPF1.baseGetCraftInfo(craftIndex);
			local firstGroup = SPF1:GetGroupSpell("Left", spellID, 0);
			
			if groupIndex == 0 then
				return firstGroup;
			end
			
			local requiredGroup = SPF1:GetGroupSpell("Left", spellID, groupIndex);
			
			if (firstGroup == requiredGroup) then
				return firstGroup;
			end
		else
			return 1;
		end
		
		return 0;
	end
end

SPF1.LeftMenu:OnLoad();
