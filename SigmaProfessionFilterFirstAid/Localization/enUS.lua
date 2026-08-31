SigmaProfessionFilterFirstAid = {};
SigmaProfessionFilterFirstAid.L = {};
local L = SigmaProfessionFilterFirstAid.L;
local SPF = SigmaProfessionFilter[2];

-- Profession
L["PROFESSION"] = "First Aid";

-- Left Menu
L["LEFT_TITLE"] = "All Types";
L["LEFT_TOOLTIP"] = "Sort recipes by the type of item they produce.";
-- Names
L["LEFT_01_NAME"] = "Bandage";
L["LEFT_02_NAME"] = "Anti-Venom";
-- Filters
L["LEFT_01_FILTER"] = "Bandage";
L["LEFT_02_FILTER"] = "Venom";

-- Right Menu
L["RIGHT_TITLE"] = "All Reagents";
L["RIGHT_TOOLTIP"] = "Sort recipes by the reagents they require.";

-- Names
local names = {"Runecloth", "Mageweave", "Silk", "Wool", "Linen", "Venom Sac"};
local filters = {"Runecloth", "Mageweave", "Silk", "Wool", "Linen", "Venom"};
if not SPF.CLASSIC then
	table.insert(names, 1, "Netherweave");
	table.insert(filters, 1, "Netherweave");
end
if SPF.WRATH then
	table.insert(names, 1, "Frostweave");
	table.insert(filters, 1, "Frostweave");
end

for i,name in ipairs(names) do
	L["RIGHT_0"..i.."_NAME"] = name;
end
for i,filter in ipairs(filters) do
	L["RIGHT_0"..i.."_FILTER"] = filter;
end
