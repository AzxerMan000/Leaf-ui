local Theme = require(script.Parent.Parent.Theme) local Util = require(script.Parent.Parent.Util)

return function(props) local dropdown = Instance.new("Frame") dropdown.Size = UDim2.new(1, 0, 0, 32) dropdown.BackgroundTransparency = 1 dropdown.Parent = props.Parent

local label = Util:CreateTextLabel({
    Text = props.Text or "Dropdown",
    Parent = dropdown
})

local list = Instance.new("Frame")
list.BackgroundTransparency = 0
list.BackgroundColor3 = Theme.BackgroundColor
list.Position = UDim2.new(0, 0, 1, 0)
list.Size = UDim2.new(1, 0, 0, 0)
list.ClipsDescendants = true
list.Visible = false
list.Parent = dropdown
Util:Roundify(list)

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 100, 0, 24)
toggle.Position = UDim2.new(1, -104, 0, 4)
toggle.Text = "Select"
toggle.BackgroundColor3 = Theme.AccentColor
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Theme.Font
toggle.TextSize = Theme.TextSize
toggle.Parent = dropdown
Util:Roundify(toggle)

toggle.MouseButton1Click:Connect(function()
    list.Visible = not list.Visible
    list.Size = list.Visible and UDim2.new(1, 0, 0, #props.Options * 28) or UDim2.new(1, 0, 0, 0)
end)

for _, option in ipairs(props.Options or {}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.Text = option
    btn.BackgroundColor3 = Theme.BackgroundColor
    btn.TextColor3 = Theme.TextColor
    btn.Font = Theme.Font
    btn.TextSize = Theme.TextSize
    btn.Parent = list

    btn.MouseButton1Click:Connect(function()
        toggle.Text = option
        list.Visible = false
        if props.Callback then props.Callback(option) end
    end)
end

return dropdown

end

-- LeafUI/Components/SearchBar.lua local Theme = require(script.Parent.Parent.Theme) local Util = require(script.Parent.Parent.Util)

return function(props) local textBox = Instance.new("TextBox") textBox.Size = UDim2.new(1, 0, 0, 28) textBox.PlaceholderText = props.Placeholder or "Search..." textBox.BackgroundColor3 = Theme.BackgroundColor textBox.TextColor3 = Theme.TextColor textBox.Text = "" textBox.Font = Theme.Font textBox.TextSize = Theme.TextSize textBox.Parent = props.Parent Util:Roundify(textBox)

textBox:GetPropertyChangedSignal("Text"):Connect(function()
    if props.Callback then
        props.Callback(textBox.Text)
    end
end)

return textBox
