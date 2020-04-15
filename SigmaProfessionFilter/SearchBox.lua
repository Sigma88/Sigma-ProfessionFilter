function SPF_SearchBox_OnLoad()
	hooksecurefunc("ChatEdit_InsertLink", SPF_SearchBox_InsertItemName)
	CraftFrame:HookScript("OnHide", SPF_SearchBox_Clear);
	StackSplitFrame:HookScript("OnShow", SPF_SearchBox_StackSplitHandler);
	
    -- LeatrixPlus compatibility
    if (not (LeaPlusDB == nil) and LeaPlusDB["EnhanceProfessions"] == "On") then
        SPF_SearchBox:SetPoint("TOPRIGHT", CraftFrame, "TOPRIGHT", -50, -40);
		SPF_SearchBox:SetWidth(300);
    end
end

function SPF_SearchBox_StackSplitHandler()
	if SPF_SearchBox:IsVisible() and SPF_SearchBox:HasFocus() then
		StackSplitFrame:Hide()
	end
end

function SPF_SearchBox_Clear()
	SPF_SearchBox:SetText("");
end

function SPF_SearchBox_OnShow()
	
	-- Check if the profession is supported
	local Profession = SPF[GetCraftDisplaySkillLine()];
	
	if Profession and (Profession["Left"] or Profession["Right"]) then
		if not Sigma_ProfessionFilter_SearchBox then
			SPF_SearchBox:Hide();
		end
	end
end

function SPF_SearchBox_OnUpdate()
	if not Sigma_ProfessionFilter_SearchBox then
		SPF_SearchBox:Hide();
	else
		SPF_SearchBox:Show();
	end
end

function SPF_SearchBox_OnEscapePressed()
    SPF_SearchBox:SetText("");
    SPF_SearchBox:ClearFocus();
end

function SPF_SearchBox_OnTextChanged()
    SPF_FullUpdate();
end

function SPF_SearchBox_InsertItemName(itemLink)
	if SPF_SearchBox:IsVisible() and SPF_SearchBox:HasFocus() then
		SPF_SearchBox:Insert(GetItemInfo(itemLink));
	end
end
