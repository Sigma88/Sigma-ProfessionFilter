local _, L = ...;

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

hooksecurefunc("TradeSkillFrame_OnShow",
	function()
		if not L.Init1 then
			L.Init1 = true;
			L.GetItemInfo();
		end
	end
);

function L.GetItemInfo()
	-- Names
	L["RIGHT_01_NAME"] = GetItemInfo("\124Hitem:14047:");
	L["RIGHT_02_NAME"] = GetItemInfo("\124Hitem:4338:");
	L["RIGHT_03_NAME"] = GetItemInfo("\124Hitem:4306:");
	L["RIGHT_04_NAME"] = GetItemInfo("\124Hitem:2592:");
	L["RIGHT_05_NAME"] = GetItemInfo("\124Hitem:2589:");
	L["RIGHT_06_NAME"] = "Venom Sac";
	-- Filters
	L["RIGHT_01_FILTER"] = GetItemInfo("\124Hitem:14529:");
	L["RIGHT_02_FILTER"] = GetItemInfo("\124Hitem:8544:");
	L["RIGHT_03_FILTER"] = GetItemInfo("\124Hitem:6450:");
	L["RIGHT_04_FILTER"] = GetItemInfo("\124Hitem:3530:");
	L["RIGHT_05_FILTER"] = GetItemInfo("\124Hitem:1251:");
	L["RIGHT_06_FILTER"] = "Anti-Venom";
end
	
L.GetItemInfo();
