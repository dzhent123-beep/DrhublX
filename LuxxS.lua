--[[
    DRHUB v5  |  key: LUXXS
    Tabs: Aimbot / ESP / Chams / World / Config
    Menu key (default RightShift) hides / shows the menu, the "Dr" icon is draggable.
    Themes, fonts, scale, corner radius and animations are in Config.
]]

local genv = (getgenv and getgenv()) or _G
local KEY = "LUXXS"

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local ParentGui = (gethui and gethui()) or game:GetService("CoreGui")

-- ============================================================
-- CLEANUP (re-execute safe)
-- ============================================================
if genv.DRHUB_Cleanup then pcall(genv.DRHUB_Cleanup) end
local Cleanups = {}
genv.DRHUB_Cleanup = function()
    for _, f in Cleanups do pcall(f) end
    table.clear(Cleanups)
end
local function OnCleanup(f) table.insert(Cleanups, f) end
local function Connect(sig, fn)
    local c = sig:Connect(fn)
    OnCleanup(function() c:Disconnect() end)
    return c
end

-- ============================================================
-- SETTINGS
-- ============================================================
local S = {
    -- Aimbot
    SilentAim = false, SnapAim = false, SnapSmooth = 4, AimKey = "None",
    TargetMode = "Nearest", TargetPart = "Head",
    Distance = 300, FOV = 120, CheckTeam = true, CheckWall = true, TargetBots = true,
    ShowFOV = false, FOVColor = Color3.fromRGB(255, 255, 255),
    -- ESP
    ESP = false, ESPBox = true, BoxStyle = "Corner", ESPOutline = true, ESPFill = false, FillAlpha = 0.15,
    ESPName = true, ESPDist = true, ESPHealth = true, ESPTracer = false, TracerOrigin = "Bottom",
    ESPSkeleton = false, ESPHead = false, ESPBots = true, ESPMates = false, ESPRainbow = false,
    ESPMax = 400, ESPNameSize = 13, ESPOpacity = 1,
    BoxColor = Color3.fromRGB(235, 70, 80), NameColor = Color3.fromRGB(255, 255, 255),
    TracerColor = Color3.fromRGB(255, 200, 70), SkelColor = Color3.fromRGB(255, 255, 255),
    HeadColor = Color3.fromRGB(255, 120, 120), MateColor = Color3.fromRGB(80, 220, 120),
    -- Chams
    Chams = false, ChamWalls = true, ChamPulse = false, ChamBots = true, ChamMates = false, ChamRainbow = false,
    ChamFill = Color3.fromRGB(235, 50, 80), ChamOutline = Color3.fromRGB(255, 255, 255),
    ChamMateFill = Color3.fromRGB(60, 200, 120),
    ChamFillT = 0.5, ChamOutT = 0, ChamMax = 600,
    -- World
    Fullbright = false, CustomAmbient = false, AmbientColor = Color3.fromRGB(120, 130, 190),
    CustomTime = false, ClockTime = 14, NoFog = false, CamFOVOn = false, CamFOV = 90,
    ColorCorr = false, CCSat = 0.2, CCCon = 0.1, CCBri = 0, CCTint = Color3.fromRGB(255, 255, 255),
    Bloom = false, BloomInt = 0.6,
    Cross = false, CrossDot = true, CrossColor = Color3.fromRGB(80, 255, 140),
    CrossSize = 8, CrossGap = 4, CrossThick = 1,
    -- Skins
    SkinOn = false, SkinPreset = "Gold", SkinMat = "Metal", SkinColor = Color3.fromRGB(255, 196, 56),
    SkinRefl = 0.3, SkinTrans = 0, SkinRainbow = false, SkinStrip = true, SkinView = true, SkinChar = true,
    SkinFilter = "Deagle",
    -- Menu
    IconX = 140, IconY = 34,
    Theme = "Crimson", UIAccent = Color3.new(1, 0, 0), MenuKey = "RightShift", PanicKey = "None",
    UIScale = 1, Radius = 3, UIFont = "Ubuntu", Anim = true, AnimSpeed = 1,
    Notifs = true, Watermark = true, FeatureList = true, ShowIcon = true,
}

local Themes = {
    Crimson = { Accent = Color3.fromRGB(214, 62, 78), Bg = Color3.fromRGB(17, 17, 21), Panel = Color3.fromRGB(23, 23, 28), Row = Color3.fromRGB(32, 32, 39), Border = Color3.fromRGB(46, 46, 55) },
    Mint = { Accent = Color3.fromRGB(58, 196, 146), Bg = Color3.fromRGB(15, 19, 19), Panel = Color3.fromRGB(20, 25, 25), Row = Color3.fromRGB(28, 35, 35), Border = Color3.fromRGB(40, 54, 51) },
    Ocean = { Accent = Color3.fromRGB(72, 140, 255), Bg = Color3.fromRGB(15, 17, 24), Panel = Color3.fromRGB(20, 23, 32), Row = Color3.fromRGB(28, 32, 45), Border = Color3.fromRGB(40, 46, 64) },
    Amber = { Accent = Color3.fromRGB(232, 158, 48), Bg = Color3.fromRGB(20, 18, 15), Panel = Color3.fromRGB(27, 24, 20), Row = Color3.fromRGB(37, 33, 28), Border = Color3.fromRGB(56, 49, 40) },
    Violet = { Accent = Color3.fromRGB(146, 100, 250), Bg = Color3.fromRGB(18, 16, 24), Panel = Color3.fromRGB(24, 21, 32), Row = Color3.fromRGB(34, 30, 45), Border = Color3.fromRGB(52, 45, 68) },
    Mono = { Accent = Color3.fromRGB(222, 222, 228), Bg = Color3.fromRGB(13, 13, 13), Panel = Color3.fromRGB(19, 19, 19), Row = Color3.fromRGB(28, 28, 28), Border = Color3.fromRGB(46, 46, 46) },
}
local ThemeNames = { "Crimson", "Mint", "Ocean", "Amber", "Violet", "Mono" }

local T = { Text = Color3.fromRGB(228, 228, 234), Dim = Color3.fromRGB(128, 128, 142) }
for k, v in Themes.Crimson do T[k] = v end
S.UIAccent = T.Accent
local WHITE = Color3.new(1, 1, 1)

local Defaults = {}
for k, v in S do Defaults[k] = v end

local Ranges, Options = {}, {}   -- filled by sliders / dropdowns, used to validate configs

-- ============================================================
-- UI HELPERS
-- ============================================================
local Refresh, Callbacks, Texts, Corners, Themed = {}, {}, {}, {}, {}

-- color props may be given as "$Token" (Bg, Panel, Row, Border, Accent, Text, Dim) and follow the theme
local function New(class, props, kids)
    local o = Instance.new(class)
    local parent
    for k, v in props or {} do
        if k == "Parent" then
            parent = v
        elseif type(v) == "string" and v:sub(1, 1) == "$" and k:find("Color") then
            local key = v:sub(2)
            o[k] = T[key]
            table.insert(Themed, { o, k, key })
        else
            o[k] = v
        end
    end
    for _, c in kids or {} do c.Parent = o end
    if parent then o.Parent = parent end
    return o
end
local function Tween(o, t, p, style, dir)
    if not S.Anim then t = 0 end
    local tw = TweenService:Create(o, TweenInfo.new(t / math.max(S.AnimSpeed, 0.1), style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), p)
    tw:Play()
    return tw
end
local function Stroke(color, th, tr)
    return New("UIStroke", { Color = color or "$Border", Thickness = th or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
end
local function Corner(circle)
    local c = New("UICorner", { CornerRadius = circle and UDim.new(1, 0) or UDim.new(0, S.Radius) })
    if not circle then table.insert(Corners, c) end
    return c
end
local function SetRadius(v)
    for _, c in Corners do
        if c.Parent then c.CornerRadius = UDim.new(0, v) end
    end
end
local function Pad(l, t, r, b)
    return New("UIPadding", {
        PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r), PaddingBottom = UDim.new(0, b),
    })
end

local function ApplyTheme()
    for i = #Themed, 1, -1 do
        local e = Themed[i]
        if not e[1].Parent then
            table.remove(Themed, i)
        else
            e[1][e[2]] = T[e[3]]
        end
    end
end
local function RunRefresh()
    for _, f in Refresh do pcall(f) end
end
local function Accent(obj, prop)
    obj[prop] = T.Accent
    table.insert(Themed, { obj, prop, "Accent" })
end
local function SetAccent(c)
    T.Accent = c
    S.UIAccent = c
    ApplyTheme()
    RunRefresh()
end
local function ApplyPreset(name, keepAccent)
    local th = Themes[name]
    if not th then return end
    for k, v in th do
        if k ~= "Accent" then T[k] = v end
    end
    if keepAccent then
        T.Accent = S.UIAccent
    else
        T.Accent = th.Accent
        S.UIAccent = th.Accent
    end
    ApplyTheme()
    RunRefresh()
end

local FontSets = {
    Ubuntu = { Enum.Font.Ubuntu, Enum.Font.Ubuntu },
    SourceSans = { Enum.Font.SourceSans, Enum.Font.SourceSansBold },
    Gotham = { Enum.Font.Gotham, Enum.Font.GothamBold },
    Code = { Enum.Font.Code, Enum.Font.Code },
    RobotoMono = { Enum.Font.RobotoMono, Enum.Font.RobotoMono },
    Arial = { Enum.Font.Arial, Enum.Font.ArialBold },
}
local FontNames = { "Ubuntu", "SourceSans", "Gotham", "Code", "RobotoMono", "Arial" }
local function FontOf(bold)
    local set = FontSets[S.UIFont] or FontSets.Ubuntu
    return bold and set[2] or set[1]
end
local function SetFont()
    for i = #Texts, 1, -1 do
        local e = Texts[i]
        if e[1].Parent then e[1].Font = FontOf(e[2]) else table.remove(Texts, i) end
    end
end
local function Txt(class, props, bold, kids)
    local o = New(class, props, kids)
    o.Font = FontOf(bold)
    table.insert(Texts, { o, bold })
    return o
end
local function Label(parent, text, pos, size, color, ts, bold, align)
    return Txt("TextLabel", {
        Parent = parent, BackgroundTransparency = 1, Text = text, Position = pos or UDim2.new(), Size = size,
        TextColor3 = color or "$Text", TextSize = ts or 13, TextXAlignment = align or Enum.TextXAlignment.Left,
    }, bold)
end

-- press + drag on a frame (sliders, color pickers)
local function Pointer(frame, onMove, scrollLock)
    local down = false
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            down = true
            if scrollLock then scrollLock.ScrollingEnabled = false end
            onMove(i.Position)
        end
    end)
    Connect(UIS.InputChanged, function(i)
        if down and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            onMove(i.Position)
        end
    end)
    Connect(UIS.InputEnded, function(i)
        if down and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            down = false
            if scrollLock then scrollLock.ScrollingEnabled = true end
        end
    end)
end

-- draggable window / icon (onClick only fires when it was not dragged)
local function Draggable(handle, target, onClick)
    local drag, moved, startIn, startPos = false, false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag, moved, startIn, startPos = true, false, i.Position, target.Position
        end
    end)
    Connect(UIS.InputChanged, function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startIn
            if d.Magnitude > 6 then moved = true end
            if moved then
                target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end
    end)
    Connect(UIS.InputEnded, function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            drag = false
            if not moved and onClick then onClick() end
        end
    end)
end

-- ============================================================
-- TARGET HELPERS (list is built once per frame and shared)
-- ============================================================
local FrameId = 0
local TargetCache = { [true] = { frame = -1, list = {} }, [false] = { frame = -1, list = {} } }
local BotList, BotStamp = {}, 0

local function IsAlive(ch)
    if not ch or not ch.Parent then return false end
    if ch:GetAttribute("Alive") == false then return false end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    return hum ~= nil and hum.Health > 0
end

local function GetTargets(includeBots)
    local c = TargetCache[includeBots and true or false]
    if c.frame == FrameId then return c.list end
    local list = {}
    for _, p in Players:GetPlayers() do
        if p ~= LocalPlayer then
            local ch = p.Character
            table.insert(list, {
                Key = p, Name = p.Name, Character = ch, Player = p,
                IsBot = ch ~= nil and ch:GetAttribute("IsBot") == true,
            })
        end
    end
    if includeBots then
        if os.clock() - BotStamp > 0.5 then
            BotStamp = os.clock()
            table.clear(BotList)
            for _, m in workspace:GetChildren() do
                if m:IsA("Model") and m:GetAttribute("IsBot") == true
                    and m ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(m) then
                    table.insert(BotList, m)
                end
            end
        end
        for _, m in BotList do
            if m.Parent then
                table.insert(list, { Key = m, Name = m.Name, Character = m, IsBot = true })
            end
        end
    end
    c.frame = FrameId
    c.list = list
    return list
end

local function IsValid(t)
    return t.Character ~= nil and IsAlive(t.Character)
end

-- team detection: Roblox Teams -> "Team" attribute (player or character)
local function TeamAttr(p, ch)
    local a = p and p:GetAttribute("Team")
    if a == nil and ch then a = ch:GetAttribute("Team") end
    return a
end
local function IsTeammate(t)
    if t.IsBot and not t.Player then
        local ba = t.Character and t.Character:GetAttribute("Team")
        if ba == nil then return false end
        local la = TeamAttr(LocalPlayer, LocalPlayer.Character)
        if la ~= nil then return ba == la end
        return LocalPlayer.Team ~= nil and tostring(ba) == LocalPlayer.Team.Name
    end
    local p = t.Player
    if not p then return false end
    local lt, pt = LocalPlayer.Team, p.Team
    if lt and pt then return lt == pt end
    local la = TeamAttr(LocalPlayer, LocalPlayer.Character)
    local pa = TeamAttr(p, p.Character)
    if la ~= nil and pa ~= nil then return la == pa end
    return false
end

local function Rainbow() return Color3.fromHSV((tick() * 0.25) % 1, 1, 1) end

local function IsHeld(name)
    if not name or name == "None" then return true end
    if name:sub(1, 11) == "MouseButton" then
        return UIS:IsMouseButtonPressed(Enum.UserInputType[name])
    end
    local ok, kc = pcall(function() return Enum.KeyCode[name] end)
    return (ok and kc and UIS:IsKeyDown(kc)) or false
end

local function ValidKey(v)
    if type(v) ~= "string" then return false end
    if v == "None" or v:sub(1, 11) == "MouseButton" then return true end
    return (pcall(function() return Enum.KeyCode[v] end))
end

-- ============================================================
-- CONFIG (files if the executor supports it, memory otherwise)
-- ============================================================
local CFG_DIR = "DRHUB_cfg"
local HasFS = (writefile and readfile and isfile and isfolder and makefolder and listfiles) ~= nil
local MemCfg = genv.DRHUB_MemCfg or {}
genv.DRHUB_MemCfg = MemCfg
local KeyFields = { MenuKey = true, AimKey = true, PanicKey = true }

local function EncodeCfg()
    local out = {}
    for k, v in S do
        if typeof(v) == "Color3" then out[k] = { __c = { v.R, v.G, v.B } } else out[k] = v end
    end
    return HttpService:JSONEncode(out)
end
-- every value is checked: wrong type / out of range / unknown option is ignored
local function DecodeCfg(json)
    local ok, data = pcall(HttpService.JSONDecode, HttpService, json)
    if not ok or type(data) ~= "table" then return false end
    for k, v in data do
        local cur = S[k]
        if cur ~= nil then
            if typeof(cur) == "Color3" then
                if type(v) == "table" and type(v.__c) == "table" then
                    local r, g, b = tonumber(v.__c[1]), tonumber(v.__c[2]), tonumber(v.__c[3])
                    if r and g and b then S[k] = Color3.new(math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1)) end
                end
            elseif type(cur) == "number" then
                if type(v) == "number" and v == v then
                    local rg = Ranges[k]
                    S[k] = rg and math.clamp(v, rg[1], rg[2]) or v
                end
            elseif type(cur) == "boolean" then
                if type(v) == "boolean" then S[k] = v end
            elseif type(cur) == "string" then
                if type(v) == "string" then
                    if KeyFields[k] then
                        if ValidKey(v) then S[k] = v end
                    elseif not Options[k] or table.find(Options[k], v) then
                        S[k] = v
                    end
                end
            end
        end
    end
    return true
end
local function CleanName(n)
    n = tostring(n or ""):gsub("[^%w_%-%s]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    return n
end
local function EnsureDir()
    if HasFS and not isfolder(CFG_DIR) then makefolder(CFG_DIR) end
end
local function ListConfigs()
    local names = {}
    if HasFS then
        pcall(function()
            EnsureDir()
            for _, path in listfiles(CFG_DIR) do
                local n = path:match("([^/\\]+)%.json$")
                if n then table.insert(names, n) end
            end
        end)
    else
        for n in MemCfg do table.insert(names, n) end
    end
    table.sort(names)
    return names
end
local function WriteCfg(name)
    if HasFS then
        return (pcall(function() EnsureDir(); writefile(CFG_DIR .. "/" .. name .. ".json", EncodeCfg()) end))
    end
    MemCfg[name] = EncodeCfg()
    return true
end
local function ReadCfg(name)
    if HasFS then
        local ok, data = pcall(function()
            local p = CFG_DIR .. "/" .. name .. ".json"
            return isfile(p) and readfile(p) or nil
        end)
        return ok and data or nil
    end
    return MemCfg[name]
end

-- ============================================================
-- MAIN
-- ============================================================
local function Main()
    local HasDrawing = (Drawing ~= nil and Drawing.new ~= nil)
    local isOpen = false
    local Binding = false
    local Touch = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local RowH = Touch and 28 or 24

    local IconGui = New("ScreenGui", {
        Name = "DRHUB_Icon", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 9999, Parent = ParentGui,
    })
    OnCleanup(function() IconGui:Destroy() end)

    -- toast stack (bottom right)
    local ToastBox = New("Frame", {
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -12, 1, -12), Size = UDim2.new(0, 250, 1, -24),
        BackgroundTransparency = 1, Parent = IconGui,
    }, { New("UIListLayout", {
        Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Bottom, SortOrder = Enum.SortOrder.LayoutOrder,
    }) })
    local toastN = 0
    local function Notify(text)
        if not S.Notifs then return end
        toastN += 1
        local wrap = New("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = toastN, Parent = ToastBox })
        local f = New("Frame", {
            Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(1, 40, 0, 0), BackgroundColor3 = "$Bg", Parent = wrap,
        }, { Corner(), Stroke() })
        local bar = New("Frame", { Size = UDim2.new(0, 3, 1, 0), BorderSizePixel = 0, Parent = f })
        Accent(bar, "BackgroundColor3")
        Label(f, text, UDim2.new(0, 12, 0, 0), UDim2.new(1, -16, 1, 0), "$Text", 13)
        Tween(f, 0.25, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back)
        task.delay(2.6, function()
            local tw = Tween(f, 0.2, { Position = UDim2.new(1, 40, 0, 0) })
            tw.Completed:Wait()
            wrap:Destroy()
        end)
    end

    -- ============================================================
    -- AIMBOT
    -- ============================================================
    local DeagleShared, OrigRaycast
    local Hooked = false

    task.spawn(function()
        local ok, mod = pcall(function()
            return require(RS:WaitForChild("Modules", 8):WaitForChild("Shared", 8):WaitForChild("DeagleShared", 8))
        end)
        if ok and mod then
            DeagleShared = mod
            if not genv.DRHUB_OrigRaycast then genv.DRHUB_OrigRaycast = mod.Raycast end
            OrigRaycast = genv.DRHUB_OrigRaycast
            if S.SilentAim and Callbacks.SilentAim then Callbacks.SilentAim(true) end
        end
    end)

    local function TargetPos(ch)
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        return (ch:FindFirstChild(S.TargetPart) or hrp).Position
    end

    local function IsVisible(from, pos, ch)
        if not S.CheckWall then return true end
        local ignore = { ch }
        if LocalPlayer.Character then table.insert(ignore, LocalPlayer.Character) end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = ignore
        return workspace:Raycast(from, pos - from, params) == nil
    end

    local function CrosshairDist(pos)
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local pt, on = cam:WorldToViewportPoint(pos)
        if not on then return nil end
        return (Vector2.new(pt.X, pt.Y) - cam.ViewportSize / 2).Magnitude
    end

    local function FindTarget(from)
        local best, bestPos, bestScore = nil, nil, math.huge
        for _, t in GetTargets(S.TargetBots) do
            if IsValid(t) and not (S.CheckTeam and IsTeammate(t)) then
                local pos = TargetPos(t.Character)
                if pos then
                    local dist = (pos - from).Magnitude
                    if dist <= S.Distance then
                        local score = dist
                        local okFov = true
                        if S.TargetMode == "FOV" then
                            local cd = CrosshairDist(pos)
                            if not cd or cd > S.FOV then okFov = false else score = cd end
                        end
                        if okFov and score < bestScore and IsVisible(from, pos, t.Character) then
                            best, bestPos, bestScore = t, pos, score
                        end
                    end
                end
            end
        end
        return best, bestPos
    end

    local function SetSilent(on)
        if on then
            if not DeagleShared then
                if next(Refresh) then Notify("DeagleShared not found (yet)") end
                return
            end
            if Hooked then return end
            Hooked = true
            DeagleShared.Raycast = function(origin, from, to)
                local ok, t, pos = pcall(FindTarget, from)
                if ok and t and pos then return OrigRaycast(origin, from, pos) end
                return OrigRaycast(origin, from, to)
            end
        elseif Hooked and DeagleShared then
            Hooked = false
            DeagleShared.Raycast = OrigRaycast
        end
    end
    OnCleanup(function() SetSilent(false) end)

    local function Snap()
        if not S.SnapAim or not IsHeld(S.AimKey) then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local t, pos = FindTarget(cam.CFrame.Position)
        if not t or not pos then return end
        local desired = CFrame.new(cam.CFrame.Position, pos)
        local sm = math.max(S.SnapSmooth, 1)
        cam.CFrame = sm <= 1 and desired or cam.CFrame:Lerp(desired, 1 / sm)
    end
    RunService:BindToRenderStep("DRHUB_Aim", Enum.RenderPriority.Camera.Value + 1, function() pcall(Snap) end)
    OnCleanup(function() RunService:UnbindFromRenderStep("DRHUB_Aim") end)

    -- ============================================================
    -- ESP (Drawing)
    -- ============================================================
    local ESPCache = {}
    local FOVCircle
    local CrossObjs = {}
    local function NewDrawing(class, props)
        local d = Drawing.new(class)
        for k, v in props do d[k] = v end
        return d
    end
    if HasDrawing then
        FOVCircle = NewDrawing("Circle", { Thickness = 1, Filled = false, NumSides = 64, Visible = false })
        for i = 1, 4 do CrossObjs[i] = NewDrawing("Line", { Visible = false }) end
        CrossObjs[5] = NewDrawing("Circle", { Filled = true, NumSides = 12, Visible = false })
    end

    local Fixed = { "Box", "Outline", "Fill", "Name", "Tracer", "HpBack", "Hp", "Head" }
    local function CreateESP()
        return {
            Box = NewDrawing("Square", { Thickness = 1, Filled = false, Visible = false }),
            Outline = NewDrawing("Square", { Thickness = 3, Filled = false, Color = Color3.new(0, 0, 0), Visible = false }),
            Fill = NewDrawing("Square", { Filled = true, Thickness = 1, Visible = false }),
            Name = NewDrawing("Text", { Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Visible = false }),
            Tracer = NewDrawing("Line", { Thickness = 1, Visible = false }),
            HpBack = NewDrawing("Line", { Thickness = 4, Color = Color3.new(0, 0, 0), Visible = false }),
            Hp = NewDrawing("Line", { Thickness = 2, Visible = false }),
            Head = NewDrawing("Circle", { Thickness = 1, Filled = false, NumSides = 16, Visible = false }),
            Corners = {},
            Bones = {},
        }
    end
    local function HideCorners(d) for _, l in d.Corners do l.Visible = false end end
    local function HideESP(d)
        for _, k in Fixed do d[k].Visible = false end
        HideCorners(d)
        for _, l in d.Bones do l.Visible = false end
    end
    local function RemoveESP(d)
        for _, k in Fixed do pcall(function() d[k]:Remove() end) end
        for _, l in d.Corners do pcall(function() l:Remove() end) end
        for _, l in d.Bones do pcall(function() l:Remove() end) end
    end
    OnCleanup(function()
        for k, d in ESPCache do RemoveESP(d); ESPCache[k] = nil end
        if FOVCircle then pcall(function() FOVCircle:Remove() end) end
        for _, o in CrossObjs do pcall(function() o:Remove() end) end
    end)

    local BonesR15 = {
        { "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" },
        { "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
        { "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
        { "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
        { "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
    }
    local BonesR6 = {
        { "Head", "Torso" }, { "Torso", "Left Arm" }, { "Torso", "Right Arm" }, { "Torso", "Left Leg" }, { "Torso", "Right Leg" },
    }

    local function PickColor(base, mate, rainbow)
        if mate then return S.MateColor end
        if S.ESPRainbow then return rainbow end
        return base
    end

    local function DrawCorners(d, x, y, w, h, color, op)
        if #d.Corners == 0 then
            for i = 1, 8 do d.Corners[i] = NewDrawing("Line", { Thickness = 1, Visible = false }) end
        end
        local l = math.max(math.min(w, h) * 0.25, 4)
        local pts = {
            { x, y, x + l, y }, { x, y, x, y + l },
            { x + w, y, x + w - l, y }, { x + w, y, x + w, y + l },
            { x, y + h, x + l, y + h }, { x, y + h, x, y + h - l },
            { x + w, y + h, x + w - l, y + h }, { x + w, y + h, x + w, y + h - l },
        }
        for i, p in pts do
            local ln = d.Corners[i]
            ln.From = Vector2.new(p[1], p[2])
            ln.To = Vector2.new(p[3], p[4])
            ln.Color = color
            ln.Transparency = op
            ln.Visible = true
        end
    end

    local function DrawSkeleton(d, ch, cam, color, op)
        local bones = ch:FindFirstChild("UpperTorso") and BonesR15 or BonesR6
        for i, pair in bones do
            local line = d.Bones[i]
            if not line then
                line = NewDrawing("Line", { Thickness = 1, Visible = false })
                d.Bones[i] = line
            end
            local a, b = ch:FindFirstChild(pair[1]), ch:FindFirstChild(pair[2])
            if a and b then
                local pa = cam:WorldToViewportPoint(a.Position)
                local pb = cam:WorldToViewportPoint(b.Position)
                if pa.Z > 0 and pb.Z > 0 then
                    line.From = Vector2.new(pa.X, pa.Y)
                    line.To = Vector2.new(pb.X, pb.Y)
                    line.Color = color
                    line.Transparency = op
                    line.Visible = true
                else line.Visible = false end
            else line.Visible = false end
        end
        for i = #bones + 1, #d.Bones do d.Bones[i].Visible = false end
    end

    local function DrawPlayer(d, t, ch, cam, vp, top, bot, dist, mate, rainbow, op)
        local h = bot.Y - top.Y
        local w = h * 0.55
        local x = (top.X + bot.X) / 2
        local px, py = x - w / 2, top.Y
        local cBox = PickColor(S.BoxColor, mate, rainbow)

        if S.ESPFill then
            d.Fill.Size = Vector2.new(w, h)
            d.Fill.Position = Vector2.new(px, py)
            d.Fill.Color = cBox
            d.Fill.Transparency = S.FillAlpha * op
            d.Fill.Visible = true
        else d.Fill.Visible = false end

        if S.ESPBox and S.BoxStyle == "Full" then
            HideCorners(d)
            d.Outline.Size = Vector2.new(w, h)
            d.Outline.Position = Vector2.new(px, py)
            d.Outline.Transparency = op
            d.Outline.Visible = S.ESPOutline
            d.Box.Size = Vector2.new(w, h)
            d.Box.Position = Vector2.new(px, py)
            d.Box.Color = cBox
            d.Box.Transparency = op
            d.Box.Visible = true
        elseif S.ESPBox then
            d.Box.Visible = false
            d.Outline.Visible = false
            DrawCorners(d, px, py, w, h, cBox, op)
        else
            d.Box.Visible = false
            d.Outline.Visible = false
            HideCorners(d)
        end

        if S.ESPName then
            local txt = t.Name
            if S.ESPDist then txt ..= string.format(" [%dm]", math.round(dist)) end
            d.Name.Text = txt
            d.Name.Size = S.ESPNameSize
            d.Name.Position = Vector2.new(x, py - S.ESPNameSize - 4)
            d.Name.Color = PickColor(S.NameColor, mate, rainbow)
            d.Name.Transparency = op
            d.Name.Visible = true
        else d.Name.Visible = false end

        if S.ESPTracer then
            local from = Vector2.new(vp.X / 2, vp.Y)
            if S.TracerOrigin == "Center" then from = vp / 2
            elseif S.TracerOrigin == "Top" then from = Vector2.new(vp.X / 2, 0) end
            d.Tracer.From = from
            d.Tracer.To = Vector2.new(x, bot.Y)
            d.Tracer.Color = PickColor(S.TracerColor, mate, rainbow)
            d.Tracer.Transparency = op
            d.Tracer.Visible = true
        else d.Tracer.Visible = false end

        local hum = ch:FindFirstChildOfClass("Humanoid")
        if S.ESPHealth and hum then
            local frac = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            local bx = px - 5
            d.HpBack.From = Vector2.new(bx, py - 1)
            d.HpBack.To = Vector2.new(bx, bot.Y + 1)
            d.HpBack.Transparency = op
            d.HpBack.Visible = true
            d.Hp.From = Vector2.new(bx, bot.Y)
            d.Hp.To = Vector2.new(bx, bot.Y - h * frac)
            d.Hp.Color = Color3.fromHSV(frac * 0.33, 1, 1)
            d.Hp.Transparency = op
            d.Hp.Visible = true
        else
            d.Hp.Visible = false
            d.HpBack.Visible = false
        end

        if S.ESPHead then
            local head = ch:FindFirstChild("Head")
            if head then
                local hp = cam:WorldToViewportPoint(head.Position)
                if hp.Z > 0 then
                    d.Head.Position = Vector2.new(hp.X, hp.Y)
                    d.Head.Radius = math.max(h * 0.075, 2)
                    d.Head.Color = PickColor(S.HeadColor, mate, rainbow)
                    d.Head.Transparency = op
                    d.Head.Visible = true
                else d.Head.Visible = false end
            else d.Head.Visible = false end
        else d.Head.Visible = false end

        if S.ESPSkeleton then
            DrawSkeleton(d, ch, cam, PickColor(S.SkelColor, mate, rainbow), op)
        else
            for _, l in d.Bones do l.Visible = false end
        end
    end

    local function UpdateESP()
        if not HasDrawing then return end
        local cam = workspace.CurrentCamera

        if FOVCircle then
            if S.ShowFOV and cam then
                FOVCircle.Position = cam.ViewportSize / 2
                FOVCircle.Radius = S.FOV
                FOVCircle.Color = S.FOVColor
                FOVCircle.Visible = true
            else FOVCircle.Visible = false end
        end

        if not S.ESP or not cam then
            for _, d in ESPCache do HideESP(d) end
            return
        end

        local rainbow = Rainbow()
        local vp = cam.ViewportSize
        local seen = {}
        for _, t in GetTargets(S.ESPBots) do
            local mate = IsTeammate(t)
            if IsValid(t) and (S.ESPMates or not mate) then
                seen[t.Key] = true
                local d = ESPCache[t.Key]
                if not d then d = CreateESP(); ESPCache[t.Key] = d end
                local ch = t.Character
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                local drawn = false
                if hrp then
                    local dist = (hrp.Position - cam.CFrame.Position).Magnitude
                    if dist <= S.ESPMax then
                        local top = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.7, 0))
                        local bot = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                        if top.Z > 0 and bot.Z > 0 and (bot.Y - top.Y) > 2 then
                            drawn = true
                            DrawPlayer(d, t, ch, cam, vp, top, bot, dist, mate, rainbow, S.ESPOpacity)
                        end
                    end
                end
                if not drawn then HideESP(d) end
            end
        end
        for k, d in ESPCache do
            if not seen[k] then RemoveESP(d); ESPCache[k] = nil end
        end
    end

    local function UpdateCrosshair()
        if not HasDrawing then return end
        local cam = workspace.CurrentCamera
        if not S.Cross or not cam then
            for _, o in CrossObjs do o.Visible = false end
            return
        end
        local c = cam.ViewportSize / 2
        local gap, size, col = S.CrossGap, S.CrossSize, S.CrossColor
        local segs = {
            { c.X - gap - size, c.Y, c.X - gap, c.Y },
            { c.X + gap, c.Y, c.X + gap + size, c.Y },
            { c.X, c.Y - gap - size, c.X, c.Y - gap },
            { c.X, c.Y + gap, c.X, c.Y + gap + size },
        }
        for i, s in segs do
            local l = CrossObjs[i]
            l.From = Vector2.new(s[1], s[2])
            l.To = Vector2.new(s[3], s[4])
            l.Thickness = S.CrossThick
            l.Color = col
            l.Visible = true
        end
        local dot = CrossObjs[5]
        dot.Position = c
        dot.Radius = S.CrossThick + 0.5
        dot.Color = col
        dot.Visible = S.CrossDot
    end

    -- ============================================================
    -- CHAMS (Highlight)
    -- ============================================================
    local ChamFolder = New("Folder", { Name = "DRHUB_Chams", Parent = ParentGui })
    local ChamCache = {}
    OnCleanup(function() ChamFolder:Destroy() end)

    local function UpdateChams()
        if not S.Chams then
            for k, h in ChamCache do h:Destroy(); ChamCache[k] = nil end
            return
        end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local rainbow = Rainbow()
        local pulse = 0.5 + 0.5 * math.sin(tick() * 3)
        local seen = {}
        for _, t in GetTargets(S.ChamBots) do
            local mate = IsTeammate(t)
            if IsValid(t) and (S.ChamMates or not mate) then
                local hrp = t.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - cam.CFrame.Position).Magnitude <= S.ChamMax then
                    seen[t.Key] = true
                    local h = ChamCache[t.Key]
                    if not h then
                        h = New("Highlight", { Parent = ChamFolder })
                        ChamCache[t.Key] = h
                    end
                    h.Adornee = t.Character
                    if mate then
                        h.FillColor = S.ChamMateFill
                        h.OutlineColor = S.ChamMateFill
                    elseif S.ChamRainbow then
                        h.FillColor = rainbow
                        h.OutlineColor = rainbow
                    else
                        h.FillColor = S.ChamFill
                        h.OutlineColor = S.ChamOutline
                    end
                    local ft = S.ChamFillT
                    if S.ChamPulse and ft < 0.9 then ft = ft + (0.9 - ft) * pulse end
                    h.FillTransparency = ft
                    h.OutlineTransparency = S.ChamOutT
                    h.DepthMode = S.ChamWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                    h.Enabled = true
                end
            end
        end
        for k, h in ChamCache do
            if not seen[k] then h:Destroy(); ChamCache[k] = nil end
        end
    end

    -- ============================================================
    -- WORLD (lighting / camera / effects)
    -- ============================================================
    local cam0 = workspace.CurrentCamera
    local OrigL = {
        Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows,
    }
    local OrigFOV = cam0 and cam0.FieldOfView or 70
    local WasOn = {}
    local CC, BloomFx

    local function Feature(key, on, apply, restore)
        if on then
            apply()
            WasOn[key] = true
        elseif WasOn[key] then
            WasOn[key] = false
            restore()
        end
    end

    local function UpdateWorld()
        local cam = workspace.CurrentCamera
        Feature("amb", S.CustomAmbient, function()
            Lighting.Ambient = S.AmbientColor
            Lighting.OutdoorAmbient = S.AmbientColor
        end, function()
            Lighting.Ambient = OrigL.Ambient
            Lighting.OutdoorAmbient = OrigL.OutdoorAmbient
        end)
        Feature("fb", S.Fullbright, function()
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
            Lighting.GlobalShadows = false
        end, function()
            Lighting.Brightness = OrigL.Brightness
            Lighting.Ambient = OrigL.Ambient
            Lighting.OutdoorAmbient = OrigL.OutdoorAmbient
            Lighting.GlobalShadows = OrigL.GlobalShadows
        end)
        Feature("time", S.CustomTime, function() Lighting.ClockTime = S.ClockTime end,
            function() Lighting.ClockTime = OrigL.ClockTime end)
        Feature("fog", S.NoFog, function() Lighting.FogEnd = 1e9 end,
            function() Lighting.FogEnd = OrigL.FogEnd end)
        if cam then
            Feature("fov", S.CamFOVOn, function() cam.FieldOfView = S.CamFOV end,
                function() cam.FieldOfView = OrigFOV end)
        end

        if S.ColorCorr then
            if not CC then CC = New("ColorCorrectionEffect", { Name = "DRHUB_CC", Parent = Lighting }) end
            CC.Saturation = S.CCSat
            CC.Contrast = S.CCCon
            CC.Brightness = S.CCBri
            CC.TintColor = S.CCTint
        elseif CC then
            CC:Destroy()
            CC = nil
        end
        if S.Bloom then
            if not BloomFx then BloomFx = New("BloomEffect", { Name = "DRHUB_Bloom", Parent = Lighting }) end
            BloomFx.Intensity = S.BloomInt
            BloomFx.Size = 32
            BloomFx.Threshold = 0.9
        elseif BloomFx then
            BloomFx:Destroy()
            BloomFx = nil
        end
    end
    OnCleanup(function()
        if WasOn.amb or WasOn.fb then
            Lighting.Ambient = OrigL.Ambient
            Lighting.OutdoorAmbient = OrigL.OutdoorAmbient
        end
        if WasOn.fb then
            Lighting.Brightness = OrigL.Brightness
            Lighting.GlobalShadows = OrigL.GlobalShadows
        end
        if WasOn.time then Lighting.ClockTime = OrigL.ClockTime end
        if WasOn.fog then Lighting.FogEnd = OrigL.FogEnd end
        if CC then CC:Destroy() end
        if BloomFx then BloomFx:Destroy() end
        local c = workspace.CurrentCamera
        if c and WasOn.fov then c.FieldOfView = OrigFOV end
    end)

    -- ============================================================
    -- SKIN CHANGER (client-side visual only: recolors / re-materials the weapon on YOUR screen)
    -- ============================================================
    local SkinPresets = {
        Gold = { Color3.fromRGB(255, 196, 56), "Metal", 0.35 },
        Ice = { Color3.fromRGB(150, 220, 255), "Ice", 0.2 },
        ["Neon Red"] = { Color3.fromRGB(255, 40, 70), "Neon", 0 },
        Lava = { Color3.fromRGB(255, 90, 20), "CrackedLava", 0 },
        Toxic = { Color3.fromRGB(110, 255, 70), "Neon", 0 },
        Galaxy = { Color3.fromRGB(130, 90, 255), "ForceField", 0 },
        Carbon = { Color3.fromRGB(28, 28, 32), "CarbonFiber", 0.1 },
        Diamond = { Color3.fromRGB(140, 255, 255), "Glass", 0.45 },
        ["Rose Gold"] = { Color3.fromRGB(240, 150, 140), "Metal", 0.3 },
        Marble = { Color3.fromRGB(232, 232, 238), "Marble", 0.1 },
        Obsidian = { Color3.fromRGB(18, 18, 24), "Basalt", 0.2 },
    }
    local SkinPresetNames = { "Custom", "Gold", "Ice", "Neon Red", "Lava", "Toxic", "Galaxy", "Carbon", "Diamond", "Rose Gold", "Marble", "Obsidian" }
    local SkinMatNames = { "Plastic", "SmoothPlastic", "Metal", "Neon", "Glass", "ForceField", "Foil", "DiamondPlate", "CorrodedMetal", "Marble", "Granite", "Ice", "Slate" }

    local function Mat(name)
        local ok, m = pcall(function() return Enum.Material[name] end)
        return (ok and m) or Enum.Material.SmoothPlastic
    end

    local SkinOrig = setmetatable({}, { __mode = "k" })   -- part -> original look
    local SkinTex = {}    -- decal / surface appearance -> original state (strong refs: removed appearances must survive)
    local SkinParts, SkinStamp = {}, 0

    local function IsArmPart(p)
        local n = p.Name:lower()
        return n:find("arm$") ~= nil or n:find("hand$") ~= nil or n:find("glove") ~= nil
            or n:find("sleeve") ~= nil or n:find("finger") ~= nil
    end

    -- returns (list of parts to skin, list of matched root objects)
    local function ScanSkin()
        local filter = (S.SkinFilter or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
        local matches = {}
        local function collect(container, toolsOnly)
            if not container then return end
            for _, inst in container:GetDescendants() do
                local okType = inst:IsA("Tool") or inst:IsA("Model") or inst:IsA("BasePart")
                if okType then
                    if filter == "" then
                        if inst:IsA("Tool") or (inst:IsA("Model") and inst.Parent == container and not toolsOnly) then
                            table.insert(matches, inst)
                        end
                    elseif inst.Name:lower():find(filter, 1, true) then
                        table.insert(matches, inst)
                    end
                end
            end
        end
        if S.SkinView then collect(workspace.CurrentCamera, false) end
        if S.SkinChar then collect(LocalPlayer.Character, true) end

        local set = {}
        for _, r in matches do set[r] = true end
        local roots = {}
        for _, r in matches do
            local p, nested = r.Parent, false
            while p do
                if set[p] then nested = true break end
                p = p.Parent
            end
            if not nested then table.insert(roots, r) end
        end

        local parts, seen = {}, {}
        local function add(p)
            if p:IsA("BasePart") and not seen[p] and not IsArmPart(p) then
                seen[p] = true
                table.insert(parts, p)
            end
        end
        for _, r in roots do
            add(r)
            for _, d in r:GetDescendants() do add(d) end
        end
        return parts, roots
    end

    local function SkinSpec()
        local p = SkinPresets[S.SkinPreset]
        if p then return p[1], Mat(p[2]), p[3] end
        return S.SkinColor, Mat(S.SkinMat), S.SkinRefl
    end

    local function ApplySkin(part, color, mat, refl)
        local o = SkinOrig[part]
        if not o then
            o = { part.Color, part.Material, part.Reflectance, part.Transparency, part:IsA("MeshPart") and part.TextureID or nil }
            SkinOrig[part] = o
        end
        if o[4] >= 0.95 then return end   -- invisible helper parts stay invisible
        part.Color = color
        part.Material = mat
        part.Reflectance = refl
        part.Transparency = math.max(o[4], S.SkinTrans)
        if S.SkinStrip then
            if part:IsA("MeshPart") and part.TextureID ~= "" then part.TextureID = "" end
            for _, c in part:GetChildren() do
                if c:IsA("SurfaceAppearance") then
                    SkinTex[c] = { part }
                    c.Parent = nil
                elseif c:IsA("Decal") or c:IsA("Texture") then
                    if not SkinTex[c] then SkinTex[c] = { part, c.Transparency } end
                    c.Transparency = 1
                end
            end
        end
    end

    local function RestorePart(part)
        local o = SkinOrig[part]
        if not o then return end
        if part.Parent then
            part.Color, part.Material, part.Reflectance, part.Transparency = o[1], o[2], o[3], o[4]
            if o[5] ~= nil then part.TextureID = o[5] end
            for inst, d in SkinTex do
                if d[1] == part then
                    if inst:IsA("SurfaceAppearance") then inst.Parent = part
                    else inst.Transparency = d[2] end
                    SkinTex[inst] = nil
                end
            end
        end
        SkinOrig[part] = nil
    end
    local function RestoreSkins()
        for part in SkinOrig do RestorePart(part) end
        for inst, d in SkinTex do
            if d[1] and d[1].Parent then
                if inst:IsA("SurfaceAppearance") then inst.Parent = d[1] else inst.Transparency = d[2] end
            end
            SkinTex[inst] = nil
        end
    end
    OnCleanup(RestoreSkins)

    local function UpdateSkins()
        if not S.SkinOn then
            if next(SkinOrig) or next(SkinTex) then RestoreSkins() end
            return
        end
        if os.clock() - SkinStamp > 0.3 then
            SkinStamp = os.clock()
            SkinParts = ScanSkin()
            local current = {}
            for _, p in SkinParts do current[p] = true end
            for part in SkinOrig do
                if not current[part] then RestorePart(part) end
            end
            for inst, d in SkinTex do
                if not d[1].Parent then SkinTex[inst] = nil end
            end
        end
        local color, mat, refl = SkinSpec()
        if S.SkinRainbow then color = Rainbow() end
        for _, part in SkinParts do
            if part.Parent then ApplySkin(part, color, mat, refl) end
        end
    end

    local function SkinScanInfo()
        local parts, roots = ScanSkin()
        return #parts, roots[1] and roots[1].Name or nil
    end
    local function ListModels()
        local names = {}
        local cam = workspace.CurrentCamera
        if cam then
            for _, c in cam:GetChildren() do
                if c:IsA("Model") or c:IsA("Tool") or c:IsA("BasePart") then table.insert(names, "cam:" .. c.Name) end
            end
        end
        local ch = LocalPlayer.Character
        if ch then
            for _, c in ch:GetChildren() do
                if c:IsA("Tool") then table.insert(names, "tool:" .. c.Name) end
            end
        end
        return names
    end

    -- ============================================================
    -- WINDOW
    -- ============================================================
    local vp0 = cam0 and cam0.ViewportSize or Vector2.new(800, 600)
    local W = math.clamp(vp0.X * 0.92, 360, 680)
    local H = math.clamp(vp0.Y * 0.84, 300, 440)
    local SideW = W < 480 and 84 or 108
    local TwoCol = (W - SideW) >= 440
    local HeadH, StatH = 30, 20

    local Gui = New("ScreenGui", {
        Name = "DRHUB", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 9990, Parent = ParentGui,
    })
    OnCleanup(function() Gui:Destroy() end)

    -- Root is what gets dragged, Win is scaled by UIScale inside it
    local Root = New("Frame", {
        Size = UDim2.fromOffset(W * S.UIScale, H * S.UIScale), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1, Visible = false, Parent = Gui,
    })
    local Shadow = New("Frame", {
        Size = UDim2.new(1, 18, 1, 18), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Parent = Root,
    }, { New("UICorner", { CornerRadius = UDim.new(0, 10) }) })
    local Win = New("Frame", {
        Size = UDim2.fromOffset(W, H), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = "$Bg", ClipsDescendants = true, Parent = Root,
    }, { Corner(), Stroke() })
    local WinScale = New("UIScale", { Scale = S.UIScale, Parent = Win })

    -- header
    local Head = New("Frame", { Size = UDim2.new(1, 0, 0, HeadH), BackgroundColor3 = "$Panel", BorderSizePixel = 0, Parent = Win })
    New("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = "$Border", BorderSizePixel = 0, Parent = Head })
    local logo = New("Frame", { Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 10, 0.5, -8), BorderSizePixel = 0, Parent = Head }, { Corner() })
    Accent(logo, "BackgroundColor3")
    Label(logo, "D", UDim2.new(), UDim2.new(1, 0, 1, 0), Color3.fromRGB(14, 14, 18), 12, true, Enum.TextXAlignment.Center)
    Label(Head, "DRHUB", UDim2.new(0, 34, 0, 0), UDim2.new(0, 60, 1, -1), "$Text", 14, true)
    Label(Head, "v5", UDim2.new(0, 88, 0, 0), UDim2.new(0, 40, 1, -1), "$Dim", 11)
    local Close = Txt("TextButton", {
        Size = UDim2.new(0, 26, 0, 20), Position = UDim2.new(1, -34, 0.5, -11), BackgroundColor3 = "$Row",
        Text = "x", TextColor3 = T.Dim, TextSize = 13, AutoButtonColor = false, Parent = Head,
    }, false, { Corner() })
    Close.MouseEnter:Connect(function() Tween(Close, 0.12, { TextColor3 = T.Text }) end)
    Close.MouseLeave:Connect(function() Tween(Close, 0.12, { TextColor3 = T.Dim }) end)
    Draggable(Head, Root)

    -- sidebar
    local Side = New("Frame", {
        Size = UDim2.new(0, SideW, 1, -(HeadH + StatH)), Position = UDim2.new(0, 0, 0, HeadH),
        BackgroundColor3 = "$Panel", BorderSizePixel = 0, Parent = Win,
    })
    New("Frame", { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = "$Border", BorderSizePixel = 0, Parent = Side })
    local TabList = New("Frame", { Size = UDim2.new(1, -1, 1, -46), BackgroundTransparency = 1, Parent = Side }, {
        New("UIListLayout", { Padding = UDim.new(0, 2) }), Pad(0, 8, 0, 0),
    })
    local UB = New("Frame", { Size = UDim2.new(1, -1, 0, 44), Position = UDim2.new(0, 0, 1, -44), BackgroundTransparency = 1, Parent = Side })
    New("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = "$Border", BorderSizePixel = 0, Parent = UB })
    New("ImageLabel", {
        Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 8, 0.5, -13), BackgroundColor3 = "$Row", BorderSizePixel = 0,
        Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100", LocalPlayer.UserId), Parent = UB,
    }, { Corner(true) })
    if SideW >= 100 then
        local nm = Label(UB, LocalPlayer.DisplayName, UDim2.new(0, 42, 0, 7), UDim2.new(1, -46, 0, 16), "$Text", 12, true)
        nm.TextTruncate = Enum.TextTruncate.AtEnd
        local un = Label(UB, "@" .. LocalPlayer.Name, UDim2.new(0, 42, 0, 23), UDim2.new(1, -46, 0, 14), "$Dim", 10)
        un.TextTruncate = Enum.TextTruncate.AtEnd
    end

    -- content + status bar
    local Content = New("Frame", {
        Size = UDim2.new(1, -SideW, 1, -(HeadH + StatH)), Position = UDim2.new(0, SideW, 0, HeadH), BackgroundTransparency = 1, Parent = Win,
    })
    local Status = New("Frame", {
        Size = UDim2.new(1, 0, 0, StatH), Position = UDim2.new(0, 0, 1, -StatH), BackgroundColor3 = "$Panel", BorderSizePixel = 0, Parent = Win,
    })
    New("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = "$Border", BorderSizePixel = 0, Parent = Status })
    Label(Status, "key accepted   |   build 5.0", UDim2.new(0, 10, 0, 1), UDim2.new(0.5, 0, 1, -1), "$Dim", 11)
    local StatR = Label(Status, "", UDim2.new(0.5, 0, 0, 1), UDim2.new(0.5, -10, 1, -1), "$Dim", 11, false, Enum.TextXAlignment.Right)

    -- tabs
    local Tabs = {}
    local function SelectTab(name)
        for n, t in Tabs do
            local on = n == name
            t.Page.Visible = on
            t.Bar.Visible = on
            Tween(t.Btn, 0.15, { BackgroundTransparency = on and 0 or 1 })
            Tween(t.Lbl, 0.15, { TextColor3 = on and T.Text or T.Dim })
        end
    end
    local function AddTab(name)
        local btn = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = "$Row", BackgroundTransparency = 1, Text = "",
            AutoButtonColor = false, Parent = TabList,
        })
        local lbl = Label(btn, name, UDim2.new(0, 14, 0, 0), UDim2.new(1, -14, 1, 0), T.Dim, 13, true)
        local bar = New("Frame", { Size = UDim2.new(0, 2, 0, 16), Position = UDim2.new(0, 0, 0.5, -8), BorderSizePixel = 0, Visible = false, Parent = btn })
        Accent(bar, "BackgroundColor3")

        local page = New("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = Content,
        }, { Pad(10, 6, 12, 10) })
        Accent(page, "ScrollBarImageColor3")
        local holder = New("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page })
        local cols = {}
        if TwoCol then
            New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10), Parent = holder })
            for _, side in { "L", "R" } do
                cols[side] = New("Frame", {
                    Size = UDim2.new(0.5, -5, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = holder,
                }, { New("UIListLayout", { Padding = UDim.new(0, 4) }) })
            end
        else
            New("UIListLayout", { Padding = UDim.new(0, 4), Parent = holder })
            cols.L, cols.R = holder, holder
        end
        Tabs[name] = { Btn = btn, Lbl = lbl, Page = page, Bar = bar }
        btn.MouseButton1Click:Connect(function() SelectTab(name) end)
        return cols
    end

    -- ---------- groupbox: transparent frame, title sits on the border ----------
    local function Group(cols, title, side)
        local wrap = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = cols[side or "L"],
        }, { Pad(0, 9, 0, 0) })
        local box = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = wrap,
        }, { Corner(), Stroke() })
        Txt("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 16), Position = UDim2.new(0, 8, 0, -9),
            BackgroundColor3 = "$Bg", BorderSizePixel = 0, Text = title, TextColor3 = "$Text", TextSize = 12, ZIndex = 3, Parent = box,
        }, true, { Pad(5, 0, 5, 0) })
        return New("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = box,
        }, { New("UIListLayout", { Padding = UDim.new(0, 3) }), Pad(10, 12, 10, 10) })
    end

    local function ScrollOf(obj) return obj:FindFirstAncestorOfClass("ScrollingFrame") end

    -- ---------- elements ----------
    local function Toggle(body, text, key, cb)
        local row = New("TextButton", { Size = UDim2.new(1, 0, 0, RowH), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = body })
        local box = New("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 0, 0.5, -7), BackgroundColor3 = "$Row", Parent = row }, { Corner(), Stroke() })
        local mark = New("Frame", { Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), BorderSizePixel = 0, Parent = box }, { Corner() })
        Accent(mark, "BackgroundColor3")
        local lbl = Label(row, text, UDim2.new(0, 24, 0, 0), UDim2.new(1, -24, 1, 0), T.Text, 13)
        local function render(anim)
            local on = S[key]
            if anim then Tween(mark, 0.12, { BackgroundTransparency = on and 0 or 1 })
            else mark.BackgroundTransparency = on and 0 or 1 end
            lbl.TextColor3 = on and T.Text or T.Dim
        end
        render(false)
        table.insert(Refresh, function() render(false) end)
        if cb then Callbacks[key] = cb end
        row.MouseButton1Click:Connect(function()
            S[key] = not S[key]
            render(true)
            if cb then cb(S[key]) end
        end)
    end

    local function Slider(body, text, key, min, max, step, cb)
        Ranges[key] = { min, max }
        local fmt = step < 1 and "%.2f" or "%d"
        local bar = New("TextButton", {
            Size = UDim2.new(1, 0, 0, RowH), BackgroundColor3 = "$Row", Text = "", AutoButtonColor = false, ClipsDescendants = true, Parent = body,
        }, { Corner(), Stroke() })
        local fill = New("Frame", { Size = UDim2.new(0, 0, 1, 0), BorderSizePixel = 0, BackgroundTransparency = 0.25, Parent = bar })
        Accent(fill, "BackgroundColor3")
        local nm = Label(bar, text, UDim2.new(0, 8, 0, 0), UDim2.new(0.65, 0, 1, 0), WHITE, 12)
        local val = Label(bar, "", UDim2.new(0.5, 0, 0, 0), UDim2.new(0.5, -8, 1, 0), WHITE, 12, true, Enum.TextXAlignment.Right)
        nm.ZIndex, val.ZIndex = 2, 2
        nm.TextStrokeTransparency, val.TextStrokeTransparency = 0.6, 0.6
        local function render()
            fill.Size = UDim2.new(math.clamp((S[key] - min) / (max - min), 0, 1), 0, 1, 0)
            val.Text = string.format(fmt, S[key])
        end
        render()
        table.insert(Refresh, render)
        if cb then Callbacks[key] = cb end
        Pointer(bar, function(p)
            local a = math.clamp((p.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.clamp(math.floor((min + (max - min) * a) / step + 0.5) * step, min, max)
            S[key] = v
            render()
            if cb then cb(v) end
        end, ScrollOf(body))
    end

    local function Dropdown(body, text, key, list, cb)
        Options[key] = list
        local IH = RowH - 2
        local closed = RowH
        local opened = RowH + 3 + #list * IH + (#list - 1) * 2
        local row = New("Frame", { Size = UDim2.new(1, 0, 0, closed), BackgroundTransparency = 1, ClipsDescendants = true, Parent = body })
        local head = New("TextButton", {
            Size = UDim2.new(1, 0, 0, RowH), BackgroundColor3 = "$Row", Text = "", AutoButtonColor = false, Parent = row,
        }, { Corner(), Stroke() })
        Label(head, text, UDim2.new(0, 8, 0, 0), UDim2.new(0.5, 0, 1, 0), "$Dim", 12)
        local arrow = Label(head, "v", UDim2.new(1, -18, 0, 0), UDim2.new(0, 10, 1, 0), "$Dim", 11, true, Enum.TextXAlignment.Center)
        local val = Label(head, "", UDim2.new(0.4, 0, 0, 0), UDim2.new(0.6, -24, 1, 0), nil, 12, true, Enum.TextXAlignment.Right)
        Accent(val, "TextColor3")
        local holder = New("Frame", {
            Position = UDim2.new(0, 0, 0, RowH + 3), Size = UDim2.new(1, 0, 0, #list * IH + (#list - 1) * 2),
            BackgroundTransparency = 1, Parent = row,
        }, { New("UIListLayout", { Padding = UDim.new(0, 2) }) })
        local opts = {}
        local open = false
        local function setOpen(v)
            open = v
            arrow.Text = v and "^" or "v"
            Tween(row, 0.15, { Size = UDim2.new(1, 0, 0, v and opened or closed) })
        end
        for _, opt in list do
            local b = Txt("TextButton", {
                Size = UDim2.new(1, 0, 0, IH), BackgroundColor3 = "$Row", BackgroundTransparency = 0.45, Text = opt,
                TextColor3 = T.Dim, TextSize = 12, AutoButtonColor = false, Parent = holder,
            }, false, { Corner() })
            opts[opt] = b
            b.MouseButton1Click:Connect(function()
                S[key] = opt
                setOpen(false)
                RunRefresh()
                if cb then cb(opt) end
            end)
        end
        head.MouseButton1Click:Connect(function() setOpen(not open) end)
        local function render()
            val.Text = tostring(S[key])
            for n, b in opts do b.TextColor3 = (n == S[key]) and T.Accent or T.Dim end
        end
        render()
        table.insert(Refresh, render)
        if cb then Callbacks[key] = cb end
    end

    local HueKeys = {}
    for i = 0, 6 do
        table.insert(HueKeys, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((i / 6) % 1, 1, 1)))
    end
    local HueSeq = ColorSequence.new(HueKeys)

    local function ColorPicker(body, text, key, cb)
        local closed = RowH
        local opened = RowH + 6 + 90 + 6
        local row = New("Frame", { Size = UDim2.new(1, 0, 0, closed), BackgroundTransparency = 1, ClipsDescendants = true, Parent = body })
        local head = New("TextButton", { Size = UDim2.new(1, 0, 0, RowH), BackgroundTransparency = 1, Text = "", Parent = row })
        Label(head, text, UDim2.new(), UDim2.new(0.7, 0, 1, 0), T.Text, 13)
        local swatch = New("Frame", {
            Size = UDim2.new(0, 30, 0, 14), Position = UDim2.new(1, -30, 0.5, -7), BackgroundColor3 = S[key], Parent = head,
        }, { Corner(), Stroke(Color3.fromRGB(95, 95, 110)) })

        local sv = New("Frame", {
            Position = UDim2.new(0, 0, 0, RowH + 4), Size = UDim2.new(1, -26, 0, 90), BackgroundColor3 = Color3.new(1, 0, 0), Parent = row,
        }, { Corner() })
        New("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = sv },
            { Corner(), New("UIGradient", { Transparency = NumberSequence.new(0, 1) }) })
        New("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = sv },
            { Corner(), New("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }) })
        local svCur = New("Frame", {
            Size = UDim2.new(0, 10, 0, 10), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Parent = sv,
        }, { Corner(true), Stroke(WHITE, 2) })
        local svHit = New("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = sv })

        local hue = New("Frame", {
            Position = UDim2.new(1, -18, 0, RowH + 4), Size = UDim2.new(0, 18, 0, 90), BackgroundColor3 = WHITE, Parent = row,
        }, { Corner(), New("UIGradient", { Color = HueSeq, Rotation = 90 }) })
        local hueCur = New("Frame", {
            Size = UDim2.new(1, 4, 0, 3), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 0),
            BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = hue,
        }, { Stroke(Color3.new(0, 0, 0), 1, 0.3) })
        local hueHit = New("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = hue })

        local h, s, v = S[key]:ToHSV()
        local function visuals()
            swatch.BackgroundColor3 = S[key]
            sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            svCur.Position = UDim2.new(s, 0, 1 - v, 0)
            hueCur.Position = UDim2.new(0.5, 0, h, 0)
        end
        local function apply()
            S[key] = Color3.fromHSV(h, s, v)
            visuals()
            if cb then cb(S[key]) end
        end
        visuals()
        table.insert(Refresh, function()
            local c, cur = S[key], Color3.fromHSV(h, s, v)
            if math.abs(c.R - cur.R) + math.abs(c.G - cur.G) + math.abs(c.B - cur.B) > 0.01 then
                h, s, v = c:ToHSV()
            end
            visuals()
        end)
        if cb then Callbacks[key] = cb end

        local scroll = ScrollOf(body)
        Pointer(svHit, function(p)
            s = math.clamp((p.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp((p.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
            apply()
        end, scroll)
        Pointer(hueHit, function(p)
            h = math.clamp((p.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 0.999)
            apply()
        end, scroll)

        local open = false
        head.MouseButton1Click:Connect(function()
            open = not open
            Tween(row, 0.15, { Size = UDim2.new(1, 0, 0, open and opened or closed) })
        end)
    end

    local function Button(body, text, cb)
        local b = Txt("TextButton", {
            Size = UDim2.new(1, 0, 0, RowH), BackgroundColor3 = "$Row", Text = text, TextColor3 = "$Text",
            TextSize = 12, AutoButtonColor = false, Parent = body,
        }, false, { Corner(), Stroke() })
        local st = b:FindFirstChildOfClass("UIStroke")
        b.MouseEnter:Connect(function() Tween(st, 0.12, { Color = T.Accent }) end)
        b.MouseLeave:Connect(function() Tween(st, 0.12, { Color = T.Border }) end)
        b.MouseButton1Click:Connect(function() if cb then cb() end end)
        return b
    end

    local function Keybind(body, text, key, cb)
        local row = New("Frame", { Size = UDim2.new(1, 0, 0, RowH), BackgroundTransparency = 1, Parent = body })
        Label(row, text, UDim2.new(), UDim2.new(0.5, 0, 1, 0), T.Text, 13)
        local btn = Txt("TextButton", {
            Size = UDim2.new(0.5, 0, 1, -4), Position = UDim2.new(0.5, 0, 0, 2), BackgroundColor3 = "$Row",
            Text = "", TextColor3 = "$Accent", TextSize = 12, AutoButtonColor = false, Parent = row,
        }, false, { Corner(), Stroke() })
        local function render() btn.Text = "[ " .. tostring(S[key]) .. " ]" end
        render()
        table.insert(Refresh, render)
        if cb then Callbacks[key] = cb end
        btn.MouseButton1Click:Connect(function()
            if Binding then return end
            Binding = true
            btn.Text = "[ ... ]"
            local conn
            conn = UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    S[key] = (i.KeyCode == Enum.KeyCode.Escape) and "None" or i.KeyCode.Name
                elseif i.UserInputType == Enum.UserInputType.MouseButton2 or i.UserInputType == Enum.UserInputType.MouseButton3 then
                    S[key] = i.UserInputType.Name
                else
                    return
                end
                conn:Disconnect()
                task.defer(function() Binding = false end)
                render()
                if cb then cb(S[key]) end
            end)
        end)
    end

    local function TextInput(body, placeholder)
        return Txt("TextBox", {
            Size = UDim2.new(1, 0, 0, RowH), BackgroundColor3 = "$Row", Text = "", PlaceholderText = placeholder,
            PlaceholderColor3 = "$Dim", TextColor3 = "$Text", TextSize = 12, ClearTextOnFocus = false,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = body,
        }, false, { Corner(), Stroke(), Pad(8, 0, 8, 0) })
    end

    local function Info(body, text)
        return Txt("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            Text = text, TextColor3 = "$Dim", TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = body,
        }, false)
    end

    -- ============================================================
    -- OPEN / CLOSE
    -- ============================================================
    local token = 0
    local Icon, IconLine   -- created further down
    local lastPos = Root.Position
    local settled = false
    local function IconCenter()
        if Icon and Icon.Parent then
            local c = Icon.AbsolutePosition + Icon.AbsoluteSize / 2
            return UDim2.fromOffset(c.X, c.Y)
        end
        return Root.Position
    end
    -- the window grows out of the LX icon and shrinks back into it
    local function SetOpen(v)
        if v == isOpen and Root.Visible == v then return end
        isOpen = v
        token += 1
        local my = token
        if IconLine then
            Tween(IconLine, 0.2, { Size = UDim2.new(0, v and 26 or 10, 0, 2) }, Enum.EasingStyle.Back)
        end
        if v then
            Root.Visible = true
            Root.Position = IconCenter()
            WinScale.Scale = 0.15
            Shadow.BackgroundTransparency = 1
            settled = false
            Tween(Root, 0.32, { Position = lastPos }, Enum.EasingStyle.Quart)
            Tween(Shadow, 0.32, { BackgroundTransparency = 0.72 })
            local tw = Tween(WinScale, 0.32, { Scale = S.UIScale }, Enum.EasingStyle.Back)
            tw.Completed:Connect(function() if token == my then settled = true end end)
        else
            if settled then lastPos = Root.Position end
            settled = false
            Tween(Root, 0.22, { Position = IconCenter() }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            Tween(Shadow, 0.2, { BackgroundTransparency = 1 })
            local tw = Tween(WinScale, 0.22, { Scale = 0.15 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            tw.Completed:Connect(function() if token == my then Root.Visible = false end end)
        end
    end
    Close.MouseButton1Click:Connect(function() SetOpen(false) end)
    Connect(UIS.InputBegan, function(i, gp)
        if gp or Binding then return end
        if i.UserInputType == Enum.UserInputType.Keyboard then
            local n = i.KeyCode.Name
            if S.PanicKey ~= "None" and n == S.PanicKey then
                genv.DRHUB_Cleanup()
            elseif S.MenuKey ~= "None" and n == S.MenuKey then
                SetOpen(not isOpen)
            end
        end
    end)

    -- ============================================================
    -- TABS
    -- ============================================================
    local cAim = AddTab("Aimbot")
    local cESP = AddTab("ESP")
    local cCham = AddTab("Chams")
    local cSkin = AddTab("Skins")
    local cWorld = AddTab("World")
    local cCfg = AddTab("Config")

    -- ---------- Aimbot ----------
    do
        local g = Group(cAim, "Aim assist", "L")
        Toggle(g, "Silent Aim", "SilentAim", SetSilent)
        Toggle(g, "Snap Aim", "SnapAim")
        Keybind(g, "Snap hold key", "AimKey")
        Slider(g, "Smoothness", "SnapSmooth", 1, 30, 1)
        Dropdown(g, "Target mode", "TargetMode", { "Nearest", "FOV" })
        Dropdown(g, "Target part", "TargetPart", { "Head", "UpperTorso", "HumanoidRootPart" })
        Slider(g, "Max distance", "Distance", 50, 600, 10)
        Slider(g, "FOV radius", "FOV", 10, 400, 5)

        local c = Group(cAim, "Checks", "R")
        Toggle(c, "Team check", "CheckTeam")
        Toggle(c, "Wall check", "CheckWall")
        Toggle(c, "Target bots", "TargetBots")
        Info(c, "Team check reads Roblox Teams, then the Team attribute on the player or character.")

        local f = Group(cAim, "FOV circle", "R")
        Toggle(f, "Show circle", "ShowFOV")
        ColorPicker(f, "Circle color", "FOVColor")
    end

    -- ---------- ESP ----------
    do
        local g = Group(cESP, "Players", "L")
        if not HasDrawing then Info(g, "No Drawing API in this executor, ESP won't render. Chams still work.") end
        Toggle(g, "Enable ESP", "ESP")
        Toggle(g, "Box", "ESPBox")
        Dropdown(g, "Box style", "BoxStyle", { "Full", "Corner" })
        Toggle(g, "Box outline", "ESPOutline")
        Toggle(g, "Box fill", "ESPFill")
        Slider(g, "Fill opacity", "FillAlpha", 0.05, 1, 0.05)
        Toggle(g, "Name", "ESPName")
        Toggle(g, "Distance", "ESPDist")
        Toggle(g, "Health bar", "ESPHealth")
        Toggle(g, "Tracer", "ESPTracer")
        Dropdown(g, "Tracer origin", "TracerOrigin", { "Bottom", "Center", "Top" })
        Toggle(g, "Skeleton", "ESPSkeleton")
        Toggle(g, "Head dot", "ESPHead")
        Toggle(g, "Show bots", "ESPBots")
        Toggle(g, "Show teammates", "ESPMates")

        local c = Group(cESP, "Colors", "R")
        Toggle(c, "Rainbow", "ESPRainbow")
        ColorPicker(c, "Box", "BoxColor")
        ColorPicker(c, "Name", "NameColor")
        ColorPicker(c, "Tracer", "TracerColor")
        ColorPicker(c, "Skeleton", "SkelColor")
        ColorPicker(c, "Head dot", "HeadColor")
        ColorPicker(c, "Teammates", "MateColor")

        local s = Group(cESP, "Settings", "R")
        Slider(s, "Max distance", "ESPMax", 50, 1000, 10)
        Slider(s, "Name size", "ESPNameSize", 8, 30, 1)
        Slider(s, "Opacity", "ESPOpacity", 0.1, 1, 0.05)
    end

    -- ---------- Chams ----------
    do
        local g = Group(cCham, "Chams", "L")
        Toggle(g, "Enable chams", "Chams")
        Toggle(g, "Through walls", "ChamWalls")
        Toggle(g, "Pulse", "ChamPulse")
        Toggle(g, "Show bots", "ChamBots")
        Toggle(g, "Show teammates", "ChamMates")
        Slider(g, "Fill transparency", "ChamFillT", 0, 1, 0.05)
        Slider(g, "Outline transparency", "ChamOutT", 0, 1, 0.05)
        Slider(g, "Max distance", "ChamMax", 50, 1000, 25)

        local c = Group(cCham, "Colors", "R")
        Toggle(c, "Rainbow", "ChamRainbow")
        ColorPicker(c, "Fill", "ChamFill")
        ColorPicker(c, "Outline", "ChamOutline")
        ColorPicker(c, "Teammates", "ChamMateFill")
        Info(c, "Roblox renders at most 31 highlights at once.")
    end

    -- ---------- World ----------
    do
        local l = Group(cWorld, "Lighting", "L")
        Toggle(l, "Fullbright", "Fullbright")
        Toggle(l, "Custom ambient", "CustomAmbient")
        ColorPicker(l, "Ambient color", "AmbientColor")
        Toggle(l, "Custom time", "CustomTime")
        Slider(l, "Clock time", "ClockTime", 0, 24, 0.5)
        Toggle(l, "No fog", "NoFog")

        local cm = Group(cWorld, "Camera", "L")
        Toggle(cm, "FOV changer", "CamFOVOn")
        Slider(cm, "Field of view", "CamFOV", 40, 120, 1)

        local x = Group(cWorld, "Crosshair", "R")
        Toggle(x, "Custom crosshair", "Cross")
        Toggle(x, "Center dot", "CrossDot")
        ColorPicker(x, "Color", "CrossColor")
        Slider(x, "Size", "CrossSize", 2, 30, 1)
        Slider(x, "Gap", "CrossGap", 0, 20, 1)
        Slider(x, "Thickness", "CrossThick", 1, 4, 1)

        local cc = Group(cWorld, "Color correction", "R")
        Toggle(cc, "Enable", "ColorCorr")
        Slider(cc, "Saturation", "CCSat", -1, 2, 0.05)
        Slider(cc, "Contrast", "CCCon", -1, 1, 0.05)
        Slider(cc, "Brightness", "CCBri", -0.5, 0.5, 0.05)
        ColorPicker(cc, "Tint", "CCTint")

        local b = Group(cWorld, "Bloom", "R")
        Toggle(b, "Enable", "Bloom")
        Slider(b, "Intensity", "BloomInt", 0, 3, 0.05)
    end

    -- ---------- Skins ----------
    do
        local g = Group(cSkin, "Deagle skin", "L")
        Toggle(g, "Enable skin changer", "SkinOn")
        Dropdown(g, "Skin", "SkinPreset", SkinPresetNames)
        Info(g, "Preset = ready look. Pick Custom to use your own color + material below.")
        Dropdown(g, "Custom material", "SkinMat", SkinMatNames)
        ColorPicker(g, "Custom color", "SkinColor")
        Slider(g, "Reflectance", "SkinRefl", 0, 1, 0.05)
        Slider(g, "Transparency", "SkinTrans", 0, 0.9, 0.05)
        Toggle(g, "Rainbow", "SkinRainbow")
        Toggle(g, "Strip original textures", "SkinStrip")

        local t = Group(cSkin, "Target weapon", "R")
        Toggle(t, "First person model", "SkinView")
        Toggle(t, "Third person tool", "SkinChar")
        local fbox = TextInput(t, "weapon name, e.g. Deagle")
        fbox.Text = S.SkinFilter
        fbox.FocusLost:Connect(function()
            S.SkinFilter = CleanName(fbox.Text)
            fbox.Text = S.SkinFilter
        end)
        table.insert(Refresh, function() if not fbox:IsFocused() then fbox.Text = S.SkinFilter end end)
        Button(t, "Scan weapon", function()
            local n, name = SkinScanInfo()
            if n > 0 then
                Notify(string.format("Found %d parts in %s", n, tostring(name)))
            else
                Notify("Nothing found, check the weapon name")
            end
        end)
        Button(t, "List my models", function()
            local names = ListModels()
            if #names == 0 then
                Notify("No models found, equip the weapon first")
            else
                Notify(table.concat(names, ", "):sub(1, 70))
            end
        end)
        Info(t, "Client-side only: the new look is visible just on your screen. If nothing changes, equip the weapon, press List my models and put its name in the box.")
    end

    -- ---------- Config ----------
    local function ApplyAll()
        if Callbacks.Theme then pcall(Callbacks.Theme, S.Theme, true) end
        for key, cb in Callbacks do
            if key ~= "Theme" then pcall(cb, S[key]) end
        end
        ApplyTheme()
        RunRefresh()
    end

    do
        local g = Group(cCfg, "Configs", "L")
        local nameBox = TextInput(g, "config name")
        local selected = nil
        local listFrame = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = g,
        }, { New("UIListLayout", { Padding = UDim.new(0, 2) }) })

        local function Rebuild()
            for _, c in listFrame:GetChildren() do
                if c:IsA("GuiObject") then c:Destroy() end
            end
            local names = ListConfigs()
            if #names == 0 then
                Txt("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "no saved configs yet",
                    TextColor3 = "$Dim", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = listFrame,
                }, false)
                return
            end
            for _, n in names do
                local b = Txt("TextButton", {
                    Size = UDim2.new(1, 0, 0, RowH - 2), BackgroundColor3 = "$Row", Text = n,
                    TextColor3 = (n == selected) and T.Accent or T.Text, TextSize = 12, AutoButtonColor = false, Parent = listFrame,
                }, false, { Corner() })
                b.MouseButton1Click:Connect(function()
                    selected = n
                    nameBox.Text = n
                    Rebuild()
                end)
            end
        end
        Rebuild()

        local function CurName() return selected or CleanName(nameBox.Text) end

        Button(g, "Save", function()
            local n = CleanName(nameBox.Text)
            if n == "" then Notify("Enter a config name first") return end
            if WriteCfg(n) then
                selected = n
                Rebuild()
                Notify("Saved: " .. n)
            else
                Notify("Could not write the file")
            end
        end)
        Button(g, "Load", function()
            local n = CurName()
            local json = n ~= "" and ReadCfg(n) or nil
            if not json then Notify("Config not found") return end
            if DecodeCfg(json) then
                ApplyAll()
                Notify("Loaded: " .. n)
            else
                Notify("Config file is broken")
            end
        end)
        Button(g, "Delete", function()
            local n = CurName()
            if n == "" then return end
            if HasFS and delfile then
                pcall(delfile, CFG_DIR .. "/" .. n .. ".json")
            else
                MemCfg[n] = nil
            end
            selected = nil
            Rebuild()
            Notify("Deleted: " .. n)
        end)
        Button(g, "Refresh list", Rebuild)
        Button(g, "Set as autoload", function()
            local n = CurName()
            if n == "" or not HasFS then Notify("Needs a saved config and file support") return end
            pcall(function() EnsureDir(); writefile(CFG_DIR .. "/_autoload.txt", n) end)
            Notify("Autoload: " .. n)
        end)
        Button(g, "Clear autoload", function()
            if HasFS and delfile then pcall(delfile, CFG_DIR .. "/_autoload.txt") end
            Notify("Autoload cleared")
        end)
        if not HasFS then Info(g, "No file API here: configs stay in memory until you leave the game. Use Copy / Import to keep them.") end

        local sh = Group(cCfg, "Share", "L")
        local importBox = TextInput(sh, "paste config text here")
        Button(sh, "Copy current config", function()
            local setclip = setclipboard or toclipboard
            if setclip then
                setclip(EncodeCfg())
                Notify("Config copied")
            else
                Notify("No clipboard support")
            end
        end)
        Button(sh, "Import from text", function()
            if DecodeCfg(importBox.Text) then
                ApplyAll()
                Notify("Config imported")
            else
                Notify("Invalid config text")
            end
        end)

        local ap = Group(cCfg, "Appearance", "R")
        Dropdown(ap, "Theme", "Theme", ThemeNames, function(name, keep) ApplyPreset(name, keep) end)
        ColorPicker(ap, "Accent color", "UIAccent", SetAccent)
        Dropdown(ap, "Font", "UIFont", FontNames, SetFont)
        Slider(ap, "Corner radius", "Radius", 0, 10, 1, SetRadius)
        Slider(ap, "UI scale", "UIScale", 0.7, 1.4, 0.05, function(v)
            WinScale.Scale = v
            Root.Size = UDim2.fromOffset(W * v, H * v)
        end)
        Toggle(ap, "Animations", "Anim")
        Slider(ap, "Animation speed", "AnimSpeed", 0.5, 2, 0.1)

        local m = Group(cCfg, "Menu", "R")
        Keybind(m, "Menu key", "MenuKey")
        Keybind(m, "Panic key (unload)", "PanicKey")
        Toggle(m, "Notifications", "Notifs")
        Toggle(m, "Watermark", "Watermark")
        Toggle(m, "Feature list", "FeatureList")
        Toggle(m, "Show LX icon", "ShowIcon")

        local u = Group(cCfg, "Script", "R")
        Button(u, "Reset all settings", function()
            for k, v in Defaults do S[k] = v end
            ApplyAll()
            Notify("Settings reset")
        end)
        Button(u, "Unload script", function() genv.DRHUB_Cleanup() end)
        Info(u, "DRHUB v5  -  key LUXXS")
    end

    -- ============================================================
    -- HUD: watermark + feature list
    -- ============================================================
    local HudGui = New("ScreenGui", {
        Name = "DRHUB_HUD", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 9980, Parent = ParentGui,
    })
    OnCleanup(function() HudGui:Destroy() end)

    local WM = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.new(), AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 8), BackgroundColor3 = "$Bg", Parent = HudGui,
    }, { Corner(), Stroke(), Pad(10, 5, 10, 5) })
    local WMLabel = Txt("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.new(), BackgroundTransparency = 1, Text = "",
        TextColor3 = "$Text", TextSize = 12, RichText = true, Parent = WM,
    }, false)
    local WMLine = New("Frame", {
        Size = UDim2.new(1, 20, 0, 2), Position = UDim2.new(0, -10, 0, -5), BorderSizePixel = 0, ZIndex = 2, Parent = WM,
    })
    Accent(WMLine, "BackgroundColor3")

    local FL = Txt("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.new(), AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0.3, 0), BackgroundColor3 = "$Bg", BackgroundTransparency = 0.2, Text = "",
        TextColor3 = "$Text", TextSize = 12, RichText = true, TextXAlignment = Enum.TextXAlignment.Right, Visible = false, Parent = HudGui,
    }, false, { Corner(), Pad(8, 4, 8, 4) })

    local FeatureNames = {
        { "SilentAim", "Silent Aim" }, { "SnapAim", "Snap Aim" }, { "ESP", "ESP" }, { "Chams", "Chams" },
        { "Cross", "Crosshair" }, { "Fullbright", "Fullbright" }, { "CamFOVOn", "FOV Changer" }, { "ColorCorr", "Color Correction" }, { "SkinOn", "Skin Changer" },
    }
    local acc, fpsAcc, fpsCount = 0, 0, 0
    local function UpdateHud(dt)
        fpsAcc += dt
        fpsCount += 1
        acc += dt
        if acc < 0.4 then return end
        local fps = math.floor(fpsCount / math.max(fpsAcc, 0.001) + 0.5)
        acc, fpsAcc, fpsCount = 0, 0, 0
        local ping = 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5) end)
        local hex = T.Accent:ToHex()
        WM.Visible = S.Watermark
        WMLabel.Text = string.format('<font color="#%s">DRHUB</font>   |   %s   |   %d fps   |   %d ms', hex, LocalPlayer.Name, fps, ping)
        StatR.Text = string.format("%d fps   |   %d ms", fps, ping)

        local lines = {}
        for _, f in FeatureNames do
            if S[f[1]] then table.insert(lines, string.format('%s <font color="#%s">|</font>', f[2], hex)) end
        end
        FL.Visible = S.FeatureList and #lines > 0
        FL.Text = table.concat(lines, "\n")
    end

    -- ============================================================
    -- ICON (LX): click = open / close the menu, drag = move it anywhere
    -- ============================================================
    local function ClampIcon(x, y)
        local c = workspace.CurrentCamera
        local v = c and c.ViewportSize or Vector2.new(800, 600)
        return math.clamp(x, 24, v.X - 24), math.clamp(y, 24, v.Y - 24)
    end
    local ix, iy = ClampIcon(S.IconX, S.IconY)
    Icon = New("Frame", {
        Size = UDim2.new(0, 0, 0, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(ix, iy),
        BackgroundColor3 = "$Bg", Active = true, Parent = IconGui,
    }, { Corner(), Stroke() })
    IconLine = New("Frame", {
        Size = UDim2.new(0, 10, 0, 2), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 1, -8),
        BorderSizePixel = 0, Parent = Icon,
    })
    Accent(IconLine, "BackgroundColor3")
    Label(Icon, "LX", UDim2.new(), UDim2.new(1, 0, 1, -4), "$Text", 17, true, Enum.TextXAlignment.Center)
    local IconHit = New("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 10, Parent = Icon })
    Tween(Icon, 0.4, { Size = UDim2.new(0, 40, 0, 40) }, Enum.EasingStyle.Back)

    do
        local down, moved, startIn, startPos = false, false, nil, nil
        local function pressed(i)
            return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
        end
        IconHit.InputBegan:Connect(function(i)
            if pressed(i) then
                down, moved = true, false
                startIn = i.Position
                startPos = Icon.AbsolutePosition + Icon.AbsoluteSize / 2
            end
        end)
        Connect(UIS.InputChanged, function(i)
            if down and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - startIn
                if d.Magnitude > 5 then moved = true end
                if moved then
                    local x, y = ClampIcon(startPos.X + d.X, startPos.Y + d.Y)
                    Icon.Position = UDim2.fromOffset(x, y)
                end
            end
        end)
        Connect(UIS.InputEnded, function(i)
            if down and pressed(i) then
                down = false
                if moved then
                    local c = Icon.AbsolutePosition + Icon.AbsoluteSize / 2
                    S.IconX, S.IconY = c.X, c.Y
                else
                    local tw = Tween(Icon, 0.09, { Size = UDim2.new(0, 33, 0, 33) })
                    tw.Completed:Connect(function()
                        Tween(Icon, 0.2, { Size = UDim2.new(0, 40, 0, 40) }, Enum.EasingStyle.Back)
                    end)
                    SetOpen(not isOpen)
                end
            end
        end)
    end

    -- ============================================================
    -- LOOP
    -- ============================================================
    Connect(RunService.RenderStepped, function(dt)
        FrameId += 1
        pcall(UpdateESP)
        pcall(UpdateChams)
        pcall(UpdateCrosshair)
        pcall(UpdateWorld)
        pcall(UpdateSkins)
        pcall(UpdateHud, dt)
        Icon.Visible = S.ShowIcon
    end)

    -- autoload last config
    if HasFS then
        pcall(function()
            local p = CFG_DIR .. "/_autoload.txt"
            if isfile(p) then
                local n = CleanName(readfile(p))
                local json = n ~= "" and ReadCfg(n) or nil
                if json and DecodeCfg(json) then
                    ApplyAll()
                    Notify("Autoloaded: " .. n)
                end
            end
        end)
    end

    SelectTab("Aimbot")
    SetOpen(true)
    Notify("DRHUB loaded")
end

-- ============================================================
-- KEY SCREEN + WELCOME
-- ============================================================
if genv.DRHUB_Key == KEY then
    Main()
    return
end

local KeyGui = New("ScreenGui", {
    Name = "DRHUB_KeyGui", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 9998, Parent = ParentGui,
})
OnCleanup(function() KeyGui:Destroy() end)

local KFrame = New("Frame", {
    Size = UDim2.fromOffset(250, 142), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = T.Bg, Parent = KeyGui,
}, { Corner(), Stroke() })
local kTop = New("Frame", { Size = UDim2.new(1, 0, 0, 2), BorderSizePixel = 0, Parent = KFrame })
kTop.BackgroundColor3 = T.Accent
Label(KFrame, "DRHUB", UDim2.new(0, 16, 0, 12), UDim2.new(1, -32, 0, 22), T.Text, 18, true)
Label(KFrame, "enter your key to continue", UDim2.new(0, 16, 0, 34), UDim2.new(1, -32, 0, 16), T.Dim, 12)

local KBox = Txt("TextBox", {
    Size = UDim2.new(1, -32, 0, 30), Position = UDim2.new(0, 16, 0, 62), BackgroundColor3 = T.Row, Text = "",
    PlaceholderText = "key", PlaceholderColor3 = T.Dim, TextColor3 = T.Text, TextSize = 14,
    ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, Parent = KFrame,
}, false, { Corner(), Stroke(), Pad(8, 0, 8, 0) })
local KButton = Txt("TextButton", {
    Size = UDim2.new(1, -32, 0, 30), Position = UDim2.new(0, 16, 0, 100), BackgroundColor3 = T.Accent, Text = "Verify",
    TextColor3 = WHITE, TextSize = 14, AutoButtonColor = false, Parent = KFrame,
}, true, { Corner() })
local KStatus = Label(KFrame, "", UDim2.new(0, 16, 1, -22), UDim2.new(1, -32, 0, 16), Color3.fromRGB(240, 90, 90), 12)

Tween(KFrame, 0.3, { Size = UDim2.fromOffset(300, 170) }, Enum.EasingStyle.Back)

local verifying = false
local function ShowWelcome()
    local WGui = New("ScreenGui", {
        Name = "DRHUB_Welcome", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 10000, Parent = ParentGui,
    })
    OnCleanup(function() WGui:Destroy() end)
    local Backdrop = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(6, 6, 9), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = WGui,
    })
    local WL = Label(WGui, "", UDim2.new(0.5, -200, 0.5, -26), UDim2.new(0, 400, 0, 36), T.Text, 30, true, Enum.TextXAlignment.Center)
    WL.TextTransparency = 0
    local WLine = New("Frame", {
        Size = UDim2.new(0, 0, 0, 2), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.5, 14),
        BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = WGui,
    })
    local WSub = Label(WGui, "key accepted", UDim2.new(0.5, -200, 0.5, 22), UDim2.new(0, 400, 0, 16), T.Dim, 12, false, Enum.TextXAlignment.Center)
    WSub.TextTransparency = 1

    Tween(Backdrop, 0.3, { BackgroundTransparency = 0.35 })
    task.spawn(function()
        local msg = "Welcome to DRHUB"
        for i = 1, #msg do
            WL.Text = msg:sub(1, i)
            task.wait(0.045)
        end
        Tween(WLine, 0.4, { Size = UDim2.new(0, 220, 0, 2) }, Enum.EasingStyle.Quart)
        Tween(WSub, 0.3, { TextTransparency = 0 })
        task.wait(0.9)
        Tween(Backdrop, 0.4, { BackgroundTransparency = 1 })
        Tween(WL, 0.4, { TextTransparency = 1 })
        Tween(WSub, 0.4, { TextTransparency = 1 })
        Tween(WLine, 0.4, { BackgroundTransparency = 1 })
        task.wait(0.5)
        WGui:Destroy()
    end)
end

local function Verify()
    if verifying then return end
    if KBox.Text == KEY then
        verifying = true
        genv.DRHUB_Key = KEY
        KFrame.Visible = false
        ShowWelcome()
        task.wait(1.6)
        KeyGui:Destroy()
        Main()
    else
        KStatus.Text = "wrong key"
        KBox.Text = ""
        task.spawn(function()
            local base = UDim2.new(0.5, 0, 0.5, 0)
            for i = 1, 6 do
                KFrame.Position = base + UDim2.fromOffset(i % 2 == 0 and 7 or -7, 0)
                task.wait(0.04)
            end
            KFrame.Position = base
        end)
    end
end
KButton.MouseButton1Click:Connect(Verify)
KBox.FocusLost:Connect(function(enter) if enter then Verify() end end)
