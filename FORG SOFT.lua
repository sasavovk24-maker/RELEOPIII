--==================================================
-- FORG SOFT | NEW YEAR WHITE EDITION 🎄
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VInput = game:GetService("VirtualInputManager")

local lp = Players.LocalPlayer

-- CONFIG
local KEY = "Test"
local SAVE_TIME = 6*60*60
local KEY_FILE = "forgsoft_key.txt"
local STATE_FILE = "forgsoft_state.txt"
local ICON = "rbxassetid://3926305904"
local FONT = Enum.Font.Arcade

-- STATES
local State = {
	Jump=false, Invis=false, ESP=false,
	NoClip=false, Fly=false, AntiAFK=true,
	Mobile=true
}

-- FILE SAVE
local function Save(tbl,file)
	if writefile then writefile(file, game:GetService("HttpService"):JSONEncode(tbl)) end
end
local function Load(file)
	if isfile and isfile(file) then
		return game:GetService("HttpService"):JSONDecode(readfile(file))
	end
end

local saved = Load(STATE_FILE)
if saved then for k,v in pairs(saved) do State[k]=v end end

-- KEY CHECK
local function HasKey()
	if not (isfile and readfile) then return false end
	if not isfile(KEY_FILE) then return false end
	return os.time()-tonumber(readfile(KEY_FILE)) < SAVE_TIME
end

-- INVISIBLE (REAL)
local function SetInvisible(on)
	local c = lp.Character
	if not c then return end
	for _,v in ipairs(c:GetDescendants()) do
		if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then
			v.LocalTransparencyModifier = on and 1 or 0
		end
	end
end

-- NOCLIP
RunService.Stepped:Connect(function()
	if State.NoClip and lp.Character then
		for _,v in pairs(lp.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end
end)

-- FLY (CONTROLLED)
local flyBV, flyBG
RunService.RenderStepped:Connect(function()
	if State.Fly and lp.Character then
		local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			if not flyBV then
				flyBV = Instance.new("BodyVelocity", hrp)
				flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
				flyBG = Instance.new("BodyGyro", hrp)
				flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
			end
			local cam = workspace.CurrentCamera
			local move = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
			flyBV.Velocity = move * 60
			flyBG.CFrame = cam.CFrame
		end
	else
		if flyBV then flyBV:Destroy(); flyBV=nil end
		if flyBG then flyBG:Destroy(); flyBG=nil end
	end
end)

-- ESP
local function UpdateESP()
	for _,p in pairs(Players:GetPlayers()) do
		if p~=lp and p.Character then
			local h = p.Character:FindFirstChild("FORG_ESP")
			if State.ESP then
				if not h then
					h=Instance.new("Highlight",p.Character)
					h.Name="FORG_ESP"
					h.FillColor=Color3.fromRGB(255,80,80)
					h.OutlineColor=Color3.new(1,1,1)
					h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
				end
			else
				if h then h:Destroy() end
			end
		end
	end
end

-- ANTI AFK
lp.Idled:Connect(function()
	if State.AntiAFK then
		VInput:SendKeyEvent(true,Enum.KeyCode.Space,false,game)
		task.wait()
		VInput:SendKeyEvent(false,Enum.KeyCode.Space,false,game)
	end
end)

-- GUI (WHITE / MOBILE OPTIMIZED)
local gui=Instance.new("ScreenGui",lp.PlayerGui)
local icon=Instance.new("ImageButton",gui)
icon.Image=ICON
icon.Size=UDim2.new(0,52,0,52)
icon.Position=UDim2.new(0,12,0.5,-26)
icon.BackgroundColor3=Color3.fromRGB(255,255,255)
icon.Active,icon.Draggable=true,true
Instance.new("UICorner",icon).CornerRadius=UDim.new(0,14)

local stroke=Instance.new("UIStroke",icon)
stroke.Thickness=2

-- RGB
RunService.RenderStepped:Connect(function()
	stroke.Color=Color3.fromHSV(tick()%5/5,1,1)
end)

-- MENU
local menu=Instance.new("Frame",gui)
menu.Size=UDim2.new(0,300,0,360)
menu.Position=UDim2.new(-1,0,0.5,-180)
menu.BackgroundColor3=Color3.fromRGB(245,245,245)
menu.Visible=false
menu.Active,menu.Draggable=true,true
Instance.new("UICorner",menu).CornerRadius=UDim.new(0,18)

icon.MouseButton1Click:Connect(function()
	menu.Visible=true
	TweenService:Create(menu,TweenInfo.new(0.4),{
		Position=menu.Position.X.Scale<0 and UDim2.new(0,80,0.5,-180) or UDim2.new(-1,0,0.5,-180)
	}):Play()
end)

-- SAVE LOOP
task.spawn(function()
	while task.wait(5) do
		Save(State,STATE_FILE)
	end
end)
