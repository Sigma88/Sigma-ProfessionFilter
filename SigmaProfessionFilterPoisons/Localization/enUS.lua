local _, L = ...;

-- Profession
L["PROFESSION"] = "Poisons";
-- Left Menu
L["LEFT_TITLE"] = "All Effects";
L["LEFT_TOOLTIP"] = "Sort poisons by the effect they have on the target.";
-- Names
L["LEFT_01_NAME"] = "Damage";
L["LEFT_02_NAME"] = "Debuff";
L["LEFT_03_NAME"] = "No Effect";
-- Filters
L["LEFT_01_FILTER"] = GetSpellInfo(8681)..";"..GetSpellInfo(2835);
L["LEFT_02_FILTER"] = GetSpellInfo(3420)..";"..GetSpellInfo(5763)..";"..GetSpellInfo(13220);
L["LEFT_03_FILTER"] = "";

-- RIGHT Menu
L["RIGHT_TITLE"] = "All Types";
L["RIGHT_TOOLTIP"] = "Sort recipes by the type of item they produce.";
-- Names
L["RIGHT_01_NAME"] = "Poisons";
L["RIGHT_02_NAME"] = "Reagents";
-- Filters
L["RIGHT_01_FILTER"] = L["LEFT_01_FILTER"]..";"..L["LEFT_02_FILTER"];
L["RIGHT_02_FILTER"] = "";
