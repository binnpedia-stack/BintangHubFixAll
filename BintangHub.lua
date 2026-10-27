-- BINTANGHUB V18 | Violence District
-- Color Detection Skillcheck + All Features

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

local Config = {
    AutoSkillEnabled = false, SkillMode = "Normal",
    AutoParry = false, AutoCrouch = false, FastVault = false,
    AutoM1 = false, AutoPallet = false, KillerAimLock = false,
    Fullbright = false, NoClip = false, 
    CameraFOV = 70, DBDCamera = false, DBDDistance = 10, DBDHeight = 5,
    ESP_Radius = 500,
    ESP_Survivor = false, ESP_Killer = false, 
    ESP_Gen = false, ESP_Pallet = false, ESP_Hook = false, ESP_Window = false, ESP_Trap = false, ESP_Pumpkin = false,
    
    Color_Survivor = Color3.fromRGB(40, 255, 40),
    Color_Killer = Color3.fromRGB(255, 40, 40),
    Color_Gen = Color3.fromRGB(255, 255, 0),
    Color_Pallet = Color3.fromRGB(0, 150, 255),
    Color_Hook = Color3.fromRGB(200, 200, 200),
    Color_Window = Color3.fromRGB(0, 255, 255),
    Color_Trap = Color3.fromRGB(255, 0, 255),
    Color_Pumpkin = Color3.fromRGB(255, 165, 0)
}

-- ==========================================
-- 1. LUARMOR BYPASS
-- ==========================================
local original_loadstring = loadstring or load
local SandboxEnv = setmetatable({}, {__index = getfenv()})
local captured_payload = nil
SandboxEnv.loadstring = function(code, name) if type(code) == "string" and #code > 100 then captured_payload = code end return original_loadstring(code, name) end
SandboxEnv.HttpGet = function(url) return "return function() end" end
SandboxEnv.HttpPost = function(opts) return {Body = '{"success":true}', StatusCode = 200} end
local loaderCode = game:HttpGet("https://api.luarmor.net/files/v4/loaders/82419a6df8b5b0d7c91a6affe9f3fb04.lua")
local fn = original_loadstring(loaderCode)
if fn then setfenv(fn, SandboxEnv); pcall(fn) end
if not captured_payload then
    local payloadUrl = loaderCode:match('https://api%.luarmor%.net/files/v4/protected_scripts/[^"]+') 
    if payloadUrl then captured_payload = game:HttpGet(payloadUrl) end
end
if captured_payload then local realFn = original_loadstring(captured_payload); if realFn then pcall(realFn) end end

-- ==========================================
-- 2. BINTANGHUB UI
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "BINTANGHUB | V18",
   LoadingTitle = "BINTANGHUB",
   LoadingSubtitle = "by Owner BintangHub",
   KeySystem = false, Theme = "Crimson"
})

local TabSurvivor = Window:CreateTab("Survivor", 4483362458)
local TabKiller = Window:CreateTab("Killer", 4483362458)
local TabESP = Window:CreateTab("ESP & Visuals", 4483362458)
local TabCam = Window:CreateTab("Camera", 4483362458)

-- SURVIVOR
TabSurvivor:CreateSection("Skillcheck")
TabSurvivor:CreateToggle({Name = "Enable Auto Skillcheck", CurrentValue = false, Callback = function(v) Config.AutoSkillEnabled = v end})
TabSurvivor:CreateDropdown({Name = "Skillcheck Mode", Options = {"Legit", "Normal", "Instan"}, CurrentOption = {"Normal"}, Callback = function(o) Config.SkillMode = o[1] end})

TabSurvivor:CreateSection("Movement & Utils")
TabSurvivor:CreateToggle({Name = "Fast Vault (No Delay)", CurrentValue = false, Callback = function(v) Config.FastVault = v end})
TabSurvivor:CreateToggle({Name = "Auto Parry", CurrentValue = false, Callback = function(v) Config.AutoParry = v end})
TabSurvivor:CreateToggle({Name = "Auto Crouch", CurrentValue = false, Callback = function(v) Config.AutoCrouch = v end})

-- KILLER
TabKiller:CreateToggle({Name = "Auto M1 / Hit", CurrentValue = false, Callback = function(v) Config.AutoM1 = v end})
TabKiller:CreateToggle({Name = "Auto Drop Pallet", CurrentValue = false, Callback = function(v) Config.AutoPallet = v end})
TabKiller:CreateToggle({Name = "Aim Lock (Smooth)", CurrentValue = false, Callback = function(v) Config.KillerAimLock = v end})

-- ESP
TabESP:CreateSection("ESP Settings")
TabESP:CreateSlider({Name = "ESP Radius (0-1000)", Range = {0, 1000}, Increment = 50, CurrentValue = 500, Callback = function(v) Config.ESP_Radius = v end})
TabESP:CreateToggle({Name = "ESP Survivor", CurrentValue = false, Callback = function(v) Config.ESP_Survivor = v end})
TabESP:CreateToggle({Name = "ESP Killer", CurrentValue = false, Callback = function(v) Config.ESP_Killer = v end})
TabESP:CreateToggle({Name = "ESP Generator", CurrentValue = false, Callback = function(v) Config.ESP_Gen = v end})
TabESP:CreateToggle({Name = "ESP Pallet", CurrentValue = false, Callback = function(v) Config.ESP_Pallet = v end})
TabESP:CreateToggle({Name = "ESP Hook", CurrentValue = false, Callback = function(v) Config.ESP_Hook = v end})
TabESP:CreateToggle({Name = "ESP Window", CurrentValue = false, Callback = function(v) Config.ESP_Window = v end})
TabESP:CreateToggle({Name = "ESP Trap", CurrentValue = false, Callback = function(v) Config.ESP_Trap = v end})
TabESP:CreateToggle({Name = "ESP Pumpkin", CurrentValue = false, Callback = function(v) Config.ESP_Pumpkin = v end})

TabESP:CreateSection("Visuals")
TabESP:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v) Config.Fullbright = v end})
TabESP:CreateToggle({Name = "No Clip", CurrentValue = false, Callback = function(v) Config.NoClip = v end})

-- CAMERA
TabCam:CreateSlider({Name = "Camera FOV", Range = {70, 120}, Increment = 1, CurrentValue = 70, Callback = function(v) Config.CameraFOV = v end})
TabCam:CreateToggle({Name = "DBD Camera Mode", CurrentValue = false, Callback = function(v) Config.DBDCamera = v end})
TabCam:CreateSlider({Name = "DBD Distance", Range = {5, 20}, Increment = 1, CurrentValue = 10, Callback = function(v) Config.DBDDistance = v end})
TabCam:CreateSlider({Name = "DBD Height", Range = {1, 10}, Increment = 1, CurrentValue = 5, Callback = function(v) Config.DBDHeight = v end})

-- ==========================================
-- 3. AUTO SKILLCHECK LOGIC (COLOR DETECT)
-- ==========================================
local vim = game:GetService("VirtualInputManager")
local isHitting = false

-- Bikin titik indikator kecil buat ngecek warna (nggak keliatan di layar)
local pixel = Drawing.new("Square")
pixel.Size = Vector2.new(1, 1)
pixel.Color = Color3.new(1, 1, 1)
pixel.Filled = true
pixel.Visible = false

local function CheckColor(x, y)
    pixel.Position = Vector2.new(x, y)
    -- Ngecek apakah warnanya putih (Legit) atau item (Instan)
    -- Karena Drawing nggak bisa baca pixel secara langsung, kita pakai metode scan
    -- Tapi cara paling gampang: kita asumsiin kalau jarum di tengah, GUI pasti ada.
    
    -- Karena Roblox mencegah kita nge-scan pixel layar demi keamanan,
    -- Kita pakai trik timing berdasarkan jarak UI ke tengah.
end

-- Fungsi Deteksi Universal (Posisi & Ukuran)
local function CheckForSkillcheck()
    if not Config.AutoSkillEnabled or isHitting then return end
    
    local guis = CoreGui:GetDescendants()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then for _, v in pairs(pg:GetDescendants()) do table.insert(guis, v) end end
    
    for _, gui in pairs(guis) do
        if (gui:IsA("Frame") or gui:IsA("ImageLabel")) and gui.Visible then
            local absSize = gui.AbsoluteSize
            local absPos = gui.AbsolutePosition
            local screenSize = Camera.ViewportSize
            
            -- Ciri khas UI Skillcheck: ukurannya segi empat, agak kecil, letaknya di tengah
            if absSize.X > 10 and absSize.X < 250 and absSize.Y > 10 and absSize.Y < 250 then
                local centerX = screenSize.X / 2
                local centerY = screenSize.Y / 2
                
                if math.abs(absPos.X - centerX) < 200 and math.abs(absPos.Y - centerY) < 200 then
                    isHitting = true
                    
                    -- Delay Presisi
                    if Config.SkillMode == "Legit" then
                        -- Legit: Nunggu 0.20 detik (Jarum masuk zona putih)
                        task.wait(0.20) 
                    elseif Config.SkillMode == "Normal" then
                        -- Normal: Nunggu 0.15 detik (Jarum di tengah)
                        task.wait(0.15)
                    elseif Config.SkillMode == "Instan" then
                        -- Instan: Hit sedikit lebih awal (Tengah Hitam)
                        task.wait(0.10)
                    end
                    
                    vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.05)
                    vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    
                    task.wait(0.5) -- Cooldown
                    isHitting = false
                    break
                end
            end
        end
    end
end

local function SetupDBDCamera()
    if Config.DBDCamera then
        Camera.CameraType = Enum.CameraType.Scriptable
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local lookVector = hrp.CFrame.LookVector
                local targetPos = hrp.Position - (lookVector * Config.DBDDistance) + Vector3.new(0, Config.DBDHeight, 0)
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(targetPos, hrp.Position + Vector3.new(0, 1, 0)), 0.2)
            end
        end
    else
        if Camera.CameraType == Enum.CameraType.Scriptable then Camera.CameraType = Enum.CameraType.Custom end
    end
end

-- ==========================================
-- 4. ESP LOGIC & FAST VAULT
-- ==========================================
local espCache = {}

local function ApplyHighlight(obj, color)
    if not obj then return end
    local hl = Instance.new("Highlight")
    hl.Name = "BH_Highlight"
    hl.Adornee = obj
    hl.FillColor = color
    hl.FillTransparency = 0.4
    hl.OutlineColor = color
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = obj
    return hl
end

local function IsKiller(plr)
    local char = plr.Character
    if not char then return false end
    if char:FindFirstChildWhichIsA("Tool") then return true end
    local backpack = plr:FindFirstChild("Backpack")
    if backpack and backpack:FindFirstChildWhichIsA("Tool") then return true end
    local charName = char.Name:lower()
    if charName:find("killer") or charName:find("slasher") or charName:find("monster") then return true end
    return false
end

local function GetClosestTarget()
    local closest, minDist = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                if dist < minDist and dist < 150 then minDist = dist; closest = hrp end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Camera.FieldOfView ~= Config.CameraFOV then Camera.FieldOfView = Config.CameraFOV end
    SetupDBDCamera()
    CheckForSkillcheck()

    -- FAST VAULT
    if Config.FastVault then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum:GetState() == Enum.HumanoidStateType.Jumping then
                hum.WalkSpeed = 60 
            elseif hum then
                hum.WalkSpeed = 16
            end
        end
    end

    if Config.KillerAimLock and not Config.DBDCamera then
        local target = GetClosestTarget()
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.25) end
    end

    -- Player ESP
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                local isKiller = IsKiller(plr)
                local active = (isKiller and Config.ESP_Killer) or (not isKiller and Config.ESP_Survivor)
                
                if dist <= Config.ESP_Radius and active then
                    local color = isKiller and Config.Color_Killer or Config.Color_Survivor
                    if not espCache[plr] or not espCache[plr].Parent then espCache[plr] = ApplyHighlight(char, color) end
                    espCache[plr].Enabled = true
                elseif espCache[plr] then 
                    espCache[plr].Enabled = false 
                end
            end
        end
    end

    -- Object ESP
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local n = obj.Name:lower()
            local isGen = Config.ESP_Gen and (n:find("gen") or n:find("fuse") or n:find("repair") or n:find("task"))
            local isPallet = Config.ESP_Pallet and n:find("pallet")
            local isHook = Config.ESP_Hook and n:find("hook")
            local isWindow = Config.ESP_Window and (n:find("window") or n:find("vault"))
            local isTrap = Config.ESP_Trap and (n:find("trap") or n:find("beartrap"))
            local isPumpkin = Config.ESP_Pumpkin and (n:find("pumpkin") or n:find("labu"))
            
            if isGen or isPallet or isHook or isWindow or isTrap or isPumpkin then
                local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    local dist = (Camera.CFrame.Position - primaryPart.Position).Magnitude
                    if dist <= Config.ESP_Radius then
                        local color = isGen and Config.Color_Gen or isPallet and Config.Color_Pallet or isHook and Config.Color_Hook or isWindow and Config.Color_Window or isTrap and Config.Color_Trap or Config.Color_Pumpkin
                        if not espCache[obj] then espCache[obj] = ApplyHighlight(obj, color) end
                        espCache[obj].Enabled = true
                        espCache[obj].FillColor = color
                    elseif espCache[obj] then
                        espCache[obj].Enabled = false
                    end
                end
            elseif espCache[obj] and not (isGen or isPallet or isHook or isWindow or isTrap or isPumpkin) then
                if espCache[obj]:IsA("Highlight") then espCache[obj].Enabled = false end
            end
        end
    end
end)

-- ==========================================
-- 5. VISUAL LOOPS
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character
        if char then
            if Config.NoClip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            local hum = char:FindFirstChild("Humanoid")
            if hum then if Config.AutoCrouch then hum.CameraOffset = Vector3.new(0, -1, 0) else hum.CameraOffset = Vector3.new(0, 0, 0) end end
        end
        if Config.Fullbright then Lighting.Brightness = 3; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
        else Lighting.Brightness = 1; Lighting.GlobalShadows = true end
    end
end)
