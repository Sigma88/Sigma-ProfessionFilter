local SPF2 = SigmaProfessionFilter[2];

function SPF2.DropDownMenu_Create(name, parent)
	if MSA_DropDownMenu_Create then
		return MSA_DropDownMenu_Create(name, parent);
	else
		return CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate");
	end
end

function SPF2.DropDownMenu_SetWidth(width, frame)
	if MSA_DropDownMenu_SetWidth then
		return MSA_DropDownMenu_SetWidth(width, frame);
	elseif not SPF2.WRATH then
		return UIDropDownMenu_SetWidth(width, frame);
	else
		return UIDropDownMenu_SetWidth(frame, width);
	end
end

function SPF2.DropDownMenu_SetSelectedID(frame, id, useValue)
	if MSA_DropDownMenu_SetSelectedID then
		return MSA_DropDownMenu_SetSelectedID(frame, id, useValue);
	else
		return UIDropDownMenu_SetSelectedID(frame, id, useValue);
	end
end

function SPF2.DropDownMenu_Initialize(frame, initFunction, displayMode, level)
	if MSA_DropDownMenu_Initialize then
		return MSA_DropDownMenu_Initialize(frame, initFunction, displayMode, level);
	else
		return UIDropDownMenu_Initialize(frame, initFunction, displayMode, level);
	end
end

function SPF2.DropDownMenu_AddButton(info, level)
	if MSA_DropDownMenu_AddButton then
		return MSA_DropDownMenu_AddButton(info, level);
	else
		return UIDropDownMenu_AddButton(info, level);
	end
end
