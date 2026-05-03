local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Server Joiner", "DarkScene")

local Main = Window:NewTab("Server")
local Section = Main:NewSection("Auto Joiner")

Section:NewButton("Server Hop", "Перейти на інший сервер", function()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    
    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        
        for i,v in pairs(Site.data) do
            if tostring(v.id) ~= tostring(game.JobId) then -- Щоб не заходило на той самий сервер
                if tonumber(v.playing) < tonumber(v.maxPlayers) then
                    table.insert(AllIDs, v.id)
                end
            end
        end
    end

    function Teleport()
        pcall(function()
            TPReturner()
            if #AllIDs > 0 then
                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], game.Players.LocalPlayer)
            end
        end)
    end
    
    Teleport()
end)
