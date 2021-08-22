local SPF2 = SigmaProfessionFilter[2];

-- Replace Functions

-- Number of crafts
SPF2.baseGetNumTradeSkills = GetNumTradeSkills;
GetNumTradeSkills = SPF2.GetNumTradeSkills;

-- Info on craft index
SPF2.baseGetTradeSkillInfo = GetTradeSkillInfo;
GetTradeSkillInfo = SPF2.GetTradeSkillInfo;

-- Expand header
SPF2.baseExpandTradeSkillSubClass = ExpandTradeSkillSubClass;
ExpandTradeSkillSubClass = SPF2.ExpandTradeSkillSubClass;
-- Collapse header
SPF2.baseCollapseTradeSkillSubClass = CollapseTradeSkillSubClass;
CollapseTradeSkillSubClass = SPF2.CollapseTradeSkillSubClass;

-- Crafting
TradeSkillCreateButton:SetScript("OnClick", SPF2.TradeSkillCreateButton_OnClick);
TradeSkillCreateAllButton:SetScript("OnClick", SPF2.TradeSkillCreateAllButton_OnClick);


-- Details
SPF2.baseSetTradeSkillItem = GameTooltip.SetTradeSkillItem;
GameTooltip.SetTradeSkillItem = SPF2.SetTradeSkillItem;



-- Links
SPF2.baseGetTradeSkillItemLink = GetTradeSkillItemLink;
GetTradeSkillItemLink = SPF2.GetTradeSkillItemLink;
SPF2.baseGetTradeSkillReagentItemLink = GetTradeSkillReagentItemLink;
GetTradeSkillReagentItemLink = SPF2.GetTradeSkillReagentItemLink;
SPF2.baseGetTradeSkillRecipeLink = GetTradeSkillRecipeLink;
GetTradeSkillRecipeLink = SPF2.GetTradeSkillRecipeLink;

-- During SetSelection
SPF2.baseGetTradeSkillIcon = GetTradeSkillIcon;
GetTradeSkillIcon = SPF2.GetTradeSkillIcon;


SPF2.baseGetTradeSkillNumReagents = GetTradeSkillNumReagents;
GetTradeSkillNumReagents = SPF2.GetTradeSkillNumReagents;
SPF2.baseGetTradeSkillReagentInfo = GetTradeSkillReagentInfo;
GetTradeSkillReagentInfo = SPF2.GetTradeSkillReagentInfo;

SPF2.baseGetTradeSkillCooldown = GetTradeSkillCooldown;
GetTradeSkillCooldown = SPF2.GetTradeSkillCooldown;


SPF2.baseTradeSkillSkillButton_OnClick = TradeSkillSkillButton_OnClick;
TradeSkillSkillButton_OnClick = SPF2.TradeSkillSkillButton_OnClick;


-- Indexing
SPF2.baseGetFirstTradeSkill = GetFirstTradeSkill;
GetFirstTradeSkill = SPF2.GetFirstTradeSkill;

SPF2.baseGetTradeSkillSelectionIndex = GetTradeSkillSelectionIndex;
GetTradeSkillSelectionIndex = SPF2.GetTradeSkillSelectionIndex;

SPF2.baseTradeSkillFrame_SetSelection = TradeSkillFrame_SetSelection;
TradeSkillFrame_SetSelection = SPF2.TradeSkillFrame_SetSelection;

-- Crafting Modifiers
SPF2.baseGetTradeSkillNumMade = GetTradeSkillNumMade;
GetTradeSkillNumMade = SPF2.GetTradeSkillNumMade;
SPF2.baseGetTradeSkillTools = GetTradeSkillTools;
GetTradeSkillTools = SPF2.GetTradeSkillTools;

-- MultiCrafting
SPF2.baseGetTradeskillRepeatCount = GetTradeskillRepeatCount;
GetTradeskillRepeatCount = SPF2.GetTradeskillRepeatCount;

-- Hooks
hooksecurefunc("TradeSkillFrame_OnShow", SPF2.TradeSkillFrame_OnShow);
hooksecurefunc("TradeSkillFrame_OnShow", SPF2.CheckBoxBar.OnShow);
