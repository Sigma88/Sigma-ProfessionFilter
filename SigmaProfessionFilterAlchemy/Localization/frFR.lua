-- Thanks to user Javus-Amnennar for providing french localization

if GetLocale() == "frFR" then
	
	local _, L = ...;
	
	-- Profession
	L["PROFESSION"] = "Alchimie";
	-- Right Menu
	L["RIGHT_TITLE"] = "Toutes les sous-classes";
	L["RIGHT_TOOLTIP"] = "Trie les recettes en fonction du type d'objet produit.";
	-- Names
	L["RIGHT_01_NAME"] = "Elixirs";
	L["RIGHT_02_NAME"] = "Flacons";
	L["RIGHT_03_NAME"] = "Potions";
	L["RIGHT_04_NAME"] = "Transmutations";
	L["RIGHT_05_NAME"] = "Huile";
	L["RIGHT_06_NAME"] = "Ingénierie";
	L["RIGHT_07_NAME"] = "Couture";
	L["RIGHT_08_NAME"] = "Pierre";
	L["RIGHT_09_NAME"] = MISCELLANEOUS;
	-- Filters
	L["RIGHT_01_FILTER"] = "Elixir;Potion de sang de troll majeure";
	L["RIGHT_02_FILTER"] = "Flacon";
	L["RIGHT_03_FILTER"] = "Potion";
	L["RIGHT_04_FILTER"] = "Transmutation";
	L["RIGHT_05_FILTER"] = "Huile";
	L["RIGHT_06_FILTER"] = GetSpellInfo(11456);
	L["RIGHT_07_FILTER"] = GetSpellInfo(11473);
	L["RIGHT_08_FILTER"] = GetSpellInfo(11459)..";"..GetSpellInfo(17632);
	L["RIGHT_09_FILTER"] = "";
	
end
