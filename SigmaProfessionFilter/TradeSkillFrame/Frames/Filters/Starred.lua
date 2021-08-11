local L = SigmaProfessionFilter.L;
local SPF2 = SigmaProfessionFilter[2];

SPF2.Starred = CreateFrame("Frame", nil, TradeSkillFrame);

function SPF2.Starred.OnLoad()
	SPF2.Starred:SetWidth(27);
	SPF2.Starred:SetHeight(15);
	SPF2.Starred:SetFrameLevel(4);
	SPF2.CheckBoxBar:AddButton(SPF2.Starred);
	
	SPF2.Starred:SetScript("OnShow", SPF2.Starred.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.Starred.OnShow);
	
	local button = CreateFrame("CheckButton", nil, SPF2.Starred, "UICheckButtonTemplate");
	button:SetWidth(15);
	button:SetHeight(15);
	button:SetPoint("LEFT", SPF2.Starred, "LEFT", 0, 0);
	button:SetHitRectInsets(0, -15, 0, 0);
	
	button:SetScript("OnClick", SPF2.Starred.OnClick);
	button:SetScript("OnEnter", SPF2.Starred.OnEnter);
	button:SetScript("OnLeave", SPF2.Starred.OnLeave);
	
	local icon = CreateFrame("Frame", nil, SPF2.Starred);
	icon:SetWidth(14);
	icon:SetHeight(14);
	icon:SetPoint("TOPRIGHT", SPF2.Starred, "TOPRIGHT", 0, 0);
	
	local texture = icon:CreateTexture(nil, "ARTWORK");
	texture:SetTexture("Interface/Common/ReputationStar", false);
	texture:SetAllPoints();
	texture:SetTexCoord(0,0.5,0,0.5);
	
	SPF2.Starred.button = button;
	SPF2.Starred.icon = icon;
	SPF2.Starred.texture = texture;
end

function SPF2.Starred:OnShow()
	
	SPF2.Starred:Show();
	
	if not(SPF2:Custom("Starred")["disabled"]) then
		SPF2.Starred.tooltipText = L["STARRED_TOOLTIP"] or "Toggle Starred Recipes Filter";
		SPF2.Starred.button:SetChecked(SPF2:SavedData()["Starred"]);
		SPF2.Starred.disabled = nil;
	else
		SPF2.Starred:Hide();
		SPF2.Starred.disabled = true;
	end
end

function SPF2.Starred.OnClick()
	
	if (SPF2.Starred.button:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF2:SavedData()["Starred"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF2:SavedData()["Starred"] = nil;
	end
	
	TradeSkillFrame_OnShow();
	SPF2.FullUpdate();
end

function SPF2.Starred.OnEnter()
    if (SPF2.Starred.tooltipText) then
        GameTooltip:SetOwner(SPF2.Starred, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF2.Starred.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF2.Starred.OnLeave()
    GameTooltip:Hide();
end

function SPF2.Starred.OnUpdate()
	for i=1, TRADE_SKILLS_DISPLAYED do
		local button = _G["TradeSkillSkill"..i];
		if button then
			local star = _G["TradeSkillSkill"..i.."Star"];
			if not star then
				-- star = CreateFrame("Frame", "TradeSkillSkill"..i.."Star", button);
				star = CreateFrame("CheckButton", "TradeSkillSkill"..i.."Star", button, "UICheckButtonTemplate");
				star:SetWidth(button:GetHeight());
				star:SetHeight(button:GetHeight());
				star:SetFrameLevel(4);
				
				function star:OnClick()
					if not SPF2:SavedData()["StarredRecipes"] then
						SPF2:SavedData()["StarredRecipes"] = {};
					end
					SPF2:SavedData()["StarredRecipes"][GetTradeSkillInfo(button:GetID())] = star:GetChecked();
				end
				star:SetScript("OnClick", star.OnClick);
				
				star.normal = star:CreateTexture(nil, "ARTWORK");
				star.normal:SetTexture("Interface/Common/ReputationStar", false);
				star.normal:SetAllPoints();
				star.normal:SetTexCoord(0.5,1,0,0.5);
				
				star.checked = star:CreateTexture(nil, "ARTWORK");
				star.checked:SetTexture("Interface/Common/ReputationStar", false);
				star.checked:SetAllPoints();
				star.checked:SetTexCoord(0,0.5,0,0.5);
				
				star.highlight = star:CreateTexture(nil, "ARTWORK");
				star.highlight:SetTexture("Interface/Common/ReputationStar", false);
				star.highlight:SetAllPoints();
				star.highlight:SetTexCoord(0,0.5,0.5,1);
				
				star.pushed = star:CreateTexture(nil, "ARTWORK");
				star.pushed:SetTexture("Interface/Common/ReputationStar", false);
				star.pushed:SetAllPoints();
				star.pushed:SetTexCoord(0,0.5,0.5,1);
				
				star:SetNormalTexture(star.normal);
				star:SetCheckedTexture(star.checked);
				star:SetHighlightTexture(star.highlight);
				star:SetPushedTexture(star.pushed);
			end
			star:ClearAllPoints();
			if TradeSkillListScrollFrameScrollBar:IsVisible() or (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On")then
				star:SetPoint("RIGHT", button, "RIGHT", 0, 0);
			else
				star:SetPoint("RIGHT", button, "RIGHT", -7, 0);
			end
			
			local skillName, skillType = GetTradeSkillInfo(button:GetID());
			
			if skillType == "header" then
				star:Hide();
			else
				star:Show();
			end
			
			star:SetChecked(SPF2:SavedData()["StarredRecipes"] and SPF2:SavedData()["StarredRecipes"][skillName]);
		end
	end
end

function SPF2.Starred:Filter(skillName)
	
	if not SPF2.Starred.button:GetChecked() or not skillName then
		return true;
	end
	
	if SPF2:SavedData()["StarredRecipes"] and SPF2:SavedData()["StarredRecipes"][skillName] then
		return true;
	end
	
	return false;
end

SPF2.Starred.OnLoad();
