local SPF = SigmaProfessionFilter;
local SPF1 = SPF[1];
local SPFE = SigmaProfessionFilterEnchanting;
local L = SPFE.L;

SPFE.InvButtons = {
	[05] = CharacterChestSlot;
	[08] = CharacterFeetSlot;
	[09] = CharacterWristSlot;
	[10] = CharacterHandsSlot;
	[15] = CharacterBackSlot;
}

SPFE.InvSlots = {
	[05] = "RIGHT_01_FILTER";
	[08] = "RIGHT_02_FILTER";
	[09] = "RIGHT_03_FILTER";
	[10] = "RIGHT_04_FILTER";
	[15] = "RIGHT_05_FILTER";
}

function SPFE.AutoEnchant()
	if CharacterFrame:IsVisible() then
		local craftName = SPF1.GetCraftInfo(GetCraftSelectionIndex());
		for i,slot in pairs(SPFE.InvSlots) do
			if strfind(craftName, L[slot]) then
				SPFE.InvButtons[i]:Click();
				if StaticPopup1Button1:IsVisible() and SPF1.AutoReplaceOnSelfEnch then
					StaticPopup1Button1:Click();
				end
			end
		end
	end
end

function SPFE.DoCraft(index)
	SPFE.baseDoCraft(index);
	SPFE.AutoEnchant();
end
SPFE.baseDoCraft = DoCraft;
DoCraft = SPFE.DoCraft;

function SPFE.CraftCreateButton_OnEnter()
	GameTooltip:SetOwner(CraftCreateButton, "ANCHOR_BOTTOMRIGHT");
	if CraftCreateButton:GetText() == L["SELF_ENCH"] then
		GameTooltip:SetText(L["SELF_ENCH_TOOLTIP"], nil, nil, nil, nil, true);
	elseif GetCraftName() == L["PROFESSION"] then
		GameTooltip:SetText(L["ENCH_TOOLTIP"], nil, nil, nil, nil, true);
	end
	GameTooltip:AddLine(SPF.L["MORE_OPTIONS"], 0.69, 0.69, 0.69, 1);
	GameTooltip:Show();
end
CraftCreateButton:SetScript("OnEnter", SPFE.CraftCreateButton_OnEnter);

function SPFE.CraftCreateButton_OnLeave()
	GameTooltip:Hide();
end
CraftCreateButton:SetScript("OnLeave", SPFE.CraftCreateButton_OnLeave);

CraftCreateButton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
SPFE.baseCraftCreateButton_OnClick = SPF1.CraftCreateButton_OnClick;
function SPFE.CraftCreateButton_OnClick()
	if arg1 == "LeftButton" then
		SPFE.baseCraftCreateButton_OnClick();
	elseif arg1 == "RightButton" then
		if not SPF1.AutoReplaceOnSelfEnch then
			if IsShiftKeyDown() then
				SPF1.AutoReplaceOnSelfEnch = true;
				message = ("|cffbc5ff4[SPF]|r|cffffcf00["..L["PROFESSION"].."]|r: "..L["AutoReplaceOnSelfEnchON"]);
				DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
			else
				message = ("|cffbc5ff4[SPF]|r|cffffcf00["..L["PROFESSION"].."]|r: "..L["AutoReplaceOnSelfEnchINFO"]);
				DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
			end
		else
			SPF1.AutoReplaceOnSelfEnch = nil;
			message = ("|cffbc5ff4[SPF]|r|cffffcf00["..L["PROFESSION"].."]|r: "..L["AutoReplaceOnSelfEnchOFF"]);
			DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
		end
	end
end
CraftCreateButton:SetScript("OnClick", SPFE.CraftCreateButton_OnClick);
