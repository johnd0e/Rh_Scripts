--[[ Calendar - Millo: English ]]--
--[[ Календарь - Милло: русский ]]--

--------------------------------------------------------------------------------
local Data = {
  ----------------------------------------
  Name = "Милло",
  ["Type.Millenium"] = "Календарь тысячелетий",

  ----------------------------------------
  WeekDay = {
    n = 3,
    [0] = {
      [0] = "10-й год",
      "1-й год", "2-й год", "3-й год",
      "4-й год", "5-й год", "6-й год",
      "7-й год", "8-й год", "9-й год",
    },
    --[[
    [1] = {
      [0] = "X",
      "1", "2", "3",
      "4", "5", "6",
      "7", "8", "9",
    },
    --]]
    [2] = {
      [0] = "Xг",
      "1г", "2г", "3г",
      "4г", "5г", "6г",
      "7г", "8г", "9г",
    },
    [3] = {
      [0] = "<X>",
      "<1>", "<2>", "<3>",
      "<4>", "<5>", "<6>",
      "<7>", "<8>", "<9>",
    },
  }, -- WeekDay

  ----------------------------------------
  YearMonth = {
    n = 3,
    [0] = {
      "1-я декада",  "2-я декада",
      "3-я декада",  "4-я декада",
      "5-я декада",  "6-я декада",
      "7-я декада",  "8-я декада",
      "9-я декада", "10-я декада",
    },
    --[[
    [1] = {
      "1", "2", "3", "4", "5",
      "6", "7", "8", "9", "X",
    },
    --]]
    [2] = {
      "01", "02", "03", "04", "05",
      "06", "07", "08", "09", "10",
    },
    [3] = {
      "⟨1⟩", "⟨2⟩", "⟨3⟩", "⟨4⟩", "⟨5⟩",
      "⟨6⟩", "⟨7⟩", "⟨8⟩", "⟨9⟩", "⟨X⟩",
    },
  }, -- YearMonth

  ----------------------------------------
} --- Data

return Data
--------------------------------------------------------------------------------
