AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("commands.lua")

--GM.game.phase = PHASE.LOBBY

function GM:PlayerSpawn(player, transition)
    player:SetupHands()
    player:Give("weapon_physgun")
end

local function LoadSeatsAndHouses()
    if not file.Exists("loups-garous/"..game.GetMap().."_data.txt", "DATA") then return end

    local data = util.JSONToTable(file.Read("loups-garous/"..game.GetMap().."_data.txt", "DATA"))
    if not data then return end

    for i, pos in ipairs(data.seats or {}) do
        local seat = ents.Create("prop_vehicle_prisoner_pod")
        if IsValid(seat) then
            seat:SetModel("models/nova/airboat_seat.mdl")
            seat:SetPos(pos)
            seat:Spawn()

            seat:SetRenderMode(RENDERMODE_TRANSALPHA)
            seat:SetColor(Color(255, 255, 255, 0))
            seat:SetSolid(SOLID_NONE)
            seat:GetPhysicsObject():EnableMotion(false)
        end
    end

    for i, pos in ipairs(data.houses or {}) do
        local house = ents.Create("prop_physics")
        if IsValid(house) then
            house:SetModel("models/props_lab/huladoll.mdl")
            house:SetPos(pos)
            house:Spawn()

            house:SetRenderMode(RENDERMODE_TRANSALPHA)
            house:SetColor(Color(255, 255, 255, 0))
            house:SetSolid(SOLID_NONE)
            house:GetPhysicsObject():EnableMotion(false)
        end
    end

    print("[Loups-Garous] Les sièges et maisons ont été chargés.")
end

local function StartGame()
    local availableSeatsIds = {}
    local playersSeats = {}

    for i, seat in ipairs(ents.FindByModel("models/nova/airboat_seat.mdl")) do
        table.insert(availableSeatsIds, seat:EntIndex())
    end

    for i, player in ipairs(player.GetAll()) do
        local seatId = table.remove(availableSeatsIds, math.random(#availableSeatsIds))
        local seat = Entity(seatId)

        playersSeats[player] = seat
    end

    local availableHousesIds = {}
    local playersHouses = {}

    for i, house in ipairs(ents.FindByModel("models/props_lab/huladoll.mdl")) do
        table.insert(availableHousesIds, house:EntIndex())
    end

    for i, player in ipairs(player.GetAll()) do
        local houseId = table.remove(availableHousesIds, math.random(#availableHousesIds))
        local house = Entity(houseId)

        playersHouses[player] = house
    end

    PrintTable(playersSeats)
    PrintTable(playersHouses)
end

function GM:SetPhase(phase)
    
end

concommand.Add("lg_start_game", StartGame)
hook.Add("InitPostEntity", "LG_LoadSeatsAndHouses", LoadSeatsAndHouses)
hook.Add("PostCleanupMap", "LG_RespawnSeatsAndHouses", LoadSeatsAndHouses)