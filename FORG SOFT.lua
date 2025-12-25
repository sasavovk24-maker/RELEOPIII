--==================================================
-- FORG SOFT | Tabs + Sound + Pulse Glow 🎄
--==================================================

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

--// PLAYER
local player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================
local CHEAT_KEY = "Test"
local SAVE_TIME = 6 * 60 * 60
local KEY_FILE = "forgsoft_key.txt"
local ICON_ID = "rbxassetid://140066670936360"
local FONT = Enum.Font.Arcade -- Minecraft style

-- Sounds
local SOUND_ON  = "rbxassetid://9118828567"
local SOUND_OFF = "rbxassetid://9118828567"

--==================================================
-- KEY SYSTEM
--==================================================
local function HasKey()
	if not (readfile and writefile and isfile) then return false end
	if not isfile(KEY_FILE) then return false end
	local t = tonumber(readfile(KEY_FILE))
	return t and os.time() - t < SAVE_TIME
end

local function SaveKey()
	if writefile then writefile(KEY_FILE, tostring(os.time())) end
end

--==================================================
-- INTRO + BLUR
--==================================================
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

local function Intro()
	TweenService:Create(blur, TweenInfo.new(0.4), {Size = 22}):Play()
	local g = Instance.new("ScreenGui", player.PlayerGui)
	local t = Instance.new("TextLabel", g)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.Text = "FORG SOFT"
	t.Font = FONT
	t.TextScaled = true
	t.TextTransparency = 1
	t.TextStrokeTransparency = 0
	t.TextStrokeColor3 = Color3.fromRGB(255,80,80)
	TweenService:Create(t, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
	task.wait(1.4)
	TweenService:Create(t, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	TweenService:Create(blur, TweenInfo.new(0.4), {Size = 0}):Play()
	task.wait(0.4)
	g:Destroy()
end

--==================================================
-- KEY UI
--==================================================
if not HasKey() then
	local kg = Instance.new("ScreenGui", player.PlayerGui)
	local f = Instance.new("Frame", kg)
	f.Size = UDim2.new(0,320,0,170)
	f.Position = UDim2.new(0.5,-160,0.5,-85)
	f.BackgroundColor3 = Color3.fromRGB(18,22,36)
	f.Active, f.Draggable = true, true
	Instance.new("UICorner", f).CornerRadius = UDim.new(0,16)
	local st = Instance.new("UIStroke", f); st.Color = Color3.fromRGB(255,80,80); st.Thickness = 2

	local title = Instance.new("TextLabel", f)
	title.Size = UDim2.new(1,0,0,42)
	title.BackgroundTransparency = 1
	title.Text = "ДОСТУП FORG SOFT"
	title.Font = FONT
	title.TextScaled = true
	title.TextColor3 = Color3.new(1,1,1)

	local box = Instance.new("TextBox", f)
	box.Size = UDim2.new(0.85,0,0,36)
	box.Position = UDim2.new(0.075,0,0.42,0)
	box.PlaceholderText = "Введите ключ"
	box.Font = FONT
	box.TextScaled = true

	local btn = Instance.new("TextButton", f)
	btn.Size = UDim2.new(0.85,0,0,36)
	btn.Position = UDim2.new(0.075,0,0.68,0)
	btn.Text = "АКТИВИРОВАТЬ"
	btn.Font = FONT
	btn.TextScaled = true

	btn.MouseButton1Click:Connect(function()
		if box.Text == CHEAT_KEY then
			SaveKey()
			kg:Destroy()
			Intro()
		else
			btn.Text = "НЕВЕРНЫЙ КЛЮЧ"
		end
	end)

	repeat task.wait() until not kg.Parent
else
	Intro()
end

--==================================================
-- MAIN GUI
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- Floating Icon
local IconBtn = Instance.new("ImageButton", gui)
IconBtn.Size = UDim2.new(0,54,0,54)
IconBtn.Position = UDim2.new(0,18,0.5,-27)
IconBtn.Image = ICON_ID
IconBtn.BackgroundColor3 = Color3.fromRGB(22,26,44)
IconBtn.Active, IconBtn.Draggable = true, true
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(0,16)
local iconStroke = Instance.new("UIStroke", IconBtn)
iconStroke.Color = Color3.fromRGB(255,80,80)
iconStroke.Thickness = 2

-- Menu
local Menu = Instance.new("Frame", gui)
Menu.Size = UDim2.new(0,320,0,280)
Menu.Position = UDim2.new(-0.7,0,0.5,-140)
Menu.BackgroundColor3 = Color3.fromRGB(16,20,34)
Menu.Visible = false
Menu.Active, Menu.Draggable = true, true
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,18)
local menuStroke = Instance.new("UIStroke", Menu)
menuStroke.Color = Color3.fromRGB(255,80,80)
menuStroke.Thickness = 2

-- Pulse Glow (menu + icon)
local pulseDir = 1
RunService.RenderStepped:Connect(function(dt)
	local a = menuStroke.Transparency + pulseDir * dt * 0.6
	if a <= 0.15 then pulseDir = 1 end
	if a >= 0.5 then pulseDir = -1 end
	menuStroke.Transparency = math.clamp(a, 0.15, 0.5)
	iconStroke.Transparency = menuStroke.Transparency
end)

local header = Instance.new("TextLabel", Menu)
header.Size = UDim2.new(1,0,0,44)
header.BackgroundTransparency = 1
header.Text = "🎄 FORG SOFT 🎄"
header.Font = FONT
header.TextScaled = true
header.TextColor3 = Color3.new(1,1,1)

-- Tabs bar
local TabsBar = Instance.new("Frame", Menu)
TabsBar.Size = UDim2.new(1,-16,0,36)
TabsBar.Position = UDim2.new(0,8,0,48)
TabsBar.BackgroundTransparency = 1

local function TabButton(txt, x)
	local b = Instance.new("TextButton", TabsBar)
	b.Size = UDim2.new(0.48,0,1,0)
	b.Position = UDim2.new(x,0,0,0)
	b.Text = txt
	b.Font = FONT
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(32,38,66)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(255,80,80); s.Thickness = 1
	return b, s
end

local TabPlayer, TabPlayerStroke = TabButton("PLAYER", 0)
local TabVisuals, TabVisualsStroke = TabButton("VISUALS", 0.52)

-- Pages
local PagePlayer = Instance.new("Frame", Menu)
PagePlayer.Size = UDim2.new(1,-16,1,-100)
PagePlayer.Position = UDim2.new(0,8,0,92)
PagePlayer.BackgroundTransparency = 1

local PageVisuals = PagePlayer:Clone()
PageVisuals.Parent = Menu
PageVisuals.Visible = false

local function SwitchTab(playerTab)
	PagePlayer.Visible = playerTab
	PageVisuals.Visible = not playerTab
	TabPlayerStroke.Color  = playerTab and Color3.fromRGB(80,255,120) or Color3.fromRGB(255,80,80)
	TabVisualsStroke.Color = (not playerTab) and Color3.fromRGB(80,255,120) or Color3.fromRGB(255,80,80)
end

TabPlayer.MouseButton1Click:Connect(function() SwitchTab(true) end)
TabVisuals.MouseButton1Click:Connect(function() SwitchTab(false) end)
SwitchTab(true)

--==================================================
-- STATES
--==================================================
local State = { Jump=false, Invis=false, ESP=false }

-- Sound helper
local function PlaySound(id)
	local s = Instance.new("Sound", workspace)
	s.SoundId = id
	s.Volume = 0.8
	s:Play()
	game:GetService("Debris"):AddItem(s, 2)
end

-- Button factory
local function MakeBtn(parent, text, y)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,y,0)
	b.Text = text.." : ВЫКЛ"
	b.Font = FONT
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(32,38,66)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(255,80,80); s.Thickness = 2
	return b, s
end

local JumpBtn, JumpStroke   = MakeBtn(PagePlayer,  "Бесконечный прыжок", 0)
local InvisBtn, InvisStroke= MakeBtn(PagePlayer,  "Невидимость",        0.22)
local ESPBtn, ESPStroke    = MakeBtn(PageVisuals, "Валхак",              0)

local function Toggle(btn, stroke, state)
	btn.Text = btn.Text:split(":")[1] .. ": " .. (state and "ВКЛ" or "ВЫКЛ")
	stroke.Color = state and Color3.fromRGB(80,255,120) or Color3.fromRGB(255,80,80)
	PlaySound(state and SOUND_ON or SOUND_OFF)
end

-- Menu toggle
local open = false
IconBtn.MouseButton1Click:Connect(function()
	open = not open
	Menu.Visible = true
	TweenService:Create(Menu, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
		Position = open and UDim2.new(0,86,0.5,-140) or UDim2.new(-0.7,0,0.5,-140)
	}):Play()
	task.delay(0.4,function() if not open then Menu.Visible=false end end)
end)

-- Functions
JumpBtn.MouseButton1Click:Connect(function()
	State.Jump = not State.Jump
	Toggle(JumpBtn, JumpStroke, State.Jump)
end)

UIS.JumpRequest:Connect(function()
	if State.Jump then
		(player.Character or player.CharacterAdded:Wait())
			:FindFirstChildOfClass("Humanoid")
			:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

InvisBtn.MouseButton1Click:Connect(function()
	State.Invis = not State.Invis
	Toggle(InvisBtn, InvisStroke, State.Invis)
	for _,v in ipairs((player.Character or player.CharacterAdded:Wait()):GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.Transparency = State.Invis and 1 or 0
		end
	end
end)

local function UpdateESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local h = p.Character:FindFirstChildOfClass("Highlight")
			if State.ESP then
				if not h then
					h = Instance.new("Highlight", p.Character)
					h.FillColor = Color3.fromRGB(255,80,80)
					h.OutlineColor = Color3.new(1,1,1)
					h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				end
			else
				if h then h:Destroy() end
			end
		end
	end
end

ESPBtn.MouseButton1Click:Connect(function()
	State.ESP = not State.ESP
	Toggle(ESPBtn, ESPStroke, State.ESP)
	UpdateESP()
end) 
