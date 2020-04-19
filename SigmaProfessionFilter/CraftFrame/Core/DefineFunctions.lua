--Set up data table
function SPF.GetNumCrafts()
	
	if not SPF:GetMenu("Right") then
		SPF:SavedData()["GroupBy"] = nil;
		SPF.LeftSort:OnShow();
	end
	
	-- Check the Chosen Grouping Scheme
	local groupBy = SPF:SavedData()["GroupBy"] or "Left";
	local Ordered = {["Left"] = {}, ["Right"] = {}}
	
    -- Find which items pass all filters
    for i=1, SPF.baseGetNumCrafts() do
		-- IMPLEMENT CHECKS LATER
		local leftGroupName = SPF.LeftMenu:Filter(i, SPF:GetSelected("Left"));
		local rightGroupName = SPF.RightMenu:Filter(i, SPF:GetSelected("Right"));

		-- FILTER_1
        if (not SPF.Filter1:Filter(i))
		-- FILTER_2
			or (not SPF.Filter2:Filter(i))
		-- SEARCH_BOX
			or not(SPF.SearchBox:Filter(i))
		-- LEFT_DROPDOWN
			or not (SPF:GetSelected("Left") == 1 or #leftGroupName > 0)
		-- RIGHT_DROPDOWN
			or not (SPF:GetSelected("Right") == 1 or #rightGroupName > 0)
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
		if (getglobal("Craft"..i.."Cost")) then
			getglobal("Craft"..i.."Cost"):SetText("");
		end
    end
	
	-- Build the new ordered table
	
	SPF.Data = {};
	SPF.Headers = {};
	
	local totalCount = 0;
    local headerCount = 0;
	local firstRecipe = nil;
	
	if Ordered[groupBy] ~= nil then
		local Pairs = SPF:GetMenu(groupBy);
		
		if (groupBy == "Left" and not SPF:GetMenu("Left")) then
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
					SPF.Headers[headerCount] = totalCount;
				
					SPF.Data[totalCount] = {
						["craftName"] = group;
						["craftSubSpellName"] = "";
						["craftType"] = "header";
						["numAvailable"] = 0;
						["trainingPointCost"] = nil;
						["requiredLevel"] = 0;
						["original"] = 0;
					};
				end
				
				if (SPF.Collapsed and SPF.Collapsed[group]) then
					SPF.Data[totalCount]["isExpanded"] = false;
				else
					if (#group > 0) then
						SPF.Data[totalCount]["isExpanded"] = true;
					end
					
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
function SPF.GetCraftInfo(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		if (SPF.Data[id]["original"] == 0) then
			return SPF.Data[id]["craftName"], SPF.Data[id]["craftSubSpellName"], SPF.Data[id]["craftType"], SPF.Data[id]["numAvailable"], SPF.Data[id]["isExpanded"], SPF.Data[id]["trainingPointCost"], SPF.Data[id]["requiredLevel"];
		else
			return SPF.baseGetCraftInfo(SPF.Data[id]["original"]);
		end
	end
	
	-- Otherwise fall back to the original
	return SPF.baseGetCraftInfo(id);
end

-- Expand
function SPF.ExpandCraftSkillLine(id)
	
	-- Check if the profession is supported
	if (not SPF[GetCraftName()]) then
		return SPF.baseExpandCraftSkillLine(id);
	end
	
	-- if the id is zero we need to expand all headers
	if (id == 0) then
		-- Expand in reverse order otherwise it's a mess
		for i=#SPF.Headers, 1, -1 do
			SPF.ExpandCraftSkillLine(SPF.Headers[i]);
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
	
    SPF.FullUpdate();
end

-- Collapse
function SPF.CollapseCraftSkillLine(id)
	
	-- Check if the profession is supported
	if (not SPF[GetCraftName()]) then
		return SPF.baseCollapseCraftSkillLine(id);
	end
	
	-- if the id is zero we need to collapse all headers
	if (id == 0) then
		-- Collapse in reverse order otherwise it's a mess
		for i=#SPF.Headers, 1, -1 do
			SPF.CollapseCraftSkillLine(SPF.Headers[i]);
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
	
    SPF.FullUpdate();
end

-- Select Craft
function SPF.CraftFrame_SetSelection(craftIndex)
	SPF.SELECTED = craftIndex;
	SPF.baseCraftFrame_SetSelection(craftIndex);
end

function SPF.GetCraftSelectionIndex()
	return SPF.SELECTED;
end

function SPF.SelectCraft(id)
	if SPF[GetCraftName()] and SPF.Data and SPF.Data[id] and SPF.CRAFTING then
		SPF.baseSelectCraft(SPF.Data[id]["original"]);
	else
		SPF.baseSelectCraft(id);
	end
end

-- Crafting
function SPF.CraftCreateButton_OnMouseDown(self, mouseBtn)
	if CraftCreateButton:IsEnabled() and mouseBtn == "LeftButton" then
		SPF.CRAFTING = true;
		SPF.SelectCraft(SPF.GetCraftSelectionIndex());
	end
end

function SPF.CraftCreateButton_OnMouseUp()
	if SPF.CRAFTING then
		if not CraftCreateButton:IsMouseOver() then
			SPF.CRAFTING = nil;
			SPF.SelectCraft(SPF.GetCraftSelectionIndex());
		end
	end
end

function SPF.CraftCreateButton_OnClick()
	if SPF.CRAFTING then
		SPF.CRAFTING = nil;
		SPF.SelectCraft(SPF.GetCraftSelectionIndex());
	end
end

function SPF.SetCraftItem(obj, id, reagId)
	
	-- If The Profession is supported
	local craftIndex = SPF.GetCraftSelectionIndex();
	
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[craftIndex]) then
		return SPF.baseSetCraftItem(obj, SPF.Data[craftIndex]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF.baseSetCraftItem(obj, id, reagId);
end

function SPF.SetCraftSpell(obj, id)
	
	local craftIndex = SPF.GetCraftSelectionIndex();
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[craftIndex]) then
		return SPF.baseSetCraftSpell(obj, SPF.Data[craftIndex]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF.baseSetCraftSpell(obj, id);
end

function SPF.GetCraftItemLink(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF.baseGetCraftItemLink(SPF.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF.baseGetCraftItemLink(id);
end

function SPF.GetCraftReagentItemLink(id, reagId)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF.baseGetCraftReagentItemLink(SPF.Data[id]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF.baseGetCraftReagentItemLink(id, reagId);
end

function SPF.GetCraftIcon(id)
	
	local craftIndex = SPF.GetCraftSelectionIndex();
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[craftIndex]) then
		return SPF.baseGetCraftIcon(SPF.Data[craftIndex]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF.baseGetCraftIcon(id);
end

function SPF.GetCraftDescription(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF.baseGetCraftDescription(SPF.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF.baseGetCraftDescription(id);
end

function SPF.GetCraftNumReagents(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF.baseGetCraftNumReagents(SPF.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF.baseGetCraftNumReagents(id);
end

function SPF.GetCraftReagentInfo(id, reagId)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF.baseGetCraftReagentInfo(SPF.Data[id]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF.baseGetCraftReagentInfo(id, reagId);
end

function SPF.GetCraftSpellFocus(id)
	
	-- If The Profession is supported
	if (SPF[GetCraftName()] and SPF.Data and SPF.Data[id]) then
		return SPF.baseGetCraftSpellFocus(SPF.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF.baseGetCraftSpellFocus(id);
end
