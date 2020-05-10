local _, L = ...;

-- Profession
L["PROFESSION"] = "Smelting";
-- Left Menu
L["LEFT_TITLE"] = "All Materials";
L["LEFT_TOOLTIP"] = "Sort recipes by the type of material they produce.";
-- Names
L["LEFT_01_NAME"] = "Metals";
L["LEFT_02_NAME"] = "Alloys";
L["LEFT_03_NAME"] = "Rare Metals";
-- Filters
L["LEFT_01_FILTER"] = "";
L["LEFT_02_FILTER"] = GetSpellInfo(2659)..";"..GetSpellInfo(3569)..";"..GetSpellInfo(22967);
L["LEFT_03_FILTER"] = GetSpellInfo(2658)..";"..GetSpellInfo(3308)..";"..GetSpellInfo(10098);
-- Right Menu
L["RIGHT_TITLE"] = "All Products";
L["RIGHT_TOOLTIP"] = "Sort recipes by the item they produce.";
-- Names
L["RIGHT_01_NAME"] = "Bars";
-- Filters
L["RIGHT_01_FILTER"] = "";
