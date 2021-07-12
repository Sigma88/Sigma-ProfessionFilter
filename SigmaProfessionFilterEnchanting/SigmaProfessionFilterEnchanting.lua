local _, L = ...;

SigmaProfessionFilter[L["PROFESSION"]] = {
	["LeftMenu"] = {
		["title"] = L["LEFT_TITLE"];
		["tooltip"] = L["LEFT_TOOLTIP"];
	};
	["Left"] = {
		[01] = { name = L["LEFT_01_NAME"]; filter = L["LEFT_01_FILTER"]; };
		[02] = { name = L["LEFT_02_NAME"]; filter = L["LEFT_02_FILTER"]; };
		[03] = { name = L["LEFT_03_NAME"]; filter = L["LEFT_03_FILTER"]; };
		[04] = { name = L["LEFT_04_NAME"]; filter = L["LEFT_04_FILTER"]; };
		[05] = { name = L["LEFT_05_NAME"]; filter = L["LEFT_05_FILTER"]; };
		[06] = { name = L["LEFT_06_NAME"]; filter = L["LEFT_06_FILTER"]; };
		[07] = { name = L["LEFT_07_NAME"]; filter = L["LEFT_07_FILTER"]; };
		[08] = { name = L["LEFT_08_NAME"]; filter = L["LEFT_08_FILTER"]; };
		[09] = { name = L["LEFT_09_NAME"]; filter = L["LEFT_09_FILTER"]; };
		[10] = { name = L["LEFT_10_NAME"]; filter = L["LEFT_10_FILTER"]; };
		[11] = { name = L["LEFT_11_NAME"]; filter = L["LEFT_11_FILTER"]; };
		[12] = { name = L["LEFT_12_NAME"]; filter = L["LEFT_12_FILTER"]; };
		[13] = { name = L["LEFT_13_NAME"]; filter = L["LEFT_13_FILTER"]; };
		[14] = { name = L["LEFT_14_NAME"]; filter = L["LEFT_14_FILTER"]; };
		[15] = { name = L["LEFT_15_NAME"]; filter = L["LEFT_15_FILTER"]; };
		[16] = { name = L["LEFT_16_NAME"]; filter = L["LEFT_16_FILTER"]; };
		[17] = { name = L["LEFT_17_NAME"]; filter = L["LEFT_17_FILTER"]; };
		[18] = { name = L["LEFT_18_NAME"]; filter = L["LEFT_18_FILTER"]; };
		[19] = { name = L["LEFT_19_NAME"]; filter = L["LEFT_19_FILTER"]; };
	};
	["RightMenu"] = {
		["title"] = L["RIGHT_TITLE"];
		["tooltip"] = L["RIGHT_TOOLTIP"];
	};
	["Right"] = {
		[01] = { name = L["RIGHT_01_NAME"]; filter = L["RIGHT_01_FILTER"]; };
		[02] = { name = L["RIGHT_02_NAME"]; filter = L["RIGHT_02_FILTER"]; };
		[03] = { name = L["RIGHT_03_NAME"]; filter = L["RIGHT_03_FILTER"]; };
		[04] = { name = L["RIGHT_04_NAME"]; filter = L["RIGHT_04_FILTER"]; };
		[05] = { name = L["RIGHT_05_NAME"]; filter = L["RIGHT_05_FILTER"]; };
		[06] = { name = L["RIGHT_06_NAME"]; filter = L["RIGHT_06_FILTER"]; };
		[07] = { name = L["RIGHT_07_NAME"]; filter = L["RIGHT_07_FILTER"]; };
		[08] = { name = L["RIGHT_08_NAME"]; filter = L["RIGHT_08_FILTER"]; };
		[09] = { name = L["RIGHT_09_NAME"]; filter = L["RIGHT_09_FILTER"]; };
		[10] = { name = L["RIGHT_10_NAME"]; filter = L["RIGHT_10_FILTER"]; };
		[11] = { name = L["RIGHT_11_NAME"]; filter = L["RIGHT_11_FILTER"]; };
		[12] = { name = L["RIGHT_12_NAME"]; filter = L["RIGHT_12_FILTER"]; };
	};
};

local InvSlots = {
	[05] = "RIGHT_01_FILTER";
	[08] = "RIGHT_02_FILTER";
	[09] = "RIGHT_03_FILTER";
	[10] = "RIGHT_04_FILTER";
	[15] = "RIGHT_05_FILTER";
}

local InvButtons = {
	[05] = CharacterChestSlot;
	[08] = CharacterFeetSlot;
	[09] = CharacterWristSlot;
	[10] = CharacterHandsSlot;
	[15] = CharacterBackSlot;
}

local AutoEnchant = function()
	if CharacterFrame:IsVisible() then
		local craftName = SigmaProfessionFilter[1].baseGetCraftInfo(GetCraftSelectionIndex());
		for i,slot in pairs(InvSlots) do
			if strfind(craftName, L[slot]) then
				return UseInventoryItem(i);
			end
		end
	end
end

local InvSlotHighlight = function()
	local craftName = GetCraftInfo(GetCraftSelectionIndex());
	CraftCreateButton:SetText(ENSCRIBE);
	for i,slot in pairs(InvSlots) do
		if GetCraftName() == L["PROFESSION"] and CraftFrame:IsVisible() and CraftCreateButton:IsEnabled() and strfind(craftName or "", L[slot]) then
			ActionButton_ShowOverlayGlow(InvButtons[i]);
			if CharacterFrame:IsVisible() then
				CraftCreateButton:SetText(L["SELF_ENCH"]);
			end
		else
			ActionButton_HideOverlayGlow(InvButtons[i]);
		end
	end
end

hooksecurefunc("DoCraft", AutoEnchant);
hooksecurefunc("CraftFrame_Update", InvSlotHighlight);
CharacterFrame:HookScript("OnShow", InvSlotHighlight);
CharacterFrame:HookScript("OnHide", InvSlotHighlight);
hooksecurefunc("CloseCraft", InvSlotHighlight);
