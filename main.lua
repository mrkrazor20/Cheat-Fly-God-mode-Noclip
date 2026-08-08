-- Krazor V-Powers: Mod Menu (Fly, GodMode, Noclip + Speed Control)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- Видаляємо старе меню, якщо воно вже було
if PlayerGui:FindFirstChild("KrazorModMenu") then
    PlayerGui.KrazorModMenu:Destroy()
end

-- Створення головного GUI (збільшили висоту для кнопок швидкості)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KrazorModMenu"
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 310)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Text = "KRAZOR MOD MENU"
Title.Parent = MainFrame

-- Функція створення кнопок функцій
local function createButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name .. ": OFF"
    btn.Parent = MainFrame
    return btn
end

local FlyBtn = createButton("Fly (E)", 50)
local GodBtn = createButton("God Mode", 95)
local NoclipBtn = createButton("Noclip", 140)

-- Написи та кнопки для швидкості польоту
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0.05, 0, 0, 185)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 14
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.Text = "Fly Speed: 50"
SpeedLabel.Parent = MainFrame

local flySpeed = 50

local function createSpeedButton(text, posX, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.42, 0, 0, 35)
    btn.Position = UDim2.new(posX, 0, 0, 215)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(func)
    return btn
end

createSpeedButton("- Speed", 0.05, function()
    flySpeed = math.clamp(flySpeed - 25, 25, 300)
    SpeedLabel.Text = "Fly Speed: " .. flySpeed
end)

createSpeedButton("+ Speed", 0.53, function()
    flySpeed = math.clamp(flySpeed + 25, 25, 300)
    SpeedLabel.Text = "Fly Speed: " .. flySpeed
end)

-- Змінні станів
local flyActive = false
local godActive = false
local noclipActive = false

-- Фізика польоту
local bodyVel = Instance.new("BodyVelocity")
bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

FlyBtn.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    FlyBtn.Text = "Fly (E): " .. (flyActive and "ON" or "OFF")
    FlyBtn.BackgroundColor3 = flyActive and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E then
        flyActive = not flyActive
        FlyBtn.Text = "Fly (E): " .. (flyActive and "ON" or "OFF")
        FlyBtn.BackgroundColor3 = flyActive and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
    end
end)

GodBtn.MouseButton1Click:Connect(function()
    godActive = not godActive
    GodBtn.Text = "God Mode: " .. (godActive and "ON" or "OFF")
    GodBtn.BackgroundColor3 = godActive and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
end)

NoclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    NoclipBtn.Text = "Noclip: " .. (noclipActive and "ON" or "OFF")
    NoclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
end)

-- Головний цикл
RunService.Stepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")

    -- Політ з урахуванням вибраної швидкості
    if flyActive and hrp then
        bodyVel.Parent = hrp
        bodyVel.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
    else
        bodyVel.Parent = nil
    end

    -- God Mode
    if godActive and hum then
        hum.Health = hum.MaxHealth
    end

    -- Noclip
    if noclipActive then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
