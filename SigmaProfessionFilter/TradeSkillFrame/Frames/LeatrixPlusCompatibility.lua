--LeatrixPlus compatibility

if LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On" then
	TradeSkillExpandTabLeft:Hide();
	TradeSkillExpandTabMiddle:Hide();
	TradeSkillExpandTabRight:Hide();
	TRADE_SKILLS_DISPLAYED = 9;
	TradeSkillSkill9 = CreateFrame("Button", "TradeSkillSkill9", TradeSkillFrame, "TradeSkillSkillButtonTemplate");
	TradeSkillSkill9:SetID(9);
	TradeSkillSkill9:Hide();
	TradeSkillSkill9:ClearAllPoints();
	TradeSkillSkill9:SetPoint("TOPLEFT", TradeSkillSkill8, "BOTTOMLEFT", 0, 0);
end
