-- Thanks to user Javus-Amnennar for providing french localization

if GetLocale() == "frFR" then
	
	local L = SigmaProfessionFilter.L;
	
	-- CraftFrame\Frames\Filters\Filter1.lua
	-- TradeSkillFrame\Frames\Filters\Filter1.lua
	L["MORE_OPTIONS"] = "Effectuez un clic droit pour activer des options supplémentaires.";
	L["TradeSkillFilter1RightClick"] = "Niveau de progrès : ";
	L["ORANGE"] = "Maximal";
	L["YELLOW"] = "Moyen";
	L["GREEN"] = "Faible";
	L["HAS_SKILL_UP"] = "Gain de compétence";
	L["HAS_SKILL_UP_TOOLTIP"] = "Ne montrer que les recettes qui peuvent monter votre compétence de métier.";
	
	-- CraftFrame\Frames\Filters\Filter2.lua
	-- TradeSkillFrame\Frames\Filters\Filter2.lua
	L["HAVE_MATS"] = "Concevable";
	L["HAVE_MATS_TOOLTIP"] = CRAFT_IS_MAKEABLE_TOOLTIP;
	L["TradeSkillFilter2RightClickON"] = "Récurrence 'posséder les composants' = |cff00ff00ACTIVÉ|r";
	L["TradeSkillFilter2RightClickOFF"] = "Récurrence 'posséder les composants' = |cffff0000DESACTIVÉ|r";
	
	-- CraftFrame\Frames\TextSearch\Search.lua
	-- TradeSkillFrame\Frames\TextSearch\Search.lua
	L["SEARCH"] = "Rechercher";
	L["SEARCH_TOOLTIP"] = "Affiche la barre de recherche.";
	
	-- TradeSkillFrame\Frames\DropDowns\LeftSort.lua
	L["ALL_SUBCLASSES_TOOLTIP"] = "Trie les recettes en fonction de la catégorie d'objet produit.";
	-- TradeSkillFrame\Frames\DropDowns\RightSort.lua
	L["ALL_INVENTORY_SLOTS_TOOLTIP"] = "Trie les recettes en fonction de l’emplacement d’inventaire de l’objet produit.";
	
	-- TradeSkillFrame\Core\Utility.lua
	L["Mining_SpellName"] = "Fondre";
	L["CRAFT_REAGENT"] = "Produire composant";
	
end
