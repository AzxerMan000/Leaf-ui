
local LeafUI = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--==[ Theme ]==--
local Theme = {
	PrimaryColor = Color3.fromRGB(30, 30, 30),
	AccentColor = Color3.fromRGB(60, 180, 255),
	TextColor = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.Legacy,
	TextSize = 18,
	Transparency = 0.3,
	CornerRadius = UDim.new(0, 6)
}

--==[ GUI Setup ]==--
local function getGui()
	local gui = player:WaitForChild("PlayerGui"):FindFirstChild("LeafUI")
	if not gui then
		gui = Instance.new("ScreenGui")
		gui.Name = "LeafUI"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.Parent = player:WaitForChild("PlayerGui")
	end
	return gui
end

--==[ Style Helper ]==--
local function style(obj)
	obj.BackgroundTransparency = Theme.Transparency
	if obj:IsA("TextLabel") or obj:IsA("TextButton") then
		obj.TextColor3 = Theme.TextColor
		obj.Font = Theme.Font
		obj.TextSize = Theme.TextSize
	end
	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.CornerRadius
	corner.Parent = obj
end

--==[ Draggable Support (Mobile + PC) ]==--
local function makeDraggable(frame, dragArea)
	local dragging = false
	local dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)

	dragArea.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

--==[ Core Components ]==--

function LeafUI:Label(props)
	local label = Instance.new("TextLabel")
	label.Text = props.Text or "Label"
	label.Size = props.Size or UDim2.new(1, -20, 0, 25)
	label.Position = props.Position or UDim2.new(0, 10, 0, 10)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = props.Parent or getGui()
	style(label)
	return label
end

function LeafUI:Button(props, callback)
	local btn = Instance.new("TextButton")
	btn.Text = props.Text or "Button"
	btn.Size = props.Size or UDim2.new(0, 120, 0, 30)
	btn.Position = props.Position or UDim2.new(0.5, -60, 0, 50)
	btn.BackgroundColor3 = props.BackgroundColor3 or Theme.AccentColor
	btn.Parent = props.Parent or getGui()
	style(btn)
	if callback then btn.MouseButton1Click:Connect(callback) end
	return btn
end

function LeafUI:TitleWindow(titleText)
	local gui = getGui()

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 200)
	frame.Position = UDim2.new(0.5, -150, 0.5, -100)
	frame.BackgroundColor3 = Theme.PrimaryColor
	frame.Parent = gui
	style(frame)

	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 30)
	titleBar.BackgroundColor3 = Theme.AccentColor
	titleBar.Parent = frame
	style(titleBar)

	local title = self:Label({
		Text = titleText or "Leaf UI",
		Parent = titleBar,
		Size = UDim2.new(1, -40, 1, 0),
		Position = UDim2.new(0, 10, 0, 0)
	})

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, -30)
	content.Position = UDim2.new(0, 0, 0, 30)
	content.BackgroundColor3 = Theme.PrimaryColor
	content.Parent = frame
	style(content)

	local minimize = self:Button({
		Text = "-",
		Size = UDim2.new(0, 30, 1, 0),
		Position = UDim2.new(1, -35, 0, 0),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		Parent = titleBar
	}, function()
		local minimized = content.Size.Y.Offset == 0
		local targetSize = minimized and UDim2.new(1, 0, 1, -30) or UDim2.new(1, 0, 0, 0)
		TweenService:Create(content, TweenInfo.new(0.3), { Size = targetSize }):Play()
	end)

	makeDraggable(frame, titleBar)

	return frame, content
end

return LeafUI
