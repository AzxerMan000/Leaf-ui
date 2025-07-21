-- LeafUI/Components/KeySystem.lua

local Theme = require(script.Parent.Parent.Theme) local Util = require(script.Parent.Parent.Util)

return function(config) local key = config.Key or "abc123" local onSuccess = config.Callback or function() end local link = config.Link or "https://yourkeysite.com"

local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "LeafUI_KeyUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.5, -150, 0.5, -80)
frame.BackgroundColor3 = Theme.BackgroundColor
frame.BackgroundTransparency = 0.3
frame.Parent = gui
Util:Roundify(frame, UDim.new(0, 12))

local title = Util:CreateTextLabel({
    Text = "🔐 Enter Key to Continue",
    Parent = frame,
    Size = UDim2.new(1, -20, 0, 28),
    Align = Enum.TextXAlignment.Center
})
title.Position = UDim2.new(0, 10, 0, 10)

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -40, 0, 28)
input.Position = UDim2.new(0, 20, 0, 50)
input.PlaceholderText = "Enter Key..."
input.Text = ""
input.BackgroundColor3 = Theme.BackgroundColor
input.TextColor3 = Theme.TextColor
input.Font = Theme.Font
input.TextSize = Theme.TextSize
input.Parent = frame
Util:Roundify(input)

local function showError()
    input.Text = "Invalid Key!"
    input.TextColor3 = Color3.fromRGB(255, 0, 0)
    task.wait(1)
    input.Text = ""
    input.TextColor3 = Theme.TextColor
end

local submit = Instance.new("TextButton")
submit.Size = UDim2.new(0.5, -25, 0, 28)
submit.Position = UDim2.new(0, 20, 0, 90)
submit.Text = "Submit"
submit.BackgroundColor3 = Color3.new(0, 0, 0)
submit.TextColor3 = Color3.new(1, 1, 1)
submit.Font = Theme.Font
submit.TextSize = Theme.TextSize
submit.Parent = frame
Util:Roundify(submit)

local getKey = Instance.new("TextButton")
getKey.Size = UDim2.new(0.5, -25, 0, 28)
getKey.Position = UDim2.new(0.5, 5, 0, 90)
getKey.Text = "Get Key"
getKey.BackgroundColor3 = Color3.new(0, 0, 0)
getKey.TextColor3 = Color3.new(1, 1, 1)
getKey.Font = Theme.Font
getKey.TextSize = Theme.TextSize
getKey.Parent = frame
Util:Roundify(getKey)

submit.MouseButton1Click:Connect(function()
    if input.Text == key then
        gui:Destroy()
        onSuccess()
    else
        showError()
    end
end)

getKey.MouseButton1Click:Connect(function()
    setclipboard(link)
    getKey.Text = "Copied!"
    task.wait(1)
    getKey.Text = "Get Key"
end)

Util:MakeDraggable(frame, title)

end

