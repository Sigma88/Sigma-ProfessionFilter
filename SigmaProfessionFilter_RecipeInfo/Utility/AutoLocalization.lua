-- Local Tables
local RI = SigmaProfessionFilter_RecipeInfo;
local L = RI.L;

-- CraftFrame
function RI.AutoLocalizeCraft()
	
	local localName = GetCraftName();
	
	if not RI.Data[name] then
		
		for i=1, 10, 1 do
			local craftName = GetCraftInfo(i);
			local _,_,_,_,_,_, spellID = GetSpellInfo(craftName);
			
			if spellID then
				for usName,Data in pairs(RI.Data) do
					if Data[spellID] then
						L[localName] = L[usName];
						return;
					end
				end
			end
		end
	end
end
RI.Craft:SetScript("OnShow", RI.AutoLocalizeCraft);


-- TradeSkillFrame
function RI.AutoLocalizeSkill()
	
	local localName = GetTradeSkillName();
	
	if not RI.Data[name] then
		for i=1, 10, 1 do
			local craftName = GetTradeSkillInfo(i);
			local _,_,_,_,_,_, spellID = GetSpellInfo(craftName);
			
			if spellID then
				for usName,Data in pairs(RI.Data) do
					if Data[spellID] then
						L[localName] = L[usName];
						return;
					end
				end
			end
		end
	end
end
RI.Skill:SetScript("OnShow", RI.AutoLocalizeSkill);
