-- Unnamed Library Hub UI

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local UI = {}

-- Config
local enableKeySystem = false
local correctKey = "OpenSesame"
local unlockFlagName = "UnnamedLibraryUnlocked"

-- Theme colors
local Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    TopBar = Color3.fromRGB(50, 50, 50),
    Section = Color3.fromRGB(40, 40, 40),
    Button = Color3.fromRGB(0, 150, 255),
    Text = Color3.new(1, 1, 1)
}

local function roundify(frame)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
end

local UserInputService = game:GetService("UserInputService")

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function promptKeyInput(onSuccess)
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeyPrompt"
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Theme.Background
    roundify(frame)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Position = UDim2.new(0, 0, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = "Enter Access Key:"
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14

    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.8, 0, 0, 30)
    textBox.Position = UDim2.new(0.1, 0, 0, 50)
    textBox.PlaceholderText = "Key here..."
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.TextColor3 = Theme.Text
    textBox.BackgroundColor3 = Theme.Section
    roundify(textBox)

    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.5, 0, 0, 30)
    submitButton.Position = UDim2.new(0.25, 0, 0, 95)
    submitButton.Text = "Submit"
    submitButton.Font = Enum.Font.Gotham
    submitButton.TextSize = 14
    submitButton.TextColor3 = Theme.Text
    submitButton.BackgroundColor3 = Theme.Button
    roundify(submitButton)

    submitButton.MouseButton1Click:Connect(function()
        if textBox.Text == correctKey then
            if not PlayerGui:FindFirstChild(unlockFlagName) then
                local unlocked = Instance.new("BoolValue")
                unlocked.Name = unlockFlagName
                unlocked.Value = true
                unlocked.Parent = PlayerGui
            end
            screenGui:Destroy()
            onSuccess()
        else
            textBox.Text = ""
            textBox.PlaceholderText = "Wrong key, try again!"
        end
    end)
end

local function createUI(title)
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "UnnamedLibraryHub"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 600, 0, 400)
    main.Position = UDim2.new(0.5, -300, 0.5, -200)
    main.BackgroundColor3 = Theme.Background
    roundify(main)
    makeDraggable(main)

    local topBar = Instance.new("Frame", main)
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Theme.TopBar
    roundify(topBar)

    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(1, -70, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local closeButton = Instance.new("TextButton", topBar)
    closeButton.Size = UDim2.new(0, 30, 1, 0)
    closeButton.Position = UDim2.new(1, -35, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    roundify(closeButton)
    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local minimizeButton = Instance.new("TextButton", topBar)
    minimizeButton.Size = UDim2.new(0, 30, 1, 0)
    minimizeButton.Position = UDim2.new(1, -70, 0, 0)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
    minimizeButton.Text = "-"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 22
    minimizeButton.TextColor3 = Color3.new(0, 0, 0)
    roundify(minimizeButton)

    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(0, 120, 1, -30)
    tabBar.Position = UDim2.new(0, 0, 0, 30)
    tabBar.BackgroundTransparency = 1

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Vertical
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -130, 1, -40)
    content.Position = UDim2.new(0, 130, 0, 35)
    content.BackgroundTransparency = 1

    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        main.Size = minimized and UDim2.new(0, 600, 0, 30) or UDim2.new(0, 600, 0, 400)
        content.Visible = not minimized
        tabBar.Visible = not minimized
        minimizeButton.Text = minimized and "+" or "-"
    end)

    local tabs = {}

    local function createTab(name)
        local tabFrame = Instance.new("Frame", content)
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false

        local sectionLayout = Instance.new("UIListLayout", tabFrame)
        sectionLayout.SortOrder = Enum
