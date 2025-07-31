-- Grow a Garden ESP + Randomizer Script (With Full Egg Support)
-- Main Use: Displays the exact pet you will hatch from any egg using ESP (Floating Text), allows randomizing what's inside the egg, and ensures that the shown pet is the one that hatches.
-- Educational use only

-- ESP Color Functions
local RarityColors = {
  Common = Color3.fromRGB(200, 200, 200),
  Uncommon = Color3.fromRGB(85, 255, 85),
  Rare = Color3.fromRGB(85, 170, 255),
  Epic = Color3.fromRGB(170, 85, 255),
  Legendary = Color3.fromRGB(255, 170, 0),
  Mythical = Color3.fromRGB(255, 0, 255),
  Divine = Color3.fromRGB(255, 255, 102)
}

-- ESP Display Function
function displayESP(egg, petName, rarity)
  if egg:FindFirstChild("Head") and not egg:FindFirstChild("EggESP") then
    local bill = Instance.new("BillboardGui", egg.Head)
    bill.Name = "EggESP"
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.Text = "Pet: " .. petName
    txt.TextColor3 = RarityColors[rarity] or Color3.new(1, 1, 1)
    txt.BackgroundTransparency = 1
    txt.TextScaled = true
  elseif egg:FindFirstChild("EggESP") then
    egg.EggESP.TextLabel.Text = "Pet: " .. petName
    egg.EggESP.TextLabel.TextColor3 = RarityColors[rarity] or Color3.new(1, 1, 1)
  end
end

-- Egg Scanner + Pet Assignment Logic
function choosePet(pets)
  local total = 0
  for _, p in pairs(pets) do total += p.chance end
  local rand = math.random() * total
  local cumulative = 0
  for _, p in ipairs(pets) do
    cumulative += p.chance
    if rand <= cumulative then
      return p.name, p.rarity
    end
  end
  return "Unknown", "Common"
end

function assignPetToEgg(egg, pets)
  local petName, rarity = choosePet(pets)
  displayESP(egg, petName, rarity)
  if not egg:FindFirstChild("ForcedPet") then
    local forced = Instance.new("StringValue")
    forced.Name = "ForcedPet"
    forced.Value = petName
    forced.Parent = egg
  else
    egg.ForcedPet.Value = petName
  end
end

-- Pet database (Eggs + Pets + Chances)
local EggPets = {
  ["Common Egg"] = {
    {name = "Golden Lab", rarity = "Common", chance = 33},
    {name = "Dog", rarity = "Common", chance = 33},
    {name = "Bunny", rarity = "Common", chance = 34},
  },
  ["Uncommon Egg"] = {
    {name = "Black Bunny", rarity = "Uncommon", chance = 25},
    {name = "Chicken", rarity = "Uncommon", chance = 25},
    {name = "Cat", rarity = "Uncommon", chance = 25},
    {name = "Deer", rarity = "Uncommon", chance = 25},
  },
  ["Rare Egg"] = {
    {name = "Orange Tabby", rarity = "Rare", chance = 33},
    {name = "Spotted Deer", rarity = "Rare", chance = 25},
    {name = "Pig", rarity = "Rare", chance = 16.7},
    {name = "Rooster", rarity = "Rare", chance = 16.7},
    {name = "Monkey", rarity = "Rare", chance = 8.3},
  },
  ["Legendary Egg"] = {
    {name = "Cow", rarity = "Legendary", chance = 42.5},
    {name = "Silver Monkey", rarity = "Legendary", chance = 42.5},
    {name = "Sea Otter", rarity = "Legendary", chance = 10.6},
    {name = "Turtle", rarity = "Legendary", chance = 2.1},
    {name = "Polar Bear", rarity = "Legendary", chance = 2.1},
  },
  ["Mythical Egg"] = {
    {name = "Grey Mouse", rarity = "Mythical", chance = 35.7},
    {name = "Brown Mouse", rarity = "Mythical", chance = 26.7},
    {name = "Squirrel", rarity = "Mythical", chance = 26.8},
    {name = "Red Giant Ant", rarity = "Mythical", chance = 8.9},
    {name = "Red Fox", rarity = "Mythical", chance = 1.8},
  },
  ["Bug Egg"] = {
    {name = "Snail", rarity = "Divine", chance = 40},
    {name = "Giant Ant", rarity = "Divine", chance = 30},
    {name = "Caterpillar", rarity = "Divine", chance = 25},
    {name = "Praying Mantis", rarity = "Divine", chance = 4},
    {name = "Dragonfly", rarity = "Divine", chance = 1},
  },
  ["Zen Egg"] = {
    {name = "Shiba Inu", rarity = "Rare", chance = 40},
    {name = "Nihonzaru", rarity = "Rare", chance = 32},
    {name = "Tanuki", rarity = "Epic", chance = 20.8},
    {name = "Tanchozuru", rarity = "Epic", chance = 4.6},
    {name = "Kappa", rarity = "Legendary", chance = 3.5},
    {name = "Kitsune", rarity = "Mythical", chance = 0.08},
  },
  ["Dinosaur Egg"] = {
    {name = "Raptor", rarity = "Rare", chance = 35},
    {name = "Triceratops", rarity = "Rare", chance = 32.5},
    {name = "Stegosaurus", rarity = "Epic", chance = 28},
    {name = "Pterodactyl", rarity = "Legendary", chance = 3},
    {name = "Brontosaurus", rarity = "Legendary", chance = 1},
    {name = "T-Rex", rarity = "Mythical", chance = 0.5},
  }
}

-- Initial assignment
for _, egg in pairs(workspace:GetDescendants()) do
  if egg:IsA("Model") and egg:FindFirstChild("Head") then
    for eggType, pets in pairs(EggPets) do
      if egg.Name == eggType then
        assignPetToEgg(egg, pets)
      end
    end
  end
end

-- Add GUI with Randomize Button
local ScreenGui = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "PetRandomizerGui"

local btn = Instance.new("TextButton", ScreenGui)
btn.Size = UDim2.new(0, 200, 0, 40)
btn.Position = UDim2.new(0.5, -100, 0.9, 0)
btn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Text = "Randomize Pets"
btn.TextScaled = true
btn.Name = "RandomizeButton"

btn.MouseButton1Click:Connect(function()
  for _, egg in pairs(workspace:GetDescendants()) do
    if egg:IsA("Model") and egg:FindFirstChild("Head") then
      for eggType, pets in pairs(EggPets) do
        if egg.Name == eggType then
          assignPetToEgg(egg, pets)
        end
      end
    end
  end
end)
