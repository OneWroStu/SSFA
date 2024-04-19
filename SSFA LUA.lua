local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", screenGui)
local toggleButton = Instance.new("TextButton", frame)
local minimizeButton = Instance.new("TextButton", frame)
local active = false
local minimized = false
local mouse = player:GetMouse()

-- Configuração da Frame
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- Botão de ativar/desativar
toggleButton.Text = "Ativar"
toggleButton.Size = UDim2.new(0, 180, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 250)

-- Botão de minimizar
minimizeButton.Text = "Minimizar"
minimizeButton.Size = UDim2.new(0, 180, 0, 40)
minimizeButton.Position = UDim2.new(0, 10, 0, 50)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 250, 100)

-- Funções de automação
function findEnemies()
    local enemies = {"Fishbone", "Frog Hollow"}
    local foundEnemies = {}
    for _, enemyName in pairs(enemies) do
        for _, instance in pairs(workspace:GetDescendants()) do
            if instance:IsA("Model") and instance.Name == enemyName then
                table.insert(foundEnemies, instance)
            end
        end
    end
    return foundEnemies
end

function teleportToEnemies(enemies)
    if #enemies > 0 then
        local targetEnemy = enemies[1]  -- Pega o primeiro inimigo encontrado
        player.Character:MoveTo(targetEnemy.Position)
        return true
    else
        return false
    end
end

function spamClick()
    while active do
        mouse:Click()
        wait(0.1)  -- Intervalo entre cliques para evitar sobrecarga
    end
end

-- Main loop
function mainLoop()
    while active do
        local enemiesFound = findEnemies()
        if #enemiesFound > 0 then
            if teleportToEnemies(enemiesFound) then
                spamClick()
            end
        end
        wait(1)  -- Verifica a presença dos inimigos a cada segundo
    end
end

-- Corrotina para executar o main loop assincronamente
function startMainLoop()
    if coroutine.status(mainCoroutine) == "dead" then
        mainCoroutine = coroutine.create(mainLoop)
        coroutine.resume(mainCoroutine)
    end
end

-- Conexões dos botões
toggleButton.MouseButton1Click:Connect(function()
    active = not active
    toggleButton.Text = active and "Desativar" or "Ativar"
    if active then
        print("Script ativado")
        startMainLoop()
    else
        print("Script desativado")
        if mainCoroutine then
            coroutine.close(mainCoroutine)
        end
    end
end)

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame.Size = minimized and UDim2.new(0, 200, 0, 40) or UDim2.new(0, 200, 0, 100)
    minimizeButton.Position = minimized and UDim2.new(0, 10, 0, 10) or UDim2.new(0, 10, 0, 50)
    toggleButton.Visible = not minimized
    minimizeButton.Text = minimized and "Maximizar" or "Minimizar"
end)

local mainCoroutine = coroutine.create(mainLoop)
