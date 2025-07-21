-- LeafUI Module
local LeafUI = {}
LeafUI.__index = LeafUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function LeafUI.new()
    local self = setmetatable({}, LeafUI)

    -- Create main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "LeafUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = CoreGui

    -- Main Frame
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Size = UDim2.new(0, 460, 0, 300)
    self.Main.Position = UDim2.new(0.5, -230, 0.5, -150)
    self.Main.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Main.BackgroundColor3 = Color3.fromRGB(60, 150, 80)
    self.Main.BackgroundTransparency = 0.15
    self.Main.BorderSizePixel = 0
    self.Main.ClipsDescendants = true
    self.Main.Active = true
    self.Main.Parent = self.ScreenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 14)
    mainCorner.Parent = self.Main

    -- Titlebar
    self.Titlebar = Instance.new("Frame")
    self.Titlebar.Name = "Titlebar"
    self.Titlebar.Size = UDim2.new(1, 0, 0, 30)
    self.Titlebar.BackgroundTransparency = 1
    self.Titlebar.Parent = self.Main

    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Size = UDim2.new(1, -70, 1, 0)
    self.TitleText.Position = UDim2.new(0, 10, 0, 0)
    self.TitleText.Font = Enum.Font.GothamBlack
    self.TitleText.TextSize = 22
    self.TitleText.TextColor3 = Color3.new(1, 1, 1)
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Text = "LeafUI"
    self.TitleText.Parent = self.Titlebar

    -- Close Button
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Name = "CloseBtn"
    self.CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    self.CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    self.CloseBtn.BackgroundTransparency = 1
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.TextSize = 22
    self.CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    self.CloseBtn.Text = "X"
    self.CloseBtn.Parent = self.Titlebar

    -- Minimize Button
    self.MinimizeBtn = Instance.new("TextButton")
    self.MinimizeBtn.Name = "MinimizeBtn"
    self.MinimizeBtn.Size = UDim2.new(0, 30, 1, 0)
    self.MinimizeBtn.Position = UDim2.new(1, -70, 0, 0)
    self.MinimizeBtn.BackgroundTransparency = 1
    self.MinimizeBtn.Font = Enum.Font.GothamBold
    self.MinimizeBtn.TextSize = 24
    self.MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    self.MinimizeBtn.Text = "—"
    self.MinimizeBtn.Parent = self.Titlebar

    -- Left Tabs Frame
    self.TabsFrame = Instance.new("Frame")
    self.TabsFrame.Name = "TabsFrame"
    self.TabsFrame.Size = UDim2.new(0, 120, 1, -30)
    self.TabsFrame.Position = UDim2.new(0, 0, 0, 30)
    self.TabsFrame.BackgroundTransparency = 0.2
    self.TabsFrame.BackgroundColor3 = Color3.fromRGB(60, 150, 80)
    self.TabsFrame.BorderSizePixel = 0
    self.TabsFrame.Parent = self.Main

    local tabsCorner = Instance.new("UICorner")
    tabsCorner.CornerRadius = UDim.new(0, 14)
    tabsCorner.Parent = self.TabsFrame

    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsLayout.Padding = UDim.new(0, 8)
    tabsLayout.Parent = self.TabsFrame

    -- Right Content Frame (scrollable)
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -130, 1, -30)
    self.ContentFrame.Position = UDim2.new(0, 130, 0, 30)
    self.ContentFrame.BackgroundTransparency = 0.2
    self.ContentFrame.BackgroundColor3 = Color3.fromRGB(60, 150, 80)
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentFrame.ScrollBarThickness = 6
    self.ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ContentFrame.Parent = self.Main

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 14)
    contentCorner.Parent = self.ContentFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 12)
    contentLayout.Parent = self.ContentFrame

    -- Internal storage
    self.tabs = {}
    self.tabContents = {}
    self.currentTab = nil
    self.minimized = false
    self.origSize = self.Main.Size
    self.origPos = self.Main.Position

    -- Drag vars
    self.dragging = false
    self.dragInput = nil
    self.dragStart = nil
    self.startPos = nil

    -- Setup connections
    self:SetupDrag()
    self:SetupButtons()

    return self
end

-- Setup drag functionality
function LeafUI:SetupDrag()
    self.Titlebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.dragging = true
            self.dragStart = input.Position
            self.startPos = self.Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self.dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if self.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - self.dragStart
            self.Main.Position = UDim2.new(
                self.startPos.X.Scale,
                self.startPos.X.Offset + delta.X,
                self.startPos.Y.Scale,
                self.startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Setup minimize and close buttons
function LeafUI:SetupButtons()
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self.minimized = not self.minimized
        if self.minimized then
            local tween = TweenService:Create(self.Main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(self.origSize.X.Scale, self.origSize.X.Offset, 0, 30),
                Position = UDim2.new(self.origPos.X.Scale, self.origPos.X.Offset, self.origPos.Y.Scale, self.origPos.Y.Offset + self.origSize.Y.Offset - 30)
            })
            tween:Play()
            tween.Completed:Wait()
            self.TabsFrame.Visible = false
            self.ContentFrame.Visible = false
        else
            self.TabsFrame.Visible = true
            self.ContentFrame.Visible = true
            TweenService:Create(self.Main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = self.origSize,
                Position = self.origPos
            }):Play()
        end
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        if self.ScreenGui then
            self.ScreenGui:Destroy()
            self.ScreenGui = nil
        end
    end)
end

-- Create tab button and store it
function LeafUI:AddTab(name)
    if not name or typeof(name) ~= "string" then
        warn("LeafUI:AddTab expects a valid string name")
        return
    end

    if self.tabs[name] then
        warn("Tab '" .. name .. "' already exists")
        return
    end

    local tab = Instance.new("TextButton")
    tab.Name = name .. "Tab"
    tab.BackgroundColor3 = Color3.fromRGB(50, 130, 70)
    tab.Size = UDim2.new(1, -16, 0, 42)
    tab.AutoButtonColor = false
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 18
    tab.TextColor3 = Color3.new(1, 1, 1)
    tab.Text = name
    tab.Parent = self.TabsFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = tab

    tab.MouseButton1Click:Connect(function()
        self:LoadTab(name)
    end)

    self.tabs[name] = tab
    self.tabContents[name] = {}

    return tab
end

-- Add a button to a tab's content
function LeafUI:AddButton(tabName, title, desc, callback)
    if not self.tabContents[tabName] then
        warn("Tab '" .. tostring(tabName) .. "' does not exist")
        return
    end

    if type(title) ~= "string" or type(desc) ~= "string" then
        warn("AddButton expects title and desc as strings")
        return
    end

    table.insert(self.tabContents[tabName], {
        Title = title,
        Desc = desc,
        Callback = callback
    })
end

-- Clear content frame buttons safely
function LeafUI:ClearContent()
    for _, child in pairs(self.ContentFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- Create a content button UI instance
function LeafUI:CreateContentButton(item)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 70)
    button.BackgroundColor3 = Color3.fromRGB(50, 130, 70)
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Parent = self.ContentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = button

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = item.Title or "Title"
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 12, 0, 6)
    titleLabel.Size = UDim2.new(1, -24, 0, 30)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = button

    local descLabel = Instance.new("TextLabel")
    descLabel.Text = item.Desc or ""
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 14
    descLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 12, 0, 36)
    descLabel.Size = UDim2.new(1, -24, 0, 28)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = button

    if typeof(item.Callback) == "function" then
        button.MouseButton1Click:Connect(item.Callback)
    end
end

-- Load a tab by name (show its buttons)
function LeafUI:LoadTab(name)
    if not self.tabs[name] then
        warn("No such tab: " .. tostring(name))
        return
    end

    if self.currentTab == name then return end

    self.currentTab = name
    self:ClearContent()

    for _, item in ipairs(self.tabContents[name]) do
        self:CreateContentButton(item)
    end

    -- Update tab button colors
    for tabName, tabBtn in pairs(self.tabs) do
        if tabName == name then
            tabBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 100)
        else
            tabBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 70)
        end
    end
end

return LeafUI
