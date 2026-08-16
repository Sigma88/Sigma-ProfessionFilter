if not TradeSkillFrameAvailableFilterCheckButton then -- CLASSIC
	SigmaProfessionFilter_RecipeInfo = SigmaProfessionFilter_RecipeInfo_classic;
elseif CraftFrame then -- TBC
	SigmaProfessionFilter_RecipeInfo = SigmaProfessionFilter_RecipeInfo_tbc;
else -- wotlk
	SigmaProfessionFilter_RecipeInfo = SigmaProfessionFilter_RecipeInfo_wotlk;
end

local RI = SigmaProfessionFilter_RecipeInfo;

RI.L = {};

RI.Skill = CreateFrame("Frame", nil, TradeSkillFrame);

if CraftFrame then
	RI.Craft = CreateFrame("Frame", nil, CraftFrame);
else
	RI.Craft = RI.Skill;
end
