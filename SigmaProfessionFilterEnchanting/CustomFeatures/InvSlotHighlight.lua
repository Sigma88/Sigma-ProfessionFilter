local SPF = SigmaProfessionFilter[1];
local SPFE = SigmaProfessionFilterEnchanting;
local L = SPFE.L;

function SPFE.InvSlotGlow(slot, show)
	if not slot then
		return;
	end
	
	if not slot.glow and show then
		local glow = CreateFrame("Model", slot:GetName().."Glow", slot);
		glow:SetWidth(27);
		glow:SetHeight(27);
		glow:SetPoint("CENTER", slot, "CENTER", 0, 0);
		glow:SetModel("Interface\\Buttons\\UI-AutoCastButton.mdx");
		glow:SetScale(1.3);
		glow:SetSequence(0);
		glow:SetSequenceTime(0, 0);
		glow:SetAlpha(1);
		glow:Hide();
		slot.glow = glow;
	end
	
	if show then
		slot.glow:Show();
	end
	
	if slot.glow and not show then
		slot.glow:Hide();
	end
end

function SPFE.InvSlotHighlight()
	local craftName = GetCraftInfo(GetCraftSelectionIndex());
	CraftCreateButton:SetText(getglobal(GetCraftButtonToken()));
	for i,slot in pairs(SPFE.InvSlots) do
		SPFE.InvSlotGlow(SPFE.InvButtons[i], false);
		
		if GetCraftName() == L["PROFESSION"] and CharacterFrame:IsVisible() == 1 and CraftFrame:IsVisible() == 1 and CraftCreateButton:IsEnabled() == 1 and strfind(craftName or "", L[slot]) then
			SPFE.InvSlotGlow(SPFE.InvButtons[i], true);
			CraftCreateButton:SetText(L["SELF_ENCH"]);
		end
	end
end

function SPFE.CraftFrame_Update()
	SPFE.baseCraftFrame_Update();
	SPFE.InvSlotHighlight();
end
SPFE.baseCraftFrame_Update = CraftFrame_Update;
CraftFrame_Update = SPFE.CraftFrame_Update;


function SPFE.CharacterFrame_OnShow()
	SPFE.baseCharacterFrame_OnShow();
	SPFE.InvSlotHighlight();
end
SPFE.baseCharacterFrame_OnShow = CharacterFrame_OnShow;
CharacterFrame_OnShow = SPFE.CharacterFrame_OnShow;


function SPFE.CharacterFrame_OnHide()
	SPFE.baseCharacterFrame_OnHide();
	SPFE.InvSlotHighlight();
end
SPFE.baseCharacterFrame_OnHide = CharacterFrame_OnHide;
CharacterFrame_OnHide = SPFE.CharacterFrame_OnHide;


function SPFE.CloseCraft()
	SPFE.baseCloseCraft();
	SPFE.InvSlotHighlight();
end
SPFE.baseCloseCraft = CloseCraft;
CloseCraft = SPFE.CloseCraft;
