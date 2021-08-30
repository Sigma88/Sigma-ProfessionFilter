local L = SigmaProfessionFilter.L;
local SPF1 = SigmaProfessionFilter[1];

SPF1.Starred = CreateFrame("Frame", nil, CraftFrame);

function SPF1.Starred.OnLoad()
	SPF1.Starred:SetWidth(27);
	SPF1.Starred:SetHeight(15);
	SPF1.Starred:SetFrameLevel(4);
	SPF1.CheckBoxBar:AddButton(SPF1.Starred);
	
	SPF1.Starred:SetScript("OnShow", SPF1.Starred.OnShow);
	hooksecurefunc("CraftFrame_OnShow", SPF1.Starred.OnShow);
	
	local button = CreateFrame("CheckButton", nil, SPF1.Starred, "UICheckButtonTemplate");
	button:SetWidth(15);
	button:SetHeight(15);
	button:SetPoint("LEFT", SPF1.Starred, "LEFT", 0, 0);
	button:SetHitRectInsets(0, -15, 0, 0);
	
	button:SetScript("OnClick", SPF1.Starred.OnClick);
	button:SetScript("OnEnter", SPF1.Starred.OnEnter);
	button:SetScript("OnLeave", SPF1.Starred.OnLeave);
	
	local icon = CreateFrame("Frame", nil, SPF1.Starred);
	icon:SetWidth(14);
	icon:SetHeight(14);
	icon:SetPoint("TOPRIGHT", SPF1.Starred, "TOPRIGHT", 0, 0);
	
	local texture = icon:CreateTexture(nil, "ARTWORK");
	texture:SetTexture("Interface/Common/ReputationStar", false);
	texture:SetAllPoints();
	texture:SetTexCoord(0,0.5,0,0.5);
	
	SPF1.Starred.button = button;
	SPF1.Starred.icon = icon;
	SPF1.Starred.texture = texture;
end

function SPF1.Starred:OnShow()
	
	SPF1.Starred:Show();
	
	if not(SPF1:Custom("Starred")["disabled"]) then
		SPF1.Starred.tooltipText = SPF1:Custom("Starred")["tooltip"] or L["STARRED_TOOLTIP"];
		SPF1.Starred.button:SetChecked(SPF1:SavedData()["Starred"]);
		SPF1.Starred.disabled = nil;
	else
		SPF1.Starred:Hide();
		SPF1.Starred.disabled = true;
	end
end

function SPF1.Starred.OnClick()
	
	if (SPF1.Starred.button:GetChecked()) then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
		SPF1:SavedData()["Starred"] = true;
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
		SPF1:SavedData()["Starred"] = nil;
	end
	
	CraftFrame_OnShow();
	SPF1.FullUpdate();
	SPF1.Starred.OnEnter();
end

function SPF1.Starred.OnEnter()
    if (SPF1.Starred.tooltipText) then
        GameTooltip:SetOwner(SPF1.Starred, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(SPF1.Starred.tooltipText, nil, nil, nil, nil, true);
    end
end

function SPF1.Starred.OnLeave()
    GameTooltip:Hide();
end

function SPF1.Starred.OnUpdate()
	if CraftFrame:IsVisible() then
	for i=1, CRAFTS_DISPLAYED do
		local button = _G["Craft"..i];
		if button then
			local star = _G["Craft"..i.."Star"];
			if not star then
				star = CreateFrame("CheckButton", "Craft"..i.."Star", button, "UICheckButtonTemplate");
				star:SetWidth(button:GetHeight());
				star:SetHeight(button:GetHeight());
				star:SetFrameLevel(4);
				
				function star:OnClick()
					if (star:GetChecked()) then
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX");
					else
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "SFX");
					end
					if not SPF1:SavedData()["StarredRecipes"] then
						SPF1:SavedData()["StarredRecipes"] = {};
					end
					local craftName, craftSubSpellName = GetCraftInfo(button:GetID());
					
					if craftName then
						if not SPF1:SavedData()["StarredRecipes"][craftName] then
							SPF1:SavedData()["StarredRecipes"][craftName] = {};
						end
						SPF1:SavedData()["StarredRecipes"][craftName][craftSubSpellName or ""] = star:GetChecked();
					end
					star:OnEnter();
				end
				star:SetScript("OnClick", star.OnClick);
				
				function star:OnEnter()
					GameTooltip:SetOwner(star, "ANCHOR_TOPLEFT");
					if star:GetChecked() then
						GameTooltip:SetText(L["UNSET_FAVORITE"], nil, nil, nil, nil, true);
					else
						GameTooltip:SetText(L["SET_FAVORITE"], nil, nil, nil, nil, true);
					end
				end
				star:SetScript("OnEnter", star.OnEnter);
				
				function star:OnLeave()
					GameTooltip:Hide();
				end
				star:SetScript("OnLeave", star.OnLeave);
				
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
			
			if CraftListScrollFrameScrollBar:IsVisible() then
				star:SetPoint("RIGHT", button, "RIGHT", 0, 0);
			elseif (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
				star:SetPoint("RIGHT", button, "RIGHT", 0, 0);
			else
				star:SetPoint("RIGHT", button, "RIGHT", -7, 0);
			end
			
			local craftName, craftSubSpellName, craftType = GetCraftInfo(button:GetID());
			
			if craftType == "header" then
				star:Hide();
			else
				star:Show();
			end
			
			if craftName then
				star:SetChecked(SPF1:SavedData()["StarredRecipes"] and SPF1:SavedData()["StarredRecipes"][craftName] and SPF1:SavedData()["StarredRecipes"][craftName][craftSubSpellName or ""]);
			end
		end
	end
	end
end

function SPF1.Starred:Filter(craftName, craftSubSpellName)
	
	if not SPF1.Starred.button:GetChecked() or not craftName then
		return true;
	end
	
	if SPF1:SavedData()["StarredRecipes"] and SPF1:SavedData()["StarredRecipes"][craftName] and SPF1:SavedData()["StarredRecipes"][craftName][craftSubSpellName or ""] then
		return true;
	end
	
	return false;
end

SPF1.Starred.OnLoad();
