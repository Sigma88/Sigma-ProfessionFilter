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
		MSA_DropDownMenu_SetWidth(...);
	else
		UIDropDownMenu_SetWidth(...);
	end
end

function SPF1.DropDownMenu_SetSelectedID(...)
	if MSA_DropDownMenu_SetSelectedID then
		MSA_DropDownMenu_SetSelectedID(...);
	else
		UIDropDownMenu_SetSelectedID(...);
	end
end

function SPF1.DropDownMenu_Initialize(...)
	if MSA_DropDownMenu_Initialize then
		MSA_DropDownMenu_Initialize(...);
	else
		UIDropDownMenu_Initialize(...);
	end
end

function SPF1.DropDownMenu_AddButton(...)
	if MSA_DropDownMenu_AddButton then
		MSA_DropDownMenu_AddButton(...);
	else
		UIDropDownMenu_AddButton(...);
	end
end
