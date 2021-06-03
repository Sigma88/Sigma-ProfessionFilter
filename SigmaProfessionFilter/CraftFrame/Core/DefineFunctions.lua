local SPF1 = SigmaProfessionFilter[1];

--Set up data table
function SPF1.GetNumCrafts()
	
	if not CraftFrame:IsVisible() then
		return SPF1.baseGetNumCrafts();
	end
	
	if not SPF1:GetMenu("Right") then
		SPF1:SavedData()["GroupBy"] = nil;
		SPF1.LeftSort:OnShow();
	end
	
	-- Check the Chosen Grouping Scheme
	local groupBy = SPF1:SavedData()["GroupBy"] or "Left";
	local Ordered = {["Left"] = {}, ["Right"] = {}}
	
    -- Find which items pass all filters
    for i=1, SPF1.baseGetNumCrafts() do
		-- IMPLEMENT CHECKS LATER
		local leftGroupName = SPF1.LeftMenu:Filter(i, SPF1:GetSelected("Left"));
		local rightGroupName = SPF1.RightMenu:Filter(i, SPF1:GetSelected("Right"));

		-- FILTER_1
        if (not SPF1.Filter1:Filter(i))
		-- FILTER_2
			or (not SPF1.Filter2:Filter(i))
		-- SEARCH_BOX
			or not(SPF1.SearchBox:Filter(i))
		-- LEFT_DROPDOWN
			or not (SPF1:GetSelected("Left") == 1 or #leftGroupName > 0)
		-- RIGHT_DROPDOWN
			or not (SPF1:GetSelected("Right") == 1 or #rightGroupName > 0)
		then
			-- ELEMENTS THAT FAIL TO MATCH ALL FILTERS
		else
			-- ELEMENTS THAT MATCH ALL FILTERS
			if (groupBy == "Left") then
				if (Ordered["Left"][leftGroupName] == nil) then
					Ordered["Left"][leftGroupName] = {};
				end
				table.insert(Ordered["Left"][leftGroupName], i);
			else
				if (Ordered["Right"][rightGroupName] == nil) then
					Ordered["Right"][rightGroupName] = {};
				end
				table.insert(Ordered["Right"][rightGroupName], i);
			end
		end
		
		-- Fix for BeastTraining headers not forgetting their old cost
		if _G["Craft"..i.."Cost"] then
			_G["Craft"..i.."Cost"]:SetText("");
		end
    end
	
	-- Build the new ordered table
	
	SPF1.FIRST = nil;
	SPF1.Data = {};
	SPF1.Headers = {};
	
	local totalCount = 0;
    local headerCount = 0;
	local firstRecipe = nil;
	
	if Ordered[groupBy] ~= nil then
		local Pairs = SPF1:GetMenu(groupBy);
		
		if (groupBy == "Left" and not SPF1:GetMenu("Left")) then
			Pairs = { [1] = { name = ""; } };
		end
		
		for i,button in ipairs(Pairs) do
			local group = button.name;
			
			local items = Ordered[groupBy][group];
			
			if (items) then
				
				-- Add the Header
				if (#group > 0) then
					headerCount = headerCount + 1;
					totalCount = totalCount + 1;
					SPF1.Headers[headerCount] = totalCount;
				
					SPF1.Data[totalCount] = {
						["craftName"] = group;
						["craftSubSpellName"] = "";
						["craftType"] = "header";
						["numAvailable"] = 0;
						["trainingPointCost"] = nil;
						["requiredLevel"] = 0;
						["original"] = 0;
					};
				end
				
				if (SPF1.Collapsed and SPF1.Collapsed[group]) then
					SPF1.Data[totalCount]["isExpanded"] = false;
				else
					if (#group > 0) then
						SPF1.Data[totalCount]["isExpanded"] = true;
					end
					
					for j,craftIndex in ipairs(items) do
						totalCount = totalCount + 1;
						
						if (not firstRecipe) then 
							firstRecipe = totalCount;
							SPF1.FIRST = totalCount;
						end
						
						SPF1.Data[totalCount] = {
							["original"] = craftIndex;
						};
					end
				end
			end
		end
	end
	
    SPF1.Data.n = totalCount;
    SPF1.Headers.n = headerCount;
	
	-- Leatrix Plus Compatibility
	if LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On" then
		if SPF1.FIRST and #SPF1.Headers == 0 then
			CRAFTS_DISPLAYED = 23;
		else 
			CRAFTS_DISPLAYED = 22;
		end
	end
	
    return totalCount, headerCount, firstRecipe;
end

-- Get Craft Info
function SPF1.GetCraftInfo(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if (SPF1.Data[id]["original"] == 0) then
			return SPF1.Data[id]["craftName"], SPF1.Data[id]["craftSubSpellName"], SPF1.Data[id]["craftType"], SPF1.Data[id]["numAvailable"], SPF1.Data[id]["isExpanded"], SPF1.Data[id]["trainingPointCost"], SPF1.Data[id]["requiredLevel"];
		else
			return SPF1.baseGetCraftInfo(SPF1.Data[id]["original"]);
		end
	end
	
	-- Otherwise fall back to the original
	return SPF1.baseGetCraftInfo(id);
end

-- Expand
function SPF1.ExpandCraftSkillLine(id)
	
	-- Check if the profession is supported
	if (not SigmaProfessionFilter[GetCraftName()]) then
		return SPF1.baseExpandCraftSkillLine(id);
	end
	
	-- if the id is zero we need to expand all headers
	if (id == 0) then
		-- Expand in reverse order otherwise it's a mess
		for i=#SPF1.Headers, 1, -1 do
			SPF1.ExpandCraftSkillLine(SPF1.Headers[i]);
		end
		
	-- otherwise expand this header
	elseif (SPF1.Data and SPF1.Data[id]) then
		-- if this is a header
		local craftType = SPF1.Data[id]["craftType"];
		local craftName = SPF1.Data[id]["craftName"];
		
		if (craftType == "header") then
			-- Remove if fom the list of collapsed headers
			SPF1.Collapsed[craftName] = nil;
		end
	end
	
    SPF1.FullUpdate();
	SPF1.ONCLICK = id;
end

-- Collapse
function SPF1.CollapseCraftSkillLine(id)
	
	-- Check if the profession is supported
	if (not SigmaProfessionFilter[GetCraftName()]) then
		return SPF1.baseCollapseCraftSkillLine(id);
	end
	
	-- if the id is zero we need to collapse all headers
	if (id == 0) then
		-- Collapse in reverse order otherwise it's a mess
		for i=#SPF1.Headers, 1, -1 do
			SPF1.CollapseCraftSkillLine(SPF1.Headers[i]);
		end
		
	-- otherwise collapse this header
	elseif (SPF1.Data and SPF1.Data[id]) then
		-- if this is a header
		local craftType = SPF1.Data[id]["craftType"];
		local craftName = SPF1.Data[id]["craftName"];
		
		if (craftType == "header") then
			-- Set Collapsed To False
			
			if (SPF1.Collapsed == nil) then
				SPF1.Collapsed = {};
			end
			
			SPF1.Collapsed[craftName] = true;
		end
	end
	
    SPF1.FullUpdate();
	SPF1.ONCLICK = id;
end

-- Select Craft
function SPF1.CraftFrame_SetSelection(craftIndex)
	SPF1.SELECTED = craftIndex;
	SPF1.baseCraftFrame_SetSelection(craftIndex);
end

function SPF1.GetCraftSelectionIndex()
	return SPF1.SELECTED;
end

function SPF1.SelectCraft(id)
	if SPF1.Data and SPF1.Data[id] and SPF1.CRAFTING then
		SPF1.baseSelectCraft(SPF1.Data[id]["original"]);
	else
		SPF1.baseSelectCraft(id);
	end
end

function SPF1.CraftButton_OnClick(self, ...)
	SPF1.ONCLICK = self:GetID();
	SPF1.baseCraftButton_OnClick(self, ...);
end

-- Crafting
function SPF1.CraftCreateButton_OnMouseDown(self, mouseBtn)
	if CraftCreateButton:IsEnabled() and mouseBtn == "LeftButton" then
		SPF1.CRAFTING = true;
		SPF1.SelectCraft(SPF1.GetCraftSelectionIndex());
	end
end

function SPF1.CraftCreateButton_OnMouseUp()
	if SPF1.CRAFTING then
		if not CraftCreateButton:IsMouseOver() then
			SPF1.CRAFTING = nil;
			SPF1.SelectCraft(SPF1.GetCraftSelectionIndex());
		end
	end
end

function SPF1.CraftCreateButton_OnClick()
	if SPF1.CRAFTING then
		SPF1.CRAFTING = nil;
		SPF1.SelectCraft(SPF1.GetCraftSelectionIndex());
	end
end

function SPF1.SetCraftItem(obj, id, reagId)
	
	-- If The Profession is supported
	local craftIndex = SPF1.GetCraftSelectionIndex();
	
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		return SPF1.baseSetCraftItem(obj, SPF1.Data[craftIndex]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseSetCraftItem(obj, id, reagId);
end

function SPF1.SetCraftSpell(obj, id)
	
	local craftIndex = SPF1.GetCraftSelectionIndex();
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		return SPF1.baseSetCraftSpell(obj, SPF1.Data[craftIndex]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseSetCraftSpell(obj, id);
end

function SPF1.GetCraftItemLink(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		return SPF1.baseGetCraftItemLink(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftItemLink(id);
end

function SPF1.GetCraftReagentItemLink(id, reagId)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		return SPF1.baseGetCraftReagentItemLink(SPF1.Data[id]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftReagentItemLink(id, reagId);
end

function SPF1.GetCraftRecipeLink(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) and SPF1.Data[id]["original"] then
		return SPF1.baseGetCraftRecipeLink(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftRecipeLink(id);
end

function SPF1.GetCraftIcon(id)
	
	local craftIndex = SPF1.GetCraftSelectionIndex();
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		return SPF1.baseGetCraftIcon(SPF1.Data[craftIndex]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftIcon(id);
end

function SPF1.GetCraftDescription(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		return SPF1.baseGetCraftDescription(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftDescription(id);
end

function SPF1.GetCraftNumReagents(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		return SPF1.baseGetCraftNumReagents(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftNumReagents(id);
end

function SPF1.GetCraftReagentInfo(id, reagId)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		return SPF1.baseGetCraftReagentInfo(SPF1.Data[id]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftReagentInfo(id, reagId);
end

function SPF1.GetCraftSpellFocus(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		return SPF1.baseGetCraftSpellFocus(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftSpellFocus(id);
end
