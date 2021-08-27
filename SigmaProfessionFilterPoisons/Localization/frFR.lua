-- Thanks to user Javus-Amnennar for providing french localization

if GetLocale() == "frFR" then
	
	local _, L = ...;
	
	-- Profession
	L["PROFESSION"] = "Poisons";
	-- Left Menu
	L["LEFT_TITLE"] = "Tous les effets";
	L["LEFT_TOOLTIP"] = "Trie les poisons en fonction de l'effet induit à la cible.";
	-- Names
	L["LEFT_01_NAME"] = "Dégâts";
	L["LEFT_02_NAME"] = "Afaiblissement";
	L["LEFT_03_NAME"] = "Sans effet";
	-- Filters
	L["LEFT_01_FILTER"] = GetSpellInfo(8681)..";"..GetSpellInfo(2835);
	L["LEFT_02_FILTER"] = GetSpellInfo(3420)..";"..GetSpellInfo(5763)..";"..GetSpellInfo(13220);
	L["LEFT_03_FILTER"] = "";
	
	-- RIGHT Menu
	L["RIGHT_TITLE"] = "Toutes les sous-classes";
	L["RIGHT_TOOLTIP"] = "Trie les recettes en fonction du type d’objet produit.";
	-- Names
	L["RIGHT_01_NAME"] = "Poisons";
	L["RIGHT_02_NAME"] = "Composants";
	-- Filters
	L["RIGHT_01_FILTER"] = L["LEFT_01_FILTER"]..";"..L["LEFT_02_FILTER"];
	L["RIGHT_02_FILTER"] = "";
	
end
