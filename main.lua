_, _, raceID = UnitRace("player");
local function zamot_print(string)
  print("|cFF9CCD25[ZMT]|r " .. string)
end

if raceID == 31 then
  if zandalarimoney == nil then
    zandalarimoney = 0;
  end
  if printzamot == nil then
    printzamot = false;
  end

  local function invert(pstr)
    return pstr:gsub("%%d", "(%1+)")
  end
  local cg = invert(GOLD_AMOUNT)
  local cs = invert(SILVER_AMOUNT)
  local cc = invert(COPPER_AMOUNT)

  local function ParseCoinString(tstr)
    if tstr == nil or tstr == "" then
      return 0
    end
    local g = tstr:match(cg) or 0
    local s = tstr:match(cs) or 0
    local c = tstr:match(cc) or 0
    return g * 10000 + s * 100 + c
  end

  local f = CreateFrame("FRAME");
  f:RegisterEvent("CHAT_MSG_MONEY");
  f:RegisterEvent("TIME_PLAYED_MSG")

  f:SetScript("OnEvent", function(self, event, ...)
    if event == "CHAT_MSG_MONEY" then
      local text = ...;
      _, text = strsplit("(", text)
      text = ParseCoinString(text)
      zandalarimoney = zandalarimoney + tonumber(text)
      if printzamot == true then
        zamot_print("Golden City Bonus: " .. GetCoinTextureString(text))
      end

      if event == "TIME_PLAYED_MSG" then
        zamot_print("Total Golden City Bonus: " .. GetCoinTextureString(zandalarimoney))
      end
    end
  end)
end

function ZandalariMoney_SlashCommandHandler(msg)
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)");
  _, _, raceID = UnitRace("player");
  if raceID == 31 then
    zamot_print("Total Golden City Bonus: " .. GetCoinTextureString(zandalarimoney))
  else
    zamot_print("You ain't no zandalari.")
  end
  if cmd == "print" then
    if printzamot == true then
      printzamot = false
      zamot_print("Printing looted bonus money is now |cFFFF0000OFF|r. Type |cFF9CCD25/zmt print|r again to enable.")
    else
      printzamot = true
      zamot_print("Printing looted bonus money is now |cFF00FF00ON|r. Type |cFF9CCD25/zmt print|r again to disable.")
    end
  end
end

SlashCmdList["ZANDALARIMONEY"] = ZandalariMoney_SlashCommandHandler;
SLASH_ZANDALARIMONEY1 = "/zmt";
