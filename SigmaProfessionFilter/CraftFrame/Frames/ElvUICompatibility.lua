-- ElvUI Compatibility

if ElvUI then
	local SPF1 = SigmaProfessionFilter[1];
	local E = unpack(ElvUI);
	local S = E:GetModule('Skins');

	S:HandleCheckBox(SPF1.Filter1);
	S:HandleCheckBox(SPF1.Filter2);
	S:HandleCheckBox(SPF1.LeftSort);
	S:HandleCheckBox(SPF1.RightSort);
	S:HandleCheckBox(SPF1.Search);
	S:HandleEditBox(SPF1.SearchBox);

	if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
		S:HandleDropDownBox(SPF1.LeftMenu, 170);
		S:HandleDropDownBox(SPF1.RightMenu, 170);
	else
		S:HandleDropDownBox(SPF1.LeftMenu, 155);
		S:HandleDropDownBox(SPF1.RightMenu, 155);
	end
	
	function SPF1:RankFrameFix()
		CraftRankFrame:ClearAllPoints();
		if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
			CraftRankFrame:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 24, -37);
		else
			CraftRankFrame:SetPoint("TOP", CraftFrame, "TOP", -9.856, -37);
		end
	end
	
	CraftRankFrame:HookScript("OnShow", SPF1.RankFrameFix);
end
