local _, L = ...;

SigmaProfessionFilter[L["PROFESSION"]] = {
	["LeftMenu"] = {
		["title"] = L["LEFT_TITLE"];
		["tooltip"] = L["LEFT_TOOLTIP"];
	};
	["Left"] = {
		[01] = { name = L["LEFT_01_NAME"]; filter = L["LEFT_01_FILTER"]; };
		[02] = { name = L["LEFT_02_NAME"]; filter = L["LEFT_02_FILTER"]; };
		[03] = { name = L["LEFT_03_NAME"]; filter = L["LEFT_03_FILTER"]; };
	};
	["RightMenu"] = {
		["title"] = L["RIGHT_TITLE"];
		["tooltip"] = L["RIGHT_TOOLTIP"];
	};
	["Right"] = {
		[01] = { name = L["RIGHT_01_NAME"]; filter = L["RIGHT_01_FILTER"]; };
		[02] = { name = L["RIGHT_02_NAME"]; filter = L["RIGHT_02_FILTER"]; };
	};
};
