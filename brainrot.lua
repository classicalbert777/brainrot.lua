--[[
    Steal a Brainrot Script
    Features:
        - ESP System
        - Teleport System
        - Auto-Steal System
        - User-Friendly GUI
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local basePosition = Vector3.new(0, 0, 0) -- Set your base position here
local brainrots = {} -- Table to store brainrot instances
local espEnabled = true
local autoStealEnabled = true

-- Function to create ESP
local function createESP(brainrot)
    local esp = Instance.new("BillboardGui")
    esp.Adornee = brainrot
    esp.Size = UDim2.new(0, 100, 0, 50)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    esp.Parent = player.PlayerGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.8
    label.Text = brainrot.Name .. "\n" .. "Earnings: " .. brainrot.EarningsPerMinute .. " per minute"
    label.Parent = esp
end

-- Function to update ESP
local function updateESP()
    for _, brainrot in pairs(brainrots) do
        if espEnabled then
            createESP(brainrot)
        else
            -- Remove ESP if disabled
            for _, gui in pairs(player.PlayerGui:GetChildren()) do
                if gui.Adornee == brainrot then
                    gui:Destroy()
                end
            end
        end
    end
end

-- Function to teleport to base
local function teleportToBase()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {Position = basePosition}
    local tween = TweenService:Create(character.HumanoidRootPart, tweenInfo, goal)
    tween:Play()
end

-- Function to auto-steal brainrot
local function autoSteal(brainrot)
    if autoStealEnabled and (character.HumanoidRootPart.Position - brainrot.Position).Magnitude < 10 then
        -- Initiate stealing process
        -- Add your stealing logic here
        teleportToBase()
    end
end

-- Function to handle brainrot detection
local function detectBrainrots()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "Brainrot" and not table.find(brainrots, obj) then
            table.insert(brainrots, obj)
            updateESP()
        end
    end
end

-- Function to handle auto-steal
local function handleAutoSteal()
    for _, brainrot in pairs(brainrots) do
        autoSteal(brainrot)
    end
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 80, 0, 30)
espButton.Position = UDim2.new(0, 10, 0, 10)
espButton.Text = "Toggle ESP"
espButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
espButton.Parent = frame

local autoStealButton = Instance.new("TextButton")
autoStealButton.Size = UDim2.new(0, 80, 0, 30)
autoStealButton.Position = UDim2.new(0, 10, 0, 50)
autoStealButton.Text = "Toggle Auto-Steal"
autoStealButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
autoStealButton.Parent = frame

-- Button Functions
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateESP()
end)

autoStealButton.MouseButton1Click:Connect(function()
    autoStealEnabled = not autoStealEnabled
end)

-- Main Loop
RunService.Heartbeat:Connect(function()
    detectBrainrots()
    handleAutoSteal()
end)
