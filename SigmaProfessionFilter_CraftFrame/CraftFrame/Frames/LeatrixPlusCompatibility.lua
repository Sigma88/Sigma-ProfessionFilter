--LeatrixPlus compatibility

if LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On" then
	CraftExpandTabLeft:Hide();
	CraftExpandTabMiddle:Hide();
	CraftExpandTabRight:Hide();
	CRAFTS_DISPLAYED = 9;
	Craft9 = CreateFrame("Button", "Craft9", CraftFrame, "CraftButtonTemplate");
	Craft9:SetID(9);
	Craft9:Hide();
	Craft9:ClearAllPoints();
	Craft9:SetPoint("TOPLEFT", Craft8, "BOTTOMLEFT", 0, 0);
end
