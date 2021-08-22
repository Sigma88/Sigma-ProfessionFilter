-- Local Tables
local RI = SigmaProfessionFilter_RecipeInfo;

-- CraftFrame
RI.Craft = {};

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
RI.TradeSkill = CreateFrame("Frame", nil, TradeSkillFrame);

function RI.TradeSkill.Localize()
	if not RI.TradeSkill.LOCALIZE then
		RI.TradeSkill.LOCALIZE = true;
		return;
	end
	local localName = GetTradeSkillName();
	if not RI.Data[localName] then
		for i=1, 5, 1 do
			local link = GetTradeSkillRecipeLink(i);
			if link then
				local spellID = tonumber(link:match("enchant:(%d*)"));
				if spellID then
					for usName,Data in pairs(RI.Data) do
						if Data[spellID] then
							RI.Data[localName] = RI.Data[usName];
							RI.LoadIntoCache(localName);
							TradeSkillFrame_OnShow();
							return;
						end
					end
				end
			end
		end
	end
end

function RI.TradeSkill.Reset()
	RI.TradeSkill.LOCALIZE = nil;
end

RI.TradeSkill:SetScript("OnHide", RI.TradeSkill.Reset);
hooksecurefunc("TradeSkillFrame_OnShow", RI.TradeSkill.Localize);
