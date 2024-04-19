local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local enemies = {"Fishbone", "Frog Hollow"}

function findAndAttackEnemies()
    local found = false
    for _, enemyName in pairs(enemies) do
        local enemy = workspace:FindFirstChild(enemyName)
        if enemy then
            player.Character:MoveTo(enemy.Position)
            found = true
            break
        end
    end
    return found
end

function spamClick()
    while true do
        mouse:Click()
        wait(0.1)
    end
end

local attacking = false
while true do
    if findAndAttackEnemies() and not attacking then
        attacking = true
        spamClick()
    else
        attacking = false
        wait(1)  -- Ajuste para verificação a cada segundo
    end
end
