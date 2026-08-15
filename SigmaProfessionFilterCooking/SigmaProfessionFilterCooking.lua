local L = SigmaProfessionFilterCooking.L;
local SPF = SigmaProfessionFilter[2];

local LocalTooltip = CreateFrame("GameTooltip", "SPF2CookingTooltip", WorldFrame, "GameTooltipTemplate");
LocalTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
LocalTooltip.LocalTooltips = {};
local LocalTooltips = LocalTooltip.LocalTooltips;

SigmaProfessionFilter[L["PROFESSION"]] = {
	["LeftMenu"] = {
		["title"] = L["LEFT_TITLE"];
		["tooltip"] = L["LEFT_TOOLTIP"];
		["Filter"] = function(skillIndex, groupIndex)
			local itemLink = SPF.baseGetTradeSkillItemLink(skillIndex);
			if not (LocalTooltips[itemLink] and strlen(LocalTooltips[itemLink]) > 0) then
				SPF.baseSetTradeSkillItem(LocalTooltip, skillIndex);
				LocalTooltips[itemLink] = "";
				for i = 1, LocalTooltip:NumLines() do
					local left = getglobal("SPF2CookingTooltipTextLeft" .. i);
					if left and SPF.match(left:GetText(), "Use:") then
						LocalTooltips[itemLink] = left:GetText();
						break;
					end

					local right = getglobal("SPF2CookingTooltipTextRight" .. i);
					if right and SPF.match(right:GetText(), "Use:") then
						LocalTooltips[itemLink] = right:GetText();
					end
				end
			end
			if SPF.match(itemLink, L["LEFT_05_FILTER"]) then
				if groupIndex == 0 or groupIndex == 5 then
					return 5;
				end
			elseif SPF.match(LocalTooltips[itemLink], L["LEFT_01_FILTER"]) then
				if groupIndex == 0 or groupIndex == 1 then
					return 1;
				end
			elseif SPF.match(LocalTooltips[itemLink], L["LEFT_02_FILTER"]) then
				if groupIndex == 0 or groupIndex == 2 then
					return 2;
				end
			elseif SPF.match(LocalTooltips[itemLink], L["LEFT_04_FILTER"]) then
				if groupIndex == 0 or groupIndex == 4 then
					return 4;
				end
			else
				if groupIndex == 0 or groupIndex == 3 then
					return 3;
				end
			end
			
			return 0;
		end;
		["FilterSpell"] = function(spellID, groupIndex)
			local itemLink = "item:"..SPF.GetRecipeInfo(spellID, "creates");
			if not (LocalTooltips[itemLink] and strlen(LocalTooltips[itemLink]) > 0) then
				LocalTooltip:SetHyperlink(itemLink);
				LocalTooltips[itemLink] = "";
				for i=2,4 do
					if strlen(LocalTooltips[itemLink]) == 0 or not SPF.match(LocalTooltips[itemLink], "Use:") then
						LocalTooltips[itemLink] = (getfenv()["SPF2CookingTooltipTextLeft"..i]):GetText() or "";
					end
				end
			end
			if SPF.match(itemLink, L["LEFT_05_FILTER"]) then
				if groupIndex == 0 or groupIndex == 5 then
					return 5;
				end
			elseif SPF.match(LocalTooltips[itemLink], L["LEFT_01_FILTER"]) then
				if groupIndex == 0 or groupIndex == 1 then
					return 1;
				end
			elseif SPF.match(LocalTooltips[itemLink], L["LEFT_02_FILTER"]) then
				if groupIndex == 0 or groupIndex == 2 then
					return 2;
				end
			elseif SPF.match(LocalTooltips[itemLink], L["LEFT_04_FILTER"]) then
				if groupIndex == 0 or groupIndex == 4 then
					return 4;
				end
			else
				if groupIndex == 0 or groupIndex == 3 then
					return 3;
				end
			end
			
			return 0;
		end;
	};
	["Left"] = {
		[01] = { name = L["LEFT_01_NAME"]; filter = L["LEFT_01_FILTER"]; };
		[02] = { name = L["LEFT_02_NAME"]; filter = L["LEFT_02_FILTER"]; };
		[03] = { name = L["LEFT_03_NAME"]; filter = L["LEFT_03_FILTER"]; };
		[04] = { name = L["LEFT_04_NAME"]; filter = L["LEFT_04_FILTER"]; };
		[05] = { name = L["LEFT_05_NAME"]; filter = L["LEFT_05_FILTER"]; };
	};
	["RightMenu"] = {
		["title"] = L["RIGHT_TITLE"];
		["tooltip"] = L["RIGHT_TOOLTIP"];
		["Filter"] = function(skillIndex, groupIndex)
			local itemLink = SPF.baseGetTradeSkillItemLink(skillIndex);
			if not (LocalTooltips[itemLink] and strlen(LocalTooltips[itemLink]) > 0) then
				SPF.baseSetTradeSkillItem(LocalTooltip, skillIndex);
				LocalTooltips[itemLink] = "";
				for i = 1, LocalTooltip:NumLines() do
					local left = getglobal("SPF2CookingTooltipTextLeft" .. i);
					if left and SPF.match(left:GetText(), "Use:") then
						LocalTooltips[itemLink] = left:GetText();
						break;
					end

					local right = getglobal("SPF2CookingTooltipTextRight" .. i);
					if right and SPF.match(right:GetText(), "Use:") then
						LocalTooltips[itemLink] = right:GetText();
					end
				end
			end
			if SPF.match(LocalTooltips[itemLink], L["RIGHT_04_FILTER"]) and SPF.match(LocalTooltips[itemLink], L["RIGHT_06_FILTER"]) then
				if groupIndex == 0 or groupIndex == 1 or groupIndex == 4 or groupIndex == 6 then
					return 1;
				end
			else
				for i=2,9 do
					if SPF.match(LocalTooltips[itemLink], L["RIGHT_0"..i.."_FILTER"]) then
						if groupIndex == 0 or groupIndex == i then
							return i;
						else
							return 0;
						end
					end
				end
			
				if SPF.match(LocalTooltips[itemLink], L["RIGHT_11_FILTER"]) then
					if groupIndex == 0 or groupIndex == 11 then
						return 11;
					end
				else
					if groupIndex == 0 or groupIndex == 10 then
						return 10;
					end
				end
			end
			
			return 0;
		end;
		["FilterSpell"] = function(spellID, groupIndex)
			local itemLink = "item:"..SPF.GetRecipeInfo(spellID, "creates");
			if not (LocalTooltips[itemLink] and strlen(LocalTooltips[itemLink]) > 0) then
				LocalTooltip:SetHyperlink(itemLink);
				LocalTooltips[itemLink] = "";
				for i=2,4 do
					if strlen(LocalTooltips[itemLink]) == 0 or not SPF.match(LocalTooltips[itemLink], "Use:") then
						LocalTooltips[itemLink] = (getfenv()["SPF2CookingTooltipTextLeft"..i]):GetText() or "";
					end
				end
			end
			if SPF.match(LocalTooltips[itemLink], L["RIGHT_04_FILTER"]) and SPF.match(LocalTooltips[itemLink], L["RIGHT_06_FILTER"]) then
				if groupIndex == 0 or groupIndex == 1 or groupIndex == 4 or groupIndex == 6 then
					return 1;
				end
			else
				for i=2,9 do
					if SPF.match(LocalTooltips[itemLink], L["RIGHT_0"..i.."_FILTER"]) then
						if groupIndex == 0 or groupIndex == i then
							return i;
						else
							return 0;
						end
					end
				end
			
				if SPF.match(LocalTooltips[itemLink], L["RIGHT_11_FILTER"]) then
					if groupIndex == 0 or groupIndex == 11 then
						return 11;
					end
				else
					if groupIndex == 0 or groupIndex == 10 then
						return 10;
					end
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
		[10] = { name = L["RIGHT_10_NAME"]; filter = L["RIGHT_10_FILTER"]; };
		[11] = { name = L["RIGHT_11_NAME"]; filter = L["RIGHT_11_FILTER"]; };
	};
};
