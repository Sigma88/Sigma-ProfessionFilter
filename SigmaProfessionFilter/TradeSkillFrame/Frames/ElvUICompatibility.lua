-- ElvUI Compatibility

if ElvUI then
	local SPF2 = SigmaProfessionFilter[2];
	local E = unpack(ElvUI);
	local S = E:GetModule('Skins');

	-- TradeSkillFrame
	S:HandleCheckBox(SPF2.Filter1);
	S:HandleCheckBox(SPF2.Filter2);
	S:HandleCheckBox(SPF2.LeftSort);
	S:HandleCheckBox(SPF2.RightSort);
	S:HandleCheckBox(SPF2.Search);
	S:HandleEditBox(SPF2.SearchBox);

	if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
		S:HandleDropDownBox(SPF2.LeftMenu, 170);
		S:HandleDropDownBox(SPF2.RightMenu, 170);
	else
		S:HandleDropDownBox(SPF2.LeftMenu, 155);
		S:HandleDropDownBox(SPF2.RightMenu, 155);
	end
	
	function SPF2:TradeSkillRankFrameFix()
		TradeSkillRankFrame:ClearAllPoints();
		if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
			TradeSkillRankFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 24, -37);
		else
			TradeSkillRankFrame:SetPoint("TOP", TradeSkillFrame, "TOP", -9.856, -37);
		end
	end
	
	TradeSkillRankFrame:HookScript("OnShow", SPF2.TradeSkillRankFrameFix);
end
