local SPFBT = SigmaProfessionFilterBeastTraining;
local L = SPFBT.L;
local SPF = SigmaProfessionFilter[1];

function SPFBT.Pets()
	local pets = nil;
	for i = 0, 2, 1 do
		local pet = ({GetStablePetInfo(i)})[2] or UnitCreatureFamily("pet");
		if pet then
			if not pets then
				pets = pet;
			else
				pets = pets..";"..pet;
			end
		end
	end
	return pets;
end

SigmaProfessionFilter[L["PROFESSION"]] = {
	["Functions"] = {
		["GetCraftDescription"] = function(skillIndex)
			if SPF.Data and SPF.Data[skillIndex] then
				
				if SPF.Data[skillIndex]["creates"] then
					return "";
				end
				
				SPFCraftLocalTooltip:SetOwner(CraftFrame, "ANCHOR_NONE")
				SPF:Custom("Functions")["SetCraftItem"](SPFCraftLocalTooltip, skillIndex, nil)
				local numLines = SPFCraftLocalTooltip:NumLines();
				local description = "";
				if (numLines > 3) then
					description = description..(getglobal("SPFCraftLocalTooltipTextLeft"..(numLines-3)):GetText() or "").."\n\n";
				end
				if (numLines > 1) then
					description = description..(getglobal("SPFCraftLocalTooltipTextLeft"..(numLines-1)):GetText() or "").."\n";
				end
				if (numLines > 0) then
					description = description..(getglobal("SPFCraftLocalTooltipTextLeft"..(numLines-0)):GetText() or "");
				end
				return description;
			end
		end;
		["nameWithLevel"] = function(skillIndex, unlearned)
			if unlearned then
				local skillName, skillSubSpellName = SPF.GetRecipeInfo(skillIndex, "name", "skillSubSpellName");
				return (skillName or "")..string.gsub(skillSubSpellName or "", " (%d)$", " 0%1");
			else
				local skillName, skillSubSpellName  = SPF.baseGetCraftInfo(skillIndex);
				return (skillName or "")..string.gsub(skillSubSpellName or "", " (%d)$", " 0%1");
			end
		end;
		["requiresText"] = function(learnedAt)
			local color = "|cffffffff";
			if UnitLevel("pet") > 0 and UnitLevel("pet") < learnedAt then
				color = "|cffff0000";
			end
			local requiresText = "|cffffffff".."Requires: Pet Level "..color..learnedAt.."|r";
			CraftRequirements:SetText(requiresText);
			CraftReagentLabel:Hide();
			return requiresText;
		end;
		["SetCraftItem"] = function(tooltip, skillIndex, reagentIndex)
			local skillName, skillSubSpellName = GetCraftInfo(skillIndex);
			
			if skillName then
			
				local learnedFrom = nil;
				local usedBy = nil;
				local pets = SPFBT.Pets();
				local usedByAllPets = true;
				
				if SPF.Data[skillIndex]["original"] then -- Spells Already Learned
					
					SPF.baseSetCraftSpell(tooltip, SPF.Data[skillIndex]["original"])
					
					local source = SPF:GetGroup("Right", skillIndex, 0);
					learnedFrom = SPF:GetMenu("Right")[source].name;
					
					for i = 4, getn(SPF:GetMenu("Right")), 1 do
						if (SPF:GetGroup("Right", skillIndex, i) == i) then
							local color = "|cffffffff";
							local family = SPF:GetMenu("Right")[i].name;
							if pets and not SPF.match(family, pets) then
								color = "|cff808080";
							end
							if not usedBy then
								usedBy = "Used by Pets: ";
							else
								usedBy = usedBy..", ";
							end
							usedBy = usedBy..color..family.."|cffffffff";
						else
							usedByAllPets = false;
						end
					end
				else -- Spells Not Yet Learned
				
					local spellID = SPF.Data[skillIndex]["spellID"];
					tooltip:SetHyperlink("spell:"..spellID)
					
					local source = SPF:GetGroupSpell("Right", spellID, 0);
					learnedFrom = SPF:GetMenu("Right")[source].name;
					
					for i = 4, getn(SPF:GetMenu("Right")), 1 do
						if (SPF:GetGroupSpell("Right", spellID, i) == i) then
							local color = "|cffffffff";
							local family = SPF:GetMenu("Right")[i].name;
							if pets and not SPF.match(family, pets) then
								color = "|cff808080";
							end
							if not usedBy then
								usedBy = "|cffffd200Used by Pets: ";
							else
								usedBy = usedBy..", ";
							end
							usedBy = usedBy..color..family.."|cffffffff";
						else
							usedByAllPets = false;
						end
					end
				end
				
				if usedByAllPets or not usedBy then
					usedBy = "|cffffd200Used by Pets: ".."|cffffffff".."All Families";
				end
				
				local requiresText = SPF.GetRequiresText(skillIndex);
				if requiresText and requiresText ~= "" then
					local left1 = getglobal(tooltip:GetName().."TextLeft1");
					left1:SetText(left1:GetText().."\n"..string.gsub(requiresText, ":", ""));
				end
				
				tooltip:AddLine(" ");
				tooltip:AddLine("|cffffd200Learned From: |cffffffff"..(learnedFrom or "").."|r");
				tooltip:AddLine(usedBy..".", nil, nil, nil, true);
			end
			if skillSubSpellName then
				local rankText = getfenv()[(tooltip:GetName() or "-").."TextRight1"];
				if rankText then
					rankText:Show();
					rankText:SetText(skillSubSpellName);
					rankText:SetTextColor(0.5, 0.5, 0.5, 1);
					local requiresText = SPF.GetRequiresText(skillIndex);
					if requiresText and requiresText ~= "" then
						rankText:SetText(skillSubSpellName.."\n\n");
					end
				end
			end
			tooltip:Show();
		end;
	};
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
		[09] = { name = L["OTHER"]; filter = "" };
	};
	["RightMenu"] = {
		["title"] = L["RIGHT_TITLE"];
		["tooltip"] = L["RIGHT_TOOLTIP"];
		["Filter"] = function(craftIndex, groupIndex)
			-- 0 == AllSources
			-- 1 == WildAnimals
			-- 2 == PetTrainer
			-- 3 == Other
			if groupIndex == 0 or groupIndex == 3 then
				local wildAnimals = SPF:GetGroup("Right", craftIndex, 1);
				local petTrainer = SPF:GetGroup("Right", craftIndex, 2);
				
				-- when "Other" is selected the filter matches only if the source is unknown
				if groupIndex == 3 then
					if (not wildAnimals) and (not petTrainer) then
						return 3;
					else
						return nil;
					end
				end
				
				-- when there is no selection return "wildAnimals" or "PetTrainer" or "Other"
				return wildAnimals or petTrainer or 3;
			end

			-- when "wildAnimals" or "PetTrainer" or a specific pet family is selected
			-- the filter matches with the normal rules
			return SPF:GetGroup("Right", craftIndex, groupIndex);
		end;
		["FilterSpell"] = function(spellID, groupIndex)
			-- 0 == AllSources
			-- 1 == WildAnimals
			-- 2 == PetTrainer
			-- 3 == Other
			if groupIndex == 0 or groupIndex == 3 then
				local wildAnimals = SPF:GetGroupSpell("Right", spellID, 1);
				local petTrainer = SPF:GetGroupSpell("Right", spellID, 2);
				
				-- when "Other" is selected the filter matches only if the source is unknown
				if groupIndex == 3 then
					if (not wildAnimals) and (not petTrainer) then
						return 3;
					else
						return nil;
					end
				end
				
				-- when there is no selection return "wildAnimals" or "PetTrainer" or "Other"
				return wildAnimals or petTrainer or 3;
			end

			-- when "wildAnimals" or "PetTrainer" or a specific pet family is selected
			-- the filter matches with the normal rules
			return SPF:GetGroupSpell("Right", spellID, groupIndex);
		end;
		["Initialize"] = function()
			if (SPF:GetMenu("Right")) then
				local info = {};
				info.text = L["RIGHT_TITLE"];
				info.func = SPF.RightMenu.OnClick;
				info.checked = false;

				UIDropDownMenu_AddButton(info);

				for i,button in ipairs(SPF:GetMenu("Right")) do
					info = {};
					info.text = button.name;
					info.func = SPF.RightMenu.OnClick;
					info.checked = false;

					if i > 3 then
						local pets = SPFBT.Pets();
						if pets and not SPF.match(info.text, pets) then
							info.textR = 0.5;
							info.textG = 0.5;
							info.textB = 0.5;
						end
					end
					
					UIDropDownMenu_AddButton(info);
				end
			end
		end;
	};
	["Right"] = {
		[01] = { name = L["RIGHT_01_NAME"]; filter = L["RIGHT_01_FILTER"]; };
		[02] = { name = L["RIGHT_02_NAME"]; filter = L["RIGHT_02_FILTER"]; };
		[03] = { name = L["OTHER"]; filter = ""; };
		[04] = { name = L["PET_FAMILY_01"]; filter = L["RIGHT_03_FILTER"]; };
		[05] = { name = L["PET_FAMILY_02"]; filter = L["RIGHT_04_FILTER"]; };
		[06] = { name = L["PET_FAMILY_03"]; filter = L["RIGHT_05_FILTER"]; };
		[07] = { name = L["PET_FAMILY_04"]; filter = L["RIGHT_06_FILTER"]; };
		[08] = { name = L["PET_FAMILY_05"]; filter = L["RIGHT_07_FILTER"]; };
		[09] = { name = L["PET_FAMILY_06"]; filter = L["RIGHT_08_FILTER"]; };
		[10] = { name = L["PET_FAMILY_07"]; filter = L["RIGHT_09_FILTER"]; };
		[11] = { name = L["PET_FAMILY_08"]; filter = L["RIGHT_10_FILTER"]; };
		[12] = { name = L["PET_FAMILY_09"]; filter = L["RIGHT_11_FILTER"]; };
		[13] = { name = L["PET_FAMILY_10"]; filter = L["RIGHT_12_FILTER"]; };
		[14] = { name = L["PET_FAMILY_11"]; filter = L["RIGHT_13_FILTER"]; };
		[15] = { name = L["PET_FAMILY_12"]; filter = L["RIGHT_14_FILTER"]; };
		[16] = { name = L["PET_FAMILY_13"]; filter = L["RIGHT_15_FILTER"]; };
		[17] = { name = L["PET_FAMILY_14"]; filter = L["RIGHT_16_FILTER"]; };
		[18] = { name = L["PET_FAMILY_15"]; filter = L["RIGHT_17_FILTER"]; };
		[19] = { name = L["PET_FAMILY_16"]; filter = L["RIGHT_18_FILTER"]; };
		[20] = { name = L["PET_FAMILY_17"]; filter = L["RIGHT_19_FILTER"]; };
	};
	["Portrait"] = {
		["Icon"] = function()
			if UnitExists("pet") then
				return GetPetIcon();
			end
			return SPF.GetProfessionIcon();
		end;
	};
	["Filter1"] = {
		["text"] = L["FILTER1"];
		["tooltip"] = L["FILTER1_TOOLTIP"];
		["Filter"] = function(craftIndex)
			if not UnitExists("pet") then
				return false;
			end
			
			local craftName, _, craftType, _, _, trainingPointCost = SPF.baseGetCraftInfo(craftIndex);
			
			if craftType == "used" then
				return false;
			end
			
			if craftName == L["GROWL"] then
				return true;
			end
			
			if trainingPointCost then
				return  trainingPointCost > 0;
			end
		end;
	};
	["Filter2"] = {
		["text"] = L["FILTER2"];--"Trainable";
		["tooltip"] = L["FILTER2_TOOLTIP"];--"Only show the abilities for which your active pet has the required level and training points.";
		["Filter"] = function(craftIndex)
			if not UnitExists("pet") then
				return false;
			end
			
			local craftName, _, craftType, _, _, trainingPointCost, requiredLevel = SPF.baseGetCraftInfo(craftIndex);
			
			if craftType == "used" then
				return false;
			end
			
			local petLevel = UnitLevel("pet");
			
			if petLevel < requiredLevel then
				return false;
			end
			
			if craftName == L["GROWL"] then
				return true;
			end
			
			if trainingPointCost > 0 then
				
				local totalPoints, pointsSpent = GetPetTrainingPoints();
				local trainingPointsAvailable = totalPoints - pointsSpent;
				local trainingPointsRefund = 0;
				
				for i=SPF.baseGetNumCrafts(), 1, -1 do
					local cN, _, cT, _, _, tpC = SPF.baseGetCraftInfo(craftIndex);
					if cT == "used" then
						if cN == craftName then
							trainingPointsRefund = tpC;
							break;
						end
					else
						break;
					end
				end
				
				if trainingPointsAvailable + trainingPointsRefund < trainingPointCost then
					return false;
				else
					return true;
				end
			end
		end;
	};
	["Tooltip"] = {
		["Set"] = function()
			if UnitExists("pet") then
				GameTooltip:SetUnit("pet");
			else
				SPF.PortraitChanger:DefaultTooltip();
			end
		end
	};
};

if TradeSkillFrameAvailableFilterCheckButton then -- TBC
	SigmaProfessionFilter[L["PROFESSION"]]["Left"][09] = { name = L["LEFT_09_NAME"]; filter = L["LEFT_09_FILTER"]; };
	SigmaProfessionFilter[L["PROFESSION"]]["Left"][10] = { name = L["OTHER"]; filter = "" };

	SigmaProfessionFilter[L["PROFESSION"]]["Right"][21] = { name = L["PET_FAMILY_18"]; filter = L["RIGHT_20_FILTER"]; };
	SigmaProfessionFilter[L["PROFESSION"]]["Right"][22] = { name = L["PET_FAMILY_19"]; filter = L["RIGHT_21_FILTER"]; };
	SigmaProfessionFilter[L["PROFESSION"]]["Right"][23] = { name = L["PET_FAMILY_20"]; filter = L["RIGHT_22_FILTER"]; };
	SigmaProfessionFilter[L["PROFESSION"]]["Right"][24] = { name = L["PET_FAMILY_21"]; filter = L["RIGHT_23_FILTER"]; };
	SigmaProfessionFilter[L["PROFESSION"]]["Right"][25] = { name = L["PET_FAMILY_22"]; filter = L["RIGHT_24_FILTER"]; };
	SigmaProfessionFilter[L["PROFESSION"]]["Right"][26] = { name = L["PET_FAMILY_23"]; filter = L["RIGHT_25_FILTER"]; };
end
