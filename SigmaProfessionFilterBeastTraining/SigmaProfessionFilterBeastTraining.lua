local _, L = ...;
local SPF1 = SigmaProfessionFilter[1];

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
		[09] = { name = L["OTHER"]; filter = "" };
	};
	["RightMenu"] = {
		["title"] = L["RIGHT_TITLE"];
		["tooltip"] = L["RIGHT_TOOLTIP"];
		["Filter"] = function(craftIndex, groupIndex)
			if groupIndex < 3 then
				SPF1:GetGroup("Right", craftIndex, groupIndex);
			end
			
			local wildAnimals = SPF1:GetGroup("Right", craftIndex, 1);
			local petTrainer = SPF1:GetGroup("Right", craftIndex, 2);
			
			if groupIndex == 3 then
				if (not wildAnimals) and (not petTrainer) then
					return 3;
				else
					return nil;
				end
			end
			
			return wildAnimals or petTrainer;
		end;
		["Initialize"] = function()
			if (SPF1:GetMenu("Right")) then
				local info = {};
				info.text = L["RIGHT_TITLE"];
				info.func = SPF1.RightMenu.OnClick;
				info.checked = false;

				UIDropDownMenu_AddButton(info);

				for i,button in ipairs(SPF1:GetMenu("Right")) do
					info = {};
					info.text = button.name;
					info.func = SPF1.RightMenu.OnClick;
					info.checked = false;

					if i > 3 then
						if UnitExists("pet") then
							local _,_,_,petFamily = GetStablePetInfo(0);
							if info.text ~= petFamily then
								info.colorCode = "|cff808080";
							end
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
				local _,_,_,petFamily = GetStablePetInfo(0);
				return SigmaProfessionFilter[L["PROFESSION"]]["PetFamily"][petFamily] or 134400;
			end
			return 132162;
		end;
	};
	["PetFamily"] = {
		[L["PET_FAMILY_01"]] = 132203;
		[L["PET_FAMILY_02"]] = 132185;
		[L["PET_FAMILY_03"]] = 132196;
		[L["PET_FAMILY_04"]] = 132183;
		[L["PET_FAMILY_05"]] = 132184;
		[L["PET_FAMILY_06"]] = 132187;
		[L["PET_FAMILY_07"]] = 132200;
		[L["PET_FAMILY_08"]] = 132186;
		[L["PET_FAMILY_09"]] = 132189;
		[L["PET_FAMILY_10"]] = 132193;
		[L["PET_FAMILY_11"]] = 132198;
		[L["PET_FAMILY_12"]] = 132195;
		[L["PET_FAMILY_13"]] = 132199;
		[L["PET_FAMILY_14"]] = 132182;
		[L["PET_FAMILY_15"]] = 132190;
		[L["PET_FAMILY_16"]] = 132192;
		[L["PET_FAMILY_17"]] = 132202;
	};
	["Filter1"] = {
		["text"] = L["FILTER1"];
		["tooltip"] = L["FILTER1_TOOLTIP"];
		["Filter"] = function(craftIndex)
			local craftName, _, craftType, _, _, trainingPointCost = SPF1.baseGetCraftInfo(craftIndex);
			
			if not UnitExists("pet") then
				return false;
			end
			
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
		["text"] = L["FILTER2"];"Trainable";
		["tooltip"] = L["FILTER2_TOOLTIP"];"Only show the abilities for which your active pet has the required level and training points.";
		["Filter"] = function(craftIndex)
			local craftName, _, craftType, _, _, trainingPointCost, requiredLevel = SPF1.baseGetCraftInfo(craftIndex);
			local _, _, petLevel = GetStablePetInfo(0);
			
			if not UnitExists("pet") then
				return false;
			end
			
			if craftType == "used" then
				return false;
			end
			
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
				
				for i=SPF1.baseGetNumCrafts(), 1, -1 do
					local cN, _, cT, _, _, tpC = SPF1.baseGetCraftInfo(craftIndex);
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
				SPF1.PortraitChanger:DefaultTooltip();
			end
		end
	};
};
