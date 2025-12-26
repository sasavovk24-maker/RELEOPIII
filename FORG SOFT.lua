--==================================================
-- FORG SOFT | Final New Year Edition ❄
--==================================================

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================
local KEY = "Test"
local SAVE_TIME = 6 * 60 * 60
local KEY_FILE = "forgsoft_key.txt"
local ICON_ID = "rbxassetid://3926305904"
local FONT = Enum.Font.Arcade

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
-- INTRO
--==================================================
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

local function Intro()
	TweenService:Create(blur, TweenInfo.new(0.4), {Size = 20}):Play()
	local g = Instance.new("ScreenGui", player.PlayerGui)
	local t = Instance.new("TextLabel", g)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.Text = "FORG SOFT"
	t.Font = FONT
	t.TextScaled = true
	t.TextTransparency = 1
	t.TextColor3 = Color3.fromRGB(255,255,255)
	t.TextStrokeTransparency = 0
	TweenService:Create(t, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
	task.wait(1.2)
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
	f.Size = UDim2.new(0,300,0,160)
	f.Position = UDim2.new(0.5,-150,0.5,-80)
	f.BackgroundColor3 = Color3.fromRGB(245,245,245)
	f.Active, f.Draggable = true, true
	Instance.new("UICorner", f).CornerRadius = UDim.new(0,14)

	local title = Instance.new("TextLabel", f)
	title.Size = UDim2.new(1,0,0,40)
	title.BackgroundTransparency = 1
	title.Text = "FORG SOFT ACCESS"
	title.Font = FONT
	title.TextScaled = true
	title.TextColor3 = Color3.new(0,0,0)

	local box = Instance.new("TextBox", f)
	box.Size = UDim2.new(0.85,0,0,36)
	box.Position = UDim2.new(0.075,0,0.38,0)
	box.PlaceholderText = "Введите ключ"
	box.Font = FONT
	box.TextScaled = true

	local btn = Instance.new("TextButton", f)
	btn.Size = UDim2.new(0.85,0,0,36)
	btn.Position = UDim2.new(0.075,0,0.65,0)
	btn.Text = "АКТИВИРОВАТЬ"
	btn.Font = FONT
	btn.TextScaled = true

	btn.MouseButton1Click:Connect(function()
		if box.Text == KEY then
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

-- Icon
local Icon = Instance.new("ImageButton", gui)
Icon.Size = UDim2.new(0,54,0,54)
Icon.Position = UDim2.new(0,15,0.5,-27)
Icon.Image = ICON_ID
Icon.BackgroundColor3 = Color3.fromRGB(255,255,255)
Icon.Active, Icon.Draggable = true, true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(0,16)

local iconStroke = Instance.new("UIStroke", Icon)
iconStroke.Thickness = 2

-- Menu
local Menu = Instance.new("Frame", gui)
Menu.Size = UDim2.new(0,320,0,300)
Menu.Position = UDim2.new(-0.7,0,0.5,-150)
Menu.BackgroundColor3 = Color3.fromRGB(250,250,250)
Menu.Visible = false
Menu.Active, Menu.Draggable = true, true
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,18)

local menuStroke = Instance.new("UIStroke", Menu)
menuStroke.Thickness = 2

-- RGB Stroke
local hue = 0
RunService.RenderStepped:Connect(function()
	hue = (hue + 1) % 360
	local c = Color3.fromHSV(hue/360,1,1)
	menuStroke.Color = c
	iconStroke.Color = c
end)

local title = Instance.new("TextLabel", Menu)
title.Size = UDim2.new(1,0,0,44)
title.BackgroundTransparency = 1
title.Text = "🎄 FORG SOFT 🎄"
title.Font = FONT
title.TextScaled = true
title.TextColor3 = Color3.new(0,0,0)

--==================================================
-- STATES
--==================================================
local State = {
	Jump = false,
	Invis = false,
	ESP = false,
	NoClip = false,
	LowGrav = false
}

--==================================================
-- BUTTON MAKER
--==================================================
local function MakeBtn(text, y)
	local b = Instance.new("TextButton", Menu)
	b.Size = UDim2.new(0.9,0,0,38)
	b.Position = UDim2.new(0.05,0,y,0)
	b.Text = text.." : ВЫКЛ"
	b.Font = FONT
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(235,235,235)
	b.TextColor3 = Color3.new(0,0,0)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	local s = Instance.new("UIStroke", b)
	s.Thickness = 2
	return b, s
end

local JumpBtn, JumpS = MakeBtn("Бесконечный прыжок", 0.18)
local InvisBtn, InvisS = MakeBtn("Невидимость", 0.32)
local ESPBtn, ESPS = MakeBtn("WallHack", 0.46)
local NoClipBtn, NoClipS = MakeBtn("NoClip", 0.60)
local GravBtn, GravS = MakeBtn("Low Gravity", 0.74)

local function Toggle(btn, stroke, state)
	btn.Text = btn.Text:split(":")[1] .. ": " .. (state and "ВКЛ" or "ВЫКЛ")
	stroke.Color = state and Color3.fromRGB(0,200,80) or Color3.fromRGB(200,60,60)
end

--==================================================
-- MENU TOGGLE
--==================================================
local open = false
Icon.MouseButton1Click:Connect(function()
	open = not open
	Menu.Visible = true
	TweenService:Create(Menu, TweenInfo.new(0.4), {
		Position = open and UDim2.new(0,80,0.5,-150) or UDim2.new(-0.7,0,0.5,-150)
	}):Play()
	task.delay(0.4,function() if not open then Menu.Visible=false end end)
end)

--==================================================
-- FUNCTIONS
--==================================================

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if State.Jump then
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

JumpBtn.MouseButton1Click:Connect(function()
	State.Jump = not State.Jump
	Toggle(JumpBtn, JumpS, State.Jump)
end)

-- Invisible (fixed)
local function SetInvisible(on)
	local char = player.Character
	if not char then return end
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.Transparency = on and 1 or 0
			v.CanCollide = not on
		elseif v:IsA("Decal") then
			v.Transparency = on and 1 or 0
		end
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then hum.DisplayDistanceType = on and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer end
end

InvisBtn.MouseButton1Click:Connect(function()
	State.Invis = not State.Invis
	SetInvisible(State.Invis)
	Toggle(InvisBtn, InvisS, State.Invis)
end)

-- WallHack
local function UpdateESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local h = p.Character:FindFirstChild("FORG_ESP")
			if State.ESP then
				if not h then
					h = Instance.new("Highlight", p.Character)
					h.Name = "FORG_ESP"
					h.FillTransparency = 0.7
					h.OutlineTransparency = 0
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
	UpdateESP()
	Toggle(ESPBtn, ESPS, State.ESP)
end)

-- NoClip
RunService.Stepped:Connect(function()
	if State.NoClip and player.Character then
		for _,v in ipairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

NoClipBtn.MouseButton1Click:Connect(function()
	State.NoClip = not State.NoClip
	Toggle(NoClipBtn, NoClipS, State.NoClip)
end)

-- Low Gravity (функция от меня)
GravBtn.MouseButton1Click:Connect(function()
	State.LowGrav = not State.LowGrav
	workspace.Gravity = State.LowGrav and 60 or 196.2
	Toggle(GravBtn, GravS, State.LowGrav)
end)
