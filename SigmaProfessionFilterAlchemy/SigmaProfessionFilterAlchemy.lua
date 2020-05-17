local _, L = ...;
local SPF2 = SigmaProfessionFilter[2];

SigmaProfessionFilter[L["PROFESSION"]] = {
	["RightMenu"] = {
		["title"] = L["RIGHT_TITLE"];
		["tooltip"] = L["RIGHT_TOOLTIP"];
		["Filter"] = function(skillIndex, groupIndex)
			local skillName = SPF2.baseGetTradeSkillInfo(skillIndex);
			local skillGroup = SigmaProfessionFilter[L["PROFESSION"]]["Exceptions"][skillName];
			
			if skillGroup then
				if groupIndex == 0 or groupIndex == skillGroup then
					return skillGroup;
				end
			else
				for i=1,8 do
					if SPF2.match(skillName, L["RIGHT_0"..i.."_FILTER"]) then
						if groupIndex == 0 or groupIndex == i then
							return i;
						else
							return 0;
						end
					end
				end
				
				if groupIndex == 0 or groupIndex == 9 then
					return 9;
				end
			end
			
			return 0;
		end;
	};
	["Right"] = {
		[01] = { name = L["RIGHT_01_NAME"]; filter = L["RIGHT_01_FILTER"]; };
		[02] = { name = L["RIGHT_02_NAME"]; filter = L["RIGHT_02_FILTER"]; };
		[03] = { name = L["RIGHT_03_NAME"]; filter = L["RIGHT_03_FILTER"]; };
		[04] = { name = L["RIGHT_04_NAME"]; filter = L["RIGHT_04_FILTER"]; };
		[05] = { name = L["RIGHT_05_NAME"]; filter = L["RIGHT_05_FILTER"]; };
		[06] = { name = L["RIGHT_06_NAME"]; filter = L["RIGHT_06_FILTER"]; };
		[07] = { name = L["RIGHT_07_NAME"]; filter = L["RIGHT_07_FILTER"]; };
		[08] = { name = L["RIGHT_08_NAME"]; filter = L["RIGHT_08_FILTER"]; };
		[09] = { name = L["RIGHT_09_NAME"]; filter = L["RIGHT_09_FILTER"]; };
	};
	["Exceptions"] = {
		[GetSpellInfo(2336)] = 11;
		[GetSpellInfo(3174)] = 3;
		[GetSpellInfo(11447)] = 11;
		[GetSpellInfo(17634)] = 3;
		[GetSpellInfo(24365)] = 1;
	};
};
