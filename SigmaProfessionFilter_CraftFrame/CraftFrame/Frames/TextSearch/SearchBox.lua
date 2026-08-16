local SPF1 = SigmaProfessionFilter[1];

SPF1.SearchBox = CreateFrame("EditBox", nil, CraftFrame, "InputBoxTemplate");

function SPF1.SearchBox.OnLoad()
	SPF1.SearchBox:SetWidth(260);
	SPF1.SearchBox:SetHeight(27);
	SPF1.SearchBox:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -44, -67);
	SPF1.SearchBox:SetFrameLevel(4);
	SPF1.SearchBox:SetAutoFocus(false);
	
	SPF1.SearchBox:SetScript("OnShow", SPF1.SearchBox.OnShow);
	SPF1["CFOnShow"]["SPF1.SearchBox.OnShow"] = SPF1.SearchBox.OnShow;
	
	SPF1.SearchBox:SetScript("OnEscapePressed", SPF1.SearchBox.OnEscapePressed);
	SPF1.SearchBox:SetScript("OnEnterPressed", SPF1.SearchBox.OnEnterPressed);
	SPF1.SearchBox:SetScript("OnTextChanged", SPF1.SearchBox.OnTextChanged);
	SPF1.SearchBox:SetScript("OnEditFocusGained", function() SPF1.SearchBox.HasFocus = true; end);
	SPF1.SearchBox:SetScript("OnEditFocusLost", function() SPF1.SearchBox.HasFocus = false; end);
	CraftFrame:SetScript("OnHide", SPF1.CraftFrame_OnHide);
	SPF1.hooksecurefunc("ChatEdit_InsertLink", SPF1.SearchBox.InsertItemName)
	
    -- LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
        SPF1.SearchBox:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -50, -40);
		SPF1.SearchBox:SetWidth(300);
    end
end


function SPF1.CraftFrame_OnHide()
	CloseCraft();
	PlaySound("igCharacterInfoClose");
	SPF1.SearchBox.Clear();
end

function SPF1.SearchBox.Clear()
	SPF1.SearchBox:SetText("");
end

function SPF1.SearchBox:OnShow()
	SPF1.SearchBox:Show();
	
	if not SPF1:SavedData()["SearchBox"] then
		SPF1.SearchBox:Hide();
	end
end

function SPF1.SearchBox.OnEnterPressed()
    SPF1.SearchBox:ClearFocus();
end

function SPF1.SearchBox.OnEscapePressed()
    SPF1.SearchBox:SetText("");
    SPF1.SearchBox:ClearFocus();
end

function SPF1.SearchBox.OnTextChanged()
    SPF1.FullUpdate();
end

function SPF1.SearchBox.InsertItemName(itemLink)
	if SPF1.SearchBox:IsVisible() and SPF1.SearchBox.HasFocus then
		SPF1.SearchBox:Insert(SPF1.GetItemInfo(itemLink));
	end
end

-- Return a string if the filter matches
function SPF1.SearchBox:Filter(skillIndex)	
	if SPF1:Custom("SearchBox")["Filter"] then
		return SPF1:Custom("SearchBox")["Filter"](skillIndex);
	else
		return SPF1:FilterWithSearchBox(skillIndex);
	end
end

-- Return a string if the filter matches
function SPF1.SearchBox:FilterSpell(spellID)	
	if SPF1:Custom("SearchBox")["FilterSpell"] then
		return SPF1:Custom("SearchBox")["FilterSpell"](spellID);
	else
		return SPF1:FilterSpellWithSearchBox(spellID);
	end
end

if not CraftFrame:IsVisible() then
	SPF1.CraftFrame_OnHide();
end

SPF1.SearchBox.OnLoad();
