local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then
    warn("Не вдалося завантажити UI бібліотеку")
    return
end

-- Спробуємо "Light" тему або взагалі без теми, якщо "DarkScene" видає помилку
local Window = Library.CreateLib("Server Joiner", "Light")

local Main = Window:NewTab("Server")
local Section = Main:NewSection("Auto Joiner")

Section:NewButton("Server Hop", "Перейти на інший сервер", function()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    
    local function TPReturner()
        local Site;
        local url = 'https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'
        if foundAnything ~= "" then
            url = url .. '&cursor=' .. foundAnything
        end
        
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            local data = game.HttpService:JSONDecode(result)
            if data.nextPageCursor and data.nextPageCursor ~= "null" then
                foundAnything = data.nextPageCursor
            end
            
            for i, v in pairs(data.data) do
                if tostring(v.id) ~= tostring(game.JobId) then
                    if tonumber(v.playing) < tonumber(v.maxPlayers) then
                        table.insert(AllIDs, v.id)
                    end
                end
            end
        end
    end

    local function Teleport()
        TPReturner()
        if #AllIDs > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], game.Players.LocalPlayer)
        else
            warn("Доступних серверів не знайдено")
        end
    end
    
    Teleport()
end)
