--==================================================
-- FORG SOFT | New Year Edition 🎄
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

--// CONFIG
local CHEAT_KEY = "Test"
local SAVE_TIME = 6 * 60 * 60 -- 6 часов
local KEY_FILE = "forgsoft_key.txt"
local ICON_ID = "rbxassetid://348476928"

--==================================================
-- 🔐 KEY SYSTEM (6 HOURS)
--==================================================
local function HasSavedKey()
	if not writefile or not readfile or not isfile then return false end
	if not isfile(KEY_FILE) then return false end
	local data = tonumber(readfile(KEY_FILE))
	return data and os.time() - data < SAVE_TIME
end

local function SaveKey()
	if writefile then
		writefile(KEY_FILE, tostring(os.time()))
	end
end

--==================================================
-- 🌫 BLUR + INTRO ANIMATION
--==================================================
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

local function IntroAnimation()
	TweenService:Create(blur, TweenInfo.new(0.6), {Size = 24}):Play()

	local intro = Instance.new("ScreenGui", player.PlayerGui)
	local text = Instance.new("TextLabel", intro)

	text.Size = UDim2.new(1,0,1,0)
	text.Text = "FORG SOFT"
	text.TextColor3 = Color3.fromRGB(255,255,255)
	text.BackgroundTransparency = 1
	text.Font = Enum.Font.FredokaOne -- новогодний стиль
	text.TextScaled = true
	text.TextTransparency = 1
	text.TextStrokeTransparency = 0
	text.TextStrokeColor3 = Color3.fromRGB(255,80,80)

	TweenService:Create(text, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
	task.wait(1.8)

	TweenService:Create(text, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
	TweenService:Create(blur, TweenInfo.new(0.6), {Size = 0}):Play()

	task.wait(0.6)
	intro:Destroy()
end

--==================================================
-- 🔑 KEY UI
--==================================================
if not HasSavedKey() then
	local keyGui = Instance.new("ScreenGui", player.PlayerGui)
	local frame = Instance.new("Frame", keyGui)
	frame.Size = UDim2.new(0,300,0,150)
	frame.Position = UDim2.new(0.5,-150,0.5,-75)
	frame.BackgroundColor3 = Color3.fromRGB(20,25,40)
	frame.Active, frame.Draggable = true, true

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0,14)

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1,0,0,40)
	title.Text = "FORG SOFT KEY"
	title.Font = Enum.Font.FredokaOne
	title.TextScaled = true
	title.TextColor3 = Color3.new(1,1,1)
	title.BackgroundTransparency = 1

	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(0.8,0,0,35)
	box.Position = UDim2.new(0.1,0,0.45,0)
	box.PlaceholderText = "Enter Key"
	box.Text = ""
	box.Font = Enum.Font.GothamBold
	box.TextScaled = true

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.8,0,0,35)
	btn.Position = UDim2.new(0.1,0,0.7,0)
	btn.Text = "UNLOCK"
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true

	btn.MouseButton1Click:Connect(function()
		if box.Text == CHEAT_KEY then
			SaveKey()
			keyGui:Destroy()
			IntroAnimation()
		else
			btn.Text = "WRONG KEY"
		end
	end)

	repeat task.wait() until not keyGui.Parent
else
	IntroAnimation()
end

--==================================================
-- ⚙️ MAIN GUI
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local HudBtn = Instance.new("ImageButton", gui)
HudBtn.Size = UDim2.new(0,52,0,52)
HudBtn.Position = UDim2.new(0,15,0.5,-26)
HudBtn.Image = ICON_ID
HudBtn.BackgroundColor3 = Color3.fromRGB(25,30,55)
HudBtn.Active, HudBtn.Draggable = true, true
Instance.new("UICorner", HudBtn).CornerRadius = UDim.new(0,14)

local Menu = Instance.new("Frame", gui)
Menu.Size = UDim2.new(0,260,0,230)
Menu.Position = UDim2.new(-0.6,0,0.5,-115)
Menu.BackgroundColor3 = Color3.fromRGB(15,18,30)
Menu.Visible = false
Menu.Active, Menu.Draggable = true, true
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", Menu)
title.Size = UDim2.new(1,0,0,40)
title.Text = "🎄 FORG SOFT 🎄"
title.Font = Enum.Font.FredokaOne
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1

--==================================================
-- STATES
--==================================================
local State = {
	Jump = false,
	Invis = false,
	ESP = false
}

--==================================================
-- BUTTON CREATOR
--==================================================
local function MakeBtn(text, y)
	local b = Instance.new("TextButton", Menu)
	b.Size = UDim2.new(0.9,0,0,38)
	b.Position = UDim2.new(0.05,0,y,0)
	b.Text = text.." : OFF"
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(35,40,70)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

local JumpBtn = MakeBtn("Infinite Jump",0.22)
local InvisBtn = MakeBtn("Invisible",0.42)
local ESPBtn = MakeBtn("WallHack",0.62)

--==================================================
-- MENU TOGGLE
--==================================================
local open = false
HudBtn.MouseButton1Click:Connect(function()
	open = not open
	Menu.Visible = true
	TweenService:Create(Menu,TweenInfo.new(0.4),{
		Position = open and UDim2.new(0,80,0.5,-115) or UDim2.new(-0.6,0,0.5,-115)
	}):Play()
	task.delay(0.4,function()
		if not open then Menu.Visible=false end
	end)
end)

--==================================================
-- FUNCTIONS
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

-- WallHack
local function UpdateESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local h = p.Character:FindFirstChildOfClass("Highlight")
			if State.ESP then
				if not h then
					h = Instance.new("Highlight", p.Character)
					h.FillColor = Color3.fromRGB(255,70,70)
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
