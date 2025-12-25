--==================================================
-- FORG SOFT | New Year White UI ❄
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================
local ICON_ID = "rbxassetid://3926305904"
local FONT = Enum.Font.Arcade -- похож на Minecraft

-- STATES
local State = {
	Jump = false,
	Invis = false,
	ESP = false,
	NoClip = false
}

--==================================================
-- GUI
--==================================================
local Gui = Instance.new("ScreenGui", Player.PlayerGui)
Gui.ResetOnSpawn = false

-- FLOATING ICON
local Icon = Instance.new("ImageButton", Gui)
Icon.Size = UDim2.new(0,56,0,56)
Icon.Position = UDim2.new(0,20,0.5,-28)
Icon.Image = ICON_ID
Icon.BackgroundColor3 = Color3.fromRGB(255,255,255)
Icon.Active, Icon.Draggable = true, true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(0,16)

local IconStroke = Instance.new("UIStroke", Icon)
IconStroke.Thickness = 2

-- MAIN MENU
local Menu = Instance.new("Frame", Gui)
Menu.Size = UDim2.new(0,330,0,300)
Menu.Position = UDim2.new(-0.6,0,0.5,-150)
Menu.Visible = false
Menu.Active, Menu.Draggable = true, true
Menu.BackgroundColor3 = Color3.fromRGB(245,245,245)
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0,18)

local MenuStroke = Instance.new("UIStroke", Menu)
MenuStroke.Thickness = 2

-- RGB OUTLINE
task.spawn(function()
	local h = 0
	while true do
		h = (h + 1) % 360
		local c = Color3.fromHSV(h/360,1,1)
		MenuStroke.Color = c
		IconStroke.Color = c
		task.wait(0.03)
	end
end)

-- HEADER
local Header = Instance.new("TextLabel", Menu)
Header.Size = UDim2.new(1,0,0,48)
Header.BackgroundTransparency = 1
Header.Text = "❄ FORG SOFT ❄"
Header.Font = FONT
Header.TextScaled = true
Header.TextColor3 = Color3.fromRGB(20,20,20)

-- TABS
local Tabs = Instance.new("Frame", Menu)
Tabs.Size = UDim2.new(1,-20,0,36)
Tabs.Position = UDim2.new(0,10,0,52)
Tabs.BackgroundTransparency = 1

local function TabBtn(text,pos)
	local b = Instance.new("TextButton", Tabs)
	b.Size = UDim2.new(0.48,0,1,0)
	b.Position = UDim2.new(pos,0,0,0)
	b.Text = text
	b.Font = FONT
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(230,230,230)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

local TabPlayer = TabBtn("PLAYER",0)
local TabVisual = TabBtn("VISUALS",0.52)

-- PAGES
local PagePlayer = Instance.new("Frame", Menu)
PagePlayer.Size = UDim2.new(1,-20,1,-110)
PagePlayer.Position = UDim2.new(0,10,0,96)
PagePlayer.BackgroundTransparency = 1

local PageVisual = PagePlayer:Clone()
PageVisual.Parent = Menu
PageVisual.Visible = false

local function Switch(player)
	PagePlayer.Visible = player
	PageVisual.Visible = not player
end

TabPlayer.MouseButton1Click:Connect(function() Switch(true) end)
TabVisual.MouseButton1Click:Connect(function() Switch(false) end)

-- BUTTON FACTORY
local function MakeButton(parent,text,y)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,y,0)
	b.Text = text.." : OFF"
	b.Font = FONT
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	local s = Instance.new("UIStroke", b)
	s.Thickness = 2
	s.Color = Color3.fromRGB(255,80,80)
	return b,s
end

-- PLAYER BUTTONS
local JumpBtn,JumpStroke = MakeButton(PagePlayer,"Бесконечный прыжок",0)
local InvisBtn,InvisStroke = MakeButton(PagePlayer,"Невидимость",0.22)
local NoClipBtn,NoClipStroke = MakeButton(PagePlayer,"No Clip",0.44)

-- VISUAL BUTTONS
local ESPBtn,ESPStroke = MakeButton(PageVisual,"WallHack",0)

-- TOGGLE UI
local function Toggle(btn,stroke,state)
	btn.Text = btn.Text:split(":")[1]..": "..(state and "ON" or "OFF")
	stroke.Color = state and Color3.fromRGB(80,200,120) or Color3.fromRGB(255,80,80)
end

-- MENU OPEN
local opened = false
Icon.MouseButton1Click:Connect(function()
	opened = not opened
	Menu.Visible = true
	TweenService:Create(Menu,TweenInfo.new(0.4),{
		Position = opened and UDim2.new(0,90,0.5,-150) or UDim2.new(-0.6,0,0.5,-150)
	}):Play()
	task.delay(0.4,function()
		if not opened then Menu.Visible=false end
	end)
end)

--==================================================
-- FUNCTIONS
--==================================================

-- INFINITE JUMP
JumpBtn.MouseButton1Click:Connect(function()
	State.Jump = not State.Jump
	Toggle(JumpBtn,JumpStroke,State.Jump)
end)

UIS.JumpRequest:Connect(function()
	if State.Jump then
		local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- INVISIBLE
InvisBtn.MouseButton1Click:Connect(function()
	State.Invis = not State.Invis
	Toggle(InvisBtn,InvisStroke,State.Invis)
	for _,v in ipairs(Player.Character:GetDescendants()) do
		if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then
			v.Transparency = State.Invis and 1 or 0
		end
	end
end)

-- NO CLIP
NoClipBtn.MouseButton1Click:Connect(function()
	State.NoClip = not State.NoClip
	Toggle(NoClipBtn,NoClipStroke,State.NoClip)
end)

RunService.Stepped:Connect(function()
	if State.NoClip and Player.Character then
		for _,v in ipairs(Player.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end
end)

-- WALLHACK (ESP)
local function UpdateESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=Player and p.Character then
			local h = p.Character:FindFirstChild("FORG_ESP")
			if State.ESP then
				if not h then
					h = Instance.new("Highlight",p.Character)
					h.Name="FORG_ESP"
					h.FillColor=Color3.fromRGB(255,80,80)
					h.OutlineColor=Color3.new(1,1,1)
					h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
				end
			elseif h then h:Destroy() end
		end
	end
end

ESPBtn.MouseButton1Click:Connect(function()
	State.ESP = not State.ESP
	Toggle(ESPBtn,ESPStroke,State.ESP)
	UpdateESP()
end)
