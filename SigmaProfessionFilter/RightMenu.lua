function SPF_RightMenu_OnClick(this, arg1, arg2, checked)
    
    UIDropDownMenu_SetSelectedID(SPF_RightMenu, this:GetID());
    
    local Profession = SPF[GetCraftName()];
    if (Profession and Profession["Right"]) then
        Profession["Selected"]["Right"] = this:GetID();
    end
    
    SPF_FullUpdate();
end

function SPF_RightMenu_Initialize()
    
    -- Check if the profession is supported
    local Profession = SPF[GetCraftName()];
    
    if (Profession and Profession["Right"]) then
        local info = {};
        info.text = Profession["RightTitle"];
        info.func = SPF_RightMenu_OnClick;
        info.checked = true;
        
        UIDropDownMenu_AddButton(info);
        
        for i,button in ipairs(Profession["Right"]) do
            info = {};
            info.text = button.name;
            info.func = SPF_RightMenu_OnClick;
            info.checked = false;
            UIDropDownMenu_AddButton(info);
        end
    end
end

function SPF_RightMenu_OnShow()
    local Profession = SPF[GetCraftName()];
    if (not Profession or not Profession["Right"] or (Sigma_ProfessionFilter_SearchBox == true)) then
        SPF_RightMenu:Hide();
    end
end

function SPF_RightMenu_OnLoad()
    UIDropDownMenu_SetWidth(SPF_RightMenu, 120);
    UIDropDownMenu_Initialize(SPF_RightMenu, SPF_RightMenu_Initialize);
    UIDropDownMenu_SetSelectedID(SPF_RightMenu, 1);
    
    -- LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
        SPF_RightMenu:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -34, -40);
    end
end
