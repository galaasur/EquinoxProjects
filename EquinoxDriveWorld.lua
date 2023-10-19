local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/x3fall3nangel/mercury-lib-edit/master/src.lua"))()

local GUI = Library:Create {
    Name = "Home",
    Size = UDim2.fromOffset(600, 400),
    Theme = Library.Themes.Legacy,
    Link = "https://github.com/maybeAnnah/Equinox/DriveWorld"
}

GUI:Notification {
    Title = "Equinox | DriveWorld",
    Text = "Equinox has been successfully executed!",
    Duration = 10,
    Callback = function() end
}

--[[
    This section is for defining the Script variables and functions needed.
]]
--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService('Workspace')

local lp = Players.LocalPlayer
local human = lp.Character.Humanoid
local Systems = ReplicatedStorage:WaitForChild("Systems")

local Driveworld = {}

for i, v in pairs(getconnections(Players.LocalPlayer.Idled)) do
    if v["Disable"] then
        v["Disable"](v)
    elseif v["Disconnect"] then
        v["Disconnect"](v)
    end
end

local function getchar()
    return lp.Character or lp.CharacterAdded:Wait()
end

local function isvehicle()
    for i, v in next, Workspace.Cars:GetChildren() do
        if (v:IsA("Model") and v:FindFirstChild("Owner") and v:FindFirstChild("Owner").Value == lp) then
            if v:FindFirstChild("CurrentDriver") and v:FindFirstChild("CurrentDriver").Value == lp then
                return true
            end
        end
    end
    return false
end

local function getvehicle()
    for i, v in next, Workspace.Cars:GetChildren() do
        if v:IsA("Model") and v:FindFirstChild("Owner") and v:FindFirstChild("Owner").Value == lp then
            return v
        end
    end
end

--[[
    This section is for defining the GUI Tabs.
]]
--

local Farming = GUI:Tab {
    Name = "Money Farming",
    Icon = "rbxassetid://14993724697"
}

local Quests = GUI:Tab {
    Name = "Quests",
    Icon = "rbxassetid://14993709385"
}

local Modifiers = GUI:Tab {
    Name = "Modifiers",
    Icon = "rbxassetid://14996147700"
}

local Links = GUI:Tab {
    Name = "Creator Links",
    Icon = "rbxassetid://14998829784"
}

--[[
    This section is for defining the Tabs toggles buttons and all this stuff.
]]
--

-- FARMING TAB --

Farming:Toggle({
    Name = "AFK Delivery Trailer",
    StartingState = false,
    Description = "Use Full-E or Casper for more money. (~20sec cooldown to avoid kick)",
    Callback = function(state)
        Driveworld["autodeliverytrailer"] = state
    end
})

-- QUESTS TAB --

Quests:Toggle({
    Name = "AFK Delivery Food",
    StartingState = false,
    Description = "Use this for quests only, it's just better. (~20sec cooldown to avoid kick)",
    Callback = function(state)
        Driveworld["autodeliveryfood"] = state
    end
})

Quests:Toggle({
    Name = "AFK Drive Score",
    StartingState = false,
    Description = "Use this to farm Drive Score for quests. (Stay in a vehicle first!)",
    Callback = function(state)
        Driveworld["autodrivescore"] = state

        if state then
            task.spawn(function()
                while task.wait() do
                    if Driveworld["autodrivescore"] then
                        pcall(function()
                            if not isvehicle() then
                                local Cars = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(lp.Name)
                                    :WaitForChild("Inventory"):WaitForChild("Cars")
                                local Truck = Cars:FindFirstChild("FullE") or Cars:FindFirstChild("Casper")
                                local normalcar = Cars:FindFirstChildWhichIsA("Folder")
                                if Truck then
                                    Systems:WaitForChild("CarInteraction"):WaitForChild("SpawnPlayerCar"):InvokeServer(
                                        normalcar)
                                else
                                    Systems:WaitForChild("CarInteraction"):WaitForChild("SpawnPlayerCar"):InvokeServer(
                                        normalcar)
                                end
                                getchar().HumanoidRootPart.CFrame = getvehicle().PrimaryPart.CFrame
                                task.wait(1)
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            end
                            task.spawn(function()
                                local vu = game:GetService("VirtualUser")
                                game:GetService("Players").LocalPlayer.Idled:connect(function()
                                    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                                    wait(1)
                                    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                                end)
                            end)
                            local DriveFarmPart = Instance.new("Part")
                            DriveFarmPart.Parent = workspace
                            DriveFarmPart.Position = Vector3.new(-1713, 20000, 20110)
                            DriveFarmPart.Size = Vector3.new(2048, 1, 2048)
                            DriveFarmPart.Anchored = true
                            local i = 300
                            local name = game.Players.LocalPlayer
                            for _, v in pairs(game:GetService("Workspace").Cars:GetDescendants()) do
                                if v:IsA("ObjectValue") and v.Value == name and v.Name == 'Owner' then
                                    car = v.Parent
                                end
                            end
                            car:SetPrimaryPartCFrame(CFrame.new(-2126, 9070, 989))
                            local function dollas()
                                car.Main.Anchored = false
                                car:SetPrimaryPartCFrame(CFrame.new(-1544, 20005, 21125))
                                car.Main.Velocity = Vector3.new(0, 0, -430)
                                wait(5)
                            end
                            while i > 0 do
                                if not Driveworld["autodrivescore"] then
                                    DriveFarmPart:Remove()
                                    i = 300
                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                    task.wait(.5)
                                    human:ChangeState('Seated')
                                    task.wait(.5)
                                    Systems:WaitForChild("Navigate"):WaitForChild("Teleport"):InvokeServer(workspace
                                        .Locations.Dealership)
                                    return
                                end
                                dollas()
                                i = i - 1
                                if i == 1 then
                                    i = 300
                                end
                            end
                            -- stop
                            car.Main.Anchored = true
                        end)
                    end
                end
            end)
        end
    end
})

Quests:Toggle({
    Name = "AFK Drift Score",
    StartingState = false,
    Description = "Use this to farm Drift Score for quests. (Stay in a vehicle first!)",
    Callback = function(state)
        Driveworld["autodriftscore"] = state

        if state then
            task.spawn(function()
                while task.wait() do
                    if Driveworld["autodriftscore"] then
                        pcall(function()
                            if not isvehicle() then
                                local Cars = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(lp.Name)
                                    :WaitForChild("Inventory"):WaitForChild("Cars")
                                local Truck = Cars:FindFirstChild("FullE") or Cars:FindFirstChild("Casper")
                                local normalcar = Cars:FindFirstChildWhichIsA("Folder")
                                if Truck then
                                    Systems:WaitForChild("CarInteraction"):WaitForChild("SpawnPlayerCar"):InvokeServer(
                                        normalcar)
                                else
                                    Systems:WaitForChild("CarInteraction"):WaitForChild("SpawnPlayerCar"):InvokeServer(
                                        normalcar)
                                end
                                getchar().HumanoidRootPart.CFrame = getvehicle().PrimaryPart.CFrame
                                task.wait(.5)
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            end
                            local Workspace = game:GetService('Workspace')
                            local lp = Players.LocalPlayer
                            local random_pos = Vector3.new(math.random(1000, 2000), math.random(1000, 2000),
                                math.random(1000, 2000))
                            local current = tick()

                            for i, v in pairs(getconnections(lp.Idled)) do
                                v:Disable()
                            end

                            local DriftFarmPart = Instance.new('Part', Workspace)
                            DriftFarmPart.Name = 'leadmarker'
                            DriftFarmPart.Position = random_pos
                            DriftFarmPart.Anchored = true
                            DriftFarmPart.Size = Vector3.new(50, 5, 50)

                            local cash_stuff; do
                                cash_stuff = function()
                                    for i, v in pairs(getvehicle():GetDescendants()) do
                                        if (v.ClassName == 'VectorForce') then
                                            v.Force = Vector3.new(500000, 0, 500000)
                                        end
                                    end
                                end

                                while (task.wait()) do
                                    if not Driveworld["autodriftscore"] then
                                        DriftFarmPart:Remove('leadmarker')
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                        task.wait(.5)
                                        human:ChangeState('Seated')
                                        task.wait(.5)
                                        Systems:WaitForChild("Navigate"):WaitForChild("Teleport"):InvokeServer(workspace
                                            .Locations.Dealership)
                                        task.wait(.5)
                                        human:ChangeState('Seated')
                                        return
                                    end

                                    local mag = (getvehicle().PrimaryPart.Position - random_pos).magnitude

                                    if (tick() - current > 300) then
                                        task.wait(10)
                                        current = tick()
                                    else
                                        if (mag > 250) then
                                            getvehicle():SetPrimaryPartCFrame(CFrame.new(random_pos))
                                        end

                                        DriftFarmPart.CFrame = getvehicle().PrimaryPart.CFrame * CFrame.new(0, -5, 0)
                                        cash_stuff()
                                    end
                                end
                            end
                        end)
                    end
                end
            end)
        end
    end
})

Quests:Button({
    Name = "TP Barn Part",
    Description = "Teleports you or the vehicle to the nearest Barn Part. (Works both on USA & JP)",
    Callback = function()
        for i, v in next, Workspace.Objects.Destructible:GetChildren() do
            if v.Name == "BarnFindItem" and v:FindFirstChildWhichIsA("MeshPart") then
                Systems:WaitForChild("Navigate"):WaitForChild("Teleport"):InvokeServer(v:FindFirstChildWhichIsA(
                    "MeshPart").CFrame)
                task.wait(.5)
            end
        end
    end
})

-- MODIFIERS TAB --

Modifiers:Slider {
    Name = "WalkSpeed Modifier",
    Default = 16,
    Min = 1,
    Max = 1000,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (value)
    end
}

Modifiers:Button {
    Name = "Revert WalkSpeed to Default",
    Description = "Reverts the Player WalkSpeed to the Initial value of 16",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
}

Modifiers:Toggle {
    Name = "Infinite Jump",
    StartingState = false,
    Description = "Toggles or not the Infinite Jump",
    Callback = function(state)
        Driveworld["infinjump"] = state
        local m = lp:GetMouse()
        m.KeyDown:connect(function(k)
            if Driveworld["infinjump"] then
                if k:byte() == 32 then
                    human:ChangeState('Jumping')
                    wait()
                    human:ChangeState('Seated')
                end
            end
        end)
    end
}

-- LINKS TAB --

Links:Button {
    Name = "maybeAnnah on GitHub",
    Description = "https://github.com/maybeAnnah",
    Callback = function()
        setclipboard("https://github.com/maybeAnnah")
        GUI:Notification {
            Title = "Equinox | Links | GitHub",
            Text = "Copied to Clipboard!",
            Duration = 5,
            Callback = function() end
        }
    end
}

Links:Button {
    Name = "@EquinoxScripts on Telegram",
    Description = "Scripts & more! | https://t.me/EquinoxScripts",
    Callback = function()
        setclipboard("https://t.me/EquinoxScripts")
        GUI:Notification {
            Title = "Equinox | Links | Telegram",
            Text = "Copied to Clipboard!",
            Duration = 5,
            Callback = function() end
        }
    end
}

Links:Button {
    Name = "Equinox Discord Server",
    Description = "Scripts & more! | https://discord.gg/CUUxdUKjFB",
    Callback = function()
        setclipboard("https://discord.gg/CUUxdUKjFB")
        GUI:Notification {
            Title = "Equinox | Links | Discord",
            Text = "Copied to Clipboard!",
            Duration = 5,
            Callback = function() end
        }
    end
}

--[[
    This section is for task spawn.
]]
--

-- AUTO DELIVERY FOOD --

task.spawn(function()
    while task.wait() do
        if Driveworld["autodeliveryfood"] then
            pcall(function()
                if not isvehicle() then
                    local Cars = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(lp.Name):WaitForChild(
                        "Inventory"):WaitForChild("Cars")
                    local Truck = Cars:FindFirstChild("FullE") or Cars:FindFirstChild("Casper")
                    local normalcar = Cars:FindFirstChildWhichIsA("Folder")
                    if Truck then
                        Systems:WaitForChild("CarInteraction"):WaitForChild("SpawnPlayerCar"):InvokeServer(Truck)
                    else
                        Systems:WaitForChild("CarInteraction"):WaitForChild("SpawnPlayerCar"):InvokeServer(normalcar)
                    end
                    getchar().HumanoidRootPart.CFrame = getvehicle().PrimaryPart.CFrame
                    task.wait(1)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                end
                local completepos
                local CompletionRegion
                local job = lp.PlayerGui.Score.Frame.Jobs
                repeat
                    task.wait()
                    if job.Visible == false and Driveworld["autodeliveryfood"] then
                        Systems:WaitForChild("Jobs"):WaitForChild("StartJob"):InvokeServer("FoodDelivery", "Tavern")
                    end
                until job.Visible == true or Driveworld["autodeliveryfood"] == false
                print("Equinox | Food Job Started.")
                task.wait()
                CompletionRegion = Workspace:FindFirstChild("CompletionRegion")
                if CompletionRegion:FindFirstChild("Primary") then
                    completepos = CompletionRegion:FindFirstChild("Primary").CFrame
                end
                for i = 1, 25 do
                    if not Driveworld["autodeliveryfood"] or not getvehicle() or not getchar() then
                        Systems:WaitForChild("Jobs"):WaitForChild("QuitJob"):InvokeServer()
                        return
                    end
                    task.wait(1)
                end
                Systems:WaitForChild("Navigate"):WaitForChild("Teleport"):InvokeServer(completepos)
                task.wait(.5)
                Systems:WaitForChild("Jobs"):WaitForChild("CompleteJob"):InvokeServer()
                task.wait(.5)
                if lp.PlayerGui.JobComplete.Enabled == true then
                    Systems:WaitForChild("Jobs"):WaitForChild("CashBankedEarnings"):FireServer()
                    firesignal(lp.PlayerGui.JobComplete.Window.Content.Buttons.Close.MouseButton1Click)
                end
                print("Equinox | Food Job Completed Successfully.")
            end)
        end
    end
end)

-- AUTO DELIVERY TRAILER --

task.spawn(function()
    while task.wait() do
        if Driveworld["autodeliverytrailer"] then
            pcall(function()
                if not isvehicle() then
                    local Cars = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(lp.Name):WaitForChild(
                        "Inventory"):WaitForChild("Cars")
                    local Truck = Cars:FindFirstChild("FullE") or Cars:FindFirstChild("Casper")
                    local normalcar = Cars:FindFirstChildWhichIsA("Folder")
                    if Truck then
                        Systems:WaitForChild("CarInteraction"):WaitForChild("SpawnPlayerCar"):InvokeServer(Truck)
                    else
                        Systems:WaitForChild("CarInteraction"):WaitForChild("SpawnPlayerCar"):InvokeServer(normalcar)
                    end
                    getchar().HumanoidRootPart.CFrame = getvehicle().PrimaryPart.CFrame
                    task.wait(1)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                end
                local completepos
                local distance
                local jobDistance
                local CompletionRegion
                local job = lp.PlayerGui.Score.Frame.Jobs
                repeat
                    task.wait()
                    if job.Visible == false and Driveworld["autodeliverytrailer"] then
                        Systems:WaitForChild("Jobs"):WaitForChild("StartJob"):InvokeServer("TrailerDelivery", "F")
                    end
                until job.Visible == true or Driveworld["autodeliverytrailer"] == false
                print("Equinox | Trailer Job Started.")
                repeat
                    task.wait()
                    CompletionRegion = Workspace:WaitForChild("CompletionRegion", 3)
                    if CompletionRegion then
                        distance = CompletionRegion:FindFirstChild("Primary"):FindFirstChild("DestinationIndicator")
                            :FindFirstChild("Distance").Text
                        local yeas = string.split(distance, " ")
                        for i, v in next, yeas do
                            if tonumber(v) then
                                if tonumber(v) <= 2.1 or tonumber(v) == 200 then
                                    Systems:WaitForChild("Jobs"):WaitForChild("StartJob"):InvokeServer("TrailerDelivery",
                                        "F")
                                else
                                    jobDistance = v
                                    print("Equinox | Found Trailer Job Distance : " .. jobDistance)
                                    break
                                end
                            end
                        end
                    end
                until jobDistance and tonumber(jobDistance) > 2.1 or Driveworld["autodeliverytrailer"] == false
                if CompletionRegion:FindFirstChild("Primary") then
                    completepos = CompletionRegion:FindFirstChild("Primary").CFrame
                end
                for i = 1, 25 do
                    if not Driveworld["autodeliverytrailer"] or not getvehicle() or not getchar() then
                        Systems:WaitForChild("Jobs"):WaitForChild("QuitJob"):InvokeServer()
                        return
                    end
                    task.wait(1)
                end
                Systems:WaitForChild("Navigate"):WaitForChild("Teleport"):InvokeServer(completepos)
                task.wait(.5)
                Systems:WaitForChild("Jobs"):WaitForChild("CompleteJob"):InvokeServer()
                task.wait(.5)
                if lp.PlayerGui.JobComplete.Enabled == true then
                    Systems:WaitForChild("Jobs"):WaitForChild("CashBankedEarnings"):FireServer()
                    firesignal(lp.PlayerGui.JobComplete.Window.Content.Buttons.Close.MouseButton1Click)
                end
                print("Equinox | Trailer Job Completed Successfully.")
            end)
        end
    end
end)

-- GUI END --

GUI:Credit {
    Name = "maybeAnnah",
    Description = "Script Developer",
}

GUI:set_status("Equinox | All systems operational.")
