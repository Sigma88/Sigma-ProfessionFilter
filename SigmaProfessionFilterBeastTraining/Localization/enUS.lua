SigmaProfessionFilterBeastTraining = {};
SigmaProfessionFilterBeastTraining.L = {};
local L = SigmaProfessionFilterBeastTraining.L;

-- Profession
L["PROFESSION"] = "Beast Training";
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
-- Filter1
L["FILTER1"] = "Available";
L["FILTER1_TOOLTIP"] = "Only show the abilities that can be learned by your active pet.";
-- Filter2
L["FILTER2"] = "Trainable";
L["FILTER2_TOOLTIP"] = "Only show the abilities for which your active pet has the required level and training points.";
-- Spells
L["BITE"] = "Bite";
L["CHARGE"] = "Charge";
L["CLAW"] = "Claw";
L["COWER"] = "Cower";
L["DASH"] = "Dash";
L["DIVE"] = "Dive";
L["FURIOUS_HOWL"] = "Furious Howl";
L["LIGHTNING_BREATH"] = "Lightning Breath";
L["PROWL"] = "Prowl";
L["SCORPID_POISON"] = "Scorpid Poison";
L["SCREECH"] = "Screech";
L["SHELL_SHIELD"] = "Shell Shield";
L["THUNDERSTOMP"] = "Thunderstomp";
L["GROWL"] = "Growl";
-- Left Menu
L["LEFT_TITLE"] = "All Types";
L["LEFT_TOOLTIP"] = "Sort the abilities by the type of effect they provide.";
-- Names
L["LEFT_01_NAME"] = "Damage";
L["LEFT_02_NAME"] = "Damage Over Time";
L["LEFT_03_NAME"] = "Area of Effect";
L["LEFT_04_NAME"] = "Special";
L["LEFT_05_NAME"] = "Movement";
L["LEFT_06_NAME"] = "Threat";
L["LEFT_07_NAME"] = "Stats";
L["LEFT_08_NAME"] = "Resistance";
-- Filters
L["LEFT_01_FILTER"] = L["BITE"]..";"..L["CLAW"]..";"..L["LIGHTNING_BREATH"];
L["LEFT_02_FILTER"] = L["SCORPID_POISON"];
L["LEFT_03_FILTER"] = L["SCREECH"]..";"..L["THUNDERSTOMP"];
L["LEFT_04_FILTER"] = L["CHARGE"]..";"..L["FURIOUS_HOWL"]..";"..L["PROWL"]..";"..L["SHELL_SHIELD"];
L["LEFT_05_FILTER"] = L["DASH"]..";"..L["DIVE"];
L["LEFT_06_FILTER"] = L["COWER"]..";"..L["GROWL"];
L["LEFT_07_FILTER"] = "Stamina"..";".."Armor";
L["LEFT_08_FILTER"] = "Resistance";
-- Right Menu
L["RIGHT_TITLE"] = "All Sources";
L["RIGHT_TOOLTIP"] = "Sort the abilities by the source from which they are acquired.";
-- Names
L["RIGHT_01_NAME"] = "Wild Animals";
L["RIGHT_02_NAME"] = "Pet Trainer";

-- Wild Animals Filter
L["RIGHT_01_FILTER"] = L["BITE"]..";"..L["CHARGE"]..";"..L["CLAW"]..";"..L["COWER"]..";"..L["DASH"]..";"..L["DIVE"]..";"..L["FURIOUS_HOWL"]..";"..L["LIGHTNING_BREATH"]..";"..L["PROWL"]..";"..L["SCORPID_POISON"]..";"..L["SCREECH"]..";"..L["SHELL_SHIELD"]..";"..L["THUNDERSTOMP"];
-- Pet Trainer Filter
L["RIGHT_02_FILTER"] = L["GROWL"]..";".."Stamina"..";".."Armor"..";".."Resistance";
-- Pet Families Filters
L["RIGHT_03_FILTER"] = L["BITE"]..";"..L["DASH"]..";"..L["FURIOUS_HOWL"];
L["RIGHT_04_FILTER"] = L["BITE"]..";"..L["CLAW"]..";"..L["DASH"]..";"..L["PROWL"];
L["RIGHT_05_FILTER"] = L["BITE"];
L["RIGHT_06_FILTER"] = L["BITE"]..";"..L["CLAW"];
L["RIGHT_07_FILTER"] = L["BITE"]..";"..L["CHARGE"]..";"..L["DASH"];
L["RIGHT_08_FILTER"] = L["BITE"];
L["RIGHT_09_FILTER"] = L["BITE"]..";"..L["CLAW"]..";"..L["DIVE"]..";"..L["SCREECH"];
L["RIGHT_10_FILTER"] = L["CLAW"];
L["RIGHT_11_FILTER"] = L["BITE"]..";"..L["THUNDERSTOMP"];
L["RIGHT_12_FILTER"] = L["BITE"]..";"..L["CLAW"];
L["RIGHT_13_FILTER"] = L["BITE"]..";"..L["DASH"];
L["RIGHT_14_FILTER"] = L["CLAW"]..";"..L["SCORPID_POISON"];
L["RIGHT_15_FILTER"] = L["BITE"]..";"..L["SHELL_SHIELD"];
L["RIGHT_16_FILTER"] = L["BITE"]..";"..L["DIVE"]..";"..L["SCREECH"];
L["RIGHT_17_FILTER"] = L["BITE"]..";"..L["DASH"];
L["RIGHT_18_FILTER"] = L["CLAW"]..";"..L["DIVE"]..";"..L["SCREECH"];
L["RIGHT_19_FILTER"] = L["BITE"]..";"..L["DIVE"]..";"..L["LIGHTNING_BREATH"];

L["OTHER"] = "Other";
