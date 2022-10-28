wait()
-- Random Child Generator
local Folder = game.workspace.Map
local FolderChildren = Folder:GetChildren()
local chosen = {} -- where we will be storing the randomly selected objects
local MAX_OBJECTS = 0


local function GetChildrenOfMap()

for _ = 1, MAX_OBJECTS do
local index = math.random(1, #FolderChildren)
local obj = FolderChildren[index]

if not table.find(chosen, obj) then
    table.insert(chosen, obj)
        else
    repeat
        index = math.random(1, #FolderChildren)
         obj = FolderChildren[index]
          until not table.find(chosen, obj)

          table.insert(chosen, obj)
       end
    end
end



local badrocks = Instance.new("Folder")
    badrocks.Parent = workspace
    badrocks.Name = "BadrocksFolder"

    local function generateBedrock()
    for _, chosen in ipairs(chosen) do
        chosen.BrickColor = BrickColor.new("Dark grey metallic")
        chosen.Material = "Rock"
        chosen.CanTouch = false
        chosen.Name = "Bedrock"
        chosen.CanCollide = true
        chosen.Parent = badrocks
    end
end

-- Battery Generator

local batteries = Instance.new("Folder")
    batteries.Parent = workspace
    batteries.Name = "BatteriesFolder"

local function generateBatteries()
    chosen = {}
    GetChildrenOfMap()
    for _, chosen in ipairs(chosen) do
        local rep = game:GetService("ReplicatedStorage")
        local posOfNewBattery = chosen.Position
        local battery = rep.Meshes.Battery

        local newbattery = battery:Clone()
        newbattery.TouchPart.Touched:Connect(function(hit)
            if hit.Parent.Parent.Humanoid then
                print("Touhed")
              local char = hit.Parent.Parent
              local player = game.Players:GetPlayerFromCharacter(char)
              local Energy = player:GetAttribute("Energy")
              Energy = Energy + 25
              newbattery:Destroy()
            end
          end)
        local pos = newbattery.posPart
        newbattery.Parent = batteries
        newbattery:PivotTo(CFrame.new(posOfNewBattery)) 
        newbattery:PivotTo(newbattery:GetPivot() * CFrame.Angles(math.rad(0), math.rad(4), math.rad(-60)))
        print(pos.Position)
    end
end
MAX_OBJECTS = 40
chosen = {}
GetChildrenOfMap()
generateBedrock()

MAX_OBJECTS = 20
chosen = {}
GetChildrenOfMap()
generateBatteries()

wait(5)  
local batteryT = workspace.BatteriesFolder.Battery

  
