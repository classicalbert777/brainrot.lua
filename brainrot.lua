-- GOD MODE Steal a Brainrot Script

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- settings
local flyEnabled = false
local autoCash = true
local speed = 40

-- speed boost
char:WaitForChild("Humanoid").WalkSpeed = speed

-- detect brainrots
local brainrots = {}

function scanBrainrots()
    for _,v in pairs(workspace:GetDescendants()) do
        if string.find(string.lower(v.Name),"brain") then
            table.insert(brainrots,v)
        end
    end
end

-- ESP
function createESP(obj)
    if obj:FindFirstChild("ESP") then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "ESP"
    gui.Size = UDim2.new(0,100,0,40)
    gui.AlwaysOnTop = true
    gui.Parent = obj

    local label = Instance.new("TextLabel")
    label.Parent = gui
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = "BRAINROT"
    label.TextColor3 = Color3.new(1,0,0)
end

scanBrainrots()

for _,b in pairs(brainrots) do
    createESP(b)
end

-- FLY SYSTEM
local UIS = game:GetService("UserInputService")
local flying = false
local bv

function startFly()
    flying = true
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Parent = hrp

    while flying do
        bv.Velocity = hrp.CFrame.LookVector * 60
        task.wait()
    end
end

function stopFly()
    flying = false
    if bv then bv:Destroy() end
end

-- AUTO CASH
task.spawn(function()
    while autoCash do
        for _,v in pairs(workspace:GetDescendants()) do
            if string.find(string.lower(v.Name),"cash") then
                if v:IsA("BasePart") then
                    hrp.CFrame = v.CFrame
                    task.wait(.2)
                end
            end
        end
        task.wait(2)
    end
end)

-- GUI
local gui = Instance.new("ScreenGui",player.PlayerGui)

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,200,0,150)
frame.Position = UDim2.new(0,20,0,20)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local flyButton = Instance.new("TextButton",frame)
flyButton.Size = UDim2.new(0,180,0,40)
flyButton.Position = UDim2.new(0,10,0,10)
flyButton.Text = "Toggle Fly"

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        startFly()
    else
        stopFly()
    end
end)

local cashButton = Instance.new("TextButton",frame)
cashButton.Size = UDim2.new(0,180,0,40)
cashButton.Position = UDim2.new(0,10,0,60)
cashButton.Text = "Toggle Auto Cash"

cashButton.MouseButton1Click:Connect(function()
    autoCash = not autoCash
end)

local speedButton = Instance.new("TextButton",frame)
speedButton.Size = UDim2.new(0,180,0,40)
speedButton.Position = UDim2.new(0,10,0,110)
speedButton.Text = "Speed Boost"

speedButton.MouseButton1Click:Connect(function()
    char.Humanoid.WalkSpeed = 60
end)
