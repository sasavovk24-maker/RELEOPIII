--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--// PLAYER
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local char, hum, root

local function UpdateChar()
	char = player.Character or player.CharacterAdded:Wait()
	hum = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
end
UpdateChar()
player.CharacterAdded:Connect(UpdateChar)

--// CONFIG
local KEY = "Test"
local ICON_ID = "rbxassetid://123456789" -- ВСТАВЬ СВОЙ ID
local DEFAULT_SPEED = 16
local FAST_SPEED = 40

--// STATES (ЯВНО)
local State = {
	Jump = false,
	Speed = false,
	Invis = false,
	ESP = false,
	Aimbot = false
}

local MenuVisible = false

--// TEAM CHECK
local function SameTeam(plr)
	if not player.Team or not plr.Team then return false end
	return player.Team == plr.Team
end

--// GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local function Round(o,r)
	local c = Instance.new("UICorner", o)
	c.CornerRadius = UDim.new(0, r or 10)
end

local function Tween(o, g, t)
	TweenService:Create(
		o,
		TweenInfo.new(t or 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		g
	):Play()
end

--// ===== HUD BUTTON =====
local HudBtn = Instance.new("TextButton", gui)
HudBtn.Size = UDim2.new(0,48,0,48)
HudBtn.Position = UDim2.new(0,15,0.5,-24)
HudBtn.Text = ""
HudBtn.Active, HudBtn.Draggable = true, true
HudBtn.BackgroundColor3 = Color3.fromRGB(20,25,45)
Round(HudBtn,14)

local Icon = Instance.new("ImageLabel", HudBtn)
Icon.Size = UDim2.new(1,-8,1,-8)
Icon.Position = UDim2.new(0,4,0,4)
Icon.Image = ICON_ID
Icon.BackgroundTransparency = 1

--// ===== MENU =====
local Menu = Instance.new("Frame", gui)
Menu.Size = UDim2.new(0,260,0,300)
Menu.Position = UDim2.new(-0.5,0,0.5,-150)
Menu.BackgroundColor3 = Color3.fromRGB(15,18,30)
Menu.Visible = false
Menu.Active, Menu.Draggable = true, true
Round(Menu,14)

local Title = Instance.new("TextLabel", Menu)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "FORG SOFT"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

--// BUTTON CREATOR
local Buttons = {}

local function CreateButton(text, y)
	local b = Instance.new("TextButton", Menu)
	b.Size = UDim2.new(0.9,0,0,40)
	b.Position = UDim2.new(0.05,0,y,0)
	b.Text = text .. " : OFF"
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.BackgroundColor3 = Color3.fromRGB(35,40,70)
	b.TextColor3 = Color3.new(1,1,1)
	Round(b,10)
	Buttons[text] = b
end

CreateButton("Infinite Jump", 0.18)
CreateButton("Speed", 0.34)
CreateButton("Invisible", 0.50)
CreateButton("WallHack", 0.66)
CreateButton("Aimbot", 0.82)

--// MENU TOGGLE
local function ToggleMenu()
	MenuVisible = not MenuVisible
	Menu.Visible = true
	Tween(Menu,{
		Position = MenuVisible and UDim2.new(0,20,0.5,-150)
		or UDim2.new(-0.5,0,0.5,-150)
	},0.4)
	task.delay(0.4,function()
		if not MenuVisible then Menu.Visible=false end
	end)
end

HudBtn.MouseButton1Click:Connect(ToggleMenu)
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		ToggleMenu()
	end
end)

--// BUTTON LOGIC (ПОЧИНЕНО)
Buttons["Infinite Jump"].MouseButton1Click:Connect(function()
	State.Jump = not State.Jump
	Buttons["Infinite Jump"].Text = "Infinite Jump : "..(State.Jump and "ON" or "OFF")
end)

Buttons["Speed"].MouseButton1Click:Connect(function()
	State.Speed = not State.Speed
	Buttons["Speed"].Text = "Speed : "..(State.Speed and "ON" or "OFF")
end)

Buttons["Invisible"].MouseButton1Click:Connect(function()
	State.Invis = not State.Invis
	Buttons["Invisible"].Text = "Invisible : "..(State.Invis and "ON" or "OFF")

	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.Transparency = State.Invis and 1 or 0
		end
	end
end)

--// ESP
local function UpdateESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local h = p.Character:FindFirstChildOfClass("Highlight")
			if State.ESP and not SameTeam(p) then
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

Buttons["WallHack"].MouseButton1Click:Connect(function()
	State.ESP = not State.ESP
	Buttons["WallHack"].Text = "WallHack : "..(State.ESP and "ON" or "OFF")
	UpdateESP()
end)

--// AIMBOT
local function GetClosestEnemy()
	local closest, dist = nil, math.huge
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Head") and not SameTeam(p) then
			local pos, vis = camera:WorldToViewportPoint(p.Character.Head.Position)
			if vis then
				local d = (Vector2.new(pos.X,pos.Y)
				- Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)).Magnitude
				if d < dist then
					dist = d
					closest = p.Character.Head
				end
			end
		end
	end
	return closest
end

Buttons["Aimbot"].MouseButton1Click:Connect(function()
	State.Aimbot = not State.Aimbot
	Buttons["Aimbot"].Text = "Aimbot : "..(State.Aimbot and "ON" or "OFF")
end)

--// MECHANICS
UIS.JumpRequest:Connect(function()
	if State.Jump then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

RunService.RenderStepped:Connect(function()
	hum.WalkSpeed = State.Speed and FAST_SPEED or DEFAULT_SPEED

	if State.Aimbot then
		local t = GetClosestEnemy()
		if t then
			camera.CFrame = CFrame.new(camera.CFrame.Position, t.Position)
		end
	end
end)
