--==================================================
-- FORG SOFT | New Year Glow UI (Clean Analog)
--==================================================

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

--// PLAYER
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--==================================================
-- CONFIG
--==================================================
local CHEAT_KEY = "Test"
local SAVE_TIME = 6 * 60 * 60
local KEY_FILE = "forgsoft_key.txt"
local ICON_ID = "rbxassetid://348476928"

--==================================================
-- KEY SYSTEM (6 HOURS)
--==================================================
local function HasSavedKey()
	if not (readfile and writefile and isfile) then return false end
	if not isfile(KEY_FILE) then return false end
	local t = tonumber(readfile(KEY_FILE))
	return t and os.time() - t < SAVE_TIME
end

local function SaveKey()
	if writefile then
		writefile(KEY_FILE, tostring(os.time()))
	end
end

--==================================================
-- BLUR + INTRO
--==================================================
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

local function Intro()
	TweenService:Create(blur, TweenInfo.new(0.5), {Size = 24}):Play()

	local g = Instance.new("ScreenGui", player.PlayerGui)
	local t = Instance.new("TextLabel", g)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.Text = "FORG SOFT"
	t.Font = Enum.Font.FredokaOne
	t.TextScaled = true
	t.TextTransparency = 1
	t.TextStrokeTransparency = 0
	t.TextStrokeColor3 = Color3.fromRGB(255,80,80)

	TweenService:Create(t, TweenInfo.new(0.7), {TextTransparency = 0}):Play()
	task.wait(1.6)
	TweenService:Create(t, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
	TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()
	task.wait(0.5)
	g:Destroy()
end

--==================================================
-- KEY UI
--==================================================
if not HasSavedKey() then
	local kg = Instance.new("ScreenGui", player.PlayerGui)
	local f = Instance.new("Frame", kg)
	f.Size = UDim2.new(0,320,0,170)
	f.Position = UDim2.new(0.5,-160,0.5,-85)
	f.BackgroundColor3 = Color3.fromRGB(18,22,36)
	f.Active, f.Draggable = true, true
	Instance.new("UICorner", f).CornerRadius = UDim.new(0,16)

	local glow = Instance.new("UIStroke", f)
	glow.Color = Color3.fromRGB(255,80,80)
	glow.Thickness = 2
	glow.Transparency = 0.2

	local title = Instance.new("TextLabel", f)
	title.Size = UDim2.new(1,0,0,42)
	title.BackgroundTransparency = 1
	title.Text = "FORG SOFT ACCESS"
	title.Font = Enum.Font.FredokaOne
	title.TextScaled = true
	title.TextColor3 = Color3.new(1,1,1)

	local box = Instance.new("TextBox", f)
	box.Size = UDim2.new(0.85,0,0,36)
	box.Position = UDim2.new(0.075,0,0.42,0)
	box.PlaceholderText = "Enter key"
	box.Font = Enum.Font.GothamBold
	box.TextScaled = true

	local btn = Instance.new("TextButton", f)
	btn.Size = UDim2.new(0.85,0,0,36)
	btn.Position = UDim2.new(0.075,0,0.68,0)
	btn.Text = "UNLOCK"
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true

	btn.MouseButton1Click:Connect(function()
		if box.Text == CHEAT_KEY then
			SaveKey()
			kg:Destroy()
			Intro()
		else
			btn.Text = "WRONG KEY"
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

local iconGlow = Instance.new("UIStroke", IconBtn)
iconGlow.Color = Color3.fromRGB(255,90,90)
iconGlow.Thickness = 2
iconGlow.Transparency = 0.25

-- Menu Frame
local Menu = Instance.new("Frame", gui)
Menu.Size = UDim2.new(0,280,0,240)
Menu.Position = UDim2.new(-0.6,0,0.5,-120)
Menu.BackgroundColor3 = Color3.fromRGB(16,20,34)
Menu.Visible = false
Menu.Active, Menu.Draggable = true, true
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,18)

local menuGlow = Instance.new("UIStroke", Menu)
menuGlow.Color = Color3.fromRGB(255,80,80)
menuGlow.Thickness = 2
menuGlow.Transparency = 0.2

local header = Instance.new("TextLabel", Menu)
header.Size = UDim2.new(1,0,0,44)
header.BackgroundTransparency = 1
header.Text = "🎄 FORG SOFT 🎄"
header.Font = Enum.Font.FredokaOne
header.TextScaled = true
header.TextColor3 = Color3.new(1,1,1)

--==================================================
-- STATES
--==================================================
local State = { Jump=false, Invis=false, ESP=false }

--==================================================
-- BUTTON FACTORY
--==================================================
local function MakeBtn(text, y)
	local b = Instance.new("TextButton", Menu)
	b.Size = UDim2.new(0.9,0,0,40)
	b.Position = UDim2.new(0.05,0,y,0)
	b.Text = text.." : OFF"
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(32,38,66)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)

	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(255,80,80)
	s.Thickness = 1
	s.Transparency = 0.35
	return b
end

local JumpBtn = MakeBtn("Infinite Jump", 0.22)
local InvisBtn = MakeBtn("Invisible", 0.42)
local ESPBtn  = MakeBtn("WallHack", 0.62)

--==================================================
-- MENU TOGGLE
--==================================================
local open = false
IconBtn.MouseButton1Click:Connect(function()
	open = not open
	Menu.Visible = true
	TweenService:Create(Menu, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
		Position = open and UDim2.new(0,86,0.5,-120) or UDim2.new(-0.6,0,0.5,-120)
	}):Play()
	task.delay(0.4,function()
		if not open then Menu.Visible = false end
	end)
end)

--==================================================
-- CHARACTER
--==================================================
local function GetChar()
	return player.Character or player.CharacterAdded:Wait()
end

-- Infinite Jump
JumpBtn.MouseButton1Click:Connect(function()
	State.Jump = not State.Jump
	JumpBtn.Text = "Infinite Jump : "..(State.Jump and "ON" or "OFF")
end)

UIS.JumpRequest:Connect(function()
	if State.Jump then
		GetChar():FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Invisible
InvisBtn.MouseButton1Click:Connect(function()
	State.Invis = not State.Invis
	InvisBtn.Text = "Invisible : "..(State.Invis and "ON" or "OFF")
	for _,v in ipairs(GetChar():GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.Transparency = State.Invis and 1 or 0
		end
	end
end)

-- WallHack (ESP)
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
	ESPBtn.Text = "WallHack : "..(State.ESP and "ON" or "OFF")
	UpdateESP()
end)
