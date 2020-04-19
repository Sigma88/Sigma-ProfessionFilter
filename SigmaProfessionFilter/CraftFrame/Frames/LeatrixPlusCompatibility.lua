function SPF:LeatrixPlusCompatibility()
	--LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		for i=1, CRAFTS_DISPLAYED do
			getglobal("Craft"..i):SetWidth(293);
		end
    end
end

hooksecurefunc("CraftFrame_Update", SPF.LeatrixPlusCompatibility);
