SPF1["Beast Training"] = {
	["LeftTitle"] = "All Types";
	["Left"] = {
		[1] = { name = "Damage"; filter = "Bite;Claw;Lightning Breath"; };
		[2] = { name = "Damage Over Time"; filter = "Scorpid Poison"; };
		[3] = { name = "Area of Effect"; filter = "Screech;Thunderstomp"; };
		[4] = { name = "Special"; filter = "Charge;Furious Howl;Prowl;Shell Shield"; };
		[5] = { name = "Movement"; filter = "Dash;Dive"; };
		[6] = { name = "Threat"; filter = "Cower;Growl"; };
		[7] = { name = "Stats"; filter = "Great Stamina;Natural Armor"; };
		[8] = { name = "Resistance"; filter = "Resistance"; };
	};
	["RightTitle"] = "All Sources";
	["Right"] = {
		[1] = { name = "Wild Animals"; filter = "Bite;Charge;Claw;Cower;Dash;Dive;Furious Howl;Lightning Breath;Prowl;Scorpid Poison;Screech;Shell Shield;Thunderstomp"; };
		[2] = { name = "Pet Trainer"; filter = "Armor;Growl;Stamina;Resistance"; };
		[3] = { name = "Wolf"; filter = "Bite;Cower;Dash;Furious Howl"; };
		[4] = { name = "Cat"; filter = "Bite;Claw;Cower;Dash;Prowl"; };
		[5] = { name = "Spider"; filter = "Bite;Cower"; };
		[6] = { name = "Bear"; filter = "Bite;Claw;Cower"; };
		[7] = { name = "Boar"; filter = "Bite;Charge;Cower;Dash"; };
		[8] = { name = "Crocolisk"; filter = "Bite;Cower"; };
		[9] = { name = "Carrion Bird"; filter = "Bite;Claw;Cower;Dive;Screech"; };
		[10] = { name = "Crab"; filter = "Claw;Cower"; };
		[11] = { name = "Gorilla"; filter = "Bite;Cower;Thunderstomp"; };
		[12] = { name = "Raptor"; filter = "Bite;Claw;Cower"; };
		[13] = { name = "Tallstrider"; filter = "Bite;Cower;Dash"; };
		[14] = { name = "Scorpid"; filter = "Claw;Cower;Scorpid Poison"; };
		[15] = { name = "Turtle"; filter = "Bite;Cower;Shell Shield"; };
		[16] = { name = "Bat"; filter = "Bite;Cower;Dive;Screech"; };
		[17] = { name = "Hyena"; filter = "Bite;Cower;Dash"; };
		[18] = { name = "Owl"; filter = "Claw;Cower;Dive;Screech"; };
		[19] = { name = "Wind Serpent"; filter = "Bite;Cower;Dive;Lightning Breath"; };
	};
	["Portrait"] = {
		["Icon"] = function()
			if UnitExists("pet") then
				local _,_,_,petFamily = GetStablePetInfo(0);
				return SPF1["Beast Training"]["PetFamily"][petFamily];
			end
			return 132162;
		end;
	};
	["PetFamily"] = {
		["Wolf"] = 132203;
		["Cat"] = 132185;
		["Spider"] = 132196;
		["Bear"] = 132183;
		["Boar"] = 132184;
		["Crocolisk"] = 132187;
		["Carrion Bird"] = 132200;
		["Crab"] = 132186;
		["Gorilla"] = 132189;
		["Raptor"] = 132193;
		["Tallstrider"] = 132198;
		["Scorpid"] = 132195;
		["Turtle"] = 132199;
		["Bat"] = 132182;
		["Hyena"] = 132190;
		["Owl"] = 132192;
		["Wind Serpent"] = 132202;
	};
	["LeftMenu"] = {
		["tooltip"] = "Sort the abilities by the type of effect they provide.";
	};
	["RightMenu"] = {
		["tooltip"] = "Sort the abilities by the source from which they are acquired.";
		["Filter"] = function(craftIndex, groupIndex)
			local groupName = SPF1:GetGroup("Right", SPF1.baseGetCraftInfo(craftIndex), 3);
			if #(SPF1:GetGroup("Right", SPF1.baseGetCraftInfo(craftIndex), groupIndex)) > 0 then
				groupName = groupName..(SPF1:GetGroup("Right", SPF1.baseGetCraftInfo(craftIndex), 2));
			end
			return groupName;
		end;
		
		["Initialize"] = function()
			if (SPF1:GetMenu("Right")) then
				local info = {};
				info.text = SPF1[GetCraftName()]["RightTitle"];
				info.func = SPF1.RightMenu.OnClick;
				info.checked = false;

				UIDropDownMenu_AddButton(info);

				for i,button in ipairs(SPF1:GetMenu("Right")) do
					info = {};
					info.text = button.name;
					info.func = SPF1.RightMenu.OnClick;
					info.checked = false;

					if (GetCraftName() == "Beast Training") then
						if i > 2 then
							if UnitExists("pet") then
								local _,_,_,petFamily = GetStablePetInfo(0);
								if info.text ~= petFamily then
									info.colorCode = "|cff808080";
								end
							end
						end
					end
					UIDropDownMenu_AddButton(info);
				end
			end
		end;
	};
	["Filter1"] = {
		["text"] = "Available";
		["tooltip"] = "Only show the abilities that can be learned by your active pet.";
		["Filter"] = function(craftIndex)
			local craftName, _, craftType, _, _, trainingPointCost = SPF1.baseGetCraftInfo(craftIndex);
			
			if not UnitExists("pet") then
				return false;
			end
			
			if craftType == "used" then
				return false;
			end
			
			if craftName == "Growl" then
				return true;
			end
			
			if trainingPointCost then
				return  trainingPointCost > 0;
			end
		end;
	};
	["Filter2"] = {
		["text"] = "Trainable";
		["tooltip"] = "Only show the abilities for which your active pet has the required level and training points.";
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
			
			if craftName == "Growl" then
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
}
