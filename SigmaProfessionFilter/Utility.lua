
function trim(str)
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function SPF_GetGroup(groupName, craftName)
	local Profession = SPF[GetCraftName()];
	
	if (Profession) then
		for i,button in ipairs(Profession[groupName]) do
			if string.find(button.filter, ";") then
				for f in string.gmatch(button.filter, "[^%;]+") do
					if string.find(craftName, f) then
						return button.name, i;
					end
				end
			else
				if (string.find(craftName, button.filter)) then
					return button.name, i;
				end
			end
		end
	end
	return "";
end

function SPF_FilterWithSearchBox(craftIndex, craftName, leftGroupName, rightGroupName)

	if SPF_SearchBox ~= nil then
		local searchFilter = trim(SPF_SearchBox:GetText():lower());
		
		-- Check the Name
		if strmatch(craftName:lower(), searchFilter) ~= nil then
			return true;
		end
		
		-- Check the Header
		if (Sigma_ProfessionFilter_SearchHeaders ~= false) then
			if strmatch(leftGroupName:lower(), searchFilter) ~= nil then
				return true;
			end
			
			if strmatch(rightGroupName:lower(), searchFilter) ~= nil then
				return true;
			end
		end
		
		-- Check the Reagents
		if (Sigma_ProfessionFilter_SearchReagents ~= false) then
			for i = 1, SPF_baseGetCraftNumReagents(craftIndex), 1 do
				local reagentName, reagentTexture, reagentCount, playerReagentCount = SPF_baseGetCraftReagentInfo(craftIndex, i);
				
				if (reagentName and strmatch(reagentName:lower(), searchFilter)) then
					return true
				end
			end
		end
	end
	
	return false;
end

function SPF_FullUpdate()
	local totalCount, headerCount, firstRecipe = SPF_GetNumCrafts();
	if firstRecipe then
		CraftFrame_SetSelection(firstRecipe);
	end
	CraftFrame_Update();
end
