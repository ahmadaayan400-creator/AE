-- =========================================================
-- ALPHA EMPIRE V2 (PREMIUM PURPLE GUI) - PART 1 OF 2
-- =========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("ALPHA_EMPIRE_V2") then CoreGui.ALPHA_EMPIRE_V2:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "ALPHA_EMPIRE_V2"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = CoreGui

_G.MaxHubConfig = {
    CurrentTroll = nil,
    Spin = false,
    InfJump = false,
    AntiVoid = false,
    AntiSit = false,
    AntiFling = false,
    Spd = false,
    Noclip = false,
    SoundEnabled = true,
    ScreenGui = sg
}

local Config = _G.MaxHubConfig

-- Premium purple theme
_G.AlphaTheme = {
    Panel       = Color3.fromRGB(20, 10, 38),
    PanelDark   = Color3.fromRGB(12, 6, 24),
    Accent      = Color3.fromRGB(140, 60, 240),
    AccentLight = Color3.fromRGB(190, 135, 255),
    AccentDeep  = Color3.fromRGB(88, 30, 170),
    Text        = Color3.fromRGB(244, 238, 255),
    SubText     = Color3.fromRGB(196, 176, 235),
    Danger      = Color3.fromRGB(125, 25, 85)
}
local Theme = _G.AlphaTheme

_G.getChar = function() return player.Character or player.CharacterAdded:Wait() end
_G.getRoot = function() return _G.getChar():FindFirstChild("HumanoidRootPart") end
_G.getHum = function() return _G.getChar():FindFirstChildOfClass("Humanoid") end

_G.playSound = function(soundId, vol)
    if not Config.SoundEnabled then return end
    task.spawn(function()
        local s = Instance.new("Sound")
        s.SoundId = soundId:find("rbxassetid://") and soundId or ("rbxassetid://" .. soundId)
        s.Volume = vol or 5
        s.Parent = CoreGui
        s:Play()
        Debris:AddItem(s, 5)
    end)
end

_G.playSound("1842506172", 8)

function _G.sendChatIntro()
    local intro1 = [[⛩️ SCRIPT BY ALPHA EMPIRE _________________________________________________________________________________________________________________________________LOADED..]]
    local intro2 = [["👑 ONE & ONLY BEST GANG IS ALPHA EMPIRE🌚//NO FEAR WHEN ALPHA EMPIRE V2 IS HERE 😂/THE REAL AURA KING MAX X AAYAN 🌚//👺ARE DEKHO YE BACCHA TO ABHI INTRO DEKH KE HI RO DIYA 😨"]]
    local intro3 = [[😭MEAWWW GHOP GHOP GHOOP🤣]]
    
    task.spawn(function()
        local textChannel = TextChatService and TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        local legacyChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")

        if textChannel then
            textChannel:SendAsync(intro1) task.wait(0.6)
            textChannel:SendAsync(intro2) task.wait(0.6)
            textChannel:SendAsync(intro3)
        elseif legacyChat then
            legacyChat:FireServer(intro1, "All") task.wait(0.6)
            legacyChat:FireServer(intro2, "All") task.wait(0.6)
            legacyChat:FireServer(intro3, "All")
        end
    end)
end

_G.makeDraggable = function(p1)
    local v1, v2, v3
    p1.InputBegan:Connect(function(p2)
        if p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch then
            v1 = true
            v2 = p2.Position
            v3 = p1.Position
            p2.Changed:Connect(function()
                if p2.UserInputState == Enum.UserInputState.End then v1 = false end
            end)
        end
    end)
    p1.InputChanged:Connect(function(input)
        if v1 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local v4 = input.Position - v2
            p1.Position = UDim2.new(v3.X.Scale, v3.X.Offset + v4.X, v3.Y.Scale, v3.Y.Offset + v4.Y)
        end
    end)
end

-- Floating Toggle Image Button (Rotates 360)
local ToggleBtn = Instance.new("ImageButton", Config.ScreenGui)
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -24)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxassetid://139869430288569"
ToggleBtn.Visible = true
ToggleBtn.ZIndex = 50

_G.MaxHubToggleBtn = ToggleBtn
_G.makeDraggable(ToggleBtn)

task.spawn(function()
    while ToggleBtn and ToggleBtn.Parent do
        TweenService:Create(ToggleBtn, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Rotation = ToggleBtn.Rotation + 360}):Play()
        task.wait(3)
    end
end)

-- Main Frame (400x300)
local MAIN_TRANSPARENCY = 0.1

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 400, 0, 300) 
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Main.BackgroundTransparency = MAIN_TRANSPARENCY
Main.Visible = true
Main.Active = true
Main.ClipsDescendants = true
Main.ZIndex = 10

_G.MaxHubMainFrame = Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
_G.makeDraggable(Main)

-- Smooth Toggle Animation
local isAnimating = false
local function toggleUI()
    if isAnimating then return end
    isAnimating = true

    if Main.Visible then
        local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        local tweenScale = TweenService:Create(Main, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        tweenScale:Play()
        tweenScale.Completed:Wait()
        Main.Visible = false
    else
        Main.Size = UDim2.new(0, 0, 0, 0)
        Main.Position = UDim2.new(0.5, 0, 0.5, 0)
        Main.BackgroundTransparency = 1
        Main.Visible = true

        local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tweenScale = TweenService:Create(Main, tweenInfo, {
            Size = UDim2.new(0, 400, 0, 300),
            Position = UDim2.new(0.5, -200, 0.5, -150),
            BackgroundTransparency = MAIN_TRANSPARENCY
        })
        tweenScale:Play()
        tweenScale.Completed:Wait()
    end
    isAnimating = false
end

ToggleBtn.MouseButton1Click:Connect(function()
    _G.playSound("139869430288569", 4)
    toggleUI()
end)

-- Deep purple body gradient
local MainGradient = Instance.new("UIGradient", Main)
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 8, 36)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(46, 16, 88)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(78, 28, 140))
})
MainGradient.Rotation = 45

-- Animated glowing purple border
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local StrokeGradient = Instance.new("UIGradient", MainStroke)
StrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 30, 180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(205, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 30, 180))
})
TweenService:Create(StrokeGradient, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {Rotation = 360}):Play()

-- Header Bar
local HeaderBar = Instance.new("Frame", Main)
HeaderBar.Size = UDim2.new(1, -16, 0, 30)
HeaderBar.Position = UDim2.new(0, 8, 0, 8)
HeaderBar.BackgroundTransparency = 1
HeaderBar.ZIndex = 15

local TitleHeader = Instance.new("TextLabel", HeaderBar)
TitleHeader.Size = UDim2.new(0.7, 0, 1, 0)
TitleHeader.Position = UDim2.new(0, 4, 0, 0)
TitleHeader.BackgroundTransparency = 1
TitleHeader.Text = "ALPHA EMPIRE V2"
TitleHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleHeader.Font = Enum.Font.GothamBold
TitleHeader.TextSize = 14
TitleHeader.TextXAlignment = Enum.TextXAlignment.Left
TitleHeader.ZIndex = 16

local TitleGradient = Instance.new("UIGradient", TitleHeader)
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 160, 255))
})

local HeaderLine = Instance.new("Frame", Main)
HeaderLine.Size = UDim2.new(1, -24, 0, 1)
HeaderLine.Position = UDim2.new(0, 12, 0, 38)
HeaderLine.BorderSizePixel = 0
HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeaderLine.ZIndex = 15
local LineGradient = Instance.new("UIGradient", HeaderLine)
LineGradient.Color = ColorSequence.new(Theme.AccentLight)
LineGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(1, 1)
})

local CloseBtn = Instance.new("TextButton", HeaderBar)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -26, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 15, 70)
CloseBtn.BackgroundTransparency = 0.25
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(235, 190, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.ZIndex = 16
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
local CloseStroke = Instance.new("UIStroke", CloseBtn)
CloseStroke.Thickness = 1
CloseStroke.Color = Theme.Accent
CloseStroke.Transparency = 0.3

CloseBtn.MouseButton1Click:Connect(function()
    _G.playSound("139869430288569", 4)
    toggleUI()
end)

-- Sidebar
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.Size = UDim2.new(0, 105, 1, -72)
Sidebar.Position = UDim2.new(0, 8, 0, 44)
Sidebar.BackgroundColor3 = Theme.PanelDark
Sidebar.BackgroundTransparency = 0.35
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 2
Sidebar.ScrollBarImageColor3 = Theme.AccentLight
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ZIndex = 15
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)
local SidebarStroke = Instance.new("UIStroke", Sidebar)
SidebarStroke.Thickness = 1
SidebarStroke.Color = Theme.AccentDeep
SidebarStroke.Transparency = 0.2

local sidePad = Instance.new("UIPadding", Sidebar)
sidePad.PaddingTop = UDim.new(0, 4)
sidePad.PaddingLeft = UDim.new(0, 2)
sidePad.PaddingRight = UDim.new(0, 2)

local sideList = Instance.new("UIListLayout", Sidebar)
sideList.Padding = UDim.new(0, 5)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -127, 1, -72)
Pages.Position = UDim2.new(0, 119, 0, 44)
Pages.BackgroundTransparency = 1
Pages.ZIndex = 15

local function createPage()
    local p = Instance.new("ScrollingFrame", Pages)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 2
    p.ScrollBarImageColor3 = Theme.AccentLight
    p.Visible = false
    p.ZIndex = 20

    local grid = Instance.new("UIGridLayout", p)
    grid.CellSize = UDim2.new(0.48, 0, 0, 32)
    grid.CellPadding = UDim2.new(0.04, 0, 0, 6)
    grid.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", p)
    pad.PaddingTop = UDim.new(0, 2)
    pad.PaddingBottom = UDim.new(0, 4)

    return p
end

local activeTabBtn = nil

local function styleTabInactive(v)
    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 0.45, TextColor3 = Theme.SubText}):Play()
    v.BackgroundColor3 = Theme.Panel
    local st = v:FindFirstChildOfClass("UIStroke")
    if st then st.Color = Theme.AccentDeep st.Transparency = 0.5 end
end

local function addTab(text, p)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, -4, 0, 32)
    b.BackgroundColor3 = Theme.Panel
    b.BackgroundTransparency = 0.45
    b.Text = text
    b.TextColor3 = Theme.SubText
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 11
    b.AutoButtonColor = false
    b.ZIndex = 18
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    local tabStroke = Instance.new("UIStroke", b)
    tabStroke.Thickness = 1
    tabStroke.Color = Theme.AccentDeep
    tabStroke.Transparency = 0.5

    b.MouseButton1Click:Connect(function()
        _G.playSound("139719503904449", 3)
        for _, v in pairs(Pages:GetChildren()) do
            if v:IsA("ScrollingFrame") or v:IsA("Frame") then v.Visible = false end
        end
        for _, v in pairs(Sidebar:GetChildren()) do
            if v:IsA("TextButton") then styleTabInactive(v) end
        end
        
        activeTabBtn = b
        b.BackgroundColor3 = Theme.Accent
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.05, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        tabStroke.Color = Theme.AccentLight
        tabStroke.Transparency = 0
        p.Visible = true
    end)
    return b
end

_G.AlphaPages = {
    P1  = createPage(),
    P2  = Instance.new("ScrollingFrame", Pages), -- Custom Scroll Page for Credit
    P3  = createPage(),
    P4  = createPage(),
    P5  = createPage(),
    P6  = createPage(),
    P7  = createPage(),
    P8  = createPage(),
    P9  = createPage(), -- MUSIC TAB
    P10 = createPage(),
    P11 = createPage()  -- PHONK TAB
}

local P = _G.AlphaPages

-- Setup Custom Credit Scroll Page
P.P2.Size = UDim2.new(1, 0, 1, 0)
P.P2.CanvasSize = UDim2.new(0, 0, 0, 0)
P.P2.AutomaticCanvasSize = Enum.AutomaticSize.Y
P.P2.BackgroundTransparency = 1
P.P2.BorderSizePixel = 0
P.P2.ScrollBarThickness = 2
P.P2.ScrollBarImageColor3 = Theme.AccentLight
P.P2.Visible = false
P.P2.ZIndex = 20

local firstTabBtn = addTab("TROLL", P.P1)
addTab("CREDIT", P.P2)
addTab("FAKEOUT", P.P3)
addTab("SPAM", P.P4)
addTab("BANG", P.P5)
addTab("EXTRA", P.P6)
addTab("SHIELD", P.P7)
addTab("GAME", P.P8)
addTab("MUSIC", P.P9)
addTab("OTHER", P.P10)
addTab("PHONK", P.P11)

activeTabBtn = firstTabBtn
firstTabBtn.BackgroundColor3 = Theme.Accent
firstTabBtn.BackgroundTransparency = 0.05
firstTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
do
    local st = firstTabBtn:FindFirstChildOfClass("UIStroke")
    if st then st.Color = Theme.AccentLight st.Transparency = 0 end
end
P.P1.Visible = true

-----------------------------------------------------------
-- Button shine: light sweeps across every button every 2s
-----------------------------------------------------------
local Shines = {}

local function addShine(parent)
    parent.ClipsDescendants = true

    local sh = Instance.new("Frame", parent)
    sh.Name = "Shine"
    sh.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sh.BackgroundTransparency = 0.78
    sh.BorderSizePixel = 0
    sh.Active = false
    sh.Size = UDim2.new(0.3, 0, 1.8, 0)
    sh.Position = UDim2.new(-0.5, 0, -0.4, 0)
    sh.Rotation = 20
    -- Keep the shine from drawing over and hiding the button label.
    sh.ZIndex = math.max(1, parent.ZIndex - 1)

    local g = Instance.new("UIGradient", sh)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 215, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.6),
        NumberSequenceKeypoint.new(1, 1)
    })

    table.insert(Shines, sh)
end

task.spawn(function()
    local sweepInfo = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    while sg and sg.Parent do
        if Main.Visible then
            for i = #Shines, 1, -1 do
                local s = Shines[i]
                if s.Parent then
                    local page = s.Parent.Parent
                    if page and page.Visible then
                        s.Position = UDim2.new(-0.5, 0, -0.4, 0)
                        TweenService:Create(s, sweepInfo, {Position = UDim2.new(1.2, 0, -0.4, 0)}):Play()
                    end
                else
                    table.remove(Shines, i)
                end
            end
        end
        task.wait(2)
    end
end)

_G.addHubButton = function(txt, parent, func, customColor)
    local b = Instance.new("TextButton", parent)
    b.BackgroundColor3 = customColor or Color3.fromRGB(255, 255, 255)
    b.BackgroundTransparency = 0.2
    b.Text = txt:upper()
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextTransparency = 0
    b.TextStrokeColor3 = Color3.fromRGB(18, 8, 36)
    b.TextStrokeTransparency = 0.55
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextWrapped = true
    b.TextScaled = false
    b.AutoButtonColor = false
    b.ZIndex = 25
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    if not customColor then
        local bg = Instance.new("UIGradient", b)
        bg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 24, 110)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 12, 60))
        })
        bg.Rotation = 90
    end

    local stroke = Instance.new("UIStroke", b)
    stroke.Thickness = 1
    stroke.Color = Theme.Accent
    stroke.Transparency = 0.25

    b.MouseEnter:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.AccentLight, Transparency = 0}):Play()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Theme.Accent, Transparency = 0.25}):Play()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)

    b.MouseButton1Click:Connect(function()
        _G.playSound("139869430288569", 4)
        func(b)
    end)

    addShine(b)
    return b
end

-- Stats HUD
local StatsHUD = Instance.new("Frame", Main)
StatsHUD.Size = UDim2.new(1, -16, 0, 18)
StatsHUD.Position = UDim2.new(0, 8, 1, -22)
StatsHUD.BackgroundColor3 = Theme.PanelDark
StatsHUD.BackgroundTransparency = 0.2
StatsHUD.BorderSizePixel = 0
StatsHUD.ZIndex = 25
Instance.new("UICorner", StatsHUD).CornerRadius = UDim.new(0, 6)

local StatsStroke = Instance.new("UIStroke", StatsHUD)
StatsStroke.Thickness = 0.8
StatsStroke.Color = Theme.AccentDeep

local FpsLabel = Instance.new("TextLabel", StatsHUD)
FpsLabel.Size = UDim2.new(0.3, 0, 1, 0)
FpsLabel.Position = UDim2.new(0, 6, 0, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: --"
FpsLabel.TextColor3 = Theme.AccentLight
FpsLabel.Font = Enum.Font.GothamMedium
FpsLabel.TextSize = 9.5
FpsLabel.TextXAlignment = Enum.TextXAlignment.Left
FpsLabel.ZIndex = 26

local PlayersLabel = Instance.new("TextLabel", StatsHUD)
PlayersLabel.Size = UDim2.new(0.3, 0, 1, 0)
PlayersLabel.Position = UDim2.new(0.33, 0, 0, 0)
PlayersLabel.BackgroundTransparency = 1
PlayersLabel.Text = "PLRS: 0"
PlayersLabel.TextColor3 = Theme.Text
PlayersLabel.Font = Enum.Font.GothamMedium
PlayersLabel.TextSize = 9.5
PlayersLabel.TextXAlignment = Enum.TextXAlignment.Center
PlayersLabel.ZIndex = 26

local TimeLabel = Instance.new("TextLabel", StatsHUD)
TimeLabel.Size = UDim2.new(0.35, -6, 1, 0)
TimeLabel.Position = UDim2.new(0.65, 0, 0, 0)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "--:--:-- PM"
TimeLabel.TextColor3 = Theme.SubText
TimeLabel.Font = Enum.Font.GothamMedium
TimeLabel.TextSize = 9.5
TimeLabel.TextXAlignment = Enum.TextXAlignment.Right
TimeLabel.ZIndex = 26

local FrameCount = 0
local LastCheck = tick()

RunService.RenderStepped:Connect(function()
    FrameCount = FrameCount + 1
    local now = tick()
    if now - LastCheck >= 0.5 then
        FpsLabel.Text = "FPS: " .. tostring(math.floor(FrameCount / (now - LastCheck)))
        FrameCount = 0
        LastCheck = now
        PlayersLabel.Text = "PLRS: " .. tostring(#Players:GetPlayers())
        TimeLabel.Text = os.date("%I:%M:%S %p")
    end
end)

-- =========================================================
-- ALPHA EMPIRE V2 (PREMIUM PURPLE GUI) - PART 2 OF 2
-- =========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local P = _G.AlphaPages
local Config = _G.MaxHubConfig
local Theme = _G.AlphaTheme
local btn = _G.addHubButton

local function loadScript(url)
    task.spawn(function() pcall(function() loadstring(game:HttpGet(url))() end) end)
end

-----------------------------------------------------------
-- TAB 1: TROLL
-----------------------------------------------------------
local targetBox = Instance.new("TextBox", P.P1)
targetBox.LayoutOrder = 0
targetBox.Size = UDim2.new(1, 0, 0, 32)
targetBox.PlaceholderText = "[ENTER TARGET NAME]"
targetBox.PlaceholderColor3 = Theme.SubText
targetBox.Text = ""
targetBox.BackgroundColor3 = Theme.PanelDark
targetBox.BackgroundTransparency = 0.2
targetBox.TextColor3 = Theme.AccentLight
targetBox.Font = Enum.Font.GothamMedium
targetBox.TextSize = 10.5
Instance.new("UICorner", targetBox).CornerRadius = UDim.new(0, 8)

local targetStroke = Instance.new("UIStroke", targetBox)
targetStroke.Thickness = 1
targetStroke.Color = Theme.Accent

local function getT()
    local n = targetBox.Text:lower()
    if n == "" then return nil end
    for _, v in pairs(Players:GetPlayers()) do 
        if v ~= player and (v.Name:lower():find(n) or v.DisplayName:lower():find(n)) then return v end 
    end
end

local function startTroll(mode)
    Config.CurrentTroll = mode
    task.spawn(function()
        while Config.CurrentTroll == mode do
            local t = getT()
            local root = _G.getRoot()
            local hum = _G.getHum()

            if t and t.Character and root and hum then
                local tRoot = t.Character:FindFirstChild("HumanoidRootPart")
                local tHead = t.Character:FindFirstChild("Head")

                if mode == "facebang" and tHead then
                    root.CFrame = tHead.CFrame * CFrame.new(0, 0, -0.8) * CFrame.Angles(0, math.pi, 0) + tHead.CFrame.LookVector * math.sin(tick() * 25) * 0.6
                elseif mode == "bang" and tRoot then
                    root.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1.2 + math.sin(tick() * 25) * 0.8)
                elseif mode == "headsit" and tHead then
                    hum.Sit = true
                    root.CFrame = tHead.CFrame * CFrame.new(0, 1, 0)
                elseif mode == "frontsit" and tHead then
                    hum.Sit = true
                    root.CFrame = tHead.CFrame * CFrame.new(0, 0.5, -1) * CFrame.Angles(0, math.pi, 0)
                elseif mode == "annoy" and tRoot then
                    root.CFrame = tRoot.CFrame * CFrame.new(math.random(-4, 4), math.random(-2, 4), math.random(-4, 4))
                elseif mode == "orbit" and tRoot then
                    local angle = tick() * 5
                    root.CFrame = tRoot.CFrame * CFrame.new(math.cos(angle) * 4, 2, math.sin(angle) * 4)
                elseif mode == "dogpaws" and tRoot then
                    root.CFrame = tRoot.CFrame * CFrame.new(0, 0, -1.5) * CFrame.Angles(math.rad(45), 0, 0)
                elseif mode == "sereer" and tRoot then
                    root.CFrame = tRoot.CFrame * CFrame.new(0, 2, 0) * CFrame.Angles(math.rad(90), 0, 0)
                elseif mode == "aeroplane" and tRoot then
                    root.CFrame = tRoot.CFrame * CFrame.new(0, 4, 0) * CFrame.Angles(0, tick() * 10, 0)
                elseif mode == "butterpaws" and tRoot then
                    root.CFrame = tRoot.CFrame * CFrame.new(math.sin(tick()*10)*2, 1, math.cos(tick()*10)*2)
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

btn("BANG", P.P1, function() startTroll("bang") end)
btn("FACE BANG", P.P1, function() startTroll("facebang") end)
btn("SPECTATE", P.P1, function() 
    local t = getT() 
    if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then workspace.CurrentCamera.CameraSubject = t.Character:FindFirstChildOfClass("Humanoid") end
end)
btn("GO TO", P.P1, function() 
    local t = getT() 
    local root = _G.getRoot()
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and root then root.CFrame = t.Character.HumanoidRootPart.CFrame end 
end)
btn("HEADSIT", P.P1, function() startTroll("headsit") end)
btn("FRONT SIT", P.P1, function() startTroll("frontsit") end)
btn("ANNOY", P.P1, function() startTroll("annoy") end)
btn("ORBIT", P.P1, function() startTroll("orbit") end)
btn("DOG PAWS", P.P1, function() startTroll("dogpaws") end)
btn("SEREER", P.P1, function() startTroll("sereer") end)
btn("AEROPLANE", P.P1, function() startTroll("aeroplane") end)
btn("BUTTER PAWS", P.P1, function() startTroll("butterpaws") end)
btn("LOVE", P.P1, function() loadScript("https://pastebin.com/raw/89740248756697") end)
btn("KISS", P.P1, function() loadScript("https://pastebin.com/raw/112078433891854") end)
btn("STOP TROLL", P.P1, function() 
    Config.CurrentTroll = nil
    local hum = _G.getHum()
    if hum then hum.Sit = false workspace.CurrentCamera.CameraSubject = hum end 
end, Theme.Danger)

-----------------------------------------------------------
-- TAB 2: CREDIT PANEL
-----------------------------------------------------------
local infoCard = Instance.new("Frame", P.P2)
infoCard.Size = UDim2.new(1, -4, 0, 0)
infoCard.AutomaticSize = Enum.AutomaticSize.Y
infoCard.Position = UDim2.new(0, 2, 0, 0)
infoCard.BackgroundColor3 = Theme.PanelDark
infoCard.BackgroundTransparency = 0.25
Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 10)

local infoStroke = Instance.new("UIStroke", infoCard)
infoStroke.Thickness = 1
infoStroke.Color = Theme.Accent

local infoPad = Instance.new("UIPadding", infoCard)
infoPad.PaddingTop = UDim.new(0, 8)
infoPad.PaddingBottom = UDim.new(0, 8)

local infoList = Instance.new("UIListLayout", infoCard)
infoList.HorizontalAlignment = Enum.HorizontalAlignment.Center
infoList.Padding = UDim.new(0, 4)

local function createCreditLine(txt, color, size, bold)
    local l = Instance.new("TextLabel", infoCard)
    l.Size = UDim2.new(1, -12, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = color or Theme.Text
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextSize = size or 10.5
    l.TextXAlignment = Enum.TextXAlignment.Center
    return l
end

createCreditLine("ALPHA EMPIRE CREDIT", Theme.AccentLight, 12, true)
createCreditLine("", Theme.Text, 4)
createCreditLine("MADE BY - AE_MAX X U", Color3.fromRGB(255, 215, 0), 11, true)
createCreditLine("SNAP - snapuser78432", Theme.SubText, 10)
createCreditLine("INSTA - none", Theme.SubText, 10)
createCreditLine("ROBLOX - @mr_king7809", Theme.SubText, 10)
createCreditLine("----------------------", Color3.fromRGB(110, 80, 170), 8)
createCreditLine("HELPER X LEADER", Theme.AccentLight, 11, true)
createCreditLine("HELPER - AAYANZZ", Color3.fromRGB(255, 190, 235), 10, true)
createCreditLine("SNAP - AAYANZZ123", Theme.SubText, 10)
createCreditLine("INSTA - none", Theme.SubText, 10)
createCreditLine("ROBLOX - AAYAN_ZZZZ", Theme.SubText, 10)
createCreditLine("----------------------", Color3.fromRGB(110, 80, 170), 8)
createCreditLine("TOH DER KIS BAAT KI, MERE CHIETOO AAG LAGA DO", Color3.fromRGB(255, 110, 150), 9, true)
createCreditLine("ALPHA EMPIRE - ON TOP", Color3.fromRGB(255, 230, 120), 11, true)

-----------------------------------------------------------
-- TAB 3: FAKEOUT
-----------------------------------------------------------
btn("PROTECT SHIELD", P.P3, function() loadScript("https://pastebin.com/raw/83qNb86E") end)
btn("FLING", P.P3, function() loadScript("https://pastebin.com/raw/dGgHDVkx") end)
btn("VOIDSTRIKER", P.P3, function() loadScript("https://pastebin.com/raw/c3R861CE") end)
btn("AURA GLITCH", P.P3, function() loadScript("https://pastebin.com/raw/Uq7htgyG") end)
btn("AE FAKEOUT", P.P3, function() loadScript("https://pastebin.com/raw/6A6YcVFk") end)
btn("2 FAKEOUT", P.P3, function() loadScript("https://pastebin.com/raw/f6BCKV42") end)

-----------------------------------------------------------
-- TAB 4: SPAM
-----------------------------------------------------------
btn("AUTO REPLY", P.P4, function() loadScript("https://pastebin.com/raw/GJHtXJDP") end)
btn("CUSTOM SPAM", P.P4, function() loadScript("https://pastebin.com/raw/0GxxWYGr") end)
btn("OG SPAM", P.P4, function() loadScript("https://pastebin.com/raw/Nec3d1z6") end)
btn("SEC CUSTOM SPAM", P.P4, function() loadScript("https://pastebin.com/raw/DLTe92fB") end)
btn("ALPHA SPAM", P.P4, function() loadScript("https://pastebin.com/raw/d5kpB5Dj") end)
btn("TARGET SPAM", P.P4, function() loadScript("https://pastebin.com/raw/wwHsSEv2") end)
btn("FORBID", P.P4, function() loadScript("https://gist.githubusercontent.com/forbidtherobloxscripter/3e1a67cdf3f22192307218825c8469ea/raw/d16fabac096433b08eb63170274af33c8345603e/fm%25201.5.txt") end)

-----------------------------------------------------------
-- TAB 5: BANG / FUN
-----------------------------------------------------------
btn("BACK", P.P5, function() loadScript("https://pastefy.app/wdF0Iubo/raw") end)
btn("PANEL", P.P5, function() loadScript("https://pastebin.com/raw/vz2KXR3s") end)
btn("FACE", P.P5, function() loadScript("https://pastebin.com/raw/y5S28PKH") end)
btn("MULTI", P.P5, function() loadScript("https://pastebin.com/raw/FrDEuATX") end)

-----------------------------------------------------------
-- TAB 6: EXTRA
-----------------------------------------------------------
btn("AURA GLOW", P.P6, function() loadScript("https://pastebin.com/raw/u1ihY5R9") end)
btn("AUTO FAKEOUT", P.P6, function() loadScript("https://pastebin.com/raw/67KEqzjv") end)
btn("TELEPORT V1", P.P6, function() loadScript("https://pastebin.com/raw/EUSuniqAF") end)
btn("SPIDER MAN", P.P6, function() loadScript("https://pastebin.com/raw/wXH4B5UN") end)
btn("TELEPORT V2", P.P6, function() loadScript("https://pastebin.com/raw/216FSAFS") end)
btn("SKY DESTROY", P.P6, function() loadScript("https://rawscripts.net/raw/Universal-Script-sky-destroyer-V2-AXEZZ-110640") end)
btn("INFINITE YIELD", P.P6, function() loadScript("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source") end)
btn("FLY PANEL", P.P6, function() loadScript("https://pastebin.com/raw/Fwq2iUFC") end)

-----------------------------------------------------------
-- TAB 7: SHIELD
-----------------------------------------------------------
btn("ANTI-VOID", P.P7, function(s) Config.AntiVoid = not Config.AntiVoid s.Text = "ANTI-VOID: " .. (Config.AntiVoid and "ON" or "OFF") end)
btn("ANTI-FLING", P.P7, function(s) Config.AntiFling = not Config.AntiFling s.Text = "ANTI-FLING: " .. (Config.AntiFling and "ON" or "OFF") end)
btn("ANTI-SIT", P.P7, function(s) Config.AntiSit = not Config.AntiSit s.Text = "ANTI-SIT: " .. (Config.AntiSit and "ON" or "OFF") end)
btn("ANTI AFK", P.P7, function() Players.LocalPlayer.Idled:Connect(function() VirtualUser:ClickButton2(Vector2.new()) end) end)
btn("ANTI BANG", P.P7, function() loadScript("https://pastebin.com/raw/d4r8JDXz") end)

-----------------------------------------------------------
-- TAB 8: GAME
-----------------------------------------------------------
btn("TIC TAC TOE", P.P8, function() loadScript("https://pastebin.com/raw/ZYPzKzBF") end)
btn("JET DEFENDER", P.P8, function() loadScript("https://pastebin.com/raw/KEjtCtpP") end)
btn("CANDY BOM", P.P8, function() loadScript("https://pastebin.com/raw/tTCmn7FS") end)
btn("FLAPPY BIRD", P.P8, function() loadScript("https://pastebin.com/raw/BNqYv7N6") end)
btn("CANDY CRUSH", P.P8, function() loadScript("https://pastebin.com/raw/gSW5NzsZ") end)

-----------------------------------------------------------
-- TAB 9: MUSIC PLAYER
-----------------------------------------------------------
btn("MUSIC PLAYER", P.P9, function() loadScript("https://pastebin.com/raw/Ub8em7fc") end)

-----------------------------------------------------------
-- TAB 10: OTHER
-----------------------------------------------------------
btn("SPEED 300", P.P10, function() Config.Spd = not Config.Spd local hum = _G.getHum() if hum then hum.WalkSpeed = Config.Spd and 300 or 16 end end)
btn("SPIN 300", P.P10, function() Config.Spin = not Config.Spin end)
btn("NO CLIP", P.P10, function() loadScript("https://pastebin.com/raw/5haBtdWX") end)
btn("INF JUMP", P.P10, function(s) Config.InfJump = not Config.InfJump s.Text = "INF JUMP: " .. (Config.InfJump and "ON" or "OFF") end)
btn("LOOP", P.P10, function() loadScript("https://pastebin.com/raw/G2BciKKB") end)
btn("AIR WALK", P.P10, function() loadScript("https://pastebin.com/raw/SdgA5aZM") end)
btn("REJOIN", P.P10, function() TeleportService:Teleport(game.PlaceId, Players.LocalPlayer) end)
btn("SERVER HOP", P.P10, function() pcall(function() local Http = game:GetService("HttpService"); local Api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"; local _Next = Http:JSONDecode(game:HttpGet(Api)); TeleportService:TeleportToPlaceInstance(game.PlaceId, _Next.data[1].id) end) end)
btn("INVISIBLE", P.P10, function(b) local inv = not b:GetAttribute("Invis") b:SetAttribute("Invis", inv) if player.Character then for _, part in pairs(player.Character:GetDescendants()) do if part:IsA("BasePart") or part:IsA("Decal") then part.LocalTransparencyModifier = inv and 1 or 0 end end end end)

-----------------------------------------------------------
-- TAB 11: PHONK
-----------------------------------------------------------
local function setupPhonkTab(tabParent)
    local phonkList = {
        {"PHONK 1", "139435437308948"},
        {"PHONK 2", "137787889626447"},
        {"PHONK 3", "138864288968383"},
        {"PHONK 4", "130973511966646"},
        {"PHONK 5", "135674024616225"},
        {"PHONK 6", "137152491110539"},
        {"PHONK 7", "139606677237480"},
        {"PHONK 8", "139825057894568"}
    }
    for _, item in ipairs(phonkList) do
        btn(item[1], tabParent, function()
            for _, v in pairs(workspace:GetChildren()) do if v:IsA("Sound") and v.Name == "PhonkSound" then v:Destroy() end end
            local s = Instance.new("Sound", workspace)
            s.Name = "PhonkSound"
            s.SoundId = "rbxassetid://" .. item[2]
            s.Volume = 3
            s:Play()
        end)
    end
    btn("STOP PHONK", tabParent, function()
        for _, v in pairs(workspace:GetChildren()) do if v:IsA("Sound") and v.Name == "PhonkSound" then v:Destroy() end end
    end, Theme.Danger)
end
setupPhonkTab(P.P11)

-----------------------------------------------------------
-- ENGINE LOOPS
-----------------------------------------------------------
RunService.Stepped:Connect(function()
    if Config.Spin and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(30), 0)
    end
    if Config.AntiSit and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").Sit = false
    end
end)

RunService.Heartbeat:Connect(function()
    if Config.AntiVoid then
        local root = _G.getRoot()
        if root and root.Position.Y < -50 then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.CFrame = CFrame.new(root.Position.X, 45, root.Position.Z)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.InfJump then
        local hum = _G.getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

_G.sendChatIntro()
