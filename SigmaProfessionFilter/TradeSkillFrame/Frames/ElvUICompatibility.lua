-- ElvUI Compatibility

if ElvUI then
	local SPF2 = SigmaProfessionFilter[2];
	local E = unpack(ElvUI);
	local S = E:GetModule('Skins');

	-- TradeSkillFrame
	S:HandleCheckBox(SPF2.Filter1);
	S:HandleCheckBox(SPF2.Filter2);
	S:HandleCheckBox(SPF2.Unlearned.button);
	S:HandleCheckBox(SPF2.Starred.button);
	S:HandleCheckBox(SPF2.LeftSort);
	S:HandleCheckBox(SPF2.RightSort);
	S:HandleCheckBox(SPF2.Search);
	S:HandleEditBox(SPF2.SearchBox);
	SPF2.SearchBox:SetHeight(18);
	SPF2.SearchBox:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -44, -76);
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
        SPF2.SearchBox:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -50, -49);
    end

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
	
	for i=1, MAX_TRADE_SKILL_REAGENTS do
		local reagentButton = _G["TradeSkillReagent"..i];
		local createButton = _G["TradeSkillReagent"..i.."CreateButton"];
		if createButton then
			createButton:SetWidth(reagentButton:GetWidth() - 4);
			local a,b,c,x,y = createButton:GetPoint();
			createButton:ClearAllPoints();
			createButton:SetPoint(a,b,c,x,y-1);
			S:HandleButton(createButton);
		end
	end
	
	TradeSkillRankFrame:HookScript("OnShow", SPF2.TradeSkillRankFrameFix);
end
