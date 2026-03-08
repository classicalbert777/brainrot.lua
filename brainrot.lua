--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")

--// PLAYER
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

--// SETTINGS
local BrainrotESP = true
local PlayerESP = false
local AutoSteal = false
local AutoFarm = false
local Fly = false
local Speed = false
local InfiniteJump = false

local brainrots = {}

--// GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.Name = "GodBrainrotHub"

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,250,0,320)
frame.Position = UDim2.new(0,20,0,20)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local function makeButton(text,y)

	local b = Instance.new("TextButton")
	b.Parent = frame
	b.Size = UDim2.new(0,230,0,30)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)

	return b

end

local espBtn = makeButton("Brainrot ESP",10)
local pEspBtn = makeButton("Player ESP",45)
local stealBtn = makeButton("Auto Steal",80)
local farmBtn = makeButton("Auto Farm",115)
local tpBtn = makeButton("Teleport Closest Brainrot",150)
local flyBtn = makeButton("Fly Mode",185)
local speedBtn = makeButton("Speed Boost",220)
local jumpBtn = makeButton("Infinite Jump",255)
local hopBtn = makeButton("Server Hop",290)

--// ESP FUNCTION
local function createESP(obj,text)

	if obj:FindFirstChild("ESP") then return end

	local bill = Instance.new("BillboardGui")
	bill.Name = "ESP"
	bill.Size = UDim2.new(0,120,0,40)
	bill.StudsOffset = Vector3.new(0,3,0)
	bill.AlwaysOnTop = true
	bill.Adornee = obj
	bill.Parent = obj

	local label = Instance.new("TextLabel")
	label.Parent = bill
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1,1,1)

end

--// SCAN BRAINROTS
local function scan()

	for _,v in pairs(workspace:GetDescendants()) do

		if v.Name == "Brainrot" and v:IsA("BasePart") then

			if not table.find(brainrots,v) then
				table.insert(brainrots,v)

				if BrainrotESP then
					createESP(v,"Brainrot")
				end

			end

		end

	end

end

--// PLAYER ESP
local function updatePlayerESP()

	if not PlayerESP then return end

	for _,p in pairs(Players:GetPlayers()) do

		if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
			createESP(p.Character.Head,p.Name)
		end

	end

end

--// CLOSEST BRAINROT
local function closestBrainrot()

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local closest
	local dist = math.huge

	for _,v in pairs(brainrots) do

		local d = (hrp.Position - v.Position).Magnitude

		if d < dist then
			dist = d
			closest = v
		end

	end

	return closest

end

--// TELEPORT
local function teleportToBrainrot()

	local br = closestBrainrot()
	local hrp = character:FindFirstChild("HumanoidRootPart")

	if br and hrp then
		hrp.CFrame = br.CFrame + Vector3.new(0,3,0)
	end

end

--// AUTO STEAL
local function autoStealFunc()

	if not AutoSteal then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	for _,v in pairs(brainrots) do

		if (hrp.Position - v.Position).Magnitude < 15 then
			hrp.CFrame = v.CFrame + Vector3.new(0,3,0)
		end

	end

end

--// AUTO FARM
local function autoFarmFunc()

	if not AutoFarm then return end

	local br = closestBrainrot()
	local hrp = character:FindFirstChild("HumanoidRootPart")

	if br and hrp then
		hrp.CFrame = br.CFrame + Vector3.new(0,3,0)
	end

end

--// FLY
local body

local function startFly()

	local hrp = character:FindFirstChild("HumanoidRootPart")

	body = Instance.new("BodyVelocity")
	body.MaxForce = Vector3.new(9e9,9e9,9e9)
	body.Parent = hrp

end

local function stopFly()

	if body then
		body:Destroy()
	end

end

UIS.InputBegan:Connect(function(input)

	if InfiniteJump and input.KeyCode == Enum.KeyCode.Space then
		character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end

end)

--// SPEED
RunService.RenderStepped:Connect(function()

	character = player.Character or player.CharacterAdded:Wait()

	if Speed and character:FindFirstChild("Humanoid") then
		character.Humanoid.WalkSpeed = 50
	else
		if character:FindFirstChild("Humanoid") then
			character.Humanoid.WalkSpeed = 16
		end
	end

end)

--// BUTTONS
espBtn.MouseButton1Click:Connect(function()
	BrainrotESP = not BrainrotESP
end)

pEspBtn.MouseButton1Click:Connect(function()
	PlayerESP = not PlayerESP
end)

stealBtn.MouseButton1Click:Connect(function()
	AutoSteal = not AutoSteal
end)

farmBtn.MouseButton1Click:Connect(function()
	AutoFarm = not AutoFarm
end)

tpBtn.MouseButton1Click:Connect(function()
	teleportToBrainrot()
end)

flyBtn.MouseButton1Click:Connect(function()

	Fly = not Fly

	if Fly then
		startFly()
	else
		stopFly()
	end

end)

speedBtn.MouseButton1Click:Connect(function()
	Speed = not Speed
end)

jumpBtn.MouseButton1Click:Connect(function()
	InfiniteJump = not InfiniteJump
end)

hopBtn.MouseButton1Click:Connect(function()
	TeleportService:Teleport(game.PlaceId)
end)

--// MAIN LOOP
RunService.RenderStepped:Connect(function()

	scan()
	updatePlayerESP()
	autoStealFunc()
	autoFarmFunc()

end)
