---Replace Functions

--Number of crafts
SPF.baseGetNumCrafts = GetNumCrafts;
GetNumCrafts = SPF.GetNumCrafts;

--Info on craft index
SPF.baseGetCraftInfo = GetCraftInfo;
GetCraftInfo = SPF.GetCraftInfo;

--Expand header
SPF.baseExpandCraftSkillLine = ExpandCraftSkillLine;
ExpandCraftSkillLine = SPF.ExpandCraftSkillLine;
--Collapse header
SPF.baseCollapseCraftSkillLine = CollapseCraftSkillLine;
CollapseCraftSkillLine = SPF.CollapseCraftSkillLine;

--Indexing
SPF.baseCraftFrame_SetSelection = CraftFrame_SetSelection;
CraftFrame_SetSelection = SPF.CraftFrame_SetSelection;
SPF.baseGetCraftSelectionIndex = GetCraftSelectionIndex;
GetCraftSelectionIndex = SPF.GetCraftSelectionIndex;
SPF.baseSelectCraft = SelectCraft;
SelectCraft = SPF.SelectCraft;

--Crafting
CraftCreateButton:HookScript("OnMouseDown", SPF.CraftCreateButton_OnMouseDown);
CraftCreateButton:HookScript("OnMouseUp", SPF.CraftCreateButton_OnMouseUp);
CraftCreateButton:HookScript("OnClick", SPF.CraftCreateButton_OnClick);

--Tooltips
SPF.baseSetCraftItem = GameTooltip.SetCraftItem;
GameTooltip.SetCraftItem = SPF.SetCraftItem;
SPF.baseSetCraftSpell = GameTooltip.SetCraftSpell;
GameTooltip.SetCraftSpell = SPF.SetCraftSpell;

--Links
SPF.baseGetCraftItemLink = GetCraftItemLink;
GetCraftItemLink = SPF.GetCraftItemLink;
SPF.baseGetCraftReagentItemLink = GetCraftReagentItemLink;
GetCraftReagentItemLink = SPF.GetCraftReagentItemLink;

--During SetSelection
SPF.baseGetCraftIcon = GetCraftIcon;
GetCraftIcon = SPF.GetCraftIcon;
SPF.baseGetCraftDescription = GetCraftDescription;
GetCraftDescription = SPF.GetCraftDescription;
SPF.baseGetCraftNumReagents = GetCraftNumReagents;
GetCraftNumReagents = SPF.GetCraftNumReagents;
SPF.baseGetCraftReagentInfo = GetCraftReagentInfo;
GetCraftReagentInfo = SPF.GetCraftReagentInfo;
SPF.baseGetCraftSpellFocus = GetCraftSpellFocus;
GetCraftSpellFocus = SPF.GetCraftSpellFocus;
