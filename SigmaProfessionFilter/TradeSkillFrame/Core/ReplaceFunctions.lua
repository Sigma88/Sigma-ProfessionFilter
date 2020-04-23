-- Replace Functions

--Number of crafts
SPF2.baseGetNumTradeSkills = GetNumTradeSkills;
GetNumTradeSkills = SPF2.GetNumTradeSkills;

--Info on craft index
SPF2.baseGetTradeSkillInfo = GetTradeSkillInfo;
GetTradeSkillInfo = SPF2.GetTradeSkillInfo;

--Expand header
SPF2.baseExpandTradeSkillSubClass = ExpandTradeSkillSubClass;
ExpandTradeSkillSubClass = SPF2.ExpandTradeSkillSubClass;
--Collapse header
SPF2.baseCollapseTradeSkillSubClass = CollapseTradeSkillSubClass;
CollapseTradeSkillSubClass = SPF2.CollapseTradeSkillSubClass;

--Crafting
TradeSkillCreateButton:SetScript("OnClick", SPF2.TradeSkillCreateButton_OnClick);
TradeSkillCreateAllButton:SetScript("OnClick", SPF2.TradeSkillCreateAllButton_OnClick);


--Details
SPF2.GameTooltip.baseSetTradeSkillItem = GameTooltip.SetTradeSkillItem;
GameTooltip.SetTradeSkillItem = SPF2.GameTooltip.SetTradeSkillItem;



--Links
SPF2.baseGetTradeSkillItemLink = GetTradeSkillItemLink;
GetTradeSkillItemLink = SPF2.GetTradeSkillItemLink;
SPF2.baseGetTradeSkillReagentItemLink = GetTradeSkillReagentItemLink;
GetTradeSkillReagentItemLink = SPF2.GetTradeSkillReagentItemLink;

--During SetSelection
SPF2.baseGetTradeSkillIcon = GetTradeSkillIcon;
GetTradeSkillIcon = SPF2.GetTradeSkillIcon;


SPF2.baseGetTradeSkillNumReagents = GetTradeSkillNumReagents;
GetTradeSkillNumReagents = SPF2.GetTradeSkillNumReagents;
SPF2.baseGetTradeSkillReagentInfo = GetTradeSkillReagentInfo;
GetTradeSkillReagentInfo = SPF2.GetTradeSkillReagentInfo;



--Indexing
SPF2.baseGetFirstTradeSkill = GetFirstTradeSkill;
GetFirstTradeSkill = SPF2.GetFirstTradeSkill;

SPF2.baseGetTradeSkillSelectionIndex = GetTradeSkillSelectionIndex;
GetTradeSkillSelectionIndex = SPF2.GetTradeSkillSelectionIndex;

SPF2.baseTradeSkillFrame_SetSelection = TradeSkillFrame_SetSelection;
TradeSkillFrame_SetSelection = SPF2.TradeSkillFrame_SetSelection;

--Crafting Modifiers
SPF2.baseGetTradeSkillNumMade = GetTradeSkillNumMade;
GetTradeSkillNumMade = SPF2.GetTradeSkillNumMade;
SPF2.baseGetTradeSkillTools = GetTradeSkillTools;
GetTradeSkillTools = SPF2.GetTradeSkillTools;

--MultiCrafting
SPF2.baseGetTradeskillRepeatCount = GetTradeskillRepeatCount;
GetTradeskillRepeatCount = SPF2.GetTradeskillRepeatCount;

--Hooks
hooksecurefunc("TradeSkillFrame_OnShow", SPF2.TradeSkillFrame_OnShow);
