local Util = {}

function Util:Roundify(obj, radius) local corner = Instance.new("UICorner") corner.CornerRadius = radius or UDim.new(0, 8) corner.Parent = obj end

function Util:MakeDraggable(frame, dragArea) local UserInputService = game:GetService("UserInputService") local dragging, dragInput, dragStart, startPos

dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

dragArea.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

end

function Util:CreateTextLabel(props) local lbl = Instance.new("TextLabel") lbl.BackgroundTransparency = 1 lbl.TextColor3 = Theme.TextColor lbl.Font = Theme.Font lbl.TextSize = Theme.TextSize lbl.Text = props.Text or "" lbl.Size = props.Size or UDim2.new(1, 0, 0, 24) lbl.TextXAlignment = props.Align or Enum.TextXAlignment.Left lbl.Parent = props.Parent return lbl end

return Util

-- LeafUI/Components/TitleWindow.lua local Theme = require(script.Parent.Parent:WaitForChild("Theme")) local Util = require(script.Parent.Parent:WaitForChild("Util"))

return function(props) local screenGui = Instance.new("ScreenGui") screenGui.Name = "LeafUI" screenGui.ResetOnSpawn = false screenGui.IgnoreGuiInset = true screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Theme.BackgroundColor
frame.BackgroundTransparency = Theme.Transparency
frame.BorderSizePixel = 0
frame.Parent = screenGui
Util:Roundify(frame, Theme.CornerRadius)

local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundTransparency = 1
titleBar.Text = props.Title or "Leaf UI"
titleBar.Font = Theme.Font
titleBar.TextSize = Theme.TextSize
titleBar.TextColor3 = Theme.TextColor
titleBar.Parent = frame

Util:MakeDraggable(frame, titleBar)

local content = Instance.new("Frame")
content.Position = UDim2.new(0, 0, 0, 32)
content.Size = UDim2.new(1, 0, 1, -32)
content.BackgroundTransparency = 1
content.Name = "Content"
content.Parent = frame

return frame, content

end
