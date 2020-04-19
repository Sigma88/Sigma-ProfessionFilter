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

--Indexing
SPF.baseSelectCraft = SelectCraft;
SelectCraft = SPF.SelectCraft;

SPF.baseGetCraftSelectionIndex = GetCraftSelectionIndex;
--GetCraftSelectionIndex = SPF.GetCraftSelectionIndex; DO NOT REPLACE 'GetCraftSelectionIndex'

--SPF.baseCraftFrame_SetSelection = CraftFrame_SetSelection; INCLUDED IN SigmaProfessionFilter/CraftFrame/Core/Blizzard_CraftUI.lua
CraftFrame_SetSelection = SPF.CraftFrame_SetSelection;

-- Blizzard_CraftUI
SPF.baseCraftFrame_OnEvent = CraftFrame_OnEvent;
CraftFrame_OnEvent = SPF.CraftFrame_OnEvent;
SPF.baseCraftFrame_Update = CraftFrame_Update;
CraftFrame_Update = SPF.CraftFrame_Update;
SPF.baseCraftFrame_Update = CraftFrame_Update;
CraftFrame_Update = SPF.CraftFrame_Update;

