local _, L = ...;
local SPF2 = SigmaProfessionFilter[2];

SigmaProfessionFilter[L["PROFESSION"]] = {
	["LeftMenu"] = {
		["title"] = L["LEFT_TITLE"];
		["tooltip"] = L["LEFT_TOOLTIP"];
		["Filter"] = function(skillIndex, groupIndex)
			local skillName = SPF2.baseGetTradeSkillInfo(skillIndex);
			for i=3, 1, -1 do
				if SPF2.match(skillName, L["LEFT_0"..i.."_FILTER"]) then
					if groupIndex == 0 or groupIndex == i then
						return i;
					else
						return 0;
					end
				end
			end
			return 0;
		end;
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
	};
};
