--[[ DateTime Info ]]--

----------------------------------------
--[[ description:
  -- Show date/time information.
  -- Показ информации о дате/времени.
--]]
----------------------------------------
--[[ uses:
  LuaFAR.
  -- group: Samples.
--]]
--------------------------------------------------------------------------------

----------------------------------------
local datim = require "Rh_Scripts.Utils.DateTime"

----------------------------------------
--[[
local dbg = require "context.utils.useDebugs"
local logShow = dbg.Show
--]]
--------------------------------------------------------------------------------
local Info = {}
local SepLine = "─────────────────────"

local dt = os.date("*t")

--logShow(dt, "os.date")
Info[#Info+1] = "────── os.date ──────"
Info[#Info+1] = ("%04d-%02d-%02d %02d:%02d:%02d"):format(
                 dt.year, dt.month, dt.day, dt.hour, dt.min, dt.sec)
Info[#Info+1] = ("Day of week =   %1d"):format(dt.wday - 1)
Info[#Info+1] = ("Day of year = %03d"):format(dt.yday)

local d = datim.newDate(dt.year, dt.month, dt.day)
--logShow(d, "TDate", "w")

local c = d.config
Info[#Info+1] = "────── TConfig ──────"
Info[#Info+1] = "isLeapYear  = "..tostring(c:isLeapYear(d.y))
Info[#Info+1] = "getLeapDays = "..("%1d"):format(c:getLeapDays(d.y))
Info[#Info+1] = "getYearDay  = "..("%03d"):format(c:getYearDay(d.y, d.m, d.d))
Info[#Info+1] = "getYearWeek = "..(" %02d"):format(c:getYearWeek(d.y, d.m, d.d))
Info[#Info+1] = "getWeekDay  = "..("  %1d"):format(c:getWeekDay(d.y, d.m, d.d))
Info[#Info+1] = "getEraDay   = "..("%d"):format(c:getEraDay(d.y, d.m, d.d))
Info[#Info+1] = SepLine

local t = datim.newDate(dt.hour, dt.min, dt.sec)
--logShow(t, "TDate", "w")

far.Show(unpack(Info))
--------------------------------------------------------------------------------
