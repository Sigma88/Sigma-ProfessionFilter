-- Local Tables
local RI = SigmaProfessionFilter_RecipeInfo;
local SPF = SigmaProfessionFilter;

local LocalTooltip = CreateFrame("GameTooltip", "SPFRILocalTooltip", WorldFrame, "GameTooltipTemplate");
LocalTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");

-- Load Into Cache
function RI.LoadIntoCache(professionName)
	local professionData = RI.Data[professionName];
	if professionData then
		for spellID,spell in pairs(professionData) do
			--GetSpellInfo(spellID);
			--GetSpellDescription(spellID);
			if spell["reagents"] then
				for i,item in ipairs(spell["reagents"]) do
					LocalTooltip:SetHyperlink("item:"..item["itemID"]);
				end
			end
			-- if spell["tools"] then
				-- for i,item in ipairs(spell["tools"]) do
					-- SPF[2].GetItemInfo(item);
				-- end
			-- end
			if spell["creates"] then
				LocalTooltip:SetHyperlink("item:"..spell["creates"]);
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

SPF[1]["CFOnShow"]["CraftCache.Load"] = CraftCache.Load;


-- TradeSkillFrame

local TradeSkillCache = {};

TradeSkillCache.Load = function()
	local professionName = GetTradeSkillName();
	if TradeSkillCache.LOADED ~= professionName then
		TradeSkillCache.LOADED = RI.LoadIntoCache(professionName);
	end
end

SPF[2]["TSFOnShow"]["TradeSkillCache.Load"] = TradeSkillCache.Load;
