--[[ Truncater action ]]--

----------------------------------------
--[[ description:
  -- Void truncater action.
  -- Действие усекателя пустоты.
--]]
----------------------------------------
--[[ uses:
  LuaFAR,
  Rh Utils.
  -- areas: editor.
--]]
----------------------------------------
--[[ @notes:
   A truncation is:
   - deletion spaces at end of lines,
   - deletion empty / spaced lines at end of file.
   Усечение - это:
   - удаление пробелов в конце линий,
   - удаление пустых/пробельных линий в конце файла.
--]]
--------------------------------------------------------------------------------

----------------------------------------
local bit = bit64
local band = bit.band

----------------------------------------
local far = far
local F = far.Flags

local EditorGetInfo = editor.GetInfo
local EditorGetLine = editor.GetString
local EditorSetPos  = editor.SetPosition
--local EditorGetSel  = editor.GetSelection
local EditorSelect  = editor.Select

----------------------------------------
--local context = context
local logShow = context.ShowInfo

----------------------------------------
--local farEdit = require "Rh_Scripts.Utils.Editor"

--local EditorSetSel = farEdit.Selection.Set

local trunc = require "Rh_Scripts.Editor.VoidTruncate"

local TruncateLine  = trunc.TruncateLine
local TruncateFile  = trunc.TruncateFile
local UpdateLineEnd = trunc.UpdateLineEnd

--------------------------------------------------------------------------------

---------------------------------------- Process
local STANDARD_KEY_EVENT = F.KEY_EVENT
local FARMACRO_KEY_EVENT = F.FARMACRO_KEY_EVENT

local keyUt = require "Rh_Scripts.Utils.Keys"

local VK_END = keyUt.VKEY_Keys.END
local CMods = keyUt.VKEY_Mods
--local Cmask = CMods.BaseMask
local ALT, CTRL, SHIFT = CMods.Alt, CMods.Ctrl, CMods.Shift
--logShow({ ALT, CTRL, SHIFT }, "Cmod", "#xv4")

--local EType, CState, Info
--local BT_None = F.BTYPE_NONE
local BT_Stream, BT_Column = F.BTYPE_STREAM, F.BTYPE_COLUMN

--local debugs = require "context.utils.useDebugs"
--local flog = debugs.open("Trunc_test.log", "a", "")

function ProcessEditorInput (rec) --> (bool)
  --if rec.VirtualKeyCode == VK_END then logShow(rec, "rec", "xv4") end

  local EType = rec.EventType
  if (EType == STANDARD_KEY_EVENT or EType == FARMACRO_KEY_EVENT) and
     rec.VirtualKeyCode == VK_END and rec.KeyDown then
    --flog:logtab(rec, "rec", "xv4")
    local CState = rec.ControlKeyState
    --CState = band(rec.ControlKeyState, Cmask)
    --logShow(CState, CTRL, "xv4")
    --logShow(rec, "rec", "xv4")

    if band(CState, CTRL) ~= 0 then -- End of file
      -- TODO: Make block operation!
      TruncateFile(1)
      local Info = EditorGetInfo()
      local TotalLines = Info.TotalLines
      --[[
      local SelInfo
      if band(CState, SHIFT) ~= 0 then
        SelInfo = EditorGetSel()

      end
      --]]
      --logShow({ CState, Cmod, Info }, "State", "d2 xv4")

      --logShow(Info, "ProcessEditorInput")

      EditorSetPos(nil, TotalLines)
      --EditorSetPos(nil, Info.TotalLines)
      TruncateLine()

      --if CState == 0 then UpdateLineEnd() end

      if band(CState, SHIFT) ~= 0 then -- Select
        --logShow({ CState, Cmod, Info }, "State", "d2 xv4")
        local r = Info.CurLine
        local h = TotalLines - r + 1

        local p = Info.CurPos
        --local s = EditorGetLine(nil, 0, 3)

        --local l = (s or ""):len()
        --if l == 0 then l = 1 end

        local w = 0 --l - p + 1 -- Почему ширина д/б = 0 ?
        --[[
        logShow({ band(CState, ALT) ~= 0 and "Column" or "Stream",
                  "y1 = "..r,
                  "x1 = "..p,
                  "y2 = "..TotalLines,
                  "x2 = "..l,
                  "----------------------------------------",
                  "w  = "..w,
                  "h  = "..h,
                  s,
                  "----------------------------------------",
                  Info
                }, "TruncateLine")
        --]]

        EditorSelect(nil,
                     band(CState, ALT) ~= 0 and BT_Column or BT_Stream,
                     r, p,
                     w,
                     h
                    )
        --logShow(Info, "ProcessEditorInput")
        --far.AdvControl(F.ACTL_REDRAWALL)

      end
    else -- End of line
      --[[
      local Info = EditorGetInfo()
      local SelInfo
      if band(CState, SHIFT) ~= 0 then
        SelInfo = EditorGetSel()

      end
      --]]

      TruncateLine()
      --flog:logln("EOL")

      if CState == 0 then UpdateLineEnd() end

      --[[
      -- TODO: Добавить поддержку восстановления выделения! -- Не нужно!!!
      if band(CState, SHIFT) ~= 0 then -- Select
        --logShow({ CState, Cmod, Info }, "State", "d2 xv4")
        SelInfo = SelInfo or {}
        --logShow({ CState, Info, SelInfo }, "State", "w d2")
        SelInfo.BlockType = SelInfo.BlockType or
                            band(CState, ALT) ~= 0 and BT_Column or BT_Stream
        SelInfo.StartLine = Info.CurLine ~= SelInfo.StartLine and
                            SelInfo.StartLine or SelInfo.EndLine or
                            Info.CurLine
        SelInfo.StartPos  = Info.CurLine ~= SelInfo.StartLine and
                            SelInfo.StartPos or SelInfo.EndPos or
                            Info.CurPos
        SelInfo.EndLine   = Info.CurLine
        SelInfo.EndPos    = (EditorGetLine(nil, 0, 3) or ""):len()
        --logShow({ CState, Info, SelInfo }, "State", "w d2")

        EditorSetSel(nil, SelInfo)

      end
      --]]
    end
  end -- if

  return false

end ---- ProcessEditorInput
--------------------------------------------------------------------------------
