-- Default Language (English) --

SigmaProfessionFilter.L = {
	
	-- CraftFrame\Frames\Filters\Filter1.lua
	-- TradeSkillFrame\Frames\Filters\Filter1.lua
	["HAS_SKILL_UP"] = TRADESKILL_FILTER_HAS_SKILL_UP;
	["HAS_SKILL_UP_TOOLTIP"] = "Only show the recipes that can make your skill go up.";
	
	-- CraftFrame\Frames\Filters\Filter2.lua
	-- TradeSkillFrame\Frames\Filters\Filter2.lua
	["HAVE_MATS"] = CRAFT_IS_MAKEABLE;
	["HAVE_MATS_TOOLTIP"] = CRAFT_IS_MAKEABLE_TOOLTIP;
	["Filter2RightClickON"] = function() return "|cffbc5ff4[Sigma-ProfessionFilter]|r: Recursive '"..SigmaProfessionFilter[2].Filter2.text:GetText().."' = |cff00ff00ON|r"; end;
	["Filter2RightClickOFF"] = function() return "|cffbc5ff4[Sigma-ProfessionFilter]|r: Recursive '"..SigmaProfessionFilter[2].Filter2.text:GetText().."' = |cffff0000OFF|r"; end;
	
	-- CraftFrame\Frames\TextSearch\Search.lua
	-- TradeSkillFrame\Frames\TextSearch\Search.lua
	["SEARCH"] = SEARCH;
	["SEARCH_TOOLTIP"] = "Toggle the Search Box.";
	
	-- TradeSkillFrame\Frames\DropDowns\LeftSort.lua
	["ALL_SUBCLASSES_TOOLTIP"] = "Sort recipes by the sub-class of the crafted item.";
	-- TradeSkillFrame\Frames\DropDowns\RightSort.lua
	["ALL_INVENTORY_SLOTS_TOOLTIP"] = "Sort recipes by the inventory slot of the crafted item.";
	
	-- TradeSkillFrame\Core\Utility.lua
	["Mining_SpellName"] = "Smelting";
};
