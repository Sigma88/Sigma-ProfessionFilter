local SPF1 = SigmaProfessionFilter[1];

SPF1.SearchBox = CreateFrame("EditBox", nil, CraftFrame, "SearchBoxTemplate");

function SPF1.SearchBox:OnLoad()
	SPF1.SearchBox:SetWidth(260);
	SPF1.SearchBox:SetHeight(27);
	SPF1.SearchBox:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -44, -67);
	SPF1.SearchBox:SetFrameLevel(4);
	
	SPF1.SearchBox:SetScript("OnShow", SPF1.SearchBox.OnShow);
	SPF1.SearchBox:SetScript("OnEscapePressed", SPF1.SearchBox.OnEscapePressed);
	
	SPF1.SearchBox:HookScript("OnTextChanged", SPF1.SearchBox.OnTextChanged);
	CraftFrame:HookScript("OnHide", SPF1.SearchBox.Clear);
	StackSplitFrame:HookScript("OnShow", SPF1.SearchBox.StackSplitHandler);
	hooksecurefunc("ChatEdit_InsertLink", SPF1.SearchBox.InsertItemName)
	
    -- LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
        SPF1.SearchBox:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -50, -40);
		SPF1.SearchBox:SetWidth(300);
    end
end

function SPF1.SearchBox.StackSplitHandler()
	if SPF1.SearchBox:IsVisible() and SPF1.SearchBox:HasFocus() then
		StackSplitFrame:Hide()
	end
end

function SPF1.SearchBox.Clear()
	SPF1.SearchBox:SetText("");
end

function SPF1.SearchBox.OnShow()
	if SPF1:GetMenu("Left") or SPF1:GetMenu("Right") then
		if not SPF1:SavedData()["SearchBox"] then
			SPF1.SearchBox:Hide();
		end
	end
end

function SPF1.SearchBox.OnEscapePressed()
    SPF1.SearchBox:SetText("");
    SPF1.SearchBox:ClearFocus();
end

function SPF1.SearchBox.OnTextChanged()
    SPF1.FullUpdate();
end

function SPF1.SearchBox.InsertItemName(itemLink)
	if SPF1.SearchBox:IsVisible() and SPF1.SearchBox:HasFocus() then
		SPF1.SearchBox:Insert(GetItemInfo(itemLink));
	end
end

-- Return a string if the filter matches
function SPF1.SearchBox:Filter(craftIndex)
	if SPF1:Custom("SearchBox")["Filter"] then
		return SPF1:Custom("SearchBox")["Filter"](craftIndex);
	else
		return SPF1:FilterWithSearchBox(craftIndex);
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

SPF1.SearchBox:OnLoad();
