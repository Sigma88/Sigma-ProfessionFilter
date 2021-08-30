-- Thanks to user Javus-Amnennar for providing french localization

if GetLocale() == "frFR" then
	
	local _, L = ...;
	
	-- Profession
	L["PROFESSION"] = "Fondre";
	-- Left Menu
	L["LEFT_TITLE"] = "Tous les matériaux";
	L["LEFT_TOOLTIP"] = "Trie les recettes en fonction du matériau produit.";
	-- Names
	L["LEFT_01_NAME"] = "Métaux";
	L["LEFT_02_NAME"] = "Alliages";
	L["LEFT_03_NAME"] = "Métaux rares";
	-- Filters
	L["LEFT_01_FILTER"] = "";
	L["LEFT_02_FILTER"] = GetSpellInfo(2659)..";"..GetSpellInfo(3569)..";"..GetSpellInfo(22967);
	L["LEFT_03_FILTER"] = GetSpellInfo(2658)..";"..GetSpellInfo(3308)..";"..GetSpellInfo(10098);
	-- Right Menu
	L["RIGHT_TITLE"] = "Tous les produits";
	L["RIGHT_TOOLTIP"] = "Trie les recettes en fonction de l'objet produit.";
	-- Names
	L["RIGHT_01_NAME"] = "Barres";
	-- Filters
	L["RIGHT_01_FILTER"] = "";
	
end
