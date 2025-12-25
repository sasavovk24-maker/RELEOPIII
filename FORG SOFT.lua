--==================================================
-- FORG SOFT | New Year Edition 🎄
-- RGB Outline + Snow + Icon
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================
local ICON_ID = "rbxassetid://3926305904"
local FONT = Enum.Font.Arcade -- максимально близко к Minecraft
local CHEAT_KEY = "Test"
local KEY_TIME = 6 * 60 * 60
local KEY_FILE = "forgsoft_key.txt"

--==================================================
-- KEY SYSTEM
--==================================================
local function HasKey()
	if not (readfile and writefile and isfile) then return false end
	if not isfile(KEY_FILE) then return false end
	local t = tonumber(readfile(KEY_FILE))
	return t and os.time() - t < KEY_TIME
end

local function SaveKey()
	if writefile then writefile(KEY_FILE, tostring(os.time())) end
end

--==================================================
-- BLUR + INTRO
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
	t.TextColor3 = Color3.new(1,1,1)
	t.TextStrokeTransparency = 0
	t.TextTransparency = 1
	TweenService:Create(t, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
	task.wait(1.3)
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
	f.BackgroundColor3 = Color3.fromRGB(20,24,40)
	f.Active, f.Draggable = true, true
	Instance.new("UICorner", f).CornerRadius = UDim.new(0,16)

	local t = Instance.new("TextLabel", f)
	t.Size = UDim2.new(1,0,0,40)
	t.BackgroundTransparency = 1
	t.Text = "FORG SOFT KEY"
	t.Font = FONT
	t.TextScaled = true
	t.TextColor3 = Color3.new(1,1,1)

	local box = Instance.new("TextBox", f)
	box.Size = UDim2.new(0.85,0,0,36)
	box.Position = UDim2.new(0.075,0,0.4,0)
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

-- FLOAT ICON
local Icon = Instance.new("ImageButton", gui)
Icon.Size = UDim2.new(0,56,0,56)
Icon.Position = UDim2.new(0,16,0.5,-28)
Icon.Image = ICON_ID
Icon.BackgroundColor3 = Color3.fromRGB(25,30,50)
Icon.Active, Icon.Draggable = true, true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(0,16)
local IconStroke = Instance.new("UIStroke", Icon)
IconStroke.Thickness = 2

-- MENU
local Menu = Instance.new("Frame", gui)
Menu.Size = UDim2.new(0,320,0,260)
Menu.Position = UDim2.new(-0.6,0,0.5,-130)
Menu.Visible = false
Menu.BackgroundColor3 = Color3.fromRGB(18,22,36)
Menu.Active, Menu.Draggable = true, true
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,18)
local MenuStroke = Instance.new("UIStroke", Menu)
MenuStroke.Thickness = 2

-- HEADER
local header = Instance.new("TextLabel", Menu)
header.Size = UDim2.new(1,0,0,44)
header.BackgroundTransparency = 1
header.Text = "🎄 FORG SOFT 🎄"
header.Font = FONT
header.TextScaled = true
header.TextColor3 = Color3.new(1,1,1)

--==================================================
-- RGB OUTLINE (ICON + MENU)
--==================================================
local hue = 0
RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.2) % 1
	local c = Color3.fromHSV(hue,1,1)
	IconStroke.Color = c
	MenuStroke.Color = c
end)

--==================================================
-- SNOW EFFECT ❄
--==================================================
local SnowGui = Instance.new("ScreenGui", gui)
SnowGui.IgnoreGuiInset = true

for i = 1, 35 do
	task.spawn(function()
		while true do
			local s = Instance.new("TextLabel", SnowGui)
			s.Text = "❄"
			s.Font = Enum.Font.SourceSans
			s.TextSize = math.random(14,22)
			s.TextTransparency = 0.2
			s.TextColor3 = Color3.new(1,1,1)
			s.BackgroundTransparency = 1
			s.Position = UDim2.new(math.random(),0,-0.1,0)
			s.Size = UDim2.new(0,20,0,20)

			local fallTime = math.random(5,9)
			TweenService:Create(s, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {
				Position = UDim2.new(s.Position.X.Scale,0,1.1,0),
				TextTransparency = 0.8
			}):Play()

			game:GetService("Debris"):AddItem(s, fallTime)
			task.wait(math.random(0.3,0.7))
		end
	end)
end

--==================================================
-- MENU TOGGLE
--==================================================
local open = false
Icon.MouseButton1Click:Connect(function()
	open = not open
	Menu.Visible = true
	TweenService:Create(Menu, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
		Position = open and UDim2.new(0,90,0.5,-130) or UDim2.new(-0.6,0,0.5,-130)
	}):Play()
	task.delay(0.4,function()
		if not open then Menu.Visible = false end
	end)
end) 
