LeafUI = {}

local Components = script:WaitForChild("Components") local Theme = require(script:WaitForChild("Theme")) local Util = require(script:WaitForChild("Util"))Load components LeafUI.TitleWindow = require(Components:WaitForChild("TitleWindow")) LeafUI.Button = require(Components:WaitForChild("Button")) LeafUI.Toggle = require(Components:WaitForChild("Toggle")) LeafUI.Slider = require(Components:WaitForChild("Slider")) LeafUI.Dropdown = require(Components:WaitForChild("Dropdown")) LeafUI.Label = require(Components:WaitForChild("Label")) LeafUI.SearchBar = require(Components:WaitForChild("SearchBar")) LeafUI.RestoreToggle = require(Components:WaitForChild("RestoreToggle"))

LeafUI.Theme = Theme LeafUI.Util = Util

return LeafUI
