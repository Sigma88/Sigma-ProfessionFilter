function SPF1:LeatrixPlusCompatibility()
	--LeatrixPlus compatibility
    if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
		for i=1, CRAFTS_DISPLAYED do
			_G["Craft"..i]:SetWidth(293);
		end
		
		if SPF1.Headers and #SPF1.Headers == 0 and SPF1.FIRST then
			Craft1:ClearAllPoints();
			Craft1:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 22, -81);
			if SPF1.Data and #SPF1.Data > 22  then
				Craft23:Show();
			end
		else
			Craft1:ClearAllPoints();
			Craft1:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 22, -96);
			if Craft23 then
				Craft23:Hide();
			end
		end
    end
end

hooksecurefunc("CraftFrame_Update", SPF1.LeatrixPlusCompatibility);

if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
	CraftExpandTabRight:Hide();
	CraftExpandTabMiddle:Hide();
	CraftExpandTabLeft:Hide();
	CRAFTS_DISPLAYED = 9;
	Craft9 = CreateFrame("Button", "Craft9", CraftFrame, "CraftButtonTemplate");
	Craft9:SetID(9);
	Craft9:Hide();
	Craft9:ClearAllPoints();
	Craft9:SetPoint("TOPLEFT", Craft8, "BOTTOMLEFT", 0, 0);
end
