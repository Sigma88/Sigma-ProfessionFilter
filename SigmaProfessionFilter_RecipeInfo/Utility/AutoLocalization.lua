-- Local Tables
local RI = SigmaProfessionFilter_RecipeInfo;

-- CraftFrame
RI.Craft.Localize = {};

function RI.Craft.Localize()
	
	local localName = GetCraftName();
	
	if not RI.Data[localName] then
		
		for i=1, 5, 1 do
			local link = GetCraftRecipeLink(i);
			if link then
				local spellID = tonumber(link:match("enchant:(%d*)"));
				if spellID then
					for usName,Data in pairs(RI.Data) do
						if Data[spellID] then
							RI.Data[localName] = RI.Data[usName];
							CraftFrame_OnShow();
							return;
						end
					end
				end
			end
		end
		
		RI.Data[localName] = {};
	end
end

hooksecurefunc("CraftFrame_OnShow", RI.Craft.Localize);


-- TradeSkillFrame
RI.TradeSkill = {};

function RI.TradeSkill.Localize()
	local localName = GetTradeSkillName();
	if not RI.Data[localName] then
		
		if not RI.LOCALIZE then
			RI.LOCALIZE = true;
			return;
		end
		
		RI.LOCALIZE = nil;
		
		for i=1, 5, 1 do
			local link = GetTradeSkillRecipeLink(i);
			if link then
				local spellID = tonumber(link:match("enchant:(%d*)"));
				if spellID then
					for usName,Data in pairs(RI.Data) do
						if Data[spellID] then
							RI.Data[localName] = RI.Data[usName];
							TradeSkillFrame_OnShow();
							return;
						end
					end
				end
			end
		end
	end
end

hooksecurefunc("TradeSkillFrame_OnShow", RI.TradeSkill.Localize);
