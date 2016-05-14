--[[ LuaDUM ]]--

----------------------------------------
--[[ description:
  -- Binding type to menu.
  -- Привязка типа к меню.
--]]
--------------------------------------------------------------------------------

----------------------------------------
--local context = context

local locale = require 'context.utils.useLocale'

--------------------------------------------------------------------------------

---------------------------------------- Custom
local Custom = {
  label = "LumBinds",
  name = "lum",
  path = "Rh_Scripts.LuaDUM.config.",
  locale = { kind = 'require', },
} ---

---------------------------------------- Locale
local L, e1, e2 = locale.localize(Custom)
if L == nil then
  return locale.showError(e1, e2)
end

---------------------------------------- Data
local Data = {

  ["@"] = { -- Информация
    Author = "Aidar",
    pack = "Rh_Scripts",
    text = "LuaDUM",
  },

  ["="] = { -- Замены:
    ini = "none",
    tzt = "none",
  },

  Default = { Caption = L.MainMenu,
              After = "UAddons;UScripts;UCommands;"..
                      "U_DefSep;FARMacro;UMConfig", },

  back   = { Menu = "UAddons;UScripts;U_DefSep;UMConfig", noDefault = true, },

  none   = { Menu = "Characters", },
  --text   = { Menu = "Characters", },

--text
  --plain
  --rich
    --define
      --(subtitles)
        --sub

    --markup
      --sgml
        --html
        --xml
          --(book)
            --fb2

  --source
    --main
      --(freqs)
        --c
        --pascal
      --dbl
      --codscript
        --lua
          --lua_lum

} ---

return Data
--------------------------------------------------------------------------------
