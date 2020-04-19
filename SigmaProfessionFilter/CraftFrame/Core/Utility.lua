function SPF:SavedData()
	if not Sigma_ProfessionFilter then
		Sigma_ProfessionFilter = {};
	end
	if not Sigma_ProfessionFilter[GetCraftName()] then
		Sigma_ProfessionFilter[GetCraftName()] = {};
	end
	return Sigma_ProfessionFilter[GetCraftName()];
end

function SPF:GetMenu(side)
	if SPF[GetCraftName()] then
		return SPF[GetCraftName()][side];
	end
end

function SPF:GetSelected(side)
	if SPF:GetMenu(side) and SPF[GetCraftName()]["Selected"] then
		return SPF[GetCraftName()]["Selected"][side] or 1;
	end
	return 1;
end

function SPF:SetSelected(side, id)
	if SPF:GetMenu(side) then
		if not SPF[GetCraftName()]["Selected"] then
			SPF[GetCraftName()]["Selected"] = {};
		end
		SPF[GetCraftName()]["Selected"][side] = id;
	end
end

function SPF:Custom(target)
	local Profession = SPF[GetCraftName()] or {};
	return Profession[target] or {};
end

function trim(str)
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function SPF:GetGroup(side, craftName, groupIndex)
	if (SPF:GetMenu(side)) then
		for i = 1, #SPF:GetMenu(side), 1 do
			if groupIndex > 1 then
				i = groupIndex - 1;
			end
			
			local button = SPF:GetMenu(side)[i];
			
			if string.find(button.filter, ";") then
				for f in string.gmatch(button.filter, "[^%;]+") do
					if string.find(craftName, f) then
						return button.name;
					end
				end
			else
				if (string.find(craftName, button.filter)) then
					return button.name;
				end
			end
			
			if groupIndex > 1 then
				return "";
			end
		end
	end
	return "";
end

function SPF:FilterWithSearchBox(craftIndex)
	
	if SPF.SearchBox ~= nil then
		local searchFilter = trim(SPF.SearchBox:GetText():lower());
		local craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = SPF.baseGetCraftInfo(craftIndex);
		
		-- Check the Name
		if (SPF:SavedData()["SearchNames"] ~= false) then
			if strmatch(craftName:lower(), searchFilter) ~= nil then
				return true;
			end
		end
		
		-- Check the SubName
		if (SPF:SavedData()["SearchSubNames"] ~= false) then
			if strmatch(craftSubSpellName:lower(), searchFilter) ~= nil then
				return true;
			end
		end
		
		-- Check the Headers
		if (SPF:SavedData()["SearchHeaders"] ~= false) then
			
			-- Check the LeftMenu
			if SPF:GetMenu("Left") then
				for	i,button in ipairs(SPF:GetMenu("Left")) do
					local groupName = SPF.LeftMenu:Filter(craftIndex, i + 1);
					if #groupName > 0 then
						if strmatch(button.name:lower(), searchFilter) ~= nil then
							return true;
						end
					end
				end
			end
			
			-- Check the RightMenu
			if SPF:GetMenu("Right") then
				for	i,button in ipairs(SPF:GetMenu("Right")) do
					local groupName = SPF.RightMenu:Filter(craftIndex, i + 1);
					if #groupName > 0 then
						if strmatch(button.name:lower(), searchFilter) ~= nil then
							return true;
						end
					end
				end
			end
		end
		
		-- Check the RightMenu Groups
		
		-- Check the Reagents
		if (SPF:SavedData()["SearchReagents"] ~= false) then
			for i = 1, SPF.baseGetCraftNumReagents(craftIndex), 1 do
				local reagentName, reagentTexture, reagentCount, playerReagentCount = SPF.baseGetCraftReagentInfo(craftIndex, i);
				
				if (reagentName and strmatch(reagentName:lower(), searchFilter)) then
					return true
				end
			end
		end
	end
	
	return false;
end

function SPF.ClearCraft()
	CraftName:Hide();
	CraftRequirements:Hide();
	CraftIcon:Hide();
	CraftReagentLabel:Hide();
	CraftDescription:Hide();
	for i=1, MAX_CRAFT_REAGENTS, 1 do
		getglobal("CraftReagent"..i):Hide();
	end
	CraftDetailScrollFrameScrollBar:Hide();
	CraftDetailScrollFrameTop:Hide();
	CraftDetailScrollFrameBottom:Hide();
	CraftHighlightFrame:Hide();
	CraftRequirements:Hide();
	CraftCreateButton:Disable();
	CraftCost:Hide();
end

function SPF.FullUpdate()
	local totalCount, headerCount, firstRecipe = SPF.GetNumCrafts();
	
	if firstRecipe then
		FauxScrollFrame_SetOffset(CraftListScrollFrame, 0);
		SPF.CraftFrame_SetSelection(firstRecipe);
	end
	CraftListScrollFrameScrollBar:SetValue(0);
	
	CraftFrame_Update();
	
	if not firstRecipe then
		SPF.ClearCraft();
	end
	
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		CraftFramePointsLabel:ClearAllPoints();
		CraftFramePointsLabel:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 355, -418);
    end
end
