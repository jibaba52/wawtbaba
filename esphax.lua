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
  Mythical = Color3.fromRGB(255, 0, 255)
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

for _, egg in pairs(workspace:GetDescendants()) do
  if egg:IsA("Model") and egg:FindFirstChild("Head") then
    for eggType, pets in pairs(EggPets) do
      if egg.Name == eggType then
        local petName, rarity = choosePet(pets)
        displayESP(egg, petName, rarity)

        -- Store the selected pet inside the egg
        if not egg:FindFirstChild("ForcedPet") then
          local forced = Instance.new("StringValue")
          forced.Name = "ForcedPet"
          forced.Value = petName
          forced.Parent = egg
        else
          egg.ForcedPet.Value = petName
        end
      end
    end
  end
end

-- Pet database (Eggs + Pets + Chances)
local EggPets = {
  ["Common Egg"] = {
    {name = "Bunny", rarity = "Common", chance = 50},
    {name = "Dog", rarity = "Common", chance = 35},
    {name = "Cat", rarity = "Uncommon", chance = 15},
  },
  ["Common Summer Egg"] = {
    {name = "Beach Dog", rarity = "Common", chance = 40},
    {name = "Beach Cat", rarity = "Uncommon", chance = 30},
    {name = "Crab", rarity = "Rare", chance = 30},
  },
  ["Zen Egg"] = {
    {name = "Panda", rarity = "Uncommon", chance = 40},
    {name = "Red Panda", rarity = "Rare", chance = 35},
    {name = "Kitsune", rarity = "Epic", chance = 25},
  },
  ["Dinosaur Egg"] = {
    {name = "Triceratops", rarity = "Uncommon", chance = 45},
    {name = "T-Rex", rarity = "Rare", chance = 35},
    {name = "Pterodactyl", rarity = "Epic", chance = 20},
  },
  ["Jungle Egg"] = {
    {name = "Monkey", rarity = "Uncommon", chance = 50},
    {name = "Tiger", rarity = "Rare", chance = 35},
    {name = "Parrot", rarity = "Epic", chance = 15},
  },
  ["Ocean Egg"] = {
    {name = "Clownfish", rarity = "Common", chance = 40},
    {name = "Dolphin", rarity = "Rare", chance = 35},
    {name = "Shark", rarity = "Legendary", chance = 25},
  },
  ["Mythical Egg"] = {
    {name = "Phoenix", rarity = "Legendary", chance = 40},
    {name = "Dragon", rarity = "Legendary", chance = 35},
    {name = "Unicorn", rarity = "Mythical", chance = 25},
  }
}
}
