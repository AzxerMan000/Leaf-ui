local Theme = require(script.Parent.Parent.Theme) local Util = require(script.Parent.Parent.Util)

return function(props) local frame = Instance.new("Frame") frame.Size = UDim2.new(1, 0, 0, 32) frame.BackgroundTransparency = 1 frame.Parent = props.Parent

local label = Util:CreateTextLabel({
    Text = props.Text or "Slider",
    Parent = frame
})

local slider = Instance.new("TextButton")
slider.Size = UDim2.new(0, 200, 0, 10)
slider.Position = UDim2.new(0, 0, 1, -14)
slider.BackgroundColor3 = Theme.AccentColor
slider.Text = ""
slider.AutoButtonColor = false
slider.Parent = frame
Util:Roundify(slider)

local value = Instance.new("Frame")
value.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
value.Size = UDim2.new(0.5, 0, 1, 0)
value.Parent = slider
Util:Roundify(value)

slider.MouseButton1Down:Connect(function()
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        local mouseX = game:GetService("UserInputService"):GetMouseLocation().X
        local rel = math.clamp((mouseX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value.Size = UDim2.new(rel, 0, 1, 0)
        if props.Callback then props.Callback(rel) end
    end)
    local inputConn
    inputConn = game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            conn:Disconnect()
            inputConn:Disconnect()
        end
    end)
end)

return slider
