local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Lennze Hub | Blox Fruits", "DarkScene")

-- Tabs
local Misc = Window:NewTab("Misc")
local MiscSection = Misc:NewSection("Settings")

MiscSection:NewButton("Server Hop", "Join another server", function()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            ID = tostring(v.id)
            if tonumber(v.playing) < tonumber(v.maxPlayers) then
                local t = true
                if not t then
                else
                    table.insert(AllIDs, ID)
                    wait()
                end
            end
        end
    end

    function Teleport()
        while wait() do
            pcall(function()
                TPReturner()
                if ("" ~= "") then
                    if #AllIDs > 0 then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], game.Players.LocalPlayer)
                    end
                else
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], game.Players.LocalPlayer)
                end
            end)
        end
    end
    Teleport()
end)
