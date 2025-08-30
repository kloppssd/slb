-- Advanced Notification System v2.2 (Fixed All Issues)
-- Usage: PeaNotificationadd(Title"selam Ahmet", Desc"selam herkese {user}", mod"success", dur"20")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Notification System Class
local NotificationSystem = {}
NotificationSystem.notifications = {}
NotificationSystem.maxNotifications = 4

-- Notification modes/themes
local NotificationModes = {
    success = {
        color = Color3.fromRGB(0, 255, 100),
        icon = "rbxassetid://11604833061",
        title = "✅ Success"
    },
    error = {
        color = Color3.fromRGB(255, 100, 100),
        icon = "rbxassetid://10002373478",
        title = "❌ Error"
    },
    warning = {
        color = Color3.fromRGB(255, 200, 0),
        icon = "rbxassetid://11780939099",
        title = "⚠️ Warning"
    },
    info = {
        color = Color3.fromRGB(0, 162, 255),
        icon = "rbxassetid://11780939099",
        title = "ℹ️ Info"
    },
    default = {
        color = Color3.fromRGB(120, 120, 120),
        icon = "rbxassetid://11780939099",
        title = "📢 Notification"
    }
}

-- Enhanced update positions function with staggered animation
function NotificationSystem:UpdatePositions()
    for i, notif in ipairs(self.notifications) do
        if notif.gui and notif.gui.Parent and notif.frame then
            local delay = (i - 1) * 0.05
            spawn(function()
                wait(delay)
                TweenService:Create(notif.frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -330, 1, -80 - ((i - 1) * 80))
                }):Play()
            end)
        end
    end
end

-- Enhanced notification creation function
function NotificationSystem:CreateNotification(title, text, icon, color, duration)
    duration = duration or 4
    color = color or Color3.fromRGB(0, 162, 255)
    icon = icon or "rbxassetid://11780939099"
    title = title or "Notification"
    text = text or "No description"
    
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "NotificationGUI_" .. tostring(tick())
    notifGui.Parent = game.CoreGui
    notifGui.DisplayOrder = 999999
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Parent = notifGui
    notification.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notification.Size = UDim2.new(0, 320, 0, 70)
    notification.Position = UDim2.new(1, 10, 1, -80 - (#self.notifications * 80))
    notification.ClipsDescendants = true
    notification.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Parent = notification
    
    -- Enhanced gradient with glow effect
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    }
    gradient.Rotation = 135
    gradient.Parent = notification
    
    -- Add shadow effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Parent = notification
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.Position = UDim2.new(0, 2, 0, 2)
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.ZIndex = -1
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    local iconFrame = Instance.new("Frame")
    iconFrame.Name = "IconFrame"
    iconFrame.Parent = notification
    iconFrame.BackgroundColor3 = color
    iconFrame.Position = UDim2.new(0, 12, 0, 12)
    iconFrame.Size = UDim2.new(0, 46, 0, 46)
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 23)
    iconCorner.Parent = iconFrame
    
    -- Add icon gradient
    local iconGradient = Instance.new("UIGradient")
    iconGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, Color3.new(
            math.min(1, color.R + 0.2),
            math.min(1, color.G + 0.2),
            math.min(1, color.B + 0.2)
        ))
    }
    iconGradient.Rotation = 45
    iconGradient.Parent = iconFrame
    
    local iconLabel = Instance.new("ImageLabel")
    iconLabel.Name = "Icon"
    iconLabel.Parent = iconFrame
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 8, 0, 8)
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.Image = icon
    iconLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.ScaleType = Enum.ScaleType.Fit
    
    local textFrame = Instance.new("Frame")
    textFrame.Name = "TextFrame"
    textFrame.Parent = notification
    textFrame.BackgroundTransparency = 1
    textFrame.Position = UDim2.new(0, 70, 0, 8)
    textFrame.Size = UDim2.new(1, -100, 1, -16)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = textFrame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Parent = textFrame
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 0, 0, 22)
    textLabel.Size = UDim2.new(1, 0, 1, -22)
    textLabel.Font = Enum.Font.Gotham
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    textLabel.TextSize = 12
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "Close"
    closeButton.Parent = notification
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.Position = UDim2.new(1, -30, 0, 8)
    closeButton.Size = UDim2.new(0, 22, 0, 22)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 11)
    closeCorner.Parent = closeButton
    
    -- Enhanced progress bar with animated gradient
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Parent = notification
    progressBar.BackgroundColor3 = color
    progressBar.Position = UDim2.new(0, 0, 1, -4)
    progressBar.Size = UDim2.new(1, 0, 0, 4)
    progressBar.BorderSizePixel = 0
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 2)
    progressCorner.Parent = progressBar
    
    local progressGradient = Instance.new("UIGradient")
    progressGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.5, Color3.new(
            math.min(1, color.R + 0.3),
            math.min(1, color.G + 0.3),
            math.min(1, color.B + 0.3)
        )),
        ColorSequenceKeypoint.new(1, color)
    }
    progressGradient.Parent = progressBar
    
    -- Add notification to list
    local notificationData = {
        gui = notifGui, 
        frame = notification, 
        startTime = tick()
    }
    table.insert(self.notifications, notificationData)
    
    -- Remove old notifications if too many
    if #self.notifications > self.maxNotifications then
        local oldNotif = table.remove(self.notifications, 1)
        if oldNotif.gui and oldNotif.gui.Parent then
            oldNotif.gui:Destroy()
        end
    end
    
    -- Update all notification positions
    self:UpdatePositions()
    
    -- Enhanced entry animation sequence
    notification.Position = UDim2.new(1, 50, 1, -80 - ((#self.notifications - 1) * 80))
    notification.Size = UDim2.new(0, 0, 0, 70)
    notification.BackgroundTransparency = 1
    stroke.Transparency = 1
    
    -- Phase 1: Slide and expand
    local slideIn = TweenService:Create(notification, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -330, 1, -80 - ((#self.notifications - 1) * 80)),
        Size = UDim2.new(0, 320, 0, 70),
        BackgroundTransparency = 0
    })
    
    local strokeIn = TweenService:Create(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    })
    
    slideIn:Play()
    strokeIn:Play()
    
    -- Phase 2: Icon burst animation
    iconFrame.Size = UDim2.new(0, 0, 0, 0)
    iconFrame.Position = UDim2.new(0, 35, 0, 35)
    
    spawn(function()
        wait(0.3)
        TweenService:Create(iconFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 46, 0, 46),
            Position = UDim2.new(0, 12, 0, 12)
        }):Play()
        
        -- Icon pulse effect
        spawn(function()
            wait(0.2)
            TweenService:Create(iconFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 52, 0, 52),
                Position = UDim2.new(0, 9, 0, 9)
            }):Play()
            wait(0.3)
            TweenService:Create(iconFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 46, 0, 46),
                Position = UDim2.new(0, 12, 0, 12)
            }):Play()
        end)
    end)
    
    -- Phase 3: Text fade-in
    titleLabel.TextTransparency = 1
    textLabel.TextTransparency = 1
    
    spawn(function()
        wait(0.4)
        TweenService:Create(titleLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()
        wait(0.1)
        TweenService:Create(textLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()
    end)
    
    -- Phase 4: Close button appear
    closeButton.BackgroundTransparency = 1
    closeButton.TextTransparency = 1
    closeButton.Size = UDim2.new(0, 0, 0, 0)
    
    spawn(function()
        wait(0.6)
        TweenService:Create(closeButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0,
            TextTransparency = 0,
            Size = UDim2.new(0, 22, 0, 22)
        }):Play()
    end)
    
    -- Enhanced progress bar animation with pulse
    spawn(function()
        wait(0.8)
        local progressTween = TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 0, 4)
        })
        
        progressTween:Play()
        
        -- Animated gradient rotation
        spawn(function()
            while progressTween.PlaybackState == Enum.PlaybackState.Playing do
                TweenService:Create(progressGradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Rotation = 360
                }):Play()
                wait(2)
                progressGradient.Rotation = 0
            end
        end)
    end)
    
    -- Enhanced close function
    local function closeNotification()
        -- Multi-phase exit animation
        local exitTween1 = TweenService:Create(notification, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 315, 0, 65)
        })
        
        local exitTween2 = TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 50, notification.Position.Y.Scale, notification.Position.Y.Offset),
            BackgroundTransparency = 1
        })
        
        exitTween1:Play()
        exitTween1.Completed:Connect(function()
            exitTween2:Play()
        end)
        
        TweenService:Create(stroke, TweenInfo.new(0.6), {Transparency = 1}):Play()
        TweenService:Create(iconFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(textLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        TweenService:Create(progressBar, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(shadow, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        
        -- Remove from list
        for i, notif in ipairs(self.notifications) do
            if notif.gui == notifGui then
                table.remove(self.notifications, i)
                break
            end
        end
        
        spawn(function()
            wait(0.6)
            if notifGui and notifGui.Parent then
                notifGui:Destroy()
            end
            self:UpdatePositions()
        end)
    end
    
    -- Close button events with enhanced animations
    closeButton.MouseButton1Click:Connect(closeNotification)
    
    -- Enhanced hover effects for close button
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(255, 120, 120),
            Size = UDim2.new(0, 26, 0, 26),
            Position = UDim2.new(1, -32, 0, 6)
        }):Play()
        
        TweenService:Create(closeButton, TweenInfo.new(0.1), {
            TextSize = 18
        }):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 80, 80),
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(1, -30, 0, 8)
        }):Play()
        
        TweenService:Create(closeButton, TweenInfo.new(0.1), {
            TextSize = 16
        }):Play()
    end)
    
    -- Auto close timer
    spawn(function()
        wait(duration)
        if notifGui and notifGui.Parent then
            closeNotification()
        end
    end)
    
    -- Enhanced hover effects for notification
    notification.MouseEnter:Connect(function()
        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 330, 0, 75),
            Position = UDim2.new(1, -335, notification.Position.Y.Scale, notification.Position.Y.Offset)
        }):Play()
        
        TweenService:Create(stroke, TweenInfo.new(0.3), {
            Thickness = 3
        }):Play()
        
        TweenService:Create(shadow, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.6,
            Position = UDim2.new(0, 4, 0, 4)
        }):Play()
        
        -- Glow effect
        TweenService:Create(iconFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(0, 10, 0, 10)
        }):Play()
    end)
    
    notification.MouseLeave:Connect(function()
        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 320, 0, 70),
            Position = UDim2.new(1, -330, notification.Position.Y.Scale, notification.Position.Y.Offset)
        }):Play()
        
        TweenService:Create(stroke, TweenInfo.new(0.3), {
            Thickness = 2
        }):Play()
        
        TweenService:Create(shadow, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.8,
            Position = UDim2.new(0, 2, 0, 2)
        }):Play()
        
        TweenService:Create(iconFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 46, 0, 46),
            Position = UDim2.new(0, 12, 0, 12)
        }):Play()
    end)
end

-- NEW: Simple argument parser for the new syntax
local function parseArguments(...)
    local args = {...}
    local params = {}
    
    for _, arg in ipairs(args) do
        if type(arg) == "string" then
            -- Find the parameter type and value
            local paramType = ""
            local value = ""
            
            -- Check for Title, Desc, mod, dur, time, icon, color patterns
            if arg:find("^Title") or arg:find("^title") then
                paramType = "title"
                value = arg:match('^[Tt]itle"(.+)"') or arg:match('^[Tt]itle(.+)')
            elseif arg:find("^Desc") or arg:find("^desc") then
                paramType = "desc"
                value = arg:match('^[Dd]esc"(.+)"') or arg:match('^[Dd]esc(.+)')
            elseif arg:find("^mod") or arg:find("^Mod") then
                paramType = "mod"
                value = arg:match('^[Mm]od"(.+)"') or arg:match('^[Mm]od(.+)')
            elseif arg:find("^dur") or arg:find("^Dur") then
                paramType = "dur"
                value = arg:match('^[Dd]ur"(.+)"') or arg:match('^[Dd]ur(.+)')
            elseif arg:find("^time") or arg:find("^Time") then
                paramType = "time"
                value = arg:match('^[Tt]ime"(.+)"') or arg:match('^[Tt]ime(.+)')
            elseif arg:find("^icon") or arg:find("^Icon") then
                paramType = "icon"
                value = arg:match('^[Ii]con"(.+)"') or arg:match('^[Ii]con(.+)')
            elseif arg:find("^color") or arg:find("^Color") then
                paramType = "color"
                value = arg:match('^[Cc]olor"(.+)"') or arg:match('^[Cc]olor(.+)')
            end
            
            if paramType ~= "" and value and value ~= "" then
                params[paramType] = value
            end
        end
    end
    
    return params
end

-- Main PeaNotificationadd function with new syntax support
function PeaNotificationadd(...)
    local args = {...}
    
    -- If no arguments, show default
    if #args == 0 then
        args = {Title"Test", Desc"No parameters provided", mod"error"}
    end
    
    local success, params = pcall(parseArguments, ...)
    if not success or not next(params) then
        params = {title = "Error", desc = "Failed to parse arguments", mod = "error"}
    end
    
    -- Get player name (Display Name preferred, fallback to Name)
    local playerName = "Unknown"
    if game.Players and game.Players.LocalPlayer then
        playerName = game.Players.LocalPlayer.DisplayName or game.Players.LocalPlayer.Name or "Unknown"
    end
    
    -- Get values from parameters
    local title = params.title or "Notification"
    local desc = params.desc or "No description provided"
    local mode = params.mod or "default"
    local duration = tonumber(params.dur or params.time) or 4
    local customIcon = params.icon
    local customColor = params.color
    
    -- Replace {user} placeholder with actual player name in both title and description
    title = title:gsub("{user}", playerName)
    desc = desc:gsub("{user}", playerName)
    
    -- Get mode settings
    local modeData = NotificationModes[mode:lower()]
    if not modeData then
        modeData = NotificationModes.default
    end
    
    -- Use custom title or mode default title
    local finalTitle = title
    local finalIcon = customIcon or modeData.icon
    local finalColor = modeData.color
    
    -- Handle custom color if provided
    if customColor then
        local r, g, b = customColor:match("(%d+),(%d+),(%d+)")
        if r and g and b then
            finalColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
        end
    end
    
    -- Create notification
    pcall(function()
        NotificationSystem:CreateNotification(finalTitle, desc, finalIcon, finalColor, duration)
    end)
end

-- Helper functions for the new syntax
function Title(text)
    return "Title" .. (text and ('"' .. tostring(text) .. '"') or '""')
end

function Desc(text)
    return "Desc" .. (text and ('"' .. tostring(text) .. '"') or '""')
end

function mod(text)
    return "mod" .. (text and ('"' .. tostring(text) .. '"') or '""')
end

function dur(text)
    return "dur" .. (text and ('"' .. tostring(text) .. '"') or '""')
end

function time(text)
    return "time" .. (text and ('"' .. tostring(text) .. '"') or '""')
end

function icon(text)
    return "icon" .. (text and ('"' .. tostring(text) .. '"') or '""')
end

function color(text)
    return "color" .. (text and ('"' .. tostring(text) .. '"') or '""')
end

-- Global functions for easier access
getgenv().PeaNotificationadd = PeaNotificationadd
getgenv().NotificationSystem = NotificationSystem
getgenv().Title = Title
getgenv().Desc = Desc
getgenv().mod = mod
getgenv().dur = dur
getgenv().time = time
getgenv().icon = icon
getgenv().color = color

-- Example usage with new syntax:
-- PeaNotificationadd(Title"Selam Ahmet", Desc"Bu mesaj 15 saniye kalacak {user}", mod"warning", dur"15")
-- PeaNotificationadd(Title"Hoşgeldin {user}", Desc"Merhaba {user}, oyuna hoşgeldin!", mod"success", time"8")
-- PeaNotificationadd(Title"Test Mesajı", Desc"Bu bir test mesajıdır", mod"info")

-- Script already running check
if _G.TOHScriptRunning then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "PEA HUB ERROR",
        Text = "The script is already running",
        Duration = 3
    })
    return
end
_G.TOHScriptRunning = true

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local player = game.Players.LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "PEA",
    Icon = "gitlab",
    Author = "Tower Of Hell",
    Folder = "1.0",
    Size = UDim2.fromOffset(210, 105),
    Transparent = true,
    IsOpenButtonEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false
    },
    SideBarWidth = 125,
})

task.spawn(function()
    local success, err = pcall(function()
        local registry = getreg and getreg() or debug.getregistry()
        for _, func in pairs(registry) do
            if type(func) == "function" then
                local info = debug.getinfo(func)
                if info and info.name == "kick" then
                    if hookfunction then
                        hookfunction(func, function() return nil end)
                        PeaNotificationadd(Title"BYPASS ENABLED!", Desc"pea hub - {user}", mod"success", dur"15")
                    else
                        error("hookfunction not supported.")
                    end
                    break
                end
            end
        end
    end)

    if not success then
        game.Players.LocalPlayer:Kick("Your executor does not support this script. Please try again with another executor")
    end
end)

Window:EditOpenButton({
    Title = "Open PeaHub",
    Icon = "mouse-pointer-click",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("000000"), 
        Color3.fromHex("87CEEB")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

Window:Tag({
    Title = "FREE",
    Color = Color3.fromHex("#FFFFFF")
})

local tohTab = Window:Tab({
    Title = "Main",
    Icon = "house",
    Locked = false,
})

local AutoWinSection = tohTab:Section({ 
    Title = "FINISH",
    Icon = "door-open",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

-- Auto Win Button
local autoWinBtn = tohTab:Button({
    Title = "Auto Win",
    Desc = "Teleport to finish",
    Locked = false,
    Callback = function()
        spawn(function()
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- Özel oyun kontrolü
            if game.PlaceId == 94971861814985 then
                -- Özel koordinatlar
                hrp.CFrame = CFrame.new(-103.6, 16091.5, -1.2)
            else
                -- Normal finish line arama
                local finish = nil
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("finish") or obj.Name:lower():find("win")) then
                        finish = obj
                        break
                    end
                end

                if finish then
                    hrp.CFrame = finish.CFrame + Vector3.new(0, 3, 0)
                else
                    warn("Finish line not found.")
                end
            end
        end)
    end
})



-- God Mode Toggle
local godModeEnabled = false
local healthConnection = nil
local godModeLoop = nil
local processedParts = {}

local function disableKillPart(part)
    if processedParts[part] then return end
    
    part.CanTouch = false
    processedParts[part] = true
    
    local touch = part:FindFirstChildWhichIsA("TouchTransmitter", true)
    if touch then 
        touch:Destroy() 
    end
    
    part.AncestryChanged:Connect(function()
        if not part.Parent then
            processedParts[part] = nil
        end
    end)
end

local function enableKillPart(part)
    if not processedParts[part] then return end
    
    part.CanTouch = true
    processedParts[part] = nil
end

local function scanForKillParts()
    if not godModeEnabled then return end
    
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and 
           (part.Name:lower():find("kill") or 
            part.Name:lower():find("lava") or 
            part.Name:lower():find("death") or
            part.Name:lower():find("void") or
            part.BrickColor == BrickColor.new("Really red")) then
            disableKillPart(part)
        end
    end
end

local function activateGodMode()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid.Health = humanoid.MaxHealth

    healthConnection = humanoid.HealthChanged:Connect(function()
        if godModeEnabled and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)

    scanForKillParts()
    
    godModeLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if godModeEnabled then
            if tick() % 1 < 0.016 then
                scanForKillParts()
            end
            
            local currentChar = player.Character
            if currentChar then
                local currentHumanoid = currentChar:FindFirstChildOfClass("Humanoid")
                if currentHumanoid and currentHumanoid.Health < currentHumanoid.MaxHealth then
                    currentHumanoid.Health = currentHumanoid.MaxHealth
                end
            end
        end
    end)

    workspace.DescendantAdded:Connect(function(descendant)
        if godModeEnabled and descendant:IsA("BasePart") then
            wait(0.1)
            if descendant.Name:lower():find("kill") or 
               descendant.Name:lower():find("lava") or 
               descendant.Name:lower():find("death") or
               descendant.Name:lower():find("void") or
               descendant.BrickColor == BrickColor.new("Really red") then
                disableKillPart(descendant)
            end
        end
    end)
end

local function deactivateGodMode()
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end
    
    if godModeLoop then
        godModeLoop:Disconnect()
        godModeLoop = nil
    end

    for part, _ in pairs(processedParts) do
        if part and part.Parent then
            enableKillPart(part)
        end
    end
    
    processedParts = {}
end

player.CharacterAdded:Connect(function()
    if godModeEnabled then
        wait(1)
        activateGodMode()
    end
end)

local Section = tohTab:Section({ 
    Title = "GOD MODE",
    Icon = "badge-plus",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local godToggle = tohTab:Toggle({
    Title = "God Mode",
    Desc = "immortality",
    Default = false,
    Callback = function(state) 
        godModeEnabled = state
        if godModeEnabled then
            activateGodMode()
        else
            deactivateGodMode()
        end
    end
})

-- Infinite Jump System Variables
local infiniteJumpEnabled = false
local jumpConnection = nil

local function enableInfiniteJump()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
        if infiniteJumpEnabled and humanoid:GetState() ~= Enum.HumanoidStateType.Seated then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function disableInfiniteJump()
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
end

player.CharacterAdded:Connect(function()
    if infiniteJumpEnabled then
        wait(1)
        enableInfiniteJump()
    end
end)

local Section = tohTab:Section({ 
    Title = "JUMP",
    Icon = "chevrons-up",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

-- Infinite Jump Toggle
local infiniteJumpToggle = tohTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump infinitely without limits",
    Default = false,
    Callback = function(state) 
        infiniteJumpEnabled = state
        if infiniteJumpEnabled then
            enableInfiniteJump()
        else
            disableInfiniteJump()
        end
    end
})

-- Fly System Variables
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local flyToggle = false
local flyGuiEnabled = false -- Track WindUI toggle state
local flySpeed = 50
local smoothness = 0.1
local FLYING = false
local flyKeyDown, flyKeyUp, mfly1, mfly2
local currentVelocity = Vector3.new(0, 0, 0)
local targetVelocity = Vector3.new(0, 0, 0)
local ScreenGui = nil

-- Fly Functions
local function sFLY()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local T = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local BG = Instance.new('BodyGyro', T)
    local BV = Instance.new('BodyVelocity', T)
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.P = 9e4
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BG.CFrame = T.CFrame
    BV.Velocity = Vector3.new(0, 0, 0)

    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    flyKeyDown = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local KEY = input.KeyCode.Name
            if KEY == "W" then CONTROL.F = flySpeed end
            if KEY == "S" then CONTROL.B = -flySpeed end
            if KEY == "A" then CONTROL.L = -flySpeed end
            if KEY == "D" then CONTROL.R = flySpeed end
            if KEY == "E" then CONTROL.Q = flySpeed * 2 end
            if KEY == "Q" then CONTROL.E = -flySpeed * 2 end
            workspace.CurrentCamera.CameraType = Enum.CameraType.Track
        end
    end)

    flyKeyUp = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local KEY = input.KeyCode.Name
            if KEY == "W" then CONTROL.F = 0 end
            if KEY == "S" then CONTROL.B = 0 end
            if KEY == "A" then CONTROL.L = 0 end
            if KEY == "D" then CONTROL.R = 0 end
            if KEY == "E" then CONTROL.Q = 0 end
            if KEY == "Q" then CONTROL.E = 0 end
        end
    end)

    mfly2 = RunService.Heartbeat:Connect(function()
        if not FLYING or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
            return 
        end
        
        humanoid.PlatformStand = true
        BG.CFrame = workspace.CurrentCamera.CoordinateFrame

        local direction = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) +
                           (workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p - workspace.CurrentCamera.CoordinateFrame.p))

        targetVelocity = direction * flySpeed
        currentVelocity = currentVelocity:Lerp(targetVelocity, smoothness)
        BV.Velocity = currentVelocity
    end)

    FLYING = true
end

local function MobileFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local root = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    local v3inf = Vector3.new(9e9, 9e9, 9e9)
    local controlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

    local BV = Instance.new("BodyVelocity", root)
    BV.MaxForce = v3inf
    BV.Velocity = Vector3.new(0, 0, 0)

    local BG = Instance.new("BodyGyro", root)
    BG.MaxTorque = v3inf
    BG.P = 1000
    BG.D = 50

    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    mfly1 = LocalPlayer.CharacterAdded:Connect(function(char)
        if char:FindFirstChild("HumanoidRootPart") then
            root = char:WaitForChild("HumanoidRootPart")
            BV.Parent = root
            BG.Parent = root
        end
    end)

    mfly2 = RunService.Heartbeat:Connect(function()
        if not FLYING or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
            return 
        end
        
        humanoid.PlatformStand = true
        BG.CFrame = camera.CoordinateFrame

        local direction = controlModule:GetMoveVector()
        local targetVel = Vector3.new(0, 0, 0)
        targetVel = targetVel + camera.CFrame.RightVector * (direction.X * flySpeed)
        targetVel = targetVel - camera.CFrame.LookVector * (direction.Z * flySpeed)

        targetVelocity = targetVel
        currentVelocity = currentVelocity:Lerp(targetVelocity, smoothness)
        BV.Velocity = currentVelocity
    end)

    FLYING = true
end

function NOFLY()
    FLYING = false
    currentVelocity = Vector3.new(0, 0, 0)
    targetVelocity = Vector3.new(0, 0, 0)
    
    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp then flyKeyUp:Disconnect() end
    if mfly1 then mfly1:Disconnect() end
    if mfly2 then mfly2:Disconnect() end

    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            local bv = root:FindFirstChild("BodyVelocity")
            local bg = root:FindFirstChild("BodyGyro")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end)
end

local function createFlyGUI()
    -- If ScreenGui already exists, don't recreate it
    if ScreenGui and ScreenGui.Parent then
        return
    end

    ScreenGui = Instance.new("ScreenGui")
    local FlyButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    ScreenGui.Name = "SmallSmoothFlyGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false -- Prevent GUI from resetting on character death

    FlyButton.Name = "FlyButton"
    FlyButton.Parent = ScreenGui
    FlyButton.BackgroundColor3 = flyToggle and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(40, 40, 40)
    FlyButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
    FlyButton.BorderSizePixel = 2
    FlyButton.Position = UDim2.new(0, 20, 0, 20)
    FlyButton.Size = UDim2.new(0, 120, 0, 30)
    FlyButton.Font = Enum.Font.GothamBold
    FlyButton.Text = flyToggle and "PEA FLY ON" or "PEA FLY OFF"
    FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlyButton.TextSize = 14
    FlyButton.Active = true
    FlyButton.Draggable = true

    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = FlyButton

    local function onCharacterAdded(character)
        -- Ensure GUI persists in PlayerGui after character reset
        if flyGuiEnabled and not ScreenGui.Parent then
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end

        -- Handle fly state on death
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            if flyToggle then
                NOFLY() -- Disable flying on death
                FlyButton.Text = "PEA FLY OFF"
                FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                flyToggle = false
            end
        end)
    end

    -- Handle existing character
    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end

    -- Handle character respawn
    LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

    -- Handle GUI click
    FlyButton.MouseButton1Click:Connect(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        flyToggle = not flyToggle
        if flyToggle then
            FlyButton.Text = "PEA FLY ON"
            FlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
            if UserInputService.TouchEnabled then
                MobileFly()
            else
                sFLY()
            end
        else
            FlyButton.Text = "PEA FLY OFF"
            FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            NOFLY()
        end
    end)
end

local Section = tohTab:Section({ 
    Title = "FLY MODE",
    Icon = "bird",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

-- Fly Toggle
local flyGuiToggle = tohTab:Toggle({
    Title = "Fly",
    Desc = "fly control GUI",
    Default = false,
    Callback = function(state) 
        flyGuiEnabled = state
        if state then
            createFlyGUI()
        else
            if flyToggle then
                flyToggle = false
                NOFLY()
            end
            if ScreenGui then
                ScreenGui:Destroy()
                ScreenGui = nil
            end
        end
    end
})