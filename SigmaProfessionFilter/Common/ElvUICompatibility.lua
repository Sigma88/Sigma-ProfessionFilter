local _G = _G;
local unpack, pairs = _G.unpack, _G.pairs;

if not _G.AddOnSkins then return end
local AS = unpack(_G.AddOnSkins)
if not AS:CheckAddOn("SigmaProfessionFilter") then return end

function AS:SigmaProfessionFilter()
	-- CraftFrame
	AS:SkinRadioButton(SPF.Filter1);
	AS:SkinRadioButton(SPF.Filter2);
	AS:SkinRadioButton(SPF.LeftSort);
	AS:SkinRadioButton(SPF.RightSort);
	AS:SkinRadioButton(SPF.Search);
	AS:SkinEditBox(SPF.SearchBox);
	-- TradeSkillFrame
	AS:SkinRadioButton(SPF2.Filter1);
	AS:SkinRadioButton(SPF2.Filter2);
	AS:SkinRadioButton(SPF2.LeftSort);
	AS:SkinRadioButton(SPF2.RightSort);
	AS:SkinRadioButton(SPF2.Search);
	AS:SkinEditBox(SPF2.SearchBox);
	
	CraftRankFrame:ClearAllPoints();
	TradeSkillRankFrame:ClearAllPoints();
	if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
		AS:SkinDropDownBox(SPF.LeftMenu, 170);
		AS:SkinDropDownBox(SPF.RightMenu, 170);
		AS:SkinDropDownBox(SPF2.LeftMenu, 170);
		AS:SkinDropDownBox(SPF2.RightMenu, 170);
		CraftRankFrame:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 24, -37);
		TradeSkillRankFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 24, -37);
	else
		AS:SkinDropDownBox(SPF.LeftMenu, 155);
		AS:SkinDropDownBox(SPF.RightMenu, 155);
		AS:SkinDropDownBox(SPF2.LeftMenu, 155);
		AS:SkinDropDownBox(SPF2.RightMenu, 155);
		CraftRankFrame:SetPoint("TOP", CraftFrame, "TOP", -9.856, -37);
		TradeSkillRankFrame:SetPoint("TOP", TradeSkillFrame, "TOP", -9.856, -37);
	end
end

AS:RegisterSkin("SigmaProfessionFilter", AS.SigmaProfessionFilter);
