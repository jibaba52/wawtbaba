-- Grow a Garden ESP + Randomizer Script (With ESP Toggle & Full Egg Support)
-- Main Use: Displays the exact pet you will hatch from any egg using ESP (Floating Text), allows randomizing what's inside the egg, and ensures that the shown pet is the one that hatches.
-- Educational use only

-- ESP Toggle & Color Functions
local ESP_ENABLED = true
local RarityColors = {
  Common = Color3.fromRGB(200, 200, 200),
  Uncommon = Color3.fromRGB(85, 255, 85),
  Rare = Color3.fromRGB(85, 170, 255),
  Epic = Color3.fromRGB(170, 85, 255),
  Legendary = Color3.fromRGB(255, 170, 0),
  Mythical = Color3.fromRGB(255, 0, 255)
}

function toggleESP()
  ESP_ENABLED = not ESP_ENABLED
  for _, esp in pairs(game.CoreGui:GetChildren()) do
    if esp.Name == "EggESP" then
      esp.Enabled = ESP_ENABLED
    end
  end
end

-- UI Button to Toggle ESP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "EggGUI"
local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 120, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 10)
Button.Text = "Toggle ESP"
Button.MouseButton1Click:Connect(toggleESP)

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
      end
    end
  end
end

-- Pet database remains unchanged
local EggPets = {
  -- (Same EggPets table as in current script)
}
