function SPF_LeftMenu_OnClick(this, arg1, arg2, checked)
	
	UIDropDownMenu_SetSelectedID(SPF_LeftMenu, this:GetID());
	
	local Profession = SPF[GetCraftDisplaySkillLine()];
	if (Profession) then
		Profession["Selected"]["Left"] = this:GetID();
	end
	
	SPF_FullUpdate();
end

function SPF_LeftMenu_Initialize()
	
	-- Check if the profession is supported
	local Profession = SPF[GetCraftDisplaySkillLine()];
	
	if (Profession) then
		local info = {};
		info.text = Profession["LeftTitle"];
		info.func = SPF_LeftMenu_OnClick;
		info.checked = true;
		
		UIDropDownMenu_AddButton(info);
		
		for i,button in ipairs(Profession["Left"]) do
			info = {};
			info.text = button.name;
			info.func = SPF_LeftMenu_OnClick;
			info.checked = false;
			UIDropDownMenu_AddButton(info);
		end
	end
end

function SPF_LeftMenu_OnShow()
	local Profession = SPF[GetCraftDisplaySkillLine()];
	if (Profession and (not Sigma_ProfessionFilter_SearchBox)) then
		UIDropDownMenu_Initialize(SPF_LeftMenu, SPF_LeftMenu_Initialize);
		UIDropDownMenu_SetSelectedID(SPF_LeftMenu, 1);
		Profession["Selected"]["Left"] = 1;
	else
		SPF_LeftMenu:Hide();
	end
end

function SPF_LeftMenu_OnLoad()
	UIDropDownMenu_SetWidth(SPF_LeftMenu, 120);
	UIDropDownMenu_Initialize(SPF_LeftMenu, SPF_LeftMenu_Initialize);
	UIDropDownMenu_SetSelectedID(SPF_LeftMenu, 1);
	
	-- LeatrixPlus compatibility
	if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF_LeftMenu:SetPoint("RIGHT", SPF_RightMenu, "LEFT", 0, 0);
	end
end
