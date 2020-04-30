local _G = _G;
local unpack, pairs = _G.unpack, _G.pairs;

if not _G.AddOnSkins then return end
local AS = unpack(_G.AddOnSkins)
if not AS:CheckAddOn("SigmaProfessionFilter") then return end

function AS:SigmaProfessionFilter()
	-- CraftFrame
	AS:SkinRadioButton(SPF.Filter1);
	AS:SkinRadioButton(SPF.Filter2);
	AS:SkinDropDownBox(SPF.LeftMenu);
	AS:SkinRadioButton(SPF.LeftSort);
	AS:SkinDropDownBox(SPF.RightMenu);
	AS:SkinRadioButton(SPF.RightSort);
	AS:SkinRadioButton(SPF.Search);
	AS:SkinEditBox(SPF.SearchBox);
	-- TradeSkillFrame
	AS:SkinRadioButton(SPF2.Filter1);
	AS:SkinRadioButton(SPF2.Filter2);
	AS:SkinDropDownBox(SPF2.LeftMenu);
	AS:SkinRadioButton(SPF2.LeftSort);
	AS:SkinDropDownBox(SPF2.RightMenu);
	AS:SkinRadioButton(SPF2.RightSort);
	AS:SkinRadioButton(SPF2.Search);
	AS:SkinEditBox(SPF2.SearchBox);
end

AS:RegisterSkin("SigmaProfessionFilter", AS.SigmaProfessionFilter);
