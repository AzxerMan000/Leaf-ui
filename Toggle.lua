local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/Leaf-ui/main/Theme.lua"))()
local Util = LeafUI.Util = loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/Leaf-ui/main/Util.lua"))()

return function(props) local container = Instance.new("Frame") container.Size = UDim2.new(1, 0, 0, 32) container.BackgroundTransparency = 1 container.Parent = props.Parent

local label = Util:CreateTextLabel({
    Text = props.Text or "Toggle",
    Parent = container
})

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 32, 0, 24)
toggle.Position = UDim2.new(1, -36, 0, 4)
toggle.BackgroundColor3 = Theme.AccentColor
toggle.Text = "✓"
toggle.Font = Theme.Font
toggle.TextSize = Theme.TextSize
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Parent = container
Util:Roundify(toggle)

local state = props.Default or false
toggle.TextTransparency = state and 0 or 1

toggle.MouseButton1Click:Connect(function()
    state = not state
    toggle.TextTransparency = state and 0 or 1
    if props.Callback then props.Callback(state) end
end)

return toggle

end
