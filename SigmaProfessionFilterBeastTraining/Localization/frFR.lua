-- Thanks to user Javus-Amnennar for providing french localization

if GetLocale() == "frFR" then
	
	local _, L = ...;
	
	-- Profession
	L["PROFESSION"] = "Dressage des bêtes";
	-- PetFamilies
	L["PET_FAMILY_01"] = "Loup";
	L["PET_FAMILY_02"] = "Chat";
	L["PET_FAMILY_03"] = "Araignée";
	L["PET_FAMILY_04"] = "Ours";
	L["PET_FAMILY_05"] = "Sanglier";
	L["PET_FAMILY_06"] = "Crocodile";
	L["PET_FAMILY_07"] = "Charognard";
	L["PET_FAMILY_08"] = "Crabe";
	L["PET_FAMILY_09"] = "Gorille";
	L["PET_FAMILY_10"] = "Raptor";
	L["PET_FAMILY_11"] = "Trotteur";
	L["PET_FAMILY_12"] = "Scorpion";
	L["PET_FAMILY_13"] = "Tortue";
	L["PET_FAMILY_14"] = "Chauve souris";
	L["PET_FAMILY_15"] = "Hyène";
	L["PET_FAMILY_16"] = "Chouette";
	L["PET_FAMILY_17"] = "Serpent";
	-- Filter1
	L["FILTER1"] = "Disponible";
	L["FILTER1_TOOLTIP"] = "Montrer uniquement les capacités que votre familier actif peut apprendre actuellement.";
	-- Filter2
	L["FILTER2"] = "Enseignable";
	L["FILTER2_TOOLTIP"] = "Montrer uniquement les capacités pour votre familier actif possédant le niveau et les points d’apprentissages requis.";
	-- Spells
	L["BITE"] = GetSpellInfo(17253);
	L["CHARGE"] = GetSpellInfo(7371);
	L["CLAW"] = GetSpellInfo(16827);
	L["COWER"] = GetSpellInfo(1742);
	L["DASH"] = GetSpellInfo(23099);
	L["DIVE"] = GetSpellInfo(23145);
	L["FURIOUS_HOWL"] = GetSpellInfo(24604);
	L["GROWL"] = GetSpellInfo(2649);
	L["LIGHTNING_BREATH"] = GetSpellInfo(24844);
	L["PROWL"] = GetSpellInfo(24450);
	L["SCORPID_POISON"] = GetSpellInfo(24640);
	L["SCREECH"] = GetSpellInfo(24423);
	L["SHELL_SHIELD"] = GetSpellInfo(26064);
	L["THUNDERSTOMP"] = GetSpellInfo(26090);
	-- Left Menu
	L["LEFT_TITLE"] = "Toutes les sous-classes";
	L["LEFT_TOOLTIP"] = "Trie les capacités en fonction de leurs effets.";
	-- Names
	L["LEFT_01_NAME"] = DAMAGE;
	L["LEFT_02_NAME"] = "Dégâts sur la durée";
	L["LEFT_03_NAME"] = "Zone d'effet";
	L["LEFT_04_NAME"] = SPECIAL;
	L["LEFT_05_NAME"] = "Mouvement";
	L["LEFT_06_NAME"] = "Menace";
	L["LEFT_07_NAME"] = RAID_BUFF_1;
	L["LEFT_08_NAME"] = RESISTANCE_LABEL;
	-- Filters
	L["LEFT_01_FILTER"] = L["BITE"]..";"..L["CLAW"]..";"..L["LIGHTNING_BREATH"];
	L["LEFT_02_FILTER"] = L["SCORPID_POISON"];
	L["LEFT_03_FILTER"] = L["SCREECH"]..";"..L["THUNDERSTOMP"];
	L["LEFT_04_FILTER"] = L["CHARGE"]..";"..L["FURIOUS_HOWL"]..";"..L["PROWL"]..";"..L["SHELL_SHIELD"];
	L["LEFT_05_FILTER"] = L["DASH"]..";"..L["DIVE"];
	L["LEFT_06_FILTER"] = L["COWER"]..";"..L["GROWL"];
	L["LEFT_07_FILTER"] = SPELL_STAT3_NAME..";"..STAT_ARMOR;
	L["LEFT_08_FILTER"] = RESISTANCE_LABEL;
	-- Right Menu
	L["RIGHT_TITLE"] = "Toutes les sources";
	L["RIGHT_TOOLTIP"] = "Trie les capacités en fonction de la source dont elles sont acquises.";
	-- Names
	L["RIGHT_01_NAME"] = "Animaux sauvages";
	L["RIGHT_02_NAME"] = "Maître des familiers";
	-- Filters
	L["RIGHT_01_FILTER"] = L["BITE"]..";"..L["CHARGE"]..";"..L["CLAW"]..";"..L["COWER"]..";"..L["DASH"]..";"..L["DIVE"]..";"..L["FURIOUS_HOWL"]..";"..L["LIGHTNING_BREATH"]..";"..L["PROWL"]..";"..L["SCORPID_POISON"]..";"..L["SCREECH"]..";"..L["SHELL_SHIELD"]..";"..L["THUNDERSTOMP"];
	L["RIGHT_02_FILTER"] = L["GROWL"]..";"..SPELL_STAT3_NAME..";"..STAT_ARMOR..";"..RESISTANCE_LABEL;
	L["RIGHT_03_FILTER"] = L["BITE"]..";"..L["COWER"]..";"..L["DASH"]..";"..L["FURIOUS_HOWL"];
	L["RIGHT_04_FILTER"] = L["BITE"]..";"..L["CLAW"]..";"..L["COWER"]..";"..L["DASH"]..";"..L["PROWL"];
	L["RIGHT_05_FILTER"] = L["BITE"]..";"..L["COWER"];
	L["RIGHT_06_FILTER"] = L["BITE"]..";"..L["CLAW"]..";"..L["COWER"];
	L["RIGHT_07_FILTER"] = L["BITE"]..";"..L["CHARGE"]..";"..L["COWER"]..";"..L["DASH"];
	L["RIGHT_08_FILTER"] = L["BITE"]..";"..L["COWER"];
	L["RIGHT_09_FILTER"] = L["BITE"]..";"..L["CLAW"]..";"..L["COWER"]..";"..L["DIVE"]..";"..L["SCREECH"];
	L["RIGHT_10_FILTER"] = L["CLAW"]..";"..L["COWER"];
	L["RIGHT_11_FILTER"] = L["BITE"]..";"..L["COWER"]..";"..L["THUNDERSTOMP"];
	L["RIGHT_12_FILTER"] = L["BITE"]..";"..L["CLAW"]..";"..L["COWER"];
	L["RIGHT_13_FILTER"] = L["BITE"]..";"..L["COWER"]..";"..L["DASH"];
	L["RIGHT_14_FILTER"] = L["CLAW"]..";"..L["COWER"]..";"..L["SCORPID_POISON"];
	L["RIGHT_15_FILTER"] = L["BITE"]..";"..L["COWER"]..";"..L["SHELL_SHIELD"];
	L["RIGHT_16_FILTER"] = L["BITE"]..";"..L["COWER"]..";"..L["DIVE"]..";"..L["SCREECH"];
	L["RIGHT_17_FILTER"] = L["BITE"]..";"..L["COWER"]..";"..L["DASH"];
	L["RIGHT_18_FILTER"] = L["CLAW"]..";"..L["COWER"]..";"..L["DIVE"]..";"..L["SCREECH"];
	L["RIGHT_19_FILTER"] = L["BITE"]..";"..L["COWER"]..";"..L["DIVE"]..";"..L["LIGHTNING_BREATH"];
	
	L["OTHER"] = OTHER;
	
end
