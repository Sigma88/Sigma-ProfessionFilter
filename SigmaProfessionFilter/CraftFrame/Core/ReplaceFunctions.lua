local SPF1 = SigmaProfessionFilter[1];

---Replace Functions

--Number of crafts
SPF1.baseGetNumCrafts = GetNumCrafts;
GetNumCrafts = SPF1.GetNumCrafts;

--Info on craft index
SPF1.baseGetCraftInfo = GetCraftInfo;
GetCraftInfo = SPF1.GetCraftInfo;

--Expand header
SPF1.baseExpandCraftSkillLine = ExpandCraftSkillLine;
ExpandCraftSkillLine = SPF1.ExpandCraftSkillLine;
--Collapse header
SPF1.baseCollapseCraftSkillLine = CollapseCraftSkillLine;
CollapseCraftSkillLine = SPF1.CollapseCraftSkillLine;

--Crafting
CraftCreateButton:HookScript("OnMouseDown", SPF1.CraftCreateButton_OnMouseDown);
CraftCreateButton:HookScript("OnMouseUp", SPF1.CraftCreateButton_OnMouseUp);
CraftCreateButton:HookScript("OnClick", SPF1.CraftCreateButton_OnClick);

--Tooltips
SPF1.baseSetCraftItem = GameTooltip.SetCraftItem;
GameTooltip.SetCraftItem = SPF1.SetCraftItem;
SPF1.baseSetCraftSpell = GameTooltip.SetCraftSpell;
GameTooltip.SetCraftSpell = SPF1.SetCraftSpell;

--Links
SPF1.baseGetCraftItemLink = GetCraftItemLink;
GetCraftItemLink = SPF1.GetCraftItemLink;
SPF1.baseGetCraftReagentItemLink = GetCraftReagentItemLink;
GetCraftReagentItemLink = SPF1.GetCraftReagentItemLink;

--During SetSelection
SPF1.baseGetCraftIcon = GetCraftIcon;
GetCraftIcon = SPF1.GetCraftIcon;
SPF1.baseGetCraftDescription = GetCraftDescription;
GetCraftDescription = SPF1.GetCraftDescription;
SPF1.baseGetCraftNumReagents = GetCraftNumReagents;
GetCraftNumReagents = SPF1.GetCraftNumReagents;
SPF1.baseGetCraftReagentInfo = GetCraftReagentInfo;
GetCraftReagentInfo = SPF1.GetCraftReagentInfo;
SPF1.baseGetCraftSpellFocus = GetCraftSpellFocus;
GetCraftSpellFocus = SPF1.GetCraftSpellFocus;

--Indexing
SPF1.baseSelectCraft = SelectCraft;
SelectCraft = SPF1.SelectCraft;

SPF1.baseGetCraftSelectionIndex = GetCraftSelectionIndex;
--GetCraftSelectionIndex = SPF1.GetCraftSelectionIndex; DO NOT REPLACE 'GetCraftSelectionIndex'

--SPF1.baseCraftFrame_SetSelection = CraftFrame_SetSelection; INCLUDED IN SigmaProfessionFilter/CraftFrame/Core/Blizzard_CraftUI.lua
CraftFrame_SetSelection = SPF1.CraftFrame_SetSelection;

-- Blizzard_CraftUI
SPF1.baseCraftFrame_OnEvent = CraftFrame_OnEvent;
CraftFrame_OnEvent = SPF1.CraftFrame_OnEvent;
SPF1.baseCraftFrame_Update = CraftFrame_Update;
CraftFrame_Update = SPF1.CraftFrame_Update;
SPF1.baseCraftFrame_Update = CraftFrame_Update;
CraftFrame_Update = SPF1.CraftFrame_Update;
