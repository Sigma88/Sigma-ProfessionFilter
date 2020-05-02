local _, L = ...;

-- Profession
L["PROFESSION"] = "Beast Training";
-- Spells
L["GROWL"] = "Growl";
-- PetFamilies
L["PET_FAMILY_01"] = "Wolf";
L["PET_FAMILY_02"] = "Cat";
L["PET_FAMILY_03"] = "Spider";
L["PET_FAMILY_04"] = "Bear";
L["PET_FAMILY_05"] = "Boar";
L["PET_FAMILY_06"] = "Crocolisk";
L["PET_FAMILY_07"] = "Carrion Bird";
L["PET_FAMILY_08"] = "Crab";
L["PET_FAMILY_09"] = "Gorilla";
L["PET_FAMILY_10"] = "Raptor";
L["PET_FAMILY_11"] = "Tallstrider";
L["PET_FAMILY_12"] = "Scorpid";
L["PET_FAMILY_13"] = "Turtle";
L["PET_FAMILY_14"] = "Bat";
L["PET_FAMILY_15"] = "Hyena";
L["PET_FAMILY_16"] = "Owl";
L["PET_FAMILY_17"] = "Wind Serpent";
-- Left Menu
L["LEFT_TITLE"] = "All Types";
L["LEFT_TOOLTIP"] = "Sort the abilities by the type of effect they provide.";
-- Names
L["LEFT_01_NAME"] = DAMAGE;
L["LEFT_02_NAME"] = "Damage Over Time";
L["LEFT_03_NAME"] = "Area of Effect";
L["LEFT_04_NAME"] = SPECIAL;
L["LEFT_05_NAME"] = "Movement";
L["LEFT_06_NAME"] = "Threat";
L["LEFT_07_NAME"] = RAID_BUFF_1;
L["LEFT_08_NAME"] = RESISTANCE_LABEL;
-- Filters
L["LEFT_01_FILTER"] = "Bite;Claw;Lightning Breath";
L["LEFT_02_FILTER"] = "Scorpid Poison";
L["LEFT_03_FILTER"] = "Screech;Thunderstomp";
L["LEFT_04_FILTER"] = "Charge;Furious Howl;Prowl;Shell Shield";
L["LEFT_05_FILTER"] = "Dash;Dive";
L["LEFT_06_FILTER"] = "Cower;"..L["GROWL"];
L["LEFT_07_FILTER"] = SPELL_STAT3_NAME..";"..RESISTANCE0_NAME;
L["LEFT_08_FILTER"] = RESISTANCE_LABEL;
-- Right Menu
L["RIGHT_TITLE"] = "All Sources";
L["RIGHT_TOOLTIP"] = "Sort the abilities by the source from which they are acquired.";
-- Names
L["RIGHT_01_NAME"] = "Wild Animals";
L["RIGHT_02_NAME"] = "Pet Trainer";
-- Filters
L["RIGHT_01_FILTER"] = "Bite;Charge;Claw;Cower;Dash;Dive;Furious Howl;Lightning Breath;Prowl;Scorpid Poison;Screech;Shell Shield;Thunderstomp";
L["RIGHT_02_FILTER"] = L["GROWL"]..";"..SPELL_STAT3_NAME..";"..RESISTANCE0_NAME..";"..RESISTANCE_LABEL;
L["RIGHT_03_FILTER"] = "Bite;Cower;Dash;Furious Howl";
L["RIGHT_04_FILTER"] = "Bite;Claw;Cower;Dash;Prowl";
L["RIGHT_05_FILTER"] = "Bite;Cower";
L["RIGHT_06_FILTER"] = "Bite;Claw;Cower";
L["RIGHT_07_FILTER"] = "Bite;Charge;Cower;Dash";
L["RIGHT_08_FILTER"] = "Bite;Cower";
L["RIGHT_09_FILTER"] = "Bite;Claw;Cower;Dive;Screech";
L["RIGHT_10_FILTER"] = "Claw;Cower";
L["RIGHT_11_FILTER"] = "Bite;Cower;Thunderstomp";
L["RIGHT_12_FILTER"] = "Bite;Claw;Cower";
L["RIGHT_13_FILTER"] = "Bite;Cower;Dash";
L["RIGHT_14_FILTER"] = "Claw;Cower;Scorpid Poison";
L["RIGHT_15_FILTER"] = "Bite;Cower;Shell Shield";
L["RIGHT_16_FILTER"] = "Bite;Cower;Dive;Screech";
L["RIGHT_17_FILTER"] = "Bite;Cower;Dash";
L["RIGHT_18_FILTER"] = "Claw;Cower;Dive;Screech";
L["RIGHT_19_FILTER"] = "Bite;Cower;Dive;Lightning Breath";
-- Filter1
L["FILTER1"] = "Available";
L["FILTER1_TOOLTIP"] = "Only show the abilities that can be learned by your active pet.";
-- Filter2
L["FILTER2"] = "Trainable";
L["FILTER2_TOOLTIP"] = "Only show the abilities for which your active pet has the required level and training points.";
