-- Local Tables
local RI = SigmaProfessionFilter_RecipeInfo;

-- Load all spells into the cache
for professionName,professionData in pairs(RI.Data) do
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
end
