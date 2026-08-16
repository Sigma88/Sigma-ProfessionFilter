local SPF1 = SigmaProfessionFilter[1];

-- Replace Functions

-- Number of crafts
SPF1.baseGetNumCrafts = GetNumCrafts;
GetNumCrafts = SPF1.GetNumCrafts;

-- Info on craft index
SPF1.baseGetCraftInfo = GetCraftInfo;
GetCraftInfo = SPF1.GetCraftInfo;

-- Expand header
SPF1.baseExpandCraftSkillLine = ExpandCraftSkillLine;
ExpandCraftSkillLine = SPF1.ExpandCraftSkillLine;
-- Collapse header
SPF1.baseCollapseCraftSkillLine = CollapseCraftSkillLine;
CollapseCraftSkillLine = SPF1.CollapseCraftSkillLine;

-- Crafting
CraftCreateButton:SetScript("OnClick", SPF1.CraftCreateButton_OnClick);
-- CraftCreateAllButton:SetScript("OnClick", SPF1.CraftCreateAllButton_OnClick);


-- Details
SPF1.baseSetCraftItem = GameTooltip.SetCraftItem;
SPF1.baseSetCraftSpell = GameTooltip.SetCraftSpell;
GameTooltip.SetCraftItem = SPF1.SetCraftItem;
GameTooltip.SetCraftSpell = SPF1.SetCraftItem;

-- Links
SPF1.baseGetCraftItemLink = GetCraftItemLink;
GetCraftItemLink = SPF1.GetCraftItemLink;
SPF1.baseGetCraftReagentItemLink = GetCraftReagentItemLink;
GetCraftReagentItemLink = SPF1.GetCraftReagentItemLink;
SPF1.baseGetCraftRecipeLink = GetCraftRecipeLink;
GetCraftRecipeLink = SPF1.GetCraftRecipeLink;

-- During SetSelection
SPF1.baseGetCraftIcon = GetCraftIcon;
GetCraftIcon = SPF1.GetCraftIcon;


SPF1.baseGetCraftNumReagents = GetCraftNumReagents;
GetCraftNumReagents = SPF1.GetCraftNumReagents;
SPF1.baseGetCraftReagentInfo = GetCraftReagentInfo;
GetCraftReagentInfo = SPF1.GetCraftReagentInfo;

SPF1.baseGetCraftCooldown = GetCraftCooldown;
GetCraftCooldown = SPF1.GetCraftCooldown;


SPF1.baseCraftButton_OnClick = CraftButton_OnClick;
CraftButton_OnClick = SPF1.CraftButton_OnClick;

SPF1.baseCraftFrame_Update = CraftFrame_Update;
CraftFrame_Update = SPF1.CraftFrame_Update;


-- Indexing
SPF1.baseGetFirstCraft = GetFirstCraft;
GetFirstCraft = SPF1.GetFirstCraft;

SPF1.baseGetCraftSelectionIndex = GetCraftSelectionIndex;
GetCraftSelectionIndex = SPF1.GetCraftSelectionIndex;

SPF1.baseCraftFrame_SetSelection = CraftFrame_SetSelection;
CraftFrame_SetSelection = SPF1.CraftFrame_SetSelection;

-- Crafting Modifiers
SPF1.baseGetCraftNumMade = GetCraftNumMade;
GetCraftNumMade = SPF1.GetCraftNumMade;
SPF1.baseGetCraftSpellFocus = GetCraftSpellFocus;
GetCraftSpellFocus = SPF1.GetCraftSpellFocus;

-- MultiCrafting
SPF1.baseGetCraftRepeatCount = GetCraftRepeatCount;
GetCraftRepeatCount = SPF1.GetCraftRepeatCount;

-- CraftFrame_OnShow
SPF1.baseCraftFrame_OnShow = CraftFrame_OnShow;
CraftFrame_OnShow = SPF1.CraftFrame_OnShow;
CraftFrame:SetScript("OnShow", CraftFrame_OnShow);

--[[
function SPF1.ContainerFrameItemButton_OnClick(button, ignoreModifiers)
	if SPF1.SearchBox:IsVisible() and SPF1.SearchBox.HasFocus and IsShiftKeyDown() then
		SPF1.SearchBox.InsertItemName(GetContainerItemLink(this:GetParent():GetID(), this:GetID()));
	else
		SPF1.baseContainerFrameItemButton_OnClick(button, ignoreModifiers);
	end
end

SPF1.baseContainerFrameItemButton_OnClick = ContainerFrameItemButton_OnClick;
ContainerFrameItemButton_OnClick = SPF1.ContainerFrameItemButton_OnClick;
]]--

--[[ KEEP FOR DEBUG PURPOSES

function SPF1.SetItemRef(link, text, button, fourth)
	DEFAULT_CHAT_FRAME:AddMessage("SetItemRef:",1,0,0);
	DEFAULT_CHAT_FRAME:AddMessage("   link: "..(link or "NULL"),1,0,0);
	DEFAULT_CHAT_FRAME:AddMessage("   text: "..(text or "NULL"),1,0,0);
	DEFAULT_CHAT_FRAME:AddMessage("   button: "..(button or "NULL"),1,0,0);
	DEFAULT_CHAT_FRAME:AddMessage("   fourth: "..(fourth or "NULL"),1,0,0);
	SPF1.baseSetItemRef(link,text,button,fourth);
end

SPF1.baseSetItemRef = SetItemRef;
SetItemRef = SPF1.SetItemRef;


function SPF1.GTSetHyperlink(self,link)
	DEFAULT_CHAT_FRAME:AddMessage("GTSetHyperlink:",1,0,0);
	DEFAULT_CHAT_FRAME:AddMessage("   link: "..(link or "NULL"),1,0,0);
	SPF1.baseGTSetHyperlink(self,link);
end

SPF1.baseGTSetHyperlink = ItemRefTooltip.SetHyperlink;
ItemRefTooltip.SetHyperlink = SPF1.GTSetHyperlink;

--]]--
