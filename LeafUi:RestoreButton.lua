local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/Leaf-ui/main/Theme.lua"))()
local Util = loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/Leaf-ui/main/Util.lua"))()
return function(props) local toggleBtn = Instance.new("TextButton") toggleBtn.Size = UDim2.new(0, 120, 0, 28) toggleBtn.Position = UDim2.new(0, 10, 0, 10) toggleBtn.BackgroundColor3 = Color3.new(0, 0, 0) toggleBtn.Text = "Restore UI" toggleBtn.TextColor3 = Color3.new(1, 1, 1) toggleBtn.Font = Theme.Font toggleBtn.TextSize = Theme.TextSize toggleBtn.Visible = false Util:Roundify(toggleBtn) toggleBtn.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local target = props.Target
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 28)
button.Position = UDim2.new(1, -130, 0, 10)
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.Text = "Minimize UI"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Theme.Font
button.TextSize = Theme.TextSize
button.Parent = target
Util:Roundify(button)

button.MouseButton1Click:Connect(function()
    target.Visible = false
    toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
    target.Visible = true
    toggleBtn.Visible = false
end)

return toggleBtn

end

