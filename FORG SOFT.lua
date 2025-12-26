--========================================
-- FORG SOFT | NEW YEAR WHITE UI
--========================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

--========================================
-- CONFIG
--========================================
local ICON = "rbxassetid://3926305904"
local KEY_URL = "https://raw.githubusercontent.com/USER/REPO/main/key.txt"
local SAVE_FILE = "forgsoft_save.json"

--========================================
-- STATES
--========================================
local State = {
	Jump = false,
	Noclip = false,
	Fly = false,
	ESP = false,
	Invis = false,
	AntiFall = true
}

--========================================
-- SAVE / LOAD
--========================================
local function Save()
	if writefile then
		writefile(SAVE_FILE, HttpService:JSONEncode(State))
	end
end

local function Load()
	if readfile and isfile and isfile(SAVE_FILE) then
		local data = HttpService:JSONDecode(readfile(SAVE_FILE))
		for i,v in pairs(data) do
			State[i] = v
		end
	end
end
Load()

--========================================
-- CLOUD KEY
--========================================
local function CheckKey(input)
	local ok, key = pcall(function()
		return game:HttpGet(KEY_URL)
	end)
	if ok then
		return string.find(key, input)
	end
	return false
end

--========================================
-- GUI
--========================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

-- ICON
local icon = Instance.new("ImageButton", gui)
icon.Size = UDim2.new(0,60,0,60)
icon.Position = UDim2.new(0,15,0.5,-30)
icon.Image = ICON
icon.BackgroundColor3 = Color3.fromRGB(255,255,255)
icon.Active, icon.Draggable = true, true
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

-- MENU
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,300,0,340)
menu.Position = UDim2.new(-1,0,0.5,-170)
menu.BackgroundColor3 = Color3.fromRGB(245,245,255)
menu.Visible = false
menu.Active, menu.Draggable = true, true
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,18)

-- RGB STROKE
local stroke = Instance.new("UIStroke", menu)
stroke.Thickness = 2

RunService.RenderStepped:Connect(function()
	stroke.Color = Color3.fromHSV(tick()%5/5,1,1)
end)

-- TITLE
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1,0,0,40)
title.Text = "FORG SOFT ❄"
title.BackgroundTransparency = 1
title.TextScaled = true
title.Font = Enum.Font.Arcade
title.TextColor3 = Color3.new(0,0,0)

-- BUTTON MAKER
local y = 50
local function Btn(txt, callback)
	local b = Instance.new("TextButton", menu)
	b.Size = UDim2.new(0.9,0,0,36)
	b.Position = UDim2.new(0.05,0,0,y)
	b.Text = txt
	b.Font = Enum.Font.Arcade
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	y += 42
	b.MouseButton1Click:Connect(callback)
	return b
end

--========================================
-- FUNCTIONS
--========================================

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if State.Jump then
		Hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- NoClip
RunService.Stepped:Connect(function()
	if State.Noclip then
		for _,v in pairs(Char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- Fly (CONTROLLED)
local bv, bg
RunService.RenderStepped:Connect(function()
	if State.Fly then
		if not bv then
			bv = Instance.new("BodyVelocity", HRP)
			bg = Instance.new("BodyGyro", HRP)
			bv.MaxForce = Vector3.new(9e9,9e9,9e9)
			bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
		end
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
		bv.Velocity = dir * 60
	else
		if bv then bv:Destroy() bg:Destroy() bv=nil bg=nil end
	end
end)

-- Invisible (MAX)
local function SetInvisible(on)
	for _,v in pairs(Char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = on and 1 or 0
			v.LocalTransparencyModifier = on and 1 or 0
		end
	end
end

-- Anti Fall
local lastPos = HRP.Position
RunService.RenderStepped:Connect(function()
	if HRP.Position.Y > -10 then
		lastPos = HRP.Position
	elseif State.AntiFall then
		HRP.CFrame = CFrame.new(lastPos + Vector3.new(0,5,0))
	end
end)

--========================================
-- BUTTONS
--========================================
Btn("Беск. прыжок", function() State.Jump = not State.Jump Save() end)
Btn("NoClip", function() State.Noclip = not State.Noclip Save() end)
Btn("Fly", function() State.Fly = not State.Fly Save() end)
Btn("Invisible", function() State.Invis = not State.Invis SetInvisible(State.Invis) Save() end)
Btn("Anti Fall", function() State.AntiFall = not State.AntiFall Save() end)

--========================================
-- MENU TOGGLE
--========================================
local open = false
icon.MouseButton1Click:Connect(function()
	open = not open
	menu.Visible = true
	TweenService:Create(menu,TweenInfo.new(0.4),{
		Position = open and UDim2.new(0,90,0.5,-170) or UDim2.new(-1,0,0.5,-170)
	}):Play()
	task.delay(0.4,function() if not open then menu.Visible=false end end)
end)
