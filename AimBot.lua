--// KING LEGACY - SILENT AIM XENO (By YourName)
local Radius = 120
local SkillKeys = {"Z", "X", "C", "V", "B", "F", "Q", "E", "R", "T"}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- FOV Circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(0, 255, 100)
circle.Thickness = 2
circle.Filled = false
circle.Transparency = 1
circle.Visible = true
circle.Radius = Radius

RunService.RenderStepped:Connect(function()
    circle.Position = Vector2.new(Mouse.X, Mouse.Y)
end)

local function getClosestPlayer()
    local closest = nil
    local minDist = Radius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude

            if onScreen and dist < minDist and player.Character:FindFirstChild("Humanoid").Health > 0 then
                closest = player
                minDist = dist
            end
        end
    end

    return closest
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    for _, key in pairs(SkillKeys) do
        if input.KeyCode == Enum.KeyCode[key] then
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(
                    LocalPlayer.Character.HumanoidRootPart.Position,
                    target.Character.HumanoidRootPart.Position
                ))
            end
        end
    end
end)