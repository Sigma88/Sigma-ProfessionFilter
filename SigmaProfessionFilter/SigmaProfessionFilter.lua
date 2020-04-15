function SPF_OnLoad()
    ---Replace Functions
	
    --Number of crafts
    SPF_baseGetNumCrafts = GetNumCrafts;
    GetNumCrafts = SPF_GetNumCrafts;
    
    --Info on craft index
    SPF_baseGetCraftInfo = GetCraftInfo;
    GetCraftInfo = SPF_GetCraftInfo;
    
    --Expand header
    SPF_baseExpandCraftSkillLine = ExpandCraftSkillLine;
    ExpandCraftSkillLine = SPF_ExpandCraftSkillLine;
    --Collapse header
    SPF_baseCollapseCraftSkillLine = CollapseCraftSkillLine;
    CollapseCraftSkillLine = SPF_CollapseCraftSkillLine;
    
    --Indexing
    SPF_baseSelectCraft = SelectCraft;
    SelectCraft = SPF_SelectCraft;
	CraftCreateButton:HookScript("OnMouseDown", SPF_CraftCreateButton_OnMouseDown);
	CraftCreateButton:HookScript("OnMouseUp", SPF_CraftCreateButton_OnMouseUp);
	CraftCreateButton:HookScript("OnClick", SPF_CraftCreateButton_OnClick);
	
	-- USING THIS CAUSES BLIZ TO FREAK OUT
	-- SPF_baseGetCraftSelectionIndex = GetCraftSelectionIndex;
    -- GetCraftSelectionIndex = SPF_GetCraftSelectionIndex;
    
    -- --Crafting
    -- SPF_baseDoCraft = DoCraft;
    -- DoCraft = SPF_DoCraft;
    
    --Tooltips
    SPF_baseSetCraftItem = GameTooltip.SetCraftItem;
    GameTooltip.SetCraftItem = SPF_SetCraftItem;
    SPF_baseSetCraftSpell = GameTooltip.SetCraftSpell;
    GameTooltip.SetCraftSpell = SPF_SetCraftSpell;
    
    --Links
    SPF_baseGetCraftItemLink = GetCraftItemLink;
    GetCraftItemLink = SPF_GetCraftItemLink;
    SPF_baseGetCraftReagentItemLink = GetCraftReagentItemLink;
    GetCraftReagentItemLink = SPF_GetCraftReagentItemLink;
    
    --During SetSelection
    SPF_baseGetCraftIcon = GetCraftIcon;
    GetCraftIcon = SPF_GetCraftIcon;
    SPF_baseGetCraftDescription = GetCraftDescription;
    GetCraftDescription = SPF_GetCraftDescription;
    SPF_baseGetCraftNumReagents = GetCraftNumReagents;
    GetCraftNumReagents = SPF_GetCraftNumReagents;
    SPF_baseGetCraftReagentInfo = GetCraftReagentInfo;
    GetCraftReagentInfo = SPF_GetCraftReagentInfo;
    SPF_baseGetCraftSpellFocus = GetCraftSpellFocus;
    GetCraftSpellFocus = SPF_GetCraftSpellFocus;
end
