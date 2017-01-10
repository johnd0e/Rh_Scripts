--[[ Calendar - Millo: English ]]--

--------------------------------------------------------------------------------
local Data = {
  ----------------------------------------
  Name = "Milleniums",
  ["Type.Millenium"] = "Milleniums` calendar",

  ----------------------------------------
  WeekDay = {
    n = 3,

    [0] = {
      [0] = "10th year",
      "1st year", "2nd year", "3rd year",
      "4th year", "5th year", "6th year",
      "7th year", "8th year", "9th year",
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
      [0] = "yX",
      "y1", "y2", "y3",
      "y4", "y5", "y6",
      "y7", "y8", "y9",
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
      "1st century",  "2nd century",
      "3rd century",  "4th century",
      "5th century",  "6th century",
      "7th century",  "8th century",
      "9th century", "10th century",
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
