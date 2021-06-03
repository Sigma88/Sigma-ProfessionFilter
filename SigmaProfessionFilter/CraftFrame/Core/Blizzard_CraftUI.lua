local SPF1 = SigmaProfessionFilter[1];

-- EXACTLY THE SAME AS THE BLIZZARD CraftUI FUNCTIONS
-- EXCEPT THAT THESE USE 'SPF1.GetCraftSelectionIndex'
-- RATHER THAN THE ORIGINAL 'GetCraftSelectionIndex'
-- I HAVE TO DO THIS BECAUSE I CAN'T REPLACE THAT FUNCTION
-- BECAUSE IT GIVES AN ERROR WHEN TRYING TO CREATE THE CRAFT

function SPF1.CraftFrame_OnEvent(self, event, ...)
	if ( not self:IsVisible() ) then
		return;
	end

	if ( event == "CRAFT_UPDATE" ) then
		CraftCreateButton:Disable();
		if ( SPF1.GetCraftSelectionIndex() > 1 ) then
			CraftFrame_SetSelection(SPF1.GetCraftSelectionIndex());
		else
			if ( GetNumCrafts() > 0 ) then
				-- Check to see if has headers, if so select the second slot if not select the first slot
				local indexToSelect;
				local craftName, craftSubSpellName, craftType, numAvailable, isExpanded = GetCraftInfo(1);
				if ( craftType == "header" ) then
					indexToSelect = 2;
				else
					indexToSelect = 1;
				end
				CraftFrame_SetSelection(indexToSelect);
				FauxScrollFrame_SetOffset(CraftListScrollFrame, 0);
			end
			CraftListScrollFrameScrollBar:SetValue(0);
		end
		CraftFrame_Update();
	elseif ( event == "UNIT_PORTRAIT_UPDATE" ) then
		if ( arg1 == "player" ) then
			SetPortraitTexture(CraftFramePortrait, "player");
		end
	elseif ( event == "SPELLS_CHANGED" ) then
		CraftFrame_Update();
	elseif ( event == "UNIT_PET_TRAINING_POINTS" ) then
		Craft_UpdateTrainingPoints();
	end
end

function SPF1.CraftFrame_Update()
	SetPortraitTexture(CraftFramePortrait, "player");
	CraftFrameTitleText:SetText(GetCraftName());

	local numCrafts = GetNumCrafts();
	local craftOffset = FauxScrollFrame_GetOffset(CraftListScrollFrame);
	-- Set the action button text
	CraftCreateButton:SetText(_G[GetCraftButtonToken()]);
	-- Set the craft skill line status bar info
	local name, rank, maxRank = GetCraftDisplaySkillLine();
	if ( name ) then
		CraftRankFrameSkillName:SetText(name);
		CraftRankFrame:SetStatusBarColor(0.0, 0.0, 1.0, 0.5);
		CraftRankFrameBackground:SetVertexColor(0.0, 0.0, 0.75, 0.5);
		CraftRankFrame:SetMinMaxValues(0, maxRank);
		CraftRankFrame:SetValue(rank);
		CraftRankFrameSkillRank:SetText(rank.."/"..maxRank);
		CraftRankFrame:Show();
		CraftSkillBorderLeft:Show();
		CraftSkillBorderRight:Show();
	else
		CraftRankFrame:Hide();
		CraftSkillBorderLeft:Hide();
		CraftSkillBorderRight:Hide();
	end

	-- Hide the expand all button if less than 2 crafts learned	
	if ( numCrafts <=1 ) then
		CraftExpandButtonFrame:Hide();
	else
		CraftExpandButtonFrame:Show();
	end
	-- If no Crafts
	if ( numCrafts == 0 ) then
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
		CraftListScrollFrame:Hide();
		for i=1, CRAFTS_DISPLAYED, 1 do
			_G["Craft"..i]:Hide();
		end
		CraftHighlightFrame:Hide();
		CraftRequirements:Hide();
		
		return;
	end
	
	-- If has crafts
	CraftName:Show();
	CraftRequirements:Show();
	CraftIcon:Show();
	CraftDescription:Show();
	CraftCollapseAllButton:Enable();
	
	-- ScrollFrame update
	FauxScrollFrame_Update(CraftListScrollFrame, numCrafts, CRAFTS_DISPLAYED, CRAFT_SKILL_HEIGHT, nil, nil, nil, CraftHighlightFrame, 293, 316 );
	
	CraftHighlightFrame:Hide();
	
	local craftIndex, craftName, craftButton, craftButtonSubText, craftButtonCost, craftButtonText;
	for i=1, CRAFTS_DISPLAYED, 1 do
		craftIndex = i + craftOffset;
		craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = GetCraftInfo(craftIndex);
		craftButton = _G["Craft"..i];
		craftButtonSubText = _G["Craft"..i.."SubText"];
		craftButtonCost = _G["Craft"..i.."Cost"];
		craftButtonText = _G["Craft"..i.."Text"];
		if ( craftIndex <= numCrafts ) then
			-- Set button widths if scrollbar is shown or hidden
			if ( CraftListScrollFrame:IsVisible() ) then
				craftButton:SetWidth(293);
				-- HACK to fix a bug with (Rank) rendering in Beast Training --
				if ( not trainingPointCost ) then
					craftButtonText:SetWidth(290);
				end
			else
				craftButton:SetWidth(323);
				-- HACK to fix a bug with (Rank) rendering in Beast Training --
				if ( not trainingPointCost ) then
					craftButtonText:SetWidth(320);
				end
			end
			craftButtonCost:SetPoint("RIGHT", CRAFT_COST_OFFSET, 0);
			local color = CraftTypeColor[craftType];
			
			craftButton:SetNormalFontObject(color.font);
			craftButtonCost:SetTextColor(color.r, color.g, color.b);
			Craft_SetSubTextColor(craftButton, color.r, color.g, color.b);
			craftButton:SetID(craftIndex);
			craftButton:Show();
			-- Handle headers
			if ( craftType == "header" ) then
				craftButton:SetText(craftName);
				craftButtonSubText:SetText("");
				craftButtonText:SetWidth(0);
				if ( isExpanded ) then
					craftButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
				else
					craftButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				end
				_G["Craft"..i.."Highlight"]:SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
				_G["Craft"..i]:UnlockHighlight();
			else
				craftButton:SetNormalTexture("");
				_G["Craft"..i.."Highlight"]:SetTexture("");
				if ( numAvailable == 0 ) then
					craftButton:SetText(" "..craftName);
				else
					craftButton:SetText(" "..craftName.." ["..numAvailable.."]");
					end
				if ( craftSubSpellName and craftSubSpellName ~= "" ) then
					craftButtonSubText:SetText(format(PARENS_TEMPLATE, craftSubSpellName));
					craftButtonText:SetWidth(0);
				else 
					craftButtonSubText:SetText("");

					-- A bit of a hack. If there's no subtext, we'll set a width to ensure that we don't overflow.
					craftButtonText:SetWidth(CRAFT_TEXT_WIDTH);
				end
				if ( trainingPointCost > 0 ) then
					craftButtonCost:SetText(format(TRAINER_LIST_TP, trainingPointCost));
				else
					craftButtonCost:SetText("");
				end

				craftButtonSubText:SetPoint("LEFT", "Craft"..i.."Text", "RIGHT", CRAFT_SUBTEXT_OFFSET, 0);
				-- Place the highlight and lock the highlight state
				if ( SPF1.GetCraftSelectionIndex() == craftIndex ) then
					CraftHighlightFrame:SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 0, 0);
					CraftHighlightFrame:Show();
					Craft_SetSubTextColor(craftButton, 1.0, 1.0, 1.0);
					craftButtonCost:SetTextColor(1.0, 1.0, 1.0);
					_G["Craft"..i]:LockHighlight();
				else
					_G["Craft"..i]:UnlockHighlight();
				end
			end
			
		else
			craftButton:Hide();
		end
	end
	
	-- If player has training points show them here
	Craft_UpdateTrainingPoints();

	-- Set the expand/collapse all button texture
	local numHeaders = 0;
	local notExpanded = 0;
	for i=1, numCrafts, 1 do
		local craftName, craftSubSpellName, craftType, numAvailable, isExpanded = GetCraftInfo(i);
		if ( craftName and craftType == "header" ) then
			numHeaders = numHeaders + 1;
			if ( not isExpanded ) then
				notExpanded = notExpanded + 1;
			end
		end
	end
	-- If all headers are not expanded then show collapse button, otherwise show the expand button
	if ( notExpanded ~= numHeaders ) then
		CraftCollapseAllButton.collapsed = nil;
		CraftCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	else
		CraftCollapseAllButton.collapsed = 1;
		CraftCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	end

	-- If has headers show the expand all button
	if ( numHeaders > 0 ) then
		-- If has headers then move all the names to the right
		for i=1, CRAFTS_DISPLAYED, 1 do
			_G["Craft"..i.."Text"]:ClearAllPoints();
			if i == SPF1.ONCLICK then
				SPF1.ONCLICK = nil;
				_G["Craft"..i.."Text"]:SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 22.65, -1.65);
			else
				_G["Craft"..i.."Text"]:SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 21, 0);
			end
		end
		CraftExpandButtonFrame:Show();
	else
		-- If no headers then move all the names to the left
		for i=1, CRAFTS_DISPLAYED, 1 do
			_G["Craft"..i.."Text"]:ClearAllPoints();
			if i == SPF1.ONCLICK then
				SPF1.ONCLICK = nil;
				_G["Craft"..i.."Text"]:SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 4.65, -1.65);
			else
				_G["Craft"..i.."Text"]:SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 3, 0);
			end
		end
		CraftExpandButtonFrame:Hide();
	end
end

function SPF1.baseCraftFrame_SetSelection(id)
	if ( not id ) then
		return;
	end
	local craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = GetCraftInfo(id);
	CraftHighlightFrame:Show();
	-- If the type of the selection is header, don't process all the craft details
	if ( craftType == "header" ) then
		CraftHighlightFrame:Hide();
		if ( isExpanded ) then
			CollapseCraftSkillLine(id);
		else
			ExpandCraftSkillLine(id);
		end
		return;
	end
	SelectCraft(id);
	if ( SPF1.GetCraftSelectionIndex() > GetNumCrafts() ) then
		return;
	end
	local color = CraftTypeColor[craftType];
	CraftHighlight:SetVertexColor(color.r, color.g, color.b);

	-- General Info
	CraftName:SetText(craftName);
	CraftIcon:SetNormalTexture(GetCraftIcon(id));
	
	if ( GetCraftDescription(id) ) then
		CraftDescription:SetText(GetCraftDescription(id));
		CraftReagentLabel:SetPoint("TOPLEFT", "CraftDescription", "BOTTOMLEFT", 0, -10);
	else
		CraftDescription:SetText(" ");
		CraftReagentLabel:SetPoint("TOPLEFT", "CraftDescription", "TOPLEFT", 0, 0);
	end
	
	
	-- Reagents
	local creatable = 1;
	local numReagents = GetCraftNumReagents(id);
	
	for i=1, numReagents, 1 do
		local reagentName, reagentTexture, reagentCount, playerReagentCount = GetCraftReagentInfo(id, i);
		local reagent = _G["CraftReagent"..i];
		local name = _G["CraftReagent"..i.."Name"];
		local count = _G["CraftReagent"..i.."Count"];
		if ( not reagentName or not reagentTexture ) then
			reagent:Hide();
		else
			reagent:Show();
			SetItemButtonTexture(reagent, reagentTexture);
			name:SetText(reagentName);
			-- Grayout items
			if ( playerReagentCount < reagentCount ) then
				SetItemButtonTextureVertexColor(reagent, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
				name:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
				creatable = nil;
			else
				SetItemButtonTextureVertexColor(reagent, 1.0, 1.0, 1.0);
				name:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			end
			if ( playerReagentCount >= 100 ) then
				playerReagentCount = "*";
			end
			count:SetText(playerReagentCount.." /"..reagentCount);
		end
	end
	
	if ( numReagents > 0 ) then
		CraftReagentLabel:Show();
	else
		CraftReagentLabel:Hide();
	end
	for i=numReagents + 1, MAX_CRAFT_REAGENTS, 1 do
		_G["CraftReagent"..i]:Hide();
	end

	local requiredTotems = BuildColoredListString(GetCraftSpellFocus(id));
	if ( requiredTotems ) then
		CraftRequirements:SetText(REQUIRES_LABEL.." "..requiredTotems);
	elseif ( requiredLevel and requiredLevel > 0 ) then
		if ( UnitLevel("pet") >= requiredLevel ) then
			CraftRequirements:SetText(REQUIRES_LABEL.." "..format(TRAINER_REQ_LEVEL --[[TRAINER_PET_LEVEL]], requiredLevel));
		else
			CraftRequirements:SetText(REQUIRES_LABEL.." "..format(TRAINER_REQ_LEVEL --[[TRAINER_PET_LEVEL_RED]], requiredLevel));
		end
	else
		CraftRequirements:SetText("");
	end

	if ( trainingPointCost > 0 ) then
		local totalPoints, spent = GetPetTrainingPoints();
		local usablePoints = totalPoints - spent;
		if ( usablePoints >= trainingPointCost ) then
			CraftCost:SetText(COSTS_LABEL.." "..trainingPointCost.." "..TRAINING_POINTS_LABEL);
		else
			CraftCost:SetText(COSTS_LABEL.." "..RED_FONT_COLOR_CODE..trainingPointCost..FONT_COLOR_CODE_CLOSE.." "..TRAINING_POINTS_LABEL);
		end
		
		CraftCost:Show();
	else
		CraftCost:Hide();
	end

	if ( craftType == "used" ) then
		creatable = nil;
	end

	if ( creatable ) then
		CraftCreateButton:Enable();
	else
		CraftCreateButton:Disable();
	end
	CraftDetailScrollFrame:UpdateScrollChildRect();
	-- Show or hide scrollbar
	if ((CraftDetailScrollFrameScrollBarScrollUpButton:IsEnabled() == 0) and (CraftDetailScrollFrameScrollBarScrollDownButton:IsEnabled() == 0) ) then
		CraftDetailScrollFrameScrollBar:Hide();
		CraftDetailScrollFrameTop:Hide();
		CraftDetailScrollFrameBottom:Hide();
	else
		CraftDetailScrollFrameScrollBar:Show();
		CraftDetailScrollFrameTop:Show();
		CraftDetailScrollFrameBottom:Show();
	end
end
