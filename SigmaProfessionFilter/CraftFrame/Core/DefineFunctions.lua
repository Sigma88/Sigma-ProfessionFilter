local SPF1 = SigmaProfessionFilter[1];

--Set up data table
function SPF1.GetNumCrafts()
	
	if not CraftFrame:IsVisible() then
		return SPF1.baseGetNumCrafts();
	end
	
	if not SPF1.FILTERED then
		
		if not SPF1:GetMenu("Right") then
			SPF1:SavedData()["GroupBy"] = nil;
			SPF1.LeftSort:OnShow();
		end
		
		-- -- Check the Chosen Grouping Scheme
		-- local groupBy = SPF1:SavedData()["GroupBy"] or "Left";
		-- local Ordered = {};
		
		-- Reset the Data
		SPF1.FIRST = nil;
		SPF1.Data = {};
		SPF1.Recipes = {};
		SPF1.Headers = {};
		
		local headerIndex = 0;
		local Ordered = {};
		
		
		-- Find which items pass all filters
		for i=1, SPF1.baseGetNumCrafts() do
			-- IMPLEMENT CHECKS LATER
			---local leftGroupName = SPF1.LeftMenu:Filter(i, SPF1:GetSelected("Left"));
			---local rightGroupName = SPF1.RightMenu:Filter(i, SPF1:GetSelected("Right"));
			local leftGroupID = SPF1.LeftMenu:Filter(i, SPF1:GetSelected("Left")) or 0;
			local rightGroupID = SPF1.RightMenu:Filter(i, SPF1:GetSelected("Right")) or 0;
			print("leftGroupID",leftGroupID > 0);
			print("rightGroupID",rightGroupID>0);
			print("SPF1:GetSelected(\"Left\")",SPF1:GetSelected("Left") == 0);
			print("SPF1:GetSelected(\"Right\")",SPF1:GetSelected("Right")==0);
			-- FILTER_1
			if (not SPF1.Filter1:Filter(i))
			-- FILTER_2
				or (not SPF1.Filter2:Filter(i))
			-- SEARCH_BOX
				or not(SPF1.SearchBox:Filter(i))
			-- LEFT_DROPDOWN
				or not (SPF1:GetSelected("Left") == 0 or leftGroupID > 0)--#leftGroupName > 0)
			-- RIGHT_DROPDOWN
				or not (SPF1:GetSelected("Right") == 0 or rightGroupID > 0)--#rightGroupName > 0)
			then
				-- SKIP ELEMENTS THAT FAIL TO MATCH ALL FILTERS
				print("SKIP");
			else
				-- ELEMENTS THAT MATCH ALL FILTERS
				if (groupBy == "Left") then
					if (Ordered[leftGroupID] == nil) then
						Ordered[leftGroupID] = {};
					end
					table.insert(Ordered[leftGroupID], i);
				else
					if (Ordered[rightGroupID] == nil) then
						Ordered[rightGroupID] = {};
					end
					table.insert(Ordered[rightGroupID], i);
				end
			end
			
			-- Fix for BeastTraining headers not forgetting their old cost
			if _G["Craft"..i.."Cost"] then
				_G["Craft"..i.."Cost"]:SetText("");
			end
		end
		
		-- Build the new ordered table
		
		-- SPF1.FIRST = nil;
		-- SPF1.Data = {};
		-- SPF1.Headers = {};
		
		local totalCount = 0;
		local headerCount = 0;
		-- local firstRecipe = nil;
		
		if Ordered then
			local Pairs = SPF1:GetMenu(groupBy) or { [1] = { name = ""; } };
			
			-- if (groupBy == "Left" and not SPF1:GetMenu("Left")) then
				-- Pairs = { [1] = { name = ""; } };
			-- end
			
			for i,button in ipairs(Pairs) do
				local group = button.name;
				local items = Ordered[i];
				--print("i >",i,"<");
				--print("group>",group,"<");
				if items then
					-- Add the Header
					if (#group > 0) then
						headerCount = headerCount + 1;
						totalCount = totalCount + 1;
						SPF1.Headers[headerCount] = totalCount;
					
						SPF1.Data[totalCount] = {
							["craftName"] = group;
							["craftSubSpellName"] = "";
							["craftType"] = "header";
							["headerIndex"] = headerCount;
							["numAvailable"] = 0;
							--["trainingPointCost"] = nil;
							--["requiredLevel"] = 0;
							--["original"] = 0;
						};
					end
					
					if (SPF1.Collapsed and SPF1.Collapsed[headerCount]) then
						SPF1.Data[totalCount]["isExpanded"] = false;
					else
						if (#group > 0) then
							SPF1.Data[totalCount]["isExpanded"] = true;
						end
						
						for j,craftIndex in ipairs(items) do
							totalCount = totalCount + 1;
							--print("   item",craftIndex);
							if (not SPF1.FIRST) then
								--firstRecipe = totalCount;
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
		
		if totalCount > 0 then
			SPF1.FILTERED = {};
			SPF1.FILTERED["totalCount"] = totalCount;
			SPF1.FILTERED["headerCount"] = headerCount;
			SPF1.FILTERED["firstRecipe"] = firstRecipe;
		else
			return totalCount, headerCount, firstRecipe;
		end
		
	end
	
    return SPF1.FILTERED["totalCount"], SPF1.FILTERED["headerCount"], SPF1.FILTERED["firstRecipe"];
end

-- Get Craft Info
function SPF1.GetCraftInfo(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
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
function SPF1.ExpandCraftSkillLine(id, skipUpdate)
	
	-- Check if the profession is supported
	if (not SigmaProfessionFilter[GetCraftName()]) then
		return SPF1.baseExpandCraftSkillLine(id);
	end
	
	-- if the id is zero we need to expand all headers
	if (id == 0) then
		-- Expand in reverse order otherwise it's a mess
		for i=#SPF1.Headers, 1, -1 do
			SPF1.ExpandCraftSkillLine(SPF1.Headers[i], true);
		end
		SPF1.FullUpdate();
		return;
		
	-- otherwise expand this header
	elseif (SPF1.Data and SPF1.Data[id]) then
		-- if this is a header
		local craftType = SPF1.Data[id]["craftType"];
		local craftName = SPF1.Data[id]["craftName"];
		
		if (craftType == "header") then
			-- Remove if fom the list of collapsed headers
			
			if (SPF1.Collapsed == nil) then
				SPF1.Collapsed = {};
			end
			
			SPF1.Collapsed[SPF1.Data[id]["headerIndex"]] = nil;
		end
	end
	
	if not skipUpdate then
		SPF1.FullUpdate();
		SPF1.ONCLICK = id;
	end
end

-- Collapse
function SPF1.CollapseCraftSkillLine(id, skipUpdate)
	
	-- Check if the profession is supported
	if (not SigmaProfessionFilter[GetCraftName()]) then
		return SPF1.baseCollapseCraftSkillLine(id);
	end
	
	-- if the id is zero we need to collapse all headers
	if (id == 0) then
		-- Collapse in reverse order otherwise it's a mess
		for i=#SPF1.Headers, 1, -1 do
			SPF1.CollapseCraftSkillLine(SPF1.Headers[i], true);
		end
		
		SPF1.FullUpdate();
		return;
		
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
			
			SPF1.Collapsed[SPF1.Data[id]["headerIndex"]] = true;
		end
	end
	
	if not skipUpdate then
		SPF1.FullUpdate();
		SPF1.ONCLICK = id;
	end
end

-- Select Craft
function SPF1.CraftFrame_SetSelection(craftIndex)
	SPF1.SELECTED = craftIndex;
	SPF1.baseCraftFrame_SetSelection(craftIndex);
end

function SPF1.GetCraftSelectionIndex()
	
	if SPF1.SELECTED then
		return SPF1.SELECTED;
	end
	return SPF1.baseGetCraftSelectionIndex();
end

function SPF1.SelectCraft(id)
	if SPF1.Data and SPF1.Data[id] and SPF1.CRAFTING then
		if not SPF1.Data[id]["original"] then
			return;
		end
		--print("SELECT CRAFT1",SPF1.Data[id]["original"]);
		SPF1.baseSelectCraft(SPF1.Data[id]["original"]);
	else
		--print("SELECT CRAFT2",id);
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
		--print("ON_MOUSE_DOWN",GetCraftSelectionIndex());
		SPF1.CRAFTING = true;
		SPF1.SelectCraft(SPF1.GetCraftSelectionIndex());
	end
end

function SPF1.CraftCreateButton_OnMouseUp()
	if SPF1.CRAFTING then
		--print("ON_MOUSE_UP",GetCraftSelectionIndex());
		if not CraftCreateButton:IsMouseOver() then
			SPF1.CRAFTING = nil;
			SPF1.SelectCraft(SPF1.GetCraftSelectionIndex());
		end
	end
end

function SPF1.CraftCreateButton_OnClick()
	if SPF1.CRAFTING then
		--print("ON_CLICK",GetCraftSelectionIndex());
		SPF1.CRAFTING = nil;
		SPF1.SelectCraft(SPF1.GetCraftSelectionIndex());
	end
end

function SPF1.SetCraftItem(obj, id, reagId)
	
	-- If The Profession is supported
	local craftIndex = SPF1.GetCraftSelectionIndex();
	
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseSetCraftItem(obj, SPF1.Data[craftIndex]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseSetCraftItem(obj, id, reagId);
end

function SPF1.SetCraftSpell(obj, id)
	
	local craftIndex = SPF1.GetCraftSelectionIndex();
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseSetCraftSpell(obj, SPF1.Data[craftIndex]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseSetCraftSpell(obj, id);
end

function SPF1.GetCraftItemLink(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
		return SPF1.baseGetCraftItemLink(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftItemLink(id);
end

function SPF1.GetCraftReagentItemLink(id, reagId)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
		return SPF1.baseGetCraftReagentItemLink(SPF1.Data[id]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftReagentItemLink(id, reagId);
end

function SPF1.GetCraftRecipeLink(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
		return SPF1.baseGetCraftRecipeLink(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftRecipeLink(id);
end

function SPF1.GetCraftIcon(id)
	
	local craftIndex = SPF1.GetCraftSelectionIndex();
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[craftIndex]) then
		if not SPF1.Data[craftIndex]["original"] then
			return;
		end
		return SPF1.baseGetCraftIcon(SPF1.Data[craftIndex]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftIcon(id);
end

function SPF1.GetCraftDescription(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
		return SPF1.baseGetCraftDescription(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftDescription(id);
end

function SPF1.GetCraftNumReagents(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
		return SPF1.baseGetCraftNumReagents(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftNumReagents(id);
end

function SPF1.GetCraftReagentInfo(id, reagId)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
		return SPF1.baseGetCraftReagentInfo(SPF1.Data[id]["original"], reagId);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftReagentInfo(id, reagId);
end

function SPF1.GetCraftSpellFocus(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
		return SPF1.baseGetCraftSpellFocus(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftSpellFocus(id);
end

function SPF1.GetCraftCooldown(id)
	
	-- If The Profession is supported
	if (SPF1.Data and SPF1.Data[id]) then
		if not SPF1.Data[id]["original"] then
			return;
		end
		return SPF1.baseGetCraftCooldown(SPF1.Data[id]["original"]);
	end
	
	-- Otherwise fall back to the original
    return SPF1.baseGetCraftCooldown(id);
end
