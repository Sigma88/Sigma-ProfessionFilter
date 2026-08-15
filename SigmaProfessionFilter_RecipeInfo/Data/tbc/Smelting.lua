local RI = SigmaProfessionFilter_RecipeInfo;

RI.Data["Smelting"] = {
	[2657] = {
		creates = 2840,
		icon = "Interface\\Icons\\inv_ingot_02",
		name = "Smelt Copper",
		reagents = {
			{
				itemID = 2770,
				icon = "Interface\\Icons\\inv_ore_copper_01",
				numRequired = 1,
			},
		},
		learnedAt = 25,
		levels = {
			0,
			25,
			47,
			70,
		},
	},
	[2658] = {
		creates = 2842,
		icon = "Interface\\Icons\\inv_ingot_01",
		name = "Smelt Silver",
		reagents = {
			{
				itemID = 2775,
				icon = "Interface\\Icons\\inv_stone_16",
				numRequired = 1,
			},
		},
		learnedAt = 75,
		levels = {
			75,
			115,
			122,
			130,
		},
	},
	[2659] = {
		creates = 2841,
		icon = "Interface\\Icons\\inv_ingot_bronze",
		name = "Smelt Bronze",
		reagents = {
			{
				itemID = 2840,
				icon = "Interface\\Icons\\inv_ingot_02",
				numRequired = 1,
			},
			{
				itemID = 3576,
				icon = "Interface\\Icons\\inv_ingot_05",
				numRequired = 1,
			},
		},
		learnedAt = 65,
		levels = {
			65,
			65,
			90,
			115,
		},
	},
	[3304] = {
		creates = 3576,
		icon = "Interface\\Icons\\inv_ingot_05",
		name = "Smelt Tin",
		reagents = {
			{
				itemID = 2771,
				icon = "Interface\\Icons\\inv_ore_tin_01",
				numRequired = 1,
			},
		},
		learnedAt = 65,
		levels = {
			65,
			65,
			70,
			75,
		},
	},
	[3307] = {
		creates = 3575,
		icon = "Interface\\Icons\\inv_ingot_iron",
		name = "Smelt Iron",
		reagents = {
			{
				itemID = 2772,
				icon = "Interface\\Icons\\inv_ore_iron_01",
				numRequired = 1,
			},
		},
		learnedAt = 125,
		levels = {
			125,
			130,
			145,
			160,
		},
	},
	[3308] = {
		creates = 3577,
		icon = "Interface\\Icons\\inv_ingot_03",
		name = "Smelt Gold",
		reagents = {
			{
				itemID = 2776,
				icon = "Interface\\Icons\\inv_ore_gold_01",
				numRequired = 1,
			},
		},
		learnedAt = 155,
		levels = {
			155,
			170,
			177,
			185,
		},
	},
	[3569] = {
		creates = 3859,
		icon = "Interface\\Icons\\inv_ingot_steel",
		name = "Smelt Steel",
		reagents = {
			{
				itemID = 3575,
				icon = "Interface\\Icons\\inv_ingot_iron",
				numRequired = 1,
			},
			{
				itemID = 3857,
				icon = "Interface\\Icons\\inv_ore_tin_01",
				numRequired = 1,
			},
		},
		learnedAt = 165,
		levels = {
			165,
			165,
			165,
			165,
		},
	},
	[10097] = {
		creates = 3860,
		icon = "Interface\\Icons\\inv_ingot_06",
		name = "Smelt Mithril",
		reagents = {
			{
				itemID = 3858,
				icon = "Interface\\Icons\\inv_ore_mithril_02",
				numRequired = 1,
			},
		},
		learnedAt = 175,
		levels = {
			175,
			175,
			202,
			230,
		},
	},
	[10098] = {
		creates = 6037,
		icon = "Interface\\Icons\\inv_ingot_08",
		name = "Smelt Truesilver",
		reagents = {
			{
				itemID = 7911,
				icon = "Interface\\Icons\\inv_ore_truesilver_01",
				numRequired = 1,
			},
		},
		learnedAt = 230,
		levels = {
			230,
			235,
			242,
			250,
		},
	},
	[14891] = {
		creates = 11371,
		icon = "Interface\\Icons\\inv_ingot_mithril",
		name = "Smelt Dark Iron",
		reagents = {
			{
				itemID = 11370,
				icon = "Interface\\Icons\\inv_ore_mithril_01",
				numRequired = 8,
			},
		},
		learnedAt = 300,
		levels = {
			0,
			300,
			305,
			310,
		},
	},
	[16153] = {
		creates = 12359,
		icon = "Interface\\Icons\\inv_ingot_07",
		name = "Smelt Thorium",
		reagents = {
			{
				itemID = 10620,
				icon = "Interface\\Icons\\inv_ore_thorium_02",
				numRequired = 1,
			},
		},
		learnedAt = 250,
		levels = {
			250,
			250,
			270,
			290,
		},
	},
	[22967] = {
		creates = 17771,
		icon = "Interface\\Icons\\inv_ingot_thorium",
		name = "Smelt Elementium",
		reagents = {
			{
				itemID = 18562,
				icon = "Interface\\Icons\\inv_stone_sharpeningstone_01",
				numRequired = 1,
			},
			{
				itemID = 12360,
				icon = "Interface\\Icons\\inv_misc_stonetablet_05",
				numRequired = 10,
			},
			{
				itemID = 17010,
				icon = "Interface\\Icons\\spell_fire_flamebolt",
				numRequired = 1,
			},
			{
				itemID = 18567,
				icon = "Interface\\Icons\\spell_frost_fireresistancetotem",
				numRequired = 3,
			},
		},
		learnedAt = 350,
		levels = {
			0,
			350,
			362,
			375,
		},
	},
	[29356] = {
		creates = 23445,
		icon = "Interface\\Icons\\inv_ingot_feliron",
		name = "Smelt Fel Iron",
		reagents = {
			{
				itemID = 23424,
				icon = "Interface\\Icons\\inv_ore_feliron",
				numRequired = 2,
			},
		},
		learnedAt = 300,
		levels = {
			300,
			300,
			307,
			315,
		},
	},
	[29358] = {
		creates = 23446,
		icon = "Interface\\Icons\\inv_ingot_10",
		name = "Smelt Adamantite",
		reagents = {
			{
				itemID = 23425,
				icon = "Interface\\Icons\\inv_ore_adamantium",
				numRequired = 2,
			},
		},
		learnedAt = 325,
		levels = {
			325,
			325,
			332,
			340,
		},
	},
	[29359] = {
		creates = 23447,
		icon = "Interface\\Icons\\inv_ingot_11",
		name = "Smelt Eternium",
		reagents = {
			{
				itemID = 23427,
				icon = "Interface\\Icons\\inv_ore_eternium",
				numRequired = 2,
			},
		},
		learnedAt = 350,
		levels = {
			350,
			350,
			357,
			365,
		},
	},
	[29360] = {
		creates = 23448,
		icon = "Interface\\Icons\\inv_ingot_felsteel",
		name = "Smelt Felsteel",
		reagents = {
			{
				itemID = 23445,
				icon = "Interface\\Icons\\inv_ingot_feliron",
				numRequired = 3,
			},
			{
				itemID = 23447,
				icon = "Interface\\Icons\\inv_ingot_11",
				numRequired = 2,
			},
		},
		learnedAt = 350,
		levels = {
			350,
			355,
			367,
			380,
		},
	},
	[29361] = {
		creates = 23449,
		icon = "Interface\\Icons\\inv_ingot_09",
		name = "Smelt Khorium",
		reagents = {
			{
				itemID = 23426,
				icon = "Interface\\Icons\\inv_ore_khorium",
				numRequired = 2,
			},
		},
		learnedAt = 375,
		levels = {
			375,
			375,
			375,
			375,
		},
	},
	[29686] = {
		creates = 23573,
		icon = "Interface\\Icons\\inv_ingot_adamantite",
		name = "Smelt Hardened Adamantite",
		reagents = {
			{
				itemID = 23446,
				icon = "Interface\\Icons\\inv_ingot_10",
				numRequired = 10,
			},
		},
		learnedAt = 375,
		levels = {
			375,
			375,
			375,
			375,
		},
	},
	[35750] = {
		creates = 22573,
		icon = "Interface\\Icons\\inv_elemental_mote_earth01",
		name = "Earth Shatter",
		reagents = {
			{
				itemID = 22452,
				icon = "Interface\\Icons\\inv_elemental_primal_earth",
				numRequired = 1,
			},
		},
		learnedAt = 300,
		levels = {
			300,
			300,
			300,
			300,
		},
	},
	[35751] = {
		creates = 22574,
		icon = "Interface\\Icons\\inv_elemental_mote_fire01",
		name = "Fire Sunder",
		reagents = {
			{
				itemID = 21884,
				icon = "Interface\\Icons\\inv_elemental_primal_fire",
				numRequired = 1,
			},
		},
		learnedAt = 300,
		levels = {
			300,
			300,
			300,
			300,
		},
	},
	[46353] = {
		creates = 35128,
		icon = "Interface\\Icons\\inv_ingot_thorium",
		name = "Smelt Hardened Khorium",
		reagents = {
			{
				itemID = 23449,
				icon = "Interface\\Icons\\inv_ingot_09",
				numRequired = 3,
			},
			{
				itemID = 23573,
				icon = "Interface\\Icons\\inv_ingot_adamantite",
				numRequired = 1,
			},
		},
		learnedAt = 375,
		levels = {
			375,
			375,
			375,
			375,
		},
	},
}
