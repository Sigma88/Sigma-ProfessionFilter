local SPF = SigmaProfessionFilter[1];

SPF.LocalTooltip = CreateFrame("GameTooltip", "SPFCraftLocalTooltip", WorldFrame, "GameTooltipTemplate");
SPF.LocalTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
SPF.LocalTooltip.SetCraftItem = SPF.SetCraftItem;
SPF.LocalTooltip.SetCraftSpell = SPF.SetCraftItem;

function SPF.GetCraftDescription(skillIndex)

	-- If The Profession is supported
	if (SPF.Data and SPF.Data[skillIndex]) then
		
		if SPF:Custom("Functions")["GetCraftDescription"] then
			local customDescription = SPF:Custom("Functions")["GetCraftDescription"](skillIndex);
			if customDescription then
				return customDescription;
			end
		end
		
		if SPF.Data[skillIndex]["original"] then
			return SPF.baseGetCraftDescription(SPF.Data[skillIndex]["original"]) or "";
		end

		if SPF.Data[skillIndex]["creates"] then
			return "";
		end

		if SPF.Data[skillIndex]["spellID"] and not SPF.Data[skillIndex]["skillSubSpellName"] then
			local spellID = SPF.Data[skillIndex]["spellID"];
			local link = "enchant:"..spellID
			SPF.LocalTooltip:SetHyperlink(link);
			return SPFCraftLocalTooltipTextLeft5:GetText();
		end
		
		return "";
	end
	
	-- Otherwise fall back to the original
    return "";
end

SPF.baseGetCraftDescription = GetCraftDescription;
GetCraftDescription = SPF.GetCraftDescription;
