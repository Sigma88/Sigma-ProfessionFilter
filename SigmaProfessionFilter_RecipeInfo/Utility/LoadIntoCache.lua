-- Local Tables
local RI = SigmaProfessionFilter_RecipeInfo;

-- Load Into Cache
function RI.LoadIntoCache(professionName)
	local professionData = RI.Data[professionName];
	if professionData then
		for spellID,spell in pairs(professionData) do
			GetSpellInfo(spellID);
			GetSpellDescription(spellID);
			if spell["reagents"] then
				for i,item in ipairs(spell["reagents"]) do
					GetItemInfo(item["itemID"]);
				end
			end
			if spell["tools"] then
				for i,item in ipairs(spell["tools"]) do
					GetItemInfo(item);
				end
			end
			if spell["creates"] then
				GetItemInfo(spell["creates"]);
			end
		end
		return professionName;
	end
end


-- CraftFrame

local CraftCache = {};

CraftCache.Load = function()
	local professionName = GetCraftName();
	if CraftCache.LOADED ~= professionName then
		CraftCache.LOADED = RI.LoadIntoCache(professionName);
	end
end

hooksecurefunc("CraftFrame_OnShow", CraftCache.Load);


-- TradeSkillFrame

local TradeSkillCache = {};

TradeSkillCache.Load = function()
	local professionName = GetTradeSkillName();
	if TradeSkillCache.LOADED ~= professionName then
		TradeSkillCache.LOADED = RI.LoadIntoCache(professionName);
	end
end

hooksecurefunc("TradeSkillFrame_OnShow", TradeSkillCache.Load);
