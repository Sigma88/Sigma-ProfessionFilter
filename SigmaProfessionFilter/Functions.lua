--Set up data table
function SPF_GetNumCrafts()
	-- Check if the profession is supported
	local Profession = SPF[GetCraftName()];
	if (not Profession) then return SPF_baseGetNumCrafts() end
	
	if Sigma_ProfessionFilter_GroupBy == nil then
		Sigma_ProfessionFilter_GroupBy = {};
	end
	
	-- Check the Chosen Grouping Scheme
	local groupBy = Sigma_ProfessionFilter_GroupBy[GetCraftName()] or "Right";
	local Ordered = {["Left"] = {}, ["Right"] = {}}
	
    -- Find which items pass all filters
    for i=1, SPF_baseGetNumCrafts() do
		-- IMPLEMENT CHECKS LATER
        local craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = SPF_baseGetCraftInfo(i);
		local leftGroupName, leftGroupID = SPF_GetGroup("Left", craftName);
		local rightGroupName, rightGroupID = SPF_GetGroup("Right", craftName);

		-- CHECKBOX1
        if (craftType == "trivial" and Sigma_ProfessionFilter_HasSkillUp)
		-- CHECKBOX2
			or ((not (numAvailable > 0)) and Sigma_ProfessionFilter_HaveMats)
		-- SEARCHBOX
			or (not SPF_FilterWithSearchBox(i, craftName, leftGroupName, rightGroupName))
		-- LEFT DROPDOWN
			or ((Profession["Selected"]["Left"] > 1) and Profession["Selected"]["Left"] - 1 ~= leftGroupID)
		-- RIGHT DROPDOWN
			or ((Profession["Selected"]["Right"] > 1) and Profession["Selected"]["Right"] - 1 ~= rightGroupID)
		then
			-- ELEMENTS THAT FAIL TO MATCH ALL FILTERS
		else
			-- ELEMENTS THAT MATCH ALL FILTERS
			if (groupBy == "Left") then
				if (Ordered["Left"][leftGroupName] == nil) then
					Ordered["Left"][leftGroupName] = {}
				end
				table.insert(Ordered["Left"][leftGroupName], i)
			else
				if (Ordered["Right"][rightGroupName] == nil) then
					Ordered["Right"][rightGroupName] = {}
				end
				table.insert(Ordered["Right"][rightGroupName], i)
			end
		end
    end
	
	-- Build the new ordered table
	
	SPF.Data = {};
	SPF.Headers = {};
	
	local totalCount = 0;
    local headerCount = 0;
	local firstRecipe = nil;
	
	if Ordered[groupBy] ~= nil then
		--for group,items in pairs(Ordered[groupBy]) do
		for i,button in ipairs(Profession[groupBy]) do
			local group = button.name;
			local items = Ordered[groupBy][group];
			if (items) then
				-- Add the Header
				headerCount = headerCount + 1;
				totalCount = totalCount + 1;
				
				SPF.Headers[headerCount] = totalCount;
				
				SPF.Data[totalCount] = {
					["craftName"] = group;
					["craftSubSpellName"] = "";
					["craftType"] = "header";
					["numAvailable"] = 0;
					["trainingPointCost"] = 0;
					["requiredLevel"] = 0;
					["original"] = 0;
				};
				
				if (SPF.Collapsed and SPF.Collapsed[group]) then
					SPF.Data[totalCount]["isExpanded"] = false;
				else
					SPF.Data[totalCount]["isExpanded"] = true;
					
					for i,craftIndex in ipairs(items) do
						totalCount = totalCount + 1;
						
						if (not firstRecipe) then 
							firstRecipe = totalCount;
						end
						
						SPF.Data[totalCount] = {
							["original"] = craftIndex;
						};
					end
				end
			end
		end
	end
	
    SPF.Data.n = totalCount;
    SPF.Headers.n = headerCount;
	
    return totalCount, headerCount, firstRecipe;
end

-- Get Craft Info
function SPF_GetCraftInfo(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		if (SPF.Data[id]["original"] == 0) then
			return SPF.Data[id]["craftName"], SPF.Data[id]["craftSubSpellName"], SPF.Data[id]["craftType"], SPF.Data[id]["numAvailable"], SPF.Data[id]["isExpanded"], SPF.Data[id]["trainingPointCost"], SPF.Data[id]["requiredLevel"];
		else
			return SPF_baseGetCraftInfo(SPF.Data[id]["original"]);
		end
	end
	
	-- Otherwise fall back to the original
	return SPF_baseGetCraftInfo(id);
end

-- Expand
function SPF_ExpandCraftSkillLine(id)
	
	-- Check if the profession is supported
	local Profession = SPF[GetCraftName()];
	if (not Profession) then return SPF_baseExpandCraftSkillLine(id) end
	
	-- if the id is zero we need to expand all headers
	if (id == 0) then
		for i,headerID in ipairs(SPF.Headers) do
			SPF_ExpandCraftSkillLine(headerID)
		end
		
	-- otherwise expand this header
	elseif (SPF.Data and SPF.Data[id]) then
		-- if this is a header
		local craftType = SPF.Data[id]["craftType"];
		local craftName = SPF.Data[id]["craftName"];
		
		if (craftType == "header") then
			-- Remove if fom the list of collapsed headers
			SPF.Collapsed[craftName] = nil;
		end
	end
	
    CraftFrame_Update();
end

-- Collapse
function SPF_CollapseCraftSkillLine(id)
	
	-- Check if the profession is supported
	local Profession = SPF[GetCraftName()];
	if (not Profession) then return SPF_baseCollapseCraftSkillLine(id) end
	
	-- if the id is zero we need to collapse all headers
	if (id == 0) then
		for i,headerID in ipairs(SPF.Headers) do
			SPF_CollapseCraftSkillLine(headerID)
		end
		
	-- otherwise collapse this header
	elseif (SPF.Data and SPF.Data[id]) then
		-- if this is a header
		local craftType = SPF.Data[id]["craftType"];
		local craftName = SPF.Data[id]["craftName"];
		
		if (craftType == "header") then
			-- Set Collapsed To False
			
			if (SPF.Collapsed == nil) then
				SPF.Collapsed = {};
			end
			
			SPF.Collapsed[craftName] = true;
		end
	end
	
    SPF_FullUpdate();
end

-- Select Craft
function SPF_SelectCraft(id)

	if SPF[GetCraftName()] and SPF.Data and SPF.Data[id] and SPF_CRAFTING then
		SPF_baseSelectCraft(SPF.Data[id]["original"]);
	else
		SPF_baseSelectCraft(id);
	end
end

function SPF_CraftCreateButton_OnMouseDown(self, mouseBtn)
	if CraftCreateButton:IsEnabled() and mouseBtn == "LeftButton" then
		SPF_CRAFTING = true;
		SPF_SelectCraft(GetCraftSelectionIndex());
	end
end

function SPF_CraftCreateButton_OnMouseUp()
	if SPF_CRAFTING then
		if not CraftCreateButton:IsMouseOver() then
			SPF_CRAFTING = nil;
			SPF_SelectCraft(GetCraftSelectionIndex());
		end
	end
end

function SPF_CraftCreateButton_OnClick()
	if SPF_CRAFTING then
		SPF_CRAFTING = nil;
		SPF_SelectCraft(GetCraftSelectionIndex());
	end
end

function SPF_SetCraftItem(obj, id, reagId)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF_baseSetCraftItem(obj, SPF.Data[id]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF_baseSetCraftItem(obj, id, reagId);
end

function SPF_SetCraftSpell(obj, id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF_baseSetCraftSpell(obj, SPF.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF_baseSetCraftSpell(obj, id);
end

function SPF_GetCraftItemLink(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF_baseGetCraftItemLink(SPF.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF_baseGetCraftItemLink(id);
end

function SPF_GetCraftReagentItemLink(id, reagId)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF_baseGetCraftReagentItemLink(SPF.Data[id]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF_baseGetCraftReagentItemLink(id, reagId);
end

function SPF_GetCraftIcon(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF_baseGetCraftIcon(SPF.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF_baseGetCraftIcon(id);
end

function SPF_GetCraftDescription(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF_baseGetCraftDescription(SPF.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF_baseGetCraftDescription(id);
end

function SPF_GetCraftNumReagents(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF_baseGetCraftNumReagents(SPF.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF_baseGetCraftNumReagents(id);
end

function SPF_GetCraftReagentInfo(id, reagId)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF_baseGetCraftReagentInfo(SPF.Data[id]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF_baseGetCraftReagentInfo(id, reagId);
end

function SPF_GetCraftSpellFocus(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF_baseGetCraftSpellFocus(SPF.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF_baseGetCraftSpellFocus(id);
end
