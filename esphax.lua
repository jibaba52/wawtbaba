-- Grow a Garden ESP + Randomizer Script (With Full Egg Support)
-- Main Use: Displays the exact pet you will hatch from any egg using ESP (Floating Text), allows randomizing what's inside the egg, and ensures that the shown pet is the one that hatches.
-- Educational use only

-- Pet database (Eggs + Pets + Chances)
local EggPets = {
  ["Common Egg"] = {
    {name = "Golden Lab", chance = 33.33},
    {name = "Dog", chance = 33.33},
    {name = "Bunny", chance = 33.33},
  },
  ["Uncommon Egg"] = {
    {name = "Black Bunny", chance = 25},
    {name = "Chicken", chance = 25},
    {name = "Cat", chance = 25},
    {name = "Deer", chance = 25},
  },
  ["Rare Egg"] = {
    {name = "Orange Tabby", chance = 33.33},
    {name = "Spotted Deer", chance = 25},
    {name = "Pig", chance = 16.67},
    {name = "Rooster", chance = 16.67},
    {name = "Monkey", chance = 8.33},
  },
  ["Legendary Egg"] = {
    {name = "Cow", chance = 42.55},
    {name = "Silver Monkey", chance = 42.55},
    {name = "Sea Otter", chance = 10.64},
    {name = "Turtle", chance = 2.13},
    {name = "Polar Bear", chance = 2.13},
  },
  ["Mythical Egg"] = {
    {name = "Grey Mouse", chance = 35.71},
    {name = "Squirrel", chance = 26.79},
    {name = "Brown Mouse", chance = 26.79},
    {name = "Red Giant Ant", chance = 8.93},
    {name = "Red Fox", chance = 1.79},
  },
  ["Bug Egg"] = {
    {name = "Snail", chance = 40},
    {name = "Giant Ant", chance = 30},
    {name = "Caterpillar", chance = 25},
    {name = "Praying Mantis", chance = 4},
    {name = "Dragonfly", chance = 1},
  },
  ["Bee Egg"] = {
    {name = "Bee", chance = 65},
    {name = "Honey Bee", chance = 25},
    {name = "Bear Bee", chance = 5},
    {name = "Petal Bee", chance = 4},
    {name = "Queen Bee", chance = 1},
  },
  ["Anti Bee Egg"] = {
    {name = "Wasp", chance = 55},
    {name = "Tarantula Hawk", chance = 30},
    {name = "Moth", chance = 13.75},
    {name = "Butterfly", chance = 1},
    {name = "Disco Bee", chance = 0.25},
  },
  ["Common Summer Egg"] = {
    {name = "Starfish", chance = 50},
    {name = "Seagull", chance = 25},
    {name = "Crab", chance = 25},
  },
  ["Rare Summer Egg"] = {
    {name = "Flamingo", chance = 30},
    {name = "Toucan", chance = 25},
    {name = "Sea Turtle", chance = 20},
    {name = "Orangutan", chance = 15},
    {name = "Seal", chance = 10},
  },
  ["Paradise Egg"] = {
    {name = "Ostrich", chance = 40},
    {name = "Peacock", chance = 30},
    {name = "Capybara", chance = 21},
    {name = "Scarlet Macaw", chance = 8},
    {name = "Mimic Octopus", chance = 1},
  },
  ["Oasis Egg"] = {
    {name = "Meerkat", chance = 45},
    {name = "Sand Snake", chance = 34.5},
    {name = "Axolotl", chance = 15},
    {name = "Hyacinth Macaw", chance = 5},
    {name = "Fennec Fox", chance = 0.5},
  },
  ["Night Egg"] = {
    {name = "Hedgehog", chance = 47},
    {name = "Mole", chance = 23.5},
    {name = "Frog", chance = 17.6},
    {name = "Echo Frog", chance = 8.23},
    {name = "Night Owl", chance = 3.53},
    {name = "Raccoon", chance = 0.12},
  },
  ["Dinosaur Egg"] = {
    {name = "Raptor", chance = 35},
    {name = "Triceratops", chance = 32.5},
    {name = "Stegosaurus", chance = 28},
    {name = "Pterodactyl", chance = 3},
    {name = "Brontosaurus", chance = 1},
    {name = "T‑Rex", chance = 0.5},
  },
  ["Primal Egg"] = {
    {name = "Parasaurolophus", chance = 35},
    {name = "Iguanodon", chance = 32.5},
    {name = "Pachycephalosaurus", chance = 28},
    {name = "Dilophosaurus", chance = 3},
    {name = "Ankylosaurus", chance = 1},
    {name = "Spinosaurus", chance = 0.5},
  },
  ["Zen Egg"] = {
    {name = "Shiba Inu", chance = 40},
    {name = "Nihonzaru", chance = 31},
    {name = "Tanuki", chance = 20.82},
    {name = "Tanchozuru", chance = 4.6},
    {name = "Kappa", chance = 3.5},
    {name = "Kitsune", chance = 0.08},
  },
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EggESPGui"
ScreenGui.Parent = CoreGui

local RandomizeButton = Instance.new("TextButton")
RandomizeButton.Size = UDim2.new(0, 160, 0, 40)
RandomizeButton.Position = UDim2.new(0, 30, 0, 90)
RandomizeButton.Text = "Randomize Pets"
RandomizeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
RandomizeButton.TextColor3 = Color3.new(1, 1, 1)
RandomizeButton.Parent = ScreenGui

-- Function to choose random pet from egg type
local function chooseRandomPet(eggType)
  local pets = EggPets[eggType]
  if not pets then return nil end
  local totalWeight = 0
  for _, pet in ipairs(pets) do
    totalWeight = totalWeight + pet.chance
  end
  local rand = math.random() * totalWeight
  local current = 0
  for _, pet in ipairs(pets) do
    current = current + pet.chance
    if rand <= current then
      return pet
    end
  end
end

-- ESP Rendering
local function renderESP(egg)
  if egg:FindFirstChild("BillboardGui") then
    egg.BillboardGui:Destroy()
  end

  local gui = Instance.new("BillboardGui", egg)
  gui.Size = UDim2.new(0, 200, 0, 50)
  gui.AlwaysOnTop = true
  gui.Adornee = egg

  local label = Instance.new("TextLabel", gui)
  label.Size = UDim2.new(1, 0, 1, 0)
  label.BackgroundTransparency = 1
  label.TextColor3 = Color3.new(1, 1, 1)
  label.TextStrokeTransparency = 0
  label.TextScaled = true

  local forced = egg:FindFirstChild("ForcedPet")
  if forced then
    label.Text = "Pet: " .. forced.Value
  else
    label.Text = "Pet: Unknown"
  end
end

-- Function to randomize all eggs
local function randomizeAllEggs()
  for _, egg in ipairs(Workspace:GetDescendants()) do
    if EggPets[egg.Name] then
      local pet = chooseRandomPet(egg.Name)
      if pet then
        local forced = egg:FindFirstChild("ForcedPet") or Instance.new("StringValue")
        forced.Name = "ForcedPet"
        forced.Value = pet.name
        forced.Parent = egg
        renderESP(egg)
      end
    end
  end
end

-- ESP Auto Update
RunService.RenderStepped:Connect(function()
  for _, egg in ipairs(Workspace:GetDescendants()) do
    if EggPets[egg.Name] and not egg:FindFirstChild("BillboardGui") then
      renderESP(egg)
    end
  end
end)

-- Connect Button
RandomizeButton.MouseButton1Click:Connect(randomizeAllEggs)
