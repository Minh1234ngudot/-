# Incon UI Library

A modern, highly optimized, and bug-free Roblox UI Library designed for exploit scripts. Featuring a clean dark theme, smooth tweens, and 0% sub-pixel rendering issues.

## Booting the Library

Load the UI Library using the raw GitHub URL.

```lua
local InconUI = loadstring(game:HttpGet("[https://github.com/Minh1234ngudot/-/raw/refs/heads/main/Incon_UI.luau](https://github.com/Minh1234ngudot/-/raw/refs/heads/main/Incon_UI.luau)"))()

````

## Creating a Window

Initialize your main hub interface. You can set the title and the key to toggle the UI visibility.

``` lua
local Window = InconUI:CreateWindow({  
    Name = "Incon Premium Hub",  
    ToggleKey = Enum.KeyCode.RightControl  
})

```

## Creating a Tab

Add tabs to the sidebar to organize your features.

``` lua
local MainTab = Window:CreateTab("Main Settings")

```

## UI Components

Add these elements inside your created tabs.

### Section Header

Creates a visual separator and title to categorize elements.

``` lua
MainTab:CreateSection("Player Configurations")

```

### Label

Displays static text information.

``` lua
MainTab:CreateLabel({  
    Name = "Script loaded successfully!"  
})

```

### Button

A standard clickable button.

``` lua
MainTab:CreateButton({  
    Name = "Kill All",  
    Callback = function()  
        print("Clicked")  
    end  
})

```

### Toggle

A switch for boolean (On/Off) states.

``` lua
MainTab:CreateToggle({  
    Name = "Auto Farm",  
    Default = false,  
    Callback = function(State)  
        print(State)  
    end  
})

```

### Slider

A draggable slider that also allows manual text input for exact values.

``` lua
MainTab:CreateSlider({  
    Name = "WalkSpeed",  
    Min = 16,  
    Max = 150,  
    Default = 16,  
    Callback = function(Value)  
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value  
    end  
})

```

### Textbox

An input field to type custom strings or numbers.

``` lua
MainTab:CreateTextbox({  
    Name = "Target Player",  
    Placeholder = "Enter username...",  
    Callback = function(Text)  
        print(Text)  
    end  
})

```

### Keybind

A button that listens for a specific key press.

``` lua
MainTab:CreateKeybind({  
    Name = "Trigger Skill",  
    Default = Enum.KeyCode.E,  
    Callback = function()  
        print("Key Pressed")  
    end  
})

```

### Dropdown

A selectable list allowing a single choice.

``` lua
MainTab:CreateDropdown({  
    Name = "Select Weapon",  
    List = {"Sword", "Gun", "Bow"},  
    Callback = function(Value)  
        print(Value)  
    end  
})

```

### Multi-Dropdown

A selectable list allowing multiple choices simultaneously.

``` lua
MainTab:CreateMultiDropdown({  
    Name = "Select Targets",  
    List = {"Players", "Mobs", "Bosses"},  
    Default = {"Players"},  
    Callback = function(SelectedItems)  
        print(table.concat(SelectedItems, ", "))  
    end  
})

```

### Update Log

An expandable card displaying version history with auto-colored prefixes (+ for Add, \~ for Change, - for Remove).

``` lua
MainTab:CreateUpdateLog({  
    ver = "v1.0.0",  
    date = "13/07/2026",  
    expandable = true,  
    changes = {  
        {"+", "Added Client-Sided Mode"},  
        {"~", "Optimized UI rendering"},  
        {"-", "Fixed memory leaks"}  
    }  
})

```

## Global Functions

### Notification

A smooth pop-up notification that appears at the bottom right of the screen. This is called directly from InconUI, not from a Tab.

``` lua
InconUI:MakeNotify({  
    Title = "Success",  
    Content = "Action completed",  
    Time = 3  
})

```
