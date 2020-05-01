SPF.SearchBox = CreateFrame("EditBox", nil, CraftFrame, "SearchBoxTemplate");

function SPF.SearchBox:OnLoad()
	SPF.SearchBox:SetWidth(260);
	SPF.SearchBox:SetHeight(27);
	SPF.SearchBox:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -44, -67);
	SPF.SearchBox:SetFrameLevel(4);
	
	SPF.SearchBox:SetScript("OnShow", SPF.SearchBox.OnShow);
	SPF.SearchBox:SetScript("OnEscapePressed", SPF.SearchBox.OnEscapePressed);
	
	SPF.SearchBox:HookScript("OnTextChanged", SPF.SearchBox.OnTextChanged);
	CraftFrame:HookScript("OnHide", SPF.SearchBox.Clear);
	StackSplitFrame:HookScript("OnShow", SPF.SearchBox.StackSplitHandler);
	hooksecurefunc("ChatEdit_InsertLink", SPF.SearchBox.InsertItemName)
	
    -- LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
        SPF.SearchBox:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -50, -40);
		SPF.SearchBox:SetWidth(300);
    end
end

function SPF.SearchBox.StackSplitHandler()
	if SPF.SearchBox:IsVisible() and SPF.SearchBox:HasFocus() then
		StackSplitFrame:Hide()
	end
end

function SPF.SearchBox.Clear()
	SPF.SearchBox:SetText("");
end

function SPF.SearchBox.OnShow()
	if SPF:GetMenu("Left") or SPF:GetMenu("Right") then
		if not SPF:SavedData()["SearchBox"] then
			SPF.SearchBox:Hide();
		end
	end
end

function SPF.SearchBox.OnEscapePressed()
    SPF.SearchBox:SetText("");
    SPF.SearchBox:ClearFocus();
end

function SPF.SearchBox.OnTextChanged()
    SPF.FullUpdate();
end

function SPF.SearchBox.InsertItemName(itemLink)
	if SPF.SearchBox:IsVisible() and SPF.SearchBox:HasFocus() then
		SPF.SearchBox:Insert(GetItemInfo(itemLink));
	end
end

-- Return a string if the filter matches
function SPF.SearchBox:Filter(craftIndex)
	if SPF:Custom("SearchBox")["Filter"] then
		return SPF:Custom("SearchBox")["Filter"];
	else
		return SPF:FilterWithSearchBox(craftIndex);
	end
end

SPF.SearchBox:OnLoad();
