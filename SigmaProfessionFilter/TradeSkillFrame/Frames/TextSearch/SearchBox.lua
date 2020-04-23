SPF2.SearchBox = CreateFrame("EditBox", nil, TradeSkillFrame, "SearchBoxTemplate");

function SPF2.SearchBox.OnLoad()
	SPF2.SearchBox:SetWidth(260);
	SPF2.SearchBox:SetHeight(27);
	SPF2.SearchBox:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -44, -67);
	SPF2.SearchBox:SetFrameLevel(4);
	
	SPF2.SearchBox:SetScript("OnShow", SPF2.SearchBox.OnShow);
	hooksecurefunc("TradeSkillFrame_OnShow", SPF2.SearchBox.OnShow);
	
	SPF2.SearchBox:SetScript("OnEscapePressed", SPF2.SearchBox.OnEscapePressed);
	SPF2.SearchBox:HookScript("OnTextChanged", SPF2.SearchBox.OnTextChanged);
	TradeSkillFrame:HookScript("OnHide", SPF2.SearchBox.Clear);
	StackSplitFrame:HookScript("OnShow", SPF2.SearchBox.StackSplitHandler);
	hooksecurefunc("ChatEdit_InsertLink", SPF2.SearchBox.InsertItemName)
	
    -- LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
        SPF2.SearchBox:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -50, -40);
		SPF2.SearchBox:SetWidth(300);
    end
end

function SPF2.SearchBox.StackSplitHandler()
	if SPF2.SearchBox:IsVisible() and SPF2.SearchBox:HasFocus() then
		StackSplitFrame:Hide()
	end
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

function SPF2.SearchBox.OnEscapePressed()
    SPF2.SearchBox:SetText("");
    SPF2.SearchBox:ClearFocus();
end

function SPF2.SearchBox.OnTextChanged()
    SPF2.FullUpdate();
	--CraftFrame_Update();
end

function SPF2.SearchBox.InsertItemName(itemLink)
	if SPF2.SearchBox:IsVisible() and SPF2.SearchBox:HasFocus() then
		SPF2.SearchBox:Insert(GetItemInfo(itemLink));
	end
end

-- Return a string if the filter matches
function SPF2.SearchBox:Filter(skillIndex)	
	if SPF2:Custom("SearchBox")["Filter"] then
		return SPF2:Custom("SearchBox")["Filter"];
	else
		return SPF2:FilterWithSearchBox(skillIndex);
	end
end

SPF2.SearchBox.OnLoad();
