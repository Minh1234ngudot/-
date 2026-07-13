<div align="center">

# 🌌 Incon UI Library

[![Lua](https://img.shields.io/badge/Language-Lua-blue.svg?style=for-the-badge&logo=lua)](https://www.lua.org/)
[![Roblox](https://img.shields.io/badge/Game-Roblox-red.svg?style=for-the-badge&logo=roblox)](https://www.roblox.com/)
[![Status](https://img.shields.io/badge/Status-Active-success.svg?style=for-the-badge)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)]()

<img src="https://readme-typing-svg.herokuapp.com?font=Inconsolata&weight=600&size=24&pause=1000&color=00FF99&center=true&vCenter=true&width=435&lines=Premium+Roblox+UI+Library;Zero+Sub-Pixel+Tearing;Smooth+Drag+Tweens;Highly+Optimized" alt="Typing SVG" />

A modern, highly optimized, and bug-free Roblox UI Library designed for exploit scripts. Featuring a clean dark theme, smooth tweens, and **0% sub-pixel rendering issues**.

</div>

---

### 🚀 Booting the Library

Load the UI Library using the raw GitHub URL.

```lua
local InconUI = loadstring(game:HttpGet("[https://github.com/Minh1234ngudot/-/raw/refs/heads/main/Incon_UI.luau](https://github.com/Minh1234ngudot/-/raw/refs/heads/main/Incon_UI.luau)"))()

```

### 🪟 Creating a Window

Initialize your main hub interface. You can set the title and the key to toggle the UI visibility.

```lua
local Window = InconUI:CreateWindow({
    Name = "Incon Premium Hub",
    ToggleKey = Enum.KeyCode.RightControl
})

```

### 📑 Creating a Tab

Create tabs to organize your features.

```lua
local Tab = Window:CreateTab("Main Settings")

```

### 📌 Creating a Section

Divide your tab into neat sections.

```lua
Tab:CreateSection("Player Settings")

```

### 🔘 Creating a Button

Execute a function when clicked.

```lua
Tab:CreateButton({
    Name = "Kill All",
    Callback = function()
        print("Kill All Clicked")
    end
})

```

### 🎚️ Creating a Toggle

A switch to turn features on or off.

```lua
Tab:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(State)
        print("Toggle State: ", State)
    end
})

```

### ➖ Creating a Slider

Adjust numerical values smoothly. Includes a manual text input feature.

```lua
Tab:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

```

### 📝 Creating a Textbox

Input text directly into the UI. Triggers when you press Enter.

```lua
Tab:CreateTextbox({
    Name = "Target Player",
    Placeholder = "Enter name...",
    Callback = function(Text)
        print("Target: ", Text)
    end
})

```

### ⌨️ Creating a Keybind

Assign a quick hotkey. Users can click to rebind it dynamically.

```lua
Tab:CreateKeybind({
    Name = "Invisible",
    Default = Enum.KeyCode.T,
    Callback = function()
        print("Invisible Activated!")
    end
})

```

### 🔽 Creating a Dropdown

Select a single option from a list.

```lua
Tab:CreateDropdown({
    Name = "Select Target",
    List = {"Players", "Mobs", "Bosses"},
    Callback = function(Value)
        print("Targeting: ", Value)
    end
})

```

### ✔️ Creating a Multi-Dropdown

Select multiple options at once. Returns a table of selected items.

```lua
Tab:CreateMultiDropdown({
    Name = "Auto Weapons",
    List = {"Sword", "Gun", "Bow", "Magic"},
    Default = {"Sword"},
    Callback = function(SelectedItems)
        print("Weapons: ", table.concat(SelectedItems, ", "))
    end
})

```

### 🔔 Using Notifications

Trigger a smooth pop-up notification at the bottom right.

```lua
InconUI:MakeNotify({
    Title = "Success!",
    Content = "Script loaded perfectly.",
    Time = 3
})

```

### 📜 Creating Update Logs

Show off your recent updates in a sleek, expandable card.

```lua
Tab:CreateUpdateLog({
    ver = "v1.0.0",
    date = "13/07/2026",
    expandable = true,
    changes = {
        {"+", "Released Incon Premium Hub"},
        {"~", "Optimized Drag Tweens"},
        {"-", "Removed Sub-pixel rendering bugs"},
    }
})

```

```

```
