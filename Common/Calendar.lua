--[[ Calendar ]]--

----------------------------------------
--[[ description:
  -- Menu based simple calendar.
  -- Простой календарь на основе меню.
--]]
----------------------------------------
--[[ uses:
  LuaFAR,
  LF context,
  Rh Utils.
  -- group: Common.
  -- areas: any.
--]]
--------------------------------------------------------------------------------

local type = type
local pairs = pairs
local setmetatable = setmetatable

----------------------------------------
local useprofiler = false
--local useprofiler = true

if useprofiler then
  require "profiler" -- Lua Profiler
  profiler.start("Calendar.log")
end

----------------------------------------
--local win = win
--local win, far = win, far

----------------------------------------
--local context = context
local logShow = context.ShowInfo

--local utils = require 'context.utils.useUtils'
local numbers = require 'context.utils.useNumbers'
local strings = require 'context.utils.useStrings'
local tables = require 'context.utils.useTables'
local datas = require 'context.utils.useDatas'
local locale = require 'context.utils.useLocale'

local divf = numbers.divf

local Null = tables.Null
local addNewData = tables.extend

----------------------------------------
local farUt = require "Rh_Scripts.Utils.Utils"

local datim = require "Rh_Scripts.Utils.DateTime"

----------------------------------------
local keyUt = require "Rh_Scripts.Utils.Keys"

local IsModCtrl, IsModAlt = keyUt.IsModCtrl, keyUt.IsModAlt
local IsModCtrlAlt = keyUt.IsModCtrlAlt

--------------------------------------------------------------------------------
local unit = {}

---------------------------------------- Main data
--unit.FileName   = "DateTime"
--unit.FilePath   = "scripts\\Rh_Scripts\\Common\\"
unit.ScriptName = "Calendar"
unit.ScriptPath = "scripts\\Rh_Scripts\\Common\\"

local usercall = farUt.usercall
unit.RunMenu = usercall(nil, require, "Rh_Scripts.RectMenu.RectMenu")

---------------------------------------- ---- Custom
unit.DefCustom = {
  name = unit.ScriptName,
  path = unit.ScriptPath,

  label = unit.ScriptName,

  help   = { topic = unit.ScriptName, },
  locale = {
    kind = 'load',
    --file = unit.FileName,
    --path = unit.FilePath,
  }, --
} -- DefCustom

----------------------------------------
unit.DefOptions = {
  BaseDir  = "Rh_Scripts.Common."..unit.ScriptName..".",
} -- DefOptions

--[[
local L, e1, e2 = locale.localize(unit.DefCustom)
if L == nil then
  return locale.showError(e1, e2)
end

logShow(L, "L", "wM")
--]]
---------------------------------------- ---- Config
unit.DefCfgData = { -- Конфигурация по умолчанию:
} -- DefCfgData

---------------------------------------- ---- Types
--unit.DlgTypes = { -- Типы элементов диалога:
--} -- DlgTypes

---------------------------------------- Configure

---------------------------------------- Main class
local TMain = {
  Guid       = win.Uuid("1b26647b-44b0-4ac6-984d-45cba59568d0"),
  ConfigGuid = win.Uuid("1b537bfd-e907-4836-beff-5ac000823a5b"),
}
local MMain = { __index = TMain }

-- Создание объекта основного класса.
local function CreateMain (ArgData)

  local self = {
    ArgData   = addNewData(ArgData, unit.DefCfgData),

    Custom    = false,
    Options   = false,
    History   = false,
    CfgData   = false,
    --DlgTypes  = unit.DlgTypes,
    LocData   = false,
    L         = false,

    -- Текущее состояние:
    DT_cfg    = false,    -- Конфигурация даты+времени
    Date      = false,    -- Дата
    Time      = false,    -- Время

    World     = false,    -- Мир
    Type      = false,    -- Тип календаря
    wL        = false,    -- Локализация конфигурации

    YearMin   = false,    -- Минимально допустимый год
    YearMax   = false,    -- Максимально допустимый год

    WeekRows  = false,    -- Число строк для дней в неделе
    WeekCols  = false,    -- Число столбцов для недель в месяце

    InfoRows = false,     -- Количество строк с информацией
    InfoCols = false,     -- Количество столбцов с информацией
    RowLimit = false,     -- Ограничение на количество строк
    RowCount = false,     -- Количество строк меню
    ColCount = false,     -- Количество стобцов меню

    Fetes     = false,    -- Даты событий

    --Error     = false,    -- Текст ошибки
    --Menu      = false,    -- CfgData.Menu or {}

    Items     = false,    -- Список пунктов меню
    Props     = false,    -- Свойства меню

    ActItem   = false,    -- Выбранный пункт меню
    ItemPos   = false,    -- Позиция выбранного пункта меню
    --Action    = false,    -- Выбранное действие
    --Effect    = false,    -- Выбранный эффект
  } --- self

  self.ArgData.Custom = self.ArgData.Custom or {} -- MAYBE: addNewData with deep?!
  --logShow(self.ArgData, "ArgData", "wA d2")
  self.Custom = datas.customize(self.ArgData.Custom, unit.DefCustom)
  self.Options = addNewData(self.ArgData.Options, unit.DefOptions)

  self.History = datas.newHistory(self.Custom.history.full)
  self.CfgData = self.History:field(self.Custom.history.field)

  --local CfgData = self.CfgData
  --self.Menu = CfgData.Menu or {}
  --self.Menu.CompleteKeys = self.Menu.CompleteKeys or unit.CompleteKeys
  --self.Menu.LocalUseKeys = self.Menu.LocalUseKeys or unit.LocalUseKeys

  setmetatable(self.CfgData, { __index = self.ArgData })
  --logShow(self.CfgData, "CfgData", "w")

  locale.customize(self.Custom)
  --logShow(self.Custom, "Custom")

  return setmetatable(self, MMain)
end -- CreateMain

---------------------------------------- Dialog

---------------------------------------- Main making

---------------------------------------- ---- Init
do

function TMain:InitData ()
  local self = self
  local CfgData = self.CfgData
  --logShow(CfgData, "CfgData")

  local DT_cfg = datim.newConfig(CfgData.Config)
  self.DT_cfg = DT_cfg
  --logShow(DT_cfg, "DT_cfg", "wA d3")
  
  self.World    = CfgData.World or DT_cfg.World
  self.Type     = CfgData.Type or DT_cfg.Type
  self.wL       = DT_cfg.LocData

  --self.YearMin = CfgData.YearMin or 1
  self.YearMin  = CfgData.YearMin or DT_cfg.YearMin or -9998
  self.YearMax  = CfgData.YearMax or DT_cfg.YearMax or  9999
  self.WeekRows = DT_cfg.DayPerWeek + DT_cfg.OutPerWeek
  self.WeekCols = DT_cfg.MonthDays.WeekMax

  return true
end ---- InitData

  local prequire = farUt.prequire

function TMain:InitFetes ()
  local self = self
  local Options = self.Options

  Options.FeteName = self.World

  self.Fetes = prequire(Options.BaseDir..Options.FeteName) or {}
  --logShow(self.Fetes, "Fetes", "w d3")

  return true
end ---- InitFetes

-- Инициализация даты/времени.
function TMain:InitDateTime ()
  local self = self

  local CfgData = self.CfgData
  local DT_cfg = self.DT_cfg
  --logShow(CfgData, "CfgData")
  --logShow(DT_cfg, "DT_cfg", "w d3")

  self.Date = CfgData.Date and CfgData.Date:copy() or
              datim.newDate(1, 1, 1, DT_cfg)
  self.Time = CfgData.Time and CfgData.Time:copy() or
              datim.newTime(0, 0, 0, DT_cfg)
  --logShow(self.Date, "Default Date", "w d1")

  return true
end ---- InitDateTime

end -- do
---------------------------------------- ---- Prepare
do
-- Localize data.
-- Локализация данных.
function TMain:Localize ()
  local self = self

  self.LocData = locale.getData(self.Custom)
  -- TODO: Нужно выдавать ошибку об отсутствии файла сообщений!!!
  if not self.LocData then return end

  self.L = locale.make(self.Custom, self.LocData)

  return self.L
end ---- Localize

function TMain:MakeLocLen () --> (bool)
  local self = self

  local wL = self.wL
  if not wL then return end

  --logShow(L, self.World, "w d2")

  do -- Названия дней недели
    local WeekDay = wL.WeekDay[0]

    local MaxLen = WeekDay[0]:len()
    for k = 1, #WeekDay do
      local Len = WeekDay[k]:len()
      if MaxLen < Len then MaxLen = Len end
    end

    WeekDay.MaxLen = MaxLen
  end

  do -- Названия месяцев года
    local YearMonth = wL.YearMonth[0]

    local MaxLen = YearMonth[1]:len()
    for k = 2, #YearMonth do
      local Len = YearMonth[k]:len()
      if MaxLen < Len then MaxLen = Len end
    end

    YearMonth.MaxLen = MaxLen
  end

  return true
end ---- MakeLocLen

function TMain:MakeFetes ()
  local self = self

  local Fetes = self.Fetes
  if not Fetes then return end

  --local Custom = self.Custom

  return true
end ---- MakeFetes

function TMain:MakeColors ()

  local colors = require 'context.utils.useColors'
  local basics = colors.BaseColors
  local Basis = {
    --StandardFG  = basics.black,
    SelectedFG  = basics.blue,
    MarkedFG    = basics.maroon,
    --BorderFG    = basics.black,
    --TitleFG     = basics.black,
    --StatusBarFG = basics.black,
    --ScrollBarFG = basics.black,
  } --- Basis

  local menUt = require "Rh_Scripts.Utils.Menu"
  self.Colors = menUt.FormColors(Basis)

  return true
end ---- MakeColors

  local max = math.max

function TMain:MakeProps ()
  local self = self

  -- Свойства меню:
  local Props = self.CfgData.Props or {}
  self.Props = Props

  Props.Id = Props.Id or self.Guid
  Props.HelpTopic = self.Custom.help.tlink

  --local L = self.LocData
  --Props.Title  = L.Calendar

  local wL = self.wL
  local DT_cfg = self.DT_cfg

  Props.Title = wL[DT_cfg.Type]
  --Props.Bottom = wL[DT_cfg.Type] -- MAYBE: Keys list?
  --logShow(Props.Bottom, DT_cfg.Type, "wM d1")

  self.TextMax = max(DT_cfg.Formats.DateLen,-- Date length
                     DT_cfg.Formats.TimeLen,-- Time length
                     wL.Name:len() + 2,     -- World name
                     wL.WeekDay[0].MaxLen,  -- WeekDay max
                     wL.YearMonth[0].MaxLen -- YearMonth max
                    )

  self.InfoRows = 7
  self.InfoCols = 3
  self.RowLimit = max(self.WeekRows, self.InfoRows)
  self.RowCount = 1 + self.RowLimit + 1
  self.ColCount = self.InfoCols + self.WeekCols + 1

  -- Свойства RectMenu:
  local RM = {
    Order = "V",
    Rows = self.RowCount,
    --Cols = self.ColCount,

    Fixed = {
      HeadRows = 1,
      FootRows = self.RowCount - 1 - self.WeekRows,
      HeadCols = self.InfoCols,
      FootCols = 1,
    },

    --MenuEdge = 2,
    MenuAlign = "CM",

    TextMax = {
      [2] = self.TextMax,
    }, -- textMax

    Colors = self.Colors,

    IsStatusBar = true,
  } --- RM
  Props.RectMenu = RM

  return true
end ---- MakeProps

local Msgs = {
  NoLocale      = "No localization",
  NoWorldLocale = 'No localization for world "%s"',
} ---

-- Подготовка.
-- Preparing.
function TMain:Prepare ()

  self:InitData()
  self:InitFetes()

  self:InitDateTime()

  if not self:Localize() then
    self.Error = Msgs.NoLocale
    return
  end
  if not self:MakeLocLen() then
    self.Error = Msgs.NoWorldLocale:format(self.World or "Unknown")
    return
  end

  self:MakeFetes()

  self:MakeColors()

  return self:MakeProps()
end ---- Prepare

end -- do
---------------------------------------- ---- Menu
do
  local spaces = strings.spaces
  -- Центрирование выводимого текста. -- TEMP: До реализации в RectMenu!
  local function CenterText (Text, Max) --> (string)
    local Text = Text or ""
    local Len = Text:len()
    if Len >= Max then return Text end

    local sp = spaces[divf(Max - Len, 2)]

    return sp..Text
  end -- CenterText

-- Заполнение информационной части.
function TMain:FillInfoPart () --> (bool)
  local self = self
  
  local Date = self.Date
  local Time = self.Time
  --local World = self.World
  local DT_cfg = self.DT_cfg

  local RowCount = self.RowCount
  local ItemNames = {
    World     = RowCount + 1,
    Year      = RowCount + 3,
    Month     = RowCount + 4,
    Date      = RowCount + 6,
    Time      = RowCount + 9,
    WeekDay   = RowCount + 7,

    YearDay   = RowCount * 0 + 7,
    YearWeek  = RowCount * 2 + 7,

    PrevYear  =                3,
    NextYear  = RowCount * 2 + 3,
    PrevMonth =                4,
    NextMonth = RowCount * 2 + 4,

    Separators = {
                     2,                5,                8, -- 1
      RowCount     + 2, RowCount     + 5, RowCount     + 8, -- 2
      RowCount * 2 + 2, RowCount * 2 + 5, RowCount * 2 + 8, -- 3
                     1,                   RowCount * 1,     -- 1*
      RowCount * 2 + 1,                   RowCount * 3,     -- 3*
    }, --

  } -- ItemNames

  local Formats = DT_cfg.Formats
  local wL, Null = self.wL, Null
  --logShow(wL, "wL", "wA")
  local WeekDayNames   = (wL or Null).WeekDay or Null
  local YearMonthNames = (wL or Null).YearMonth or Null

  -- TODO: Реализовать свойство в TDate!
  local y = Date.y > 0 and Date.y or Date.y - 1

  local ItemDatas = {
    World     = self.World ~= "Terra" and
                Formats.World:format(wL.Name) or "",
    Year      = Formats.Year:format(y),
    Month     = (YearMonthNames[0] or Null)[Date.m],
    Date      = Formats.Date:format(y, Date.m, Date.d),
    Time      = Time and Formats.Time:format(Time.h, Time.n, Time.s) or "",
    WeekDay   = (WeekDayNames[0] or Null)[Date:getWeekDay()],

    YearDay   = Formats.YearDay:format(Date:getYearDay()),
    YearWeek  = Formats.YearWeek:format(Date:getYearWeek()),

    --[[
    PrevYear  = "<==",
    NextYear  = "==>",
    PrevMonth = "<--",
    NextMonth = "-->",
    --]]
  } --- ItemDatas

  --[[
  local ItemHints = {
    World     = Formats.Type:format(wL[DT_cfg.Type]),
  } --- ItemHints
  --]]

  local t = self.Items

  -- Текущая информация:
  local TextMax = self.TextMax
  for k, v in pairs(ItemDatas) do
    local pos = ItemNames[k]
    if pos then
      if pos < RowCount or pos > RowCount * 2 then
        t[pos].text = v
      else
        t[pos].text = CenterText(v, TextMax)
      end

      --[[
      local hint = ItemHints[k]
      if hint then t[pos].Hint = hint end
      --]]
    end
  end --

  local Separators = ItemNames.Separators
  for k = 1, #Separators do
    local v = Separators[k]
    t[v].separator = true
  end

  return true
end ---- FillInfoPart

-- Заполнение основной части.
-- TODO: Переделать под отдельный вывод месяцев с учётом вненедельных дат!
function TMain:FillMainPart () --> (bool)
  local self = self

  local Date = self.Date
  local WeekCols = self.WeekCols

  local DT_cfg = Date.config
  local Formats = DT_cfg.Formats
  local DayPerWeek = DT_cfg.DayPerWeek
  local OutPerWeek = DT_cfg.OutPerWeek
  
  local Real = Date:copy()
  Real.d = 1
  --logShow(Real, Date.d, "w d2")
  local MonthDays = Real:getWeekMonthDays()
  --logShow(Real, MonthDays, "w d2")
  local StartYearWeek = Real:getYearWeek()

  local YearWeekCount  = Real:getYearWeeks()
  local MonthWeekCount = Real:getMonthWeeks()

  local StartWeekShift = 0
  local StartWeekDay   = Real:getWeekNumDay()
  if StartWeekDay < divf(DayPerWeek, 2) then
    StartWeekShift = 1
    StartWeekDay = StartWeekDay + DayPerWeek
  end
  --t[RowCount * 3 - 1].text = ("%1d"):format(StartWeekDay) -- DEBUG
  
  --Real.StartWeekNumber = StartWeekShift + 1
  --Real.StartWeekNumDay = StartWeekDay - StartWeekShift * DayPerWeek

  -- Первый видимый день предыдущего месяца
  local Prev = Real:copy()
  Prev:shd(-1)
  --logShow({ Prev, Start }, StartWeekDay, "w d2")
  Prev.LastWeekNumber = 1 + StartWeekShift -
                        (StartWeekDay == DayPerWeek + 1 and 1 or 0)
  Prev.LastWeekNumDay = StartWeekDay - 1
  Prev:setMonthWeekDay(-Prev.LastWeekNumber, 1)
  --logShow({ StartWeekDay, StartWeekShift, Prev, Start }, StartWeekDay, "w d2")

  -- Первый видимый день следующего месяца
  local Next = Real:copy()
  --Next:shd(MonthDays)
  --Next:setMonthWeekDay(1 - StartWeekShift, 1)
  Next:shd(Real:getMonthDays())

  local MonthDayFmt = Formats.MonthDay

  -- Дни месяца:
  local t = self.Items
  local d = Real.d - 1  -- День текущего месяца
  local p = Prev.d - 1  -- День предыдущего месяца
  local q = Next.d - 1  -- День следующего месяца
  local SelIndex        -- Индекс пункта с текущей датой

  local k = self.FirstDayIndex - 1
  local EndRows = self.InfoRows - self.WeekRows
  for i = 1, WeekCols do
    -- Номер недели месяца:
    local week = i - StartWeekShift

    k = k + 1
    t[k].text = week > 0 and week <= MonthWeekCount and
                Formats.MonthWeek:format(week) or ""

    -- Дни недели:
    for j = 1, DayPerWeek do
      local State = 0
      if i < 3 then
        if (i - 1) * DayPerWeek + j < StartWeekDay then
          if p > 0 then
            p = p + 1
            --Prev.d = p
          end

          State = -1
        end

      elseif d >= MonthDays then
        if d == MonthDays then
          d = d + 1
          --Next.StartWeekNumber = j == DayPerWeek and i + 1 or i
          --Next.StartWeekNumDay = j == DayPerWeek and 1 or j + 1
        end

        p = false
        q = q + 1
        --Next.d = q

        State = 1
      end

      local Text = ""
      if State == 0 then
        d = d + 1
        --Real.d = d
        Text = MonthDayFmt:format(d)

        if not SelIndex and d == Date.d then
          SelIndex = k + 1
        end

        if d == MonthDays then
          Real.LastWeekNumber  = i
          Real.LastWeekNumDay  = j
        end

      else
        local day = p and p <= 0 and 0 or p or q
        Text = day > 0 and MonthDayFmt:format(day) or ""
      end

      k = k + 1
      local u = t[k]

      u.text = Text
      u.grayed = (State ~= 0)
      u.RectMenu = {
        TextMark = DT_cfg.RestWeekDays[j % DayPerWeek],
      } --
      u.Data = {
        r = j,
        c = i,
        State = State,
        [-1] = Prev,
        [ 0] = Real,
        [ 1] = Next,
        d = (State == 0 and d or
             p and p <= 0 and 0 or p or q),
      } --
    end -- for

    -- Вненедельные дни:
    if OutPerWeek > 0 then
      local Outs = 0
      local Curr = i == Prev.LastWeekNumber and Prev or
                   i == Real.LastWeekNumber and Real or false
      if Curr then Outs = Curr:getWeekMonthOuts() end

      if Curr and Outs > 0 then
        local State = 0
        if i == Prev.LastWeekNumber then
          State = -1
        end

        local b = Curr:getWeekMonthDays()

        for j = 1, Outs do

          b = b + 1
          if not SelIndex and State == 0 and b == Date.d then
            SelIndex = k + 1
          end

          k = k + 1
          local u = t[k]

          -- CHECK: Алгоритм просмотра вненедельных дат!
          u.text = MonthDayFmt:format(b)
          u.grayed = (State ~= 0)
          u.RectMenu = {
            TextMark = DT_cfg.RestWeekDays[-j],
          } --
          u.Data = {
            r = DayPerWeek + j,
            c = i,
            State = State,
            [-1] = Prev,
            [ 0] = Real,
            [ 1] = Next,
            d = b,
          } --
        end -- for

        k = k + OutPerWeek - Outs -- Пропуск остальных пунктов
      else
        k = k + OutPerWeek -- Просто пропуск вненедельных пунктов
      end
    end

    -- Номер недели года:
    week = StartYearWeek + i - 1 - StartWeekShift

    k = k + 1
    t[k].text = week > 0 and week <= YearWeekCount and
                Formats.DayWeek:format(week) or ""

    if EndRows > 0 then k = k + EndRows end -- Пропуск
    --[[
    for j = 1, self.InfoRows - self.WeekRows do
      k = k + 1
      --t[k].Label = true
    end
    --]]
  end -- for

  self.Props.SelectIndex = SelIndex

  return true
end ---- FillMainPart

-- Заполнение пояснительной части.
function TMain:FillNotePart () --> (bool)
  local self = self

  local DT_cfg = self.Date.config
  local Formats = DT_cfg.Formats
  local DayPerWeek = DT_cfg.DayPerWeek
  local OutPerWeek = DT_cfg.OutPerWeek

  local wL, Null = self.wL, Null
  --logShow(wL, "wL", "wA")
  local WeekDayNames = (wL or Null).WeekDay or Null
  local WeekDayShort = WeekDayNames[2] or WeekDayNames[3] or Null

  local WeekDayFmt = Formats.WeekDay

  -- Дни недели:
  local t = self.Items
  local k = self.FirstWeekIndex
  t[k].separator = true
  for w = 1, DayPerWeek do
    k = k + 1
    local u = t[k]

    u.text = WeekDayShort[w % DayPerWeek] or WeekDayFmt:format(w)
    u.RectMenu = {
      TextMark = DT_cfg.RestWeekDays[w % DayPerWeek],
    } --
  end

  for w = 1, OutPerWeek do
    k = k + 1
    local u = t[k]

    u.text = WeekDayShort[-w] or WeekDayFmt:format(-w)
    u.RectMenu = {
      --TextMark = true,
    } --
  end
  
  k = k + 1
  t[k].separator = true

  return true
end ---- FillNotePart

-- Формирование меню.
function TMain:MakeMenu () --> (table)
  local self = self

  local RowCount, ColCount = self.RowCount, self.ColCount
  -- Запоминание позиций для заполнения:
  self.FirstDayIndex  = RowCount * self.InfoCols + 1
  self.FirstWeekIndex = RowCount * (ColCount - 1) + 1

  local t = {}
  self.Items = t

  -- Формирование пунктов:
  for _ = 1, ColCount do
    for _ = 1, RowCount do
      t[#t+1] = {
        text = "",
        Label = true,
      } --
    end
  end --

  self:FillInfoPart() -- Информация
  self:FillMainPart() -- Календарь
  self:FillNotePart() -- Пояснение

  return true
end -- MakeMenu

-- Формирование календаря.
function TMain:Make () --> (table)

  self.Items = false -- Сброс меню (!)

  return self:MakeMenu()
end -- Make

end -- do
---------------------------------------- ---- Utils
-- Limit date.
-- Ограничение даты.
function TMain:LimitDate (Date)
  if Date.y < self.YearMin then
    Date.y = self.YearMin
    Date.m = 1
    Date.d = 1
  
  elseif Date.y > self.YearMax then
    Date.y = self.YearMax
    Date.m = Date:getYearMonths()
    Date.d = Date:getWeekMonthDays()
  end

  return Date
end ---- LimitDate
---------------------------------------- ---- Input
do
  local tonumber = tonumber
  local InputFmtY   = "^(%d+)"
  local InputFmtYM  = "^(%d+)%-(%d+)"
  local InputFmtYMD = "^(%d+)%-(%d+)%-(%d+)"

function TMain:ParseInput ()
  local self = self
  local Date = self.Date:copy()

  local Input = self.Input or ""
  local _, Count = Input:gsub("-", "")

  if Count == 0 then
    local y = Input:match(InputFmtY)
    y = tonumber(y) or 1
    Date.y, Date.m, Date.d = y, 1, 1
  elseif Count == 1 then
    local y, m = Input:match(InputFmtYM)
    y, m = tonumber(y) or 1, tonumber(m) or 1
    Date.y, Date.m, Date.d = y, m, 1
  else
    local y, m, d = Input:match(InputFmtYMD)
    y, m, d = tonumber(y) or 1, tonumber(m) or 1, tonumber(d) or 1
    --logShow({ Count, y, m, d }, Input)
    Date.y, Date.m, Date.d = y, m, d
  end

  return Date:fixMonth():fixDay()
end ---- ParseInput

function TMain:StartInput (Date)
  local self = self
  local L = self.LocData

  self.Input = ""
  self.Props.Bottom = L.InputDate
  self.IsInput = true
end ---- StartInput

function TMain:StopInput (Date)
  local self = self

  self.IsInput = false
  self.Props.Bottom = ""
  self.Date = self:ParseInput() or Date
end ---- StopInput

function TMain:EditInput (SKey)
  local self = self

  local Input = self.Input
  if SKey == "BS" then
    if Input ~= "" then Input = Input:sub(1, -2) end
  else
    if SKey == "Subtract" then SKey = "-" end

    Input = Input..SKey
  end

  self.Input = Input
  self.Props.Bottom = Input
end ---- EditInput

end -- do
---------------------------------------- ---- Events
do
  local CloseFlag  = { isClose = true }
  local CancelFlag = { isCancel = true }
  local CompleteFlags = { isRedraw = false, isRedrawAll = true }

  local DateActions = {
    AltLeft     = "dec_m",
    AltRight    = "inc_m",
    AltUp       = "dec_y",
    AltDown     = "inc_y",
  } -- DateActions

  local InputActions = {
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true,
    ["6"] = true,
    ["7"] = true,
    ["8"] = true,
    ["9"] = true,
    ["0"] = true,
    ["-"] = true,
    ["BS"] = true,
    ["Subtract"] = true,
  } --- InputActions

function TMain:AssignEvents () --> (bool | nil)
  local self = self

  local function MakeUpdate () -- Обновление!
    farUt.RedrawAll()
    self:Make()
    --logShow(self.Items, "MakeUpdate")
    if not self.Items then return nil, CloseFlag end
    --logShow(ItemPos, hex(FKey))
    return { self.Props, self.Items, self.Keys }, CompleteFlags
  end -- MakeUpdate

  -- Обработчик нажатия клавиш.
  local function KeyPress (Input, ItemPos)
    local SKey = Input.Name --or InputRecordToName(Input)
    if SKey == "Esc" then return nil, CancelFlag end
    --logShow(SKey, "SKey")

    --local DT_cfg = self.DT_cfg
    local Data = self.Items[ItemPos].Data
    if not Data then return end

    local Date = Data[Data.State]
    if Data.d <= 0 then return end
    Date.d = Data.d

    local isUpdate = true
    local Action = DateActions[SKey]
    if Action then
      Date[Action](Date)

    elseif SKey == "Divide" then
      if self.IsInput then
        self:StopInput(Date)
        return MakeUpdate()
      else
        self:StartInput(Date)
      end

    elseif self.IsInput and InputActions[SKey] then
      self:EditInput(SKey)

    else
      isUpdate = false
    end

    self.Time = false

    if isUpdate then
      --self.Date = Date
      self.Date = self:LimitDate(Date)
      return MakeUpdate()
    end

    return
  end -- KeyPress

  -- Обработчик нажатия клавиш навигации.
  local function NavKeyPress (AKey, VMod, ItemPos)
    --if self.IsInput then return end

    local AKey, VMod = AKey, VMod

    local DT_cfg = self.DT_cfg
    local Data = self.Items[ItemPos].Data
    if not Data then return end

    local State = Data.State
    local Date = Data[State]
    if Data.d <= 0 then return end
    Date.d = Data.d
    --logShow({ AKey, VMod, Data }, ItemPos, "w d2")

    local isOuts = DT_cfg.OutPerWeek > 0

    local isUpdate = true
    if VMod == 0 then
      --logShow({ AKey, VMod, Date }, ItemPos, "w d2")
      if AKey == "Clear" or AKey == "Multiply" then
        self:InitDateTime()
        return MakeUpdate()
      elseif AKey == "Left"  and Data.c == 1 then
        --Date:shd(-DT_cfg.DayPerWeek)
        if State == 0 then Date:shd(-DT_cfg.DayPerWeek) end
      elseif AKey == "Right" and Data.c == self.WeekCols then
        --Date:shd(DT_cfg.DayPerWeek)
        if State == 0 then Date:shd(DT_cfg.DayPerWeek) end
      elseif AKey == "Up"    and 
             ( Data.r == 1 or isOuts and
               (Date.d == 1 or Data.r >= DT_cfg.DayPerWeek) ) then
         Date:dec_d()
      elseif AKey == "Down"  and 
             (Data.r >= DT_cfg.DayPerWeek or
              isOuts and Date.d == Date:getWeekMonthDays()) then
        --logShow({ Date, Date:inc_d() }, AKey)
         --logShow(Date:inc_d(), AKey)
         Date:inc_d()
      else
        isUpdate = false
      end

    elseif IsModCtrl(VMod) then -- CTRL
      if AKey == "Clear" or AKey == "Multiply" then
        self:InitDateTime()
        return MakeUpdate()
      elseif AKey == "PgUp" then
        Date.y = (divf(Date.y, 10) - 1) * 10 + 1
        Date.m = 1
        Date.d = 1
      elseif AKey == "PgDn" then
        Date.y = (divf(Date.y, 10) + 1) * 10
        Date.m = Date:getYearMonths()
        Date.d = Date:getWeekMonthDays()
      elseif AKey == "Home" then
        Date.y = (divf(Date.y, 100) - 1) * 100 + 1
        Date.m = 1
        Date.d = 1
      elseif AKey == "End" then
        Date.y = (divf(Date.y, 100) + 1) * 100
        Date.m = Date:getYearMonths()
        Date.d = Date:getWeekMonthDays()
      else
        isUpdate = false
      end

    elseif IsModAlt(VMod) then -- ALT
      if AKey == "Clear" or AKey == "Multiply" then
        self:InitDateTime()
        return MakeUpdate()
      elseif AKey == "PgUp" then
        Date.d = 1
      elseif AKey == "PgDn" then
        Date.d = Date:getWeekMonthDays()
      elseif AKey == "Home" then
        if Date.m == 1 and Date.d == 1 then
          Date.y = Date.y - 1
        end
        Date.m = 1
        Date.d = 1
      elseif AKey == "End" then
        if Date.m == Date:getYearMonths() and
           Date.d == Date:getWeekMonthDays() then
          Date.y = Date.y + 1
        end
        Date.m = Date:getYearMonths()
        Date.d = Date:getWeekMonthDays()
      else
        isUpdate = false
      end

    elseif IsModCtrlAlt(VMod) then -- ALT+CTRL
      if AKey == "Clear" or AKey == "Multiply" then
        if Date.y == 1 and Date.m == 1 and Date.d == 1 then
          Date.y = 1
          Date.m = Date:getYearMonths()
          Date.d = Date:getWeekMonthDays()
        else
          Date.y = 1
          Date.m = 1
          Date.d = 1
        end
      elseif AKey == "PgUp" then
        Date.y = (divf(Date.y, 1000) - 1) * 1000 + 1
        Date.m = 1
        Date.d = 1
      elseif AKey == "PgDn" then
        Date.y = (divf(Date.y, 1000) + 1) * 1000
        Date.m = Date:getYearMonths()
        Date.d = Date:getWeekMonthDays()
      elseif AKey == "Home" then
        Date.y = self.YearMin
        Date.m = 1
        Date.d = 1
      elseif AKey == "End" then
        Date.y = self.YearMax
        Date.m = Date:getYearMonths()
        Date.d = Date:getWeekMonthDays()
      else
        isUpdate = false
      end

    else
      isUpdate = false
    end

    self.Time = false

    if isUpdate then
      self.Date = self:LimitDate(Date)
      return MakeUpdate()
    end

    return
  end -- NavKeyPress

  -- Обработчик выделения пункта.
  local function SelectItem (Kind, ItemPos)
    local Data = self.Items[ItemPos].Data
    --logShow(Data, ItemPos, "w d2")
    if not Data then return end

    self.Date = Data[Data.State]
    if Data.d <= 0 then return end
    self.Date.d = Data.d

    return self:FillInfoPart()
  end -- SelectItem

  -- Обработчик выбора пункта.
  local function ChooseItem (Kind, ItemPos)
    local Data = self.Items[ItemPos].Data
    if not Data then return end

    if self.IsInput and Kind == "Enter" then
      local Date = Data[Data.State]
      self:StopInput(Date)

      return MakeUpdate()
    end

    return nil, CloseFlag
  end -- ChooseItem

  -- Назначение обработчиков:
  local RM = self.Props.RectMenu
  RM.OnKeyPress = KeyPress
  RM.OnNavKeyPress = NavKeyPress
  RM.OnSelectItem = SelectItem
  RM.OnChooseItem = ChooseItem
end -- AssignEvents

end --

---------------------------------------- ---- Show
-- Показ меню заданного вида.
function TMain:ShowMenu () --> (item, pos)
  return usercall(nil, unit.RunMenu, self.Props, self.Items, self.Keys)
end ---- ShowMenu

-- Вывод календаря.
function TMain:Show () --> (bool | nil)

  --local Cfg = self.CfgData

  self:Make()
  if self.Error then return nil, self.Error end

  if useprofiler then profiler.stop() end

  self.ActItem, self.ItemPos = self:ShowMenu()

  return true
end -- Show

---------------------------------------- ---- Run
function TMain:Run () --> (bool | nil)

  self:AssignEvents()

  return self:Show()
end -- Run

---------------------------------------- main

function unit.Execute (Data) --> (bool | nil)

  --logShow(Data, "Data", "w d2")

  local _Main = CreateMain(Data)
  if not _Main then return end

  --logShow(Data, "Data", "w d2")
  --logShow(_Main, "Config", "w _d2")
  --logShow(_Main.CfgData, "CfgData", "w d2")
  --if not _Main.CfgData.Enabled then return end

  _Main:Prepare()
  if _Main.Error then return nil, _Main.Error end

  return _Main:Run()
end ---- Execute

--------------------------------------------------------------------------------
return unit
--return unit.Execute()
--------------------------------------------------------------------------------
