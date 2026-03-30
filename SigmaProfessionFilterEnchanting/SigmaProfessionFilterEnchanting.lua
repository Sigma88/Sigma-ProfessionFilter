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
	[05] = INVSLOT_CHEST;
	[08] = INVSLOT_FEET;
	[09] = INVSLOT_WRIST;
	[10] = INVSLOT_HAND;
	[15] = INVSLOT_BACK;
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

local _ActionButton_ShowOverlayGlow = ActionButton_ShowOverlayGlow;
local _ActionButton_HideOverlayGlow = ActionButton_HideOverlayGlow

local ClassicSlotNames = {
	[INVSLOT_CHEST] = "CharacterChestSlot",
	[INVSLOT_FEET] = "CharacterFeetSlot",
	[INVSLOT_WRIST] = "CharacterWristSlot",
	[INVSLOT_HAND] = "CharacterHandsSlot",
	[INVSLOT_BACK] = "CharacterBackSlot",
}

local slotGlow = {}

local function GetOrCreateSlotGlowButton(slotId)
	local slotName = ClassicSlotNames[slotId]
	if not slotName then
		return nil
	end

	local button = _G[slotName]
	if not button then
		return nil
	end

	if not slotGlow[slotId] then
		slotGlow[slotId] = button:CreateTexture(nil, "OVERLAY")
		slotGlow[slotId]:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
		slotGlow[slotId]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
		slotGlow[slotId]:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
		slotGlow[slotId]:SetVertexColor(1, 0.8, 0, 0.8)
		slotGlow[slotId]:Hide()
	end

	return slotGlow[slotId]
end

local function ShowSlotGlow(slotId)
	if _ActionButton_ShowOverlayGlow then
		_ActionButton_ShowOverlayGlow(InvButtons[slotId])
	end
	if not _ActionButton_ShowOverlayGlow then
		local glow = GetOrCreateSlotGlowButton(slotId)
		if glow then
			glow:Show()
		end
	end
end

local function HideSlotGlow(slotId)
	if _ActionButton_HideOverlayGlow then
		_ActionButton_HideOverlayGlow(InvButtons[slotId])
	end
	if not _ActionButton_HideOverlayGlow then
		local glow = GetOrCreateSlotGlowButton(slotId)
		if glow then
			glow:Hide()
		end
	end
end

if not _ActionButton_ShowOverlayGlow then
	_ActionButton_ShowOverlayGlow = function() end
end
if not _ActionButton_HideOverlayGlow then
	_ActionButton_HideOverlayGlow = function() end
end

local InvSlotHighlight = function()
	local craftName = GetCraftInfo(GetCraftSelectionIndex());
	CraftCreateButton:SetText(ENSCRIBE);
	for i,slot in pairs(InvSlots) do
		if GetCraftName() == L["PROFESSION"] and CraftFrame:IsVisible() and CraftCreateButton:IsEnabled() and strfind(craftName or "", L[slot]) then
			ShowSlotGlow(i)
			if CharacterFrame:IsVisible() then
				CraftCreateButton:SetText(L["SELF_ENCH"]);
			end
		else
			HideSlotGlow(i)
		end
	end
end

hooksecurefunc("DoCraft", AutoEnchant);
hooksecurefunc("CraftFrame_Update", InvSlotHighlight);
CharacterFrame:HookScript("OnShow", InvSlotHighlight);
CharacterFrame:HookScript("OnHide", InvSlotHighlight);
hooksecurefunc("CloseCraft", InvSlotHighlight);
