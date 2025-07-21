-- LeafUI.lua
local LeafUI = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

--==[ Theme ]==--
local Theme = {
	PrimaryColor = Color3.fromRGB(40, 120, 200),
	SecondaryColor = Color3.fromRGB(20, 20, 20),
	TextColor = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.Gotham,
	TextSize = 18,
	CornerRadius = UDim.new(0, 6),
	Transparency = 0.3
}

--==[ GUI Container ]==--
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

--==[ Utility ]==--
local function roundify(obj)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.CornerRadius
	corner.Parent = obj
end

local function applyTheme(obj)
	if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
		obj.TextColor3 = Theme.TextColor
		obj.Font = Theme.Font
		obj.TextSize = Theme.TextSize
	end
	obj.BackgroundTransparency = Theme.Transparency
end

local function applyDefaults(obj, props, defaults)
	for prop, value in pairs(defaults) do
		if props[prop] == nil then
			obj[prop] = value
		end
	end
	for prop, value in pairs(props) do
		obj[prop] = value
	end
end

local function makeDraggable(frame, dragArea)
	local dragging, dragStart, startPos

	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	dragArea.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			input.Changed:Connect(function()
				if dragging and input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--==[ Core UI ]==--
function LeafUI.Frame(props)
	local frame = Instance.new("Frame")
	applyDefaults(frame, props, {
		Size = UDim2.new(0, 200, 0, 100),
		Position = UDim2.new(0.5, -100, 0.5, -50),
		BackgroundColor3 = Theme.SecondaryColor,
		Parent = getGui()
	})
	frame.BackgroundTransparency = frame.BackgroundTransparency or Theme.Transparency
	roundify(frame)
	return frame
end

function LeafUI.Label(props)
	local label = Instance.new("TextLabel")
	applyDefaults(label, props, {
		Size = UDim2.new(1, -20, 0, 30),
		Position = UDim2.new(0, 10, 0, 10),
		BackgroundTransparency = 1,
		Parent = getGui()
	})
	applyTheme(label)
	return label
end

function LeafUI.Button(props, callback)
	local button = Instance.new("TextButton")
	applyDefaults(button, props, {
		Size = UDim2.new(0, 160, 0, 40),
		Position = UDim2.new(0.5, -80, 0, 60),
		BackgroundColor3 = Theme.PrimaryColor,
		Parent = getGui()
	})
	applyTheme(button)
	roundify(button)
	if callback then
		button.MouseButton1Click:Connect(callback)
	end
	return button
end

--==[ TitleBar Window Component ]==--
function LeafUI.TitleWindow(titleText)
	local gui = getGui()

	local window = LeafUI.Frame({
		Size = UDim2.new(0, 300, 0, 200),
		Position = UDim2.new(0.5, -150, 0.5, -100),
		BackgroundColor3 = Theme.SecondaryColor,
		Parent = gui
	})

	local titleBar = LeafUI.Frame({
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Theme.PrimaryColor,
		Parent = window
	})

	local title = LeafUI.Label({
		Text = titleText or "Leaf UI",
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -50, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		Parent = titleBar
	})

	local minimized = false
	local content = LeafUI.Frame({
		Size = UDim2.new(1, 0, 1, -30),
		Position = UDim2.new(0, 0, 0, 30),
		BackgroundColor3 = Theme.SecondaryColor,
		Parent = window
	})

	local toggleBtn = LeafUI.Button({
		Text = "-",
		Size = UDim2.new(0, 30, 1, 0),
		Position = UDim2.new(1, -35, 0, 0),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		Parent = titleBar
	}, function()
		minimized = not minimized
		local goalSize = minimized and UDim2.new(1, 0, 0, 0) or UDim2.new(1, 0, 1, -30)
		TweenService:Create(content, TweenInfo.new(0.3), { Size = goalSize }):Play()
	end)

	makeDraggable(window, titleBar)

	return window, content
end

return LeafUI
