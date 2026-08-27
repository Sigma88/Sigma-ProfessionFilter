local SPF2 = SigmaProfessionFilter[2];

SPF2.SearchBox = CreateFrame("EditBox", nil, TradeSkillFrame, "InputBoxTemplate");

function SPF2.SearchBox.OnLoad()
	SPF2.SearchBox:SetWidth(260);
	SPF2.SearchBox:SetHeight(27);
	SPF2.SearchBox:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -44, -67);
	SPF2.SearchBox:SetFrameLevel(4);
	SPF2.SearchBox:SetAutoFocus(false);
	
	SPF2.SearchBox:SetScript("OnShow", SPF2.SearchBox.OnShow);
	SPF2["TSFOnShow"]["SPF2.SearchBox.OnShow"] = SPF2.SearchBox.OnShow;
	
	SPF2.SearchBox:SetScript("OnEscapePressed", SPF2.SearchBox.OnEscapePressed);
	SPF2.SearchBox:SetScript("OnEnterPressed", SPF2.SearchBox.OnEnterPressed);
	SPF2.SearchBox:SetScript("OnTextChanged", SPF2.SearchBox.OnTextChanged);
	SPF2.SearchBox:SetScript("OnEditFocusGained", function() SPF2.SearchBox.HasFocus = true; end);
	SPF2.SearchBox:SetScript("OnEditFocusLost", function() SPF2.SearchBox.HasFocus = false; end);
	TradeSkillFrame:SetScript("OnHide", SPF2.TradeSkillFrame_OnHide);
	SPF2.hooksecurefunc("ChatEdit_InsertLink", SPF2.SearchBox.InsertItemName)
	
	-- LeatrixPlus compatibility
	if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
		SPF2.SearchBox:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -50, -40);
		SPF2.SearchBox:SetWidth(300);
	end
end


function SPF2.TradeSkillFrame_OnHide()
	CloseTradeSkill();
	PlaySound("igCharacterInfoClose");
	SPF2.SearchBox.Clear();
end

function SPF2.SearchBox.Clear()
	SPF2.SearchBox:SetText("");
end

function SPF2.SearchBox:OnShow()
	SPF2.SearchBox:Show();
	
	if not SPF2:SavedData()["SearchBox"] then
		SPF2.SearchBox:Hide();
	end
end

function SPF2.SearchBox.OnEnterPressed()
	SPF2.SearchBox:ClearFocus();
end

function SPF2.SearchBox.OnEscapePressed()
	SPF2.SearchBox:SetText("");
	SPF2.SearchBox:ClearFocus();
end

function SPF2.SearchBox.OnTextChanged()
	SPF2.FullUpdate();
end

function SPF2.SearchBox.InsertItemName(itemLink)
	if SPF2.SearchBox:IsVisible() and SPF2.SearchBox.HasFocus then
		SPF2.SearchBox:Insert(SPF2.GetItemInfo(itemLink));
	end
end

-- Return a string if the filter matches
function SPF2.SearchBox:Filter(skillIndex)	
	if SPF2:Custom("SearchBox")["Filter"] then
		return SPF2:Custom("SearchBox")["Filter"](skillIndex);
	else
		return SPF2:FilterWithSearchBox(skillIndex);
	end
end

-- Return a string if the filter matches
function SPF2.SearchBox:FilterSpell(spellID)	
	if SPF2:Custom("SearchBox")["FilterSpell"] then
		return SPF2:Custom("SearchBox")["FilterSpell"](spellID);
	else
		return SPF2:FilterSpellWithSearchBox(spellID);
	end
end

if not TradeSkillFrame:IsVisible() then
	SPF2.TradeSkillFrame_OnHide();
end

SPF2.SearchBox.OnLoad();
