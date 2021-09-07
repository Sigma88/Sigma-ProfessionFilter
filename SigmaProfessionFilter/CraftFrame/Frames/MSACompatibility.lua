local SPF1 = SigmaProfessionFilter[1];

function SPF1.DropDownMenu_Create(name, parent)
	if MSA_DropDownMenu_Create then
		return MSA_DropDownMenu_Create(name, parent);
	else
		return CreateFrame("Frame", nil, parent, "UIDropDownMenuTemplate");
	end
end

function SPF1.DropDownMenu_SetWidth(...)
	if MSA_DropDownMenu_SetWidth then
		return MSA_DropDownMenu_SetWidth(...);
	else
		return UIDropDownMenu_SetWidth(...);
	end
end

function SPF1.DropDownMenu_SetSelectedID(...)
	if MSA_DropDownMenu_SetSelectedID then
		return MSA_DropDownMenu_SetSelectedID(...);
	else
		return UIDropDownMenu_SetSelectedID(...);
	end
end

function SPF1.DropDownMenu_Initialize(...)
	if MSA_DropDownMenu_Initialize then
		return MSA_DropDownMenu_Initialize(...);
	else
		return UIDropDownMenu_Initialize(...);
	end
end

function SPF1.DropDownMenu_AddButton(...)
	if MSA_DropDownMenu_AddButton then
		return MSA_DropDownMenu_AddButton(...);
	else
		return UIDropDownMenu_AddButton(...);
	end
end
