local L = SigmaProfessionFilterFirstAid.L;
local SPF = SigmaProfessionFilter[2];

SigmaProfessionFilter[L["PROFESSION"]] = {
	["LeftMenu"] = {
		["title"] = L["LEFT_TITLE"];
		["tooltip"] = L["LEFT_TOOLTIP"];
	};
	["Left"] = {
		[01] = { name = L["LEFT_01_NAME"]; filter = L["LEFT_01_FILTER"]; };
		[02] = { name = L["LEFT_02_NAME"]; filter = L["LEFT_02_FILTER"]; };
		[03] = { name = MISCELLANEOUS; filter = ""; };
	};
	["RightMenu"] = {
		["title"] = L["RIGHT_TITLE"];
		["tooltip"] = L["RIGHT_TOOLTIP"];
	};
	["Right"] = {
		[01] = { name = L["RIGHT_01_NAME"]; filter = L["RIGHT_01_FILTER"]; };
		[02] = { name = L["RIGHT_02_NAME"]; filter = L["RIGHT_02_FILTER"]; };
		[03] = { name = L["RIGHT_03_NAME"]; filter = L["RIGHT_03_FILTER"]; };
		[04] = { name = L["RIGHT_04_NAME"]; filter = L["RIGHT_04_FILTER"]; };
		[05] = { name = L["RIGHT_05_NAME"]; filter = L["RIGHT_05_FILTER"]; };
		[06] = { name = L["RIGHT_06_NAME"]; filter = L["RIGHT_06_FILTER"]; };
		[07] = { name = MISCELLANEOUS; filter = ""; };
	};
};

if not SPF.CLASSIC then
	SigmaProfessionFilter[L["PROFESSION"]]["Right"][07] = { name = L["RIGHT_07_NAME"]; filter = L["RIGHT_07_FILTER"]; };
	SigmaProfessionFilter[L["PROFESSION"]]["Right"][08] = { name = MISCELLANEOUS; filter = ""; };
end

if SPF.WRATH then
	SigmaProfessionFilter[L["PROFESSION"]]["Right"][08] = { name = L["RIGHT_08_NAME"]; filter = L["RIGHT_08_FILTER"]; };
	SigmaProfessionFilter[L["PROFESSION"]]["Right"][09] = { name = MISCELLANEOUS; filter = ""; };
end
