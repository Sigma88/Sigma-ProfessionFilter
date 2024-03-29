local SPF1 = SigmaProfessionFilter[1];

function SPF1:SavedData()
	if not SigmaProfessionFilter_SavedVariables then
		SigmaProfessionFilter_SavedVariables = {};
	end
	if not SigmaProfessionFilter_SavedVariables[GetCraftName()] then
		SigmaProfessionFilter_SavedVariables[GetCraftName()] = {};
	end
	return SigmaProfessionFilter_SavedVariables[GetCraftName()];
end

function SPF1:GetMenu(side)
	if SigmaProfessionFilter[GetCraftName()] then
		return SigmaProfessionFilter[GetCraftName()][side];
	end
end

function SPF1:GetSelected(side)
	if SPF1:GetMenu(side) and SigmaProfessionFilter[GetCraftName()]["Selected"] then
		return SigmaProfessionFilter[GetCraftName()]["Selected"][side] or 0;
	end
	return 0;
end

function SPF1:SetSelected(side, id)
	if SPF1:GetMenu(side) then
		if not SigmaProfessionFilter[GetCraftName()]["Selected"] then
			SigmaProfessionFilter[GetCraftName()]["Selected"] = {};
		end
		SigmaProfessionFilter[GetCraftName()]["Selected"][side] = id;
	end
end

function SPF1:Custom(target)
	local Profession = SigmaProfessionFilter[GetCraftName()] or {};
	return Profession[target] or {};
end

function SPF1.trim(str)
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function SPF1.match(str, filter)
	if str and filter then
		if #filter == 0 then
			return true;
		end
		for f in string.gmatch(filter:lower(), "[^%;]+") do
			if string.find(str:lower(), f) then
				return true;
			end
		end
	end
end

function SPF1:GetGroup(side, craftIndex, groupIndex)
	if (SPF1:GetMenu(side)) then
		local targetValue = SPF1.baseGetCraftInfo(craftIndex);
		for i = 1, #SPF1:GetMenu(side), 1 do
			if groupIndex > 0 then
				i = groupIndex;
			end
			
			local button = SPF1:GetMenu(side)[i];
			
			if SPF1.match(targetValue, button.filter) then
				return i;
			end
			
			if groupIndex > 0 then
				return nil;
			end
		end
	else
		return 0;
	end
end

function SPF1:GetGroupSpell(side, spellID, groupIndex)
	if (SPF1:GetMenu(side)) then
		local targetValue = GetSpellInfo(spellID);
		for i = 1, #SPF1:GetMenu(side), 1 do
			if groupIndex > 0 then
				i = groupIndex;
			end
			
			local button = SPF1:GetMenu(side)[i];
			
			if SPF1.match(targetValue, button.filter) then
				return i;
			end
			
			if groupIndex > 0 then
				return nil;
			end
		end
	else
		return 0;
	end
end

function SPF1:FilterWithSearchBox(craftIndex)
	
	if SPF1.SearchBox ~= nil then
		local searchFilter = SPF1.trim(SPF1.SearchBox:GetText():lower());
		local craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = SPF1.baseGetCraftInfo(craftIndex);
		
		-- Check the Name
		if (SPF1:SavedData()["SearchNames"] ~= false) then
			if strmatch(craftName:lower(), searchFilter) ~= nil then
				return true;
			end
		end
		
		-- Check the SubName
		if craftSubSpellName then
			if (SPF1:SavedData()["SearchSubNames"] ~= false) then
				if strmatch(craftSubSpellName:lower(), searchFilter) ~= nil then
					return true;
				end
			end
		end
		
		-- Check the Headers
		if (SPF1:SavedData()["SearchHeaders"] ~= false) then
			
			-- Check the LeftMenu
			if SPF1:GetMenu("Left") then
				for	i,button in ipairs(SPF1:GetMenu("Left")) do
					if strmatch(button.name:lower(), searchFilter) ~= nil then
						local groupIndex = SPF1.LeftMenu:Filter(craftIndex, i) or 0;
						if groupIndex > 0 then
							return true;
						end
					end
				end
			end
			
			-- Check the RightMenu
			if SPF1:GetMenu("Right") then
				for	i,button in ipairs(SPF1:GetMenu("Right")) do
					if strmatch(button.name:lower(), searchFilter) ~= nil then
						local groupIndex = SPF1.RightMenu:Filter(craftIndex, i) or 0;
						if groupIndex > 0 then
							return true;
						end
					end
				end
			end
		end
		
		-- Check the Reagents
		if (SPF1:SavedData()["SearchReagents"] ~= false) then
			for i = 1, SPF1.baseGetCraftNumReagents(craftIndex), 1 do
				local reagentName, reagentTexture, reagentCount, playerReagentCount = SPF1.baseGetCraftReagentInfo(craftIndex, i);
				
				if (reagentName and strmatch(reagentName:lower(), searchFilter)) then
					return true
				end
			end
		end
	end
	
	return false;
end

function SPF1:FilterSpellWithSearchBox(spellID)
	
	if SPF1.SearchBox ~= nil then
		local searchFilter = SPF1.trim(SPF1.SearchBox:GetText():lower());
		local spellName = GetSpellInfo(spellID);
		
		-- Check the Name
		if (SPF1:SavedData()["SearchNames"] ~= false) then
			if spellName and strmatch(spellName:lower(), searchFilter) ~= nil then
				return true;
			end
		end
		
		-- Check the Headers
		if (SPF1:SavedData()["SearchHeaders"] ~= false) then
			
			-- Check the LeftMenu
			if SPF1:GetMenu("Left") then
				for	i,button in ipairs(SPF1:GetMenu("Left")) do
					if strmatch(button.name:lower(), searchFilter) ~= nil then
						local groupIndex = SPF1.LeftMenu:FilterSpell(spellID, i) or 0;
						if groupIndex > 0 then
							return true;
						end
					end
				end
			end
			
			-- Check the RightMenu
			if SPF1:GetMenu("Right") then
				for	i,button in ipairs(SPF1:GetMenu("Right")) do
					if strmatch(button.name:lower(), searchFilter) ~= nil then
						local groupIndex = SPF1.RightMenu:FilterSpell(spellID, i) or 0;
						if groupIndex > 0 then
							return true;
						end
					end
				end
			end
		end
		
		-- Check the Reagents
		if (SPF1:SavedData()["SearchReagents"] ~= false) then
			
			local reagents = SPF1.GetRecipeInfo(spellID, "reagents") or {};
			
			for i,reagentInfo in ipairs(reagents) do
				local itemID = reagentInfo["itemID"];
				if itemID then
					local itemName = GetItemInfo(itemID);
					
					if (itemName and strmatch(itemName:lower(), searchFilter)) then
						return true
					end
				end
			end
		end
	end
	
	return false;
end

function SPF1.ClearCraft()
	CraftName:Hide();
	CraftRequirements:Hide();
	CraftIcon:Hide();
	CraftReagentLabel:Hide();
	CraftDescription:Hide();
	for i=1, MAX_CRAFT_REAGENTS, 1 do
		_G["CraftReagent"..i]:Hide();
	end
	CraftDetailScrollFrameScrollBar:Hide();
	CraftDetailScrollFrameTop:Hide();
	CraftDetailScrollFrameBottom:Hide();
	CraftHighlightFrame:Hide();
	CraftRequirements:Hide();
	CraftCreateButton:Disable();
	CraftCost:Hide();
end

CraftFrameFilterDropDown:SetScript("OnShow", function(self) self:Hide() end);
CraftFrameAvailableFilterCheckButton:SetScript("OnShow", function(self) self:Hide() end);

function SPF1.ClearNewFeatures()
	CraftFrameFilterDropDown:Hide();
	CraftFrameAvailableFilterCheckButton:SetChecked(false);
	CraftFrameAvailableFilterCheckButton:Hide();
	CraftOnlyShowMakeable(false);
end

function SPF1.FullUpdate(keepCollapsed)
	if not keepCollapsed then
		SPF1.Collapsed = nil;
	end
	
	SPF1.FILTERED = nil;
	SPF1.GetNumCrafts();
	
	if SPF1.FIRST then
		FauxScrollFrame_SetOffset(CraftListScrollFrame, 0);
		SPF1.CraftFrame_SetSelection(SPF1.FIRST);
	end
	CraftFrame_Update();
	
	if not SPF1.FIRST then
		SPF1.ClearCraft();
	end
	
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		CraftFramePointsLabel:ClearAllPoints();
		CraftFramePointsLabel:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 355, -418);
    end
end

function SPF1.GetRecipeInfo(spellID, infoType)
	
	if not(spellID) and infoType then
		return;
	end
	
	local RI = SigmaProfessionFilter_RecipeInfo;
	
	if RI and RI.Data then
		local professionName = GetCraftName();
		if professionName then
			local Recipes = RI.Data[professionName];
			if Recipes then
				if spellID then
					if  Recipes[spellID] then
						if infoType then
							return Recipes[spellID][infoType];
						else
							return Recipes[spellID];
						end
					end
				else
					return Recipes;
				end
			end
		end
	end
end
