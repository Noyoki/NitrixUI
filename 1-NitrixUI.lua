local library = {}
local windowCount = 0
local sizes = {}
local listOffset = {}
local windows = {}
local pastSliders = {}
local dropdowns = {}
local dropdownSizes = {}
local destroyed

local colorPickers = {}

if game.CoreGui:FindFirstChild('NitrixUiLib') then
    game.CoreGui:FindFirstChild('NitrixUiLib'):Destroy()
    destroyed = true
end

function Lerp(a, b, c)
    return a + ((b - a) * c)
end

local players = game:service('Players');
local player = players.LocalPlayer;
local mouse = player:GetMouse();
local run = game:service('RunService');
local stepped = run.Stepped;
function Dragify(obj)
	spawn(function()
		local minitial;
		local initial;
		local isdragging;
	    obj.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				isdragging = true;
				minitial = input.Position;
				initial = obj.Position;
				local con;
                con = stepped:Connect(function()
        			if isdragging then
						local delta = Vector3.new(mouse.X, mouse.Y, 0) - minitial;
						obj.Position = UDim2.new(initial.X.Scale, initial.X.Offset + delta.X, initial.Y.Scale, initial.Y.Offset + delta.Y);
					else
						con:Disconnect();
					end;
                end);
                input.Changed:Connect(function()
    			    if input.UserInputState == Enum.UserInputState.End then
					    isdragging = false;
				    end;
			    end);
		end;
	end);
end)
end

-- Instances:

local function protect_gui(obj) 
if destroyed then
   obj.Parent = game.CoreGui
   return
end
if syn and syn.protect_gui then
syn.protect_gui(obj)
obj.Parent = game.CoreGui
elseif PROTOSMASHER_LOADED then
obj.Parent = get_hidden_gui()
else
obj.Parent = game.CoreGui
end
end
local NitrixUiLib = Instance.new("ScreenGui")

NitrixUiLib.Name = "NitrixUiLib"

protect_gui(NitrixUiLib)

local xOffset = 20

local uis = game:GetService("UserInputService")

local keybindConnection

function library:Destroy()
    NitrixUiLib:Destroy()
    if keybindConnection then
        keybindConnection:Disconnect()
    end
end
function library:Hide()
   NitrixUiLib.Enabled = not NitrixUiLib.Enabled
end	

function library:Keybind(key)
    if keybindConnection then keybindConnection:Disconnect() end

    keybindConnection = uis.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode[key] then
            NitrixUiLib.Enabled = not NitrixUiLib.Enabled
        end
    end)
end

function library:Window(name) 
    windowCount = windowCount + 1
    local winCount = windowCount
    local zindex = winCount * 7
    local UiWindow = Instance.new("Frame")

    UiWindow.Name = "UiWindow"
    UiWindow.Parent = NitrixUiLib
    UiWindow.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    UiWindow.BorderColor3 = Color3.fromRGB(40, 40, 40)
    UiWindow.Position = UDim2.new(0, xOffset, 0, 20)
    UiWindow.Size = UDim2.new(0, 207, 0, 33)
    UiWindow.ZIndex = 4 + zindex
    UiWindow.Active = true
    Dragify(UiWindow)

    xOffset = xOffset + 230

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = UiWindow
    Header.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    Header.BorderColor3 = Color3.fromRGB(33, 33, 33)
    Header.Position = UDim2.new(0, 0, -0.0202544238, 0)
    Header.Size = UDim2.new(0, 207, 0, 26)
    Header.ZIndex = 5 + zindex

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Name = "HeaderText"
    HeaderText.Parent = Header
    HeaderText.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    HeaderText.BackgroundTransparency = 1.000
    HeaderText.Position = UDim2.new(0, 0, -0.002, 0)
    HeaderText.Size = UDim2.new(0, 206, 0, 26)
    HeaderText.ZIndex = 6 + zindex
    HeaderText.Font = Enum.Font.SourceSans
    HeaderText.Text = name or "Window"
    HeaderText.TextColor3 = Color3.fromRGB(245, 246, 250)
    HeaderText.TextSize = 17.000

    local Minimise = Instance.new("TextButton")
    local Window = Instance.new("Frame")
    Minimise.Name = "Minimise"
    Minimise.Parent = Header
    Minimise.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    Minimise.BorderColor3 = Color3.fromRGB(33, 33, 33)
    Minimise.Position = UDim2.new(0, 185, 0, 2)
    Minimise.Size = UDim2.new(0, 22, 0, 22)
    Minimise.ZIndex = 7 + zindex
    Minimise.Font = Enum.Font.SourceSansLight
    Minimise.Text = "_"
    Minimise.TextColor3 = Color3.fromRGB(0, 0, 0)
    Minimise.TextSize = 20.000
    Minimise.MouseButton1Up:connect(function()
        Window.Visible = not Window.Visible
	if Window.Visible then
		Minimise.Text = "_"
	else
		Minimise.Text = "+"
	end
    end)

    Window.Name = "Window"
    Window.Parent = Header
    Window.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    Window.BorderColor3 = Color3.fromRGB(48, 48, 48)
    Window.Position = UDim2.new(0, 0, 0, 0)
    Window.Size = UDim2.new(0, 207, 0, 33)
    Window.ZIndex = 1 + zindex

    local functions = {}
    sizes[winCount] = 33
    listOffset[winCount] = 10
    function functions:Button(name, callback)
        local name = name or "Button"
        local callback = callback or function() end

        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)

        local Button = Instance.new("TextButton")
        listOffset[winCount] = listOffset[winCount] + 32
        Button.Name = "Button"
        Button.Parent = Window
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Button.BorderColor3 = Color3.fromRGB(60, 60, 60)
        Button.Position = UDim2.new(0, 12, 0, listOffset[winCount])
        Button.Size = UDim2.new(0, 182, 0, 26)
        Button.ZIndex = 2 + zindex
        Button.Selected = true
        Button.Font = Enum.Font.SourceSans
        Button.TextColor3 = Color3.fromRGB(245, 246, 250)
        Button.TextSize = 16.000
        Button.TextStrokeTransparency = 123.000
        Button.TextWrapped = true
        Button.Text = name
        Button.MouseButton1Down:Connect(callback)

        pastSliders[winCount] = false
    end
    function functions:Label(text, color)
        local labelFunctions = {}

        local color = color or Color3.fromRGB(220, 221, 225)

        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)

        listOffset[winCount] = listOffset[winCount] + 32
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Parent = Window
        Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Label.BackgroundTransparency = 0
        Label.BorderColor3 = Color3.fromRGB(60, 60, 60)
        Label.Position = UDim2.new(0, 12, 0, listOffset[winCount])
        Label.Size = UDim2.new(0, 182, 0, 26)
        Label.Font = Enum.Font.SourceSans
        Label.Text = text or "Label"
        Label.TextColor3 = Color3.fromRGB(245, 246, 250)
        Label.TextSize = 16.000
        Label.ZIndex = 2 + zindex

        pastSliders[winCount] = false
	return Label
    end
    function functions:Toggle(text, on, callback)
        local callback = callback or function() end

        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)

        listOffset[winCount] = listOffset[winCount] + 32

        local ToggleDescription = Instance.new("TextLabel")
        local ToggleButton = Instance.new("TextButton")
        local ToggleFiller = Instance.new("Frame")

        ToggleDescription.Name = "ToggleDescription"
        ToggleDescription.Parent = Window
        ToggleDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleDescription.BackgroundTransparency = 1.000
        ToggleDescription.Position = UDim2.new(0, 14, 0, listOffset[winCount])
        ToggleDescription.Size = UDim2.new(0, 131, 0, 26)
        ToggleDescription.Font = Enum.Font.SourceSans
        ToggleDescription.Text = text or "Toggle"
        ToggleDescription.TextColor3 = Color3.fromRGB(245, 246, 250)
        ToggleDescription.TextSize = 16.000
        ToggleDescription.TextWrapped = true
        ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
        ToggleDescription.ZIndex = 2 + zindex

        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleDescription
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ToggleButton.BorderColor3 = Color3.fromRGB(43, 43, 43)
        ToggleButton.Position = UDim2.new(1.2061069, 0, 0.0769230798, 0)
        ToggleButton.Size = UDim2.new(0, 22, 0, 22)
        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.Text = ""
        ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        ToggleButton.TextSize = 14.000
        ToggleButton.ZIndex = 2 + zindex
        ToggleButton.MouseButton1Up:Connect(function()
            ToggleFiller.Visible = not ToggleFiller.Visible
            callback(ToggleFiller.Visible)
        end)

        ToggleFiller.Name = "ToggleFiller"
        ToggleFiller.Parent = ToggleButton
        ToggleFiller.BackgroundColor3 = Color3.fromRGB(68, 189, 50)
        ToggleFiller.BorderColor3 = Color3.fromRGB(47, 54, 64)
        ToggleFiller.Position = UDim2.new(0, 5, 0, 5)
        ToggleFiller.Size = UDim2.new(0, 12, 0, 12)
        ToggleFiller.Visible = on
        ToggleFiller.ZIndex = 2 + zindex
        pastSliders[winCount] = false
    end
    function functions:Box(text, callback)
        local callback = callback or function() end

        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)

        listOffset[winCount] = listOffset[winCount] + 32
        local TextBox = Instance.new("TextBox")
        local BoxDescription = Instance.new("TextLabel")
        TextBox.Parent = Window
        TextBox.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
        TextBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
        TextBox.Position = UDim2.new(0, 99, 0, listOffset[winCount])
        TextBox.Size = UDim2.new(0, 95, 0, 26)
        TextBox.Font = Enum.Font.SourceSans
        TextBox.PlaceholderColor3 = Color3.fromRGB(220, 221, 225)
        TextBox.PlaceholderText = "..."
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(245, 246, 250)
        TextBox.TextSize = 16.000
        TextBox.TextStrokeColor3 = Color3.fromRGB(245, 246, 250)
        TextBox.ZIndex = 2 + zindex
        TextBox:GetPropertyChangedSignal('Text'):connect(function()
            callback(TextBox.Text, false)
        end)
        TextBox.FocusLost:Connect(function()
            callback(TextBox.Text, true)
        end)

        BoxDescription.Name = "BoxDescription"
        BoxDescription.Parent = TextBox
        BoxDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BoxDescription.BackgroundTransparency = 1.000
        BoxDescription.Position = UDim2.new(-0.894736826, 0, 0, 0)
        BoxDescription.Size = UDim2.new(0, 75, 0, 26)
        BoxDescription.Font = Enum.Font.SourceSans
        BoxDescription.Text = text or "Box"
        BoxDescription.TextColor3 = Color3.fromRGB(245, 246, 250)
        BoxDescription.TextSize = 16.000
        BoxDescription.TextXAlignment = Enum.TextXAlignment.Left
        BoxDescription.ZIndex = 2 + zindex
        pastSliders[winCount] = false
    end
    function functions:Slider(text, min, max, default, callback)
        local text = text or "Slider"
        local min = min or 1
        local max = max or 100
        local default = default or max/2
        local callback = callback or function() end
        local offset = 70
        if default > max then
            default = max
        elseif default < min then
            default = min
        end

        if pastSliders[winCount] then
            offset = 60
        end

        sizes[winCount] = sizes[winCount] + offset
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)

        listOffset[winCount] = listOffset[winCount] + offset

        local Slider = Instance.new("Frame")
        local SliderButton = Instance.new("Frame")
        local Description = Instance.new("TextLabel")
        local SilderFiller = Instance.new("Frame")
        local Current = Instance.new("TextLabel")
        local Min = Instance.new("TextLabel")
        local Max = Instance.new("TextLabel")

        function SliderMovement(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isdragging = true;
                    minitial = input.Position.X;
                    initial = SliderButton.Position.X.Offset;
                    local delta1 = SliderButton.AbsolutePosition.X - initial
                    local con;
                    con = stepped:Connect(function()
                        if isdragging then
                            local xOffset = mouse.X - delta1 - 3
                            if xOffset > 175 then
                                xOffset = 175
                            elseif xOffset< 0 then
                                xOffset = 0
                            end
                            SliderButton.Position = UDim2.new(0, xOffset , -1.33333337, 0);
                            SilderFiller.Size = UDim2.new(0, xOffset, 0, 6)
                            local value = Lerp(min, max, SliderButton.Position.X.Offset/(Slider.Size.X.Offset-5))
                            Current.Text = tostring(math.round(value))
                        else
                            con:Disconnect();
                        end;
                    end);
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            isdragging = false;
                        end;
                    end);
            end;
        end
        function SliderEnd(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local value = Lerp(min, max, SliderButton.Position.X.Offset/(Slider.Size.X.Offset-5))
            callback(math.round(value))
            end
        end

        Slider.Name = "Slider"
        Slider.Parent = Window
        Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Slider.BorderColor3 = Color3.fromRGB(60, 60, 60)
        Slider.Position = UDim2.new(0, 13, 0, listOffset[winCount])
        Slider.Size = UDim2.new(0, 180, 0, 6)
        Slider.ZIndex = 2 + zindex
        Slider.InputBegan:Connect(SliderMovement) 
        Slider.InputEnded:Connect(SliderEnd)      

        SliderButton.Position = UDim2.new(0, (Slider.Size.X.Offset - 5) * ((default - min)/(max-min)), -1.333337, 0)
        SliderButton.Name = "SliderButton"
        SliderButton.Parent = Slider
        SliderButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        SliderButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
        SliderButton.Size = UDim2.new(0, 6, 0, 22)
        SliderButton.ZIndex = 3 + zindex
        SliderButton.InputBegan:Connect(SliderMovement)
        SliderButton.InputEnded:Connect(SliderEnd)    

        Current.Name = "Current"
        Current.Parent = SliderButton
        Current.BackgroundTransparency = 1.000
        Current.Position = UDim2.new(0, 3, 0, 22   )
        Current.Size = UDim2.new(0, 0, 0, 18)
        Current.Font = Enum.Font.SourceSans
        Current.Text = tostring(default)
        Current.TextColor3 = Color3.fromRGB(220, 221, 225)
        Current.TextSize = 14.000  
        Current.ZIndex = 2 + zindex

        Description.Name = "Description"
        Description.Parent = Slider
        Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Description.BackgroundTransparency = 1.000
        Description.Position = UDim2.new(0, -10, 0, -35)
        Description.Size = UDim2.new(0, 200, 0, 21)
        Description.Font = Enum.Font.SourceSans
        Description.Text = text
        Description.TextColor3 = Color3.fromRGB(245, 246, 250)
        Description.TextSize = 16.000
        Description.ZIndex = 2 + zindex

        SilderFiller.Name = "SilderFiller"
        SilderFiller.Parent = Slider
        SilderFiller.BackgroundColor3 = Color3.fromRGB(76, 209, 55)
        SilderFiller.BorderColor3 = Color3.fromRGB(47, 54, 64)
        SilderFiller.Size = UDim2.new(0, (Slider.Size.X.Offset - 5) * ((default - min)/(max-min)), 0, 6)
        SilderFiller.ZIndex = 2 + zindex
        SilderFiller.BorderMode = Enum.BorderMode.Inset

        Min.Name = "Min"
        Min.Parent = Slider
        Min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Min.BackgroundTransparency = 1.000
        Min.Position = UDim2.new(-0.00555555569, 0, -7.33333397, 0)
        Min.Size = UDim2.new(0, 77, 0, 50)
        Min.Font = Enum.Font.SourceSans
        Min.Text = tostring(min)
        Min.TextColor3 = Color3.fromRGB(220, 221, 225)
        Min.TextSize = 14.000
        Min.TextXAlignment = Enum.TextXAlignment.Left
        Min.ZIndex = 2 + zindex

        Max.Name = "Max"
        Max.Parent = Slider
        Max.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Max.BackgroundTransparency = 1.000
        Max.Position = UDim2.new(0.577777743, 0, -7.33333397, 0)
        Max.Size = UDim2.new(0, 77, 0, 50)
        Max.Font = Enum.Font.SourceSans
        Max.Text = tostring(max)
        Max.TextColor3 = Color3.fromRGB(220, 221, 225)
        Max.TextSize = 14.000
        Max.TextXAlignment = Enum.TextXAlignment.Right
        Max.ZIndex = 2 + zindex
        pastSliders[winCount] = true

        local slider = {}
        function slider:SetValue(value)
	    value = math.clamp(value, min, max)
            local xOffset = (value-min)/max * (Slider.Size.X.Offset)
            SliderButton.Position = UDim2.new(0, xOffset , -1.33333337, 0);
            SilderFiller.Size = UDim2.new(0, xOffset, 0, 6)
            Current.Text = tostring(math.round(value))
        end
        return slider
    end
    function functions:Dropdown(text, buttons, callback, selective)
        local text = text or "Dropdown"
        local buttons = buttons or {}
        local callback = callback or function() end

        local Dropdown = Instance.new("TextButton")
        local DownSign = Instance.new("TextLabel")
        local DropdownFrame = Instance.new("ScrollingFrame")

        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)

        listOffset[winCount] = listOffset[winCount] + 32

        Dropdown.Name = "Dropdown"
        Dropdown.Parent = Window
        Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Dropdown.BorderColor3 = Color3.fromRGB(60, 60, 60)
        Dropdown.Position = UDim2.new(0, 12, 0, listOffset[winCount])
        Dropdown.Size = UDim2.new(0, 182, 0, 26)
        Dropdown.Selected = true
        Dropdown.Font = Enum.Font.SourceSans
        Dropdown.Text = tostring(text)
        Dropdown.TextColor3 = Color3.fromRGB(245, 246, 250)
        Dropdown.TextSize = 16.000
        Dropdown.TextStrokeTransparency = 123.000
        Dropdown.TextWrapped = true
        Dropdown.ZIndex = 3 + zindex
        Dropdown.MouseButton1Up:Connect(function()
            for i, v in pairs(dropdowns) do
                if v ~= DropdownFrame then
                v.Visible = false
                DownSign.Rotation = 0
                end
            end
            if DropdownFrame.Visible then
                DownSign.Rotation = 0
            else
                DownSign.Rotation = 180
            end
            DropdownFrame.Visible = not DropdownFrame.Visible
        end)

        DownSign.Name = "DownSign"
        DownSign.Parent = Dropdown
        DownSign.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DownSign.BackgroundTransparency = 1.000
        DownSign.Position = UDim2.new(0, 155, 0, 2)
        DownSign.Size = UDim2.new(0, 27, 0, 22)
        DownSign.Font = Enum.Font.SourceSans
        DownSign.Text = "^"
        DownSign.TextColor3 = Color3.fromRGB(220, 221, 225)
        DownSign.TextSize = 20.000
        DownSign.ZIndex = 4 + zindex
        DownSign.TextYAlignment = Enum.TextYAlignment.Bottom

        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Parent = Dropdown
        DropdownFrame.Active = true
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        DropdownFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        DropdownFrame.Position = UDim2.new(0, 0, 0, 28)
        DropdownFrame.Size = UDim2.new(0, 182, 0, 0)
        DropdownFrame.Visible = false
        DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        DropdownFrame.ScrollBarThickness = 4
        DropdownFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
        DropdownFrame.ZIndex = 5 + zindex
        DropdownFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        DropdownFrame.ScrollBarImageColor3 = Color3.fromRGB(220, 221, 225)
        table.insert(dropdowns, DropdownFrame)
        local dropFunctions = {}
        local canvasSize = 0
        function dropFunctions:Button(name)
            local name = name or ""
            local Button_2 = Instance.new("TextButton")
            Button_2.Name = "Button"
            Button_2.Parent = DropdownFrame
            Button_2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Button_2.BorderColor3 = Color3.fromRGB(60, 60, 60)
            Button_2.Position = UDim2.new(0, 6, 0, canvasSize + 1)
            Button_2.Size = UDim2.new(0, 170, 0, 26)
            Button_2.Selected = true
            Button_2.Font = Enum.Font.SourceSans
            Button_2.TextColor3 = Color3.fromRGB(245, 246, 250)
            Button_2.TextSize = 16.000
            Button_2.TextStrokeTransparency = 123.000
            Button_2.ZIndex = 6 + zindex
            Button_2.Text = name
            Button_2.TextWrapped = true
            canvasSize = canvasSize + 27
            DropdownFrame.CanvasSize = UDim2.new(0, 182, 0, canvasSize + 1)
            if #DropdownFrame:GetChildren() < 8 then
            DropdownFrame.Size = UDim2.new(0, 182, 0, DropdownFrame.Size.Y.Offset + 27)
            end
            Button_2.MouseButton1Up:Connect(function()
                callback(name)
		DropdownFrame.Visible = false
		if selective then
		   Dropdown.Text = name
		end
            end)
        end
        function dropFunctions:Remove(name)
            local foundIt
            for i, v in pairs(DropdownFrame:GetChildren()) do
                if foundIt then
                    canvasSize = canvasSize - 27
                    v.Position = UDim2.new(0, 6, 0, v.Position.Y.Offset - 27)
                    DropdownFrame.CanvasSize = UDim2.new(0, 182, 0, canvasSize + 1)
                end
                if v.Text == name then
                    foundIt = true
                    v:Destroy()
                    if #DropdownFrame:GetChildren() < 8 then
                        DropdownFrame.Size = UDim2.new(0, 182, 0, DropdownFrame.Size.Y.Offset - 27)
                    end
                end
            end
            if not foundIt then
                warn("The button you tried to remove didn't exist!")
            end
        end

        for i,v in pairs(buttons) do
            dropFunctions:Button(v)
        end

        return dropFunctions
    end

    return functions
end

return library
