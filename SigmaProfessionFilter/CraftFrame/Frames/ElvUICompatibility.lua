-- ElvUI Compatibility

if ElvUI then
	local E = unpack(ElvUI);
	local S = E:GetModule('Skins');

	S:HandleCheckBox(SPF.Filter1);
	S:HandleCheckBox(SPF.Filter2);
	S:HandleCheckBox(SPF.LeftSort);
	S:HandleCheckBox(SPF.RightSort);
	S:HandleCheckBox(SPF.Search);
	S:HandleEditBox(SPF.SearchBox);

	if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
		S:HandleDropDownBox(SPF.LeftMenu, 170);
		S:HandleDropDownBox(SPF.RightMenu, 170);
	else
		S:HandleDropDownBox(SPF.LeftMenu, 155);
		S:HandleDropDownBox(SPF.RightMenu, 155);
	end
	
	function SPF:RankFrameFix()
		CraftRankFrame:ClearAllPoints();
		if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
			CraftRankFrame:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 24, -37);
		else
			CraftRankFrame:SetPoint("TOP", CraftFrame, "TOP", -9.856, -37);
		end
	end
	
	CraftRankFrame:HookScript("OnShow", SPF.RankFrameFix);
end
