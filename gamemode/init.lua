AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("commands.lua")

local GM = GM

function GM:PlayerSpawn(player, transition)
    local villagerModels = {
        "models/player/group01/male_01.mdl",
        "models/player/group01/male_02.mdl",
        "models/player/group01/male_03.mdl",
        "models/player/group01/male_04.mdl",
        "models/player/group01/male_05.mdl",
        "models/player/group01/male_06.mdl",
        "models/player/group01/male_07.mdl",
        "models/player/group01/male_08.mdl",
        "models/player/group01/male_09.mdl",
        "models/player/group01/female_01.mdl",
        "models/player/group01/female_02.mdl",
        "models/player/group01/female_03.mdl",
        "models/player/group01/female_04.mdl",
        "models/player/group01/female_05.mdl",
        "models/player/group01/female_06.mdl",
    }

    local randomModel = table.Random(villagerModels)

    player:SetModel(randomModel)
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
    GM.PlayersSeats = {}

    for i, seat in ipairs(ents.FindByModel("models/nova/airboat_seat.mdl")) do
        table.insert(availableSeatsIds, seat:EntIndex())
    end

    for i, player in ipairs(player.GetAll()) do
        local seatId = table.remove(availableSeatsIds, math.random(#availableSeatsIds))
        local seat = Entity(seatId)

        GM.PlayersSeats[player] = seat
    end

    local availableHousesIds = {}
    GM.PlayersHouses = {}

    for i, house in ipairs(ents.FindByModel("models/props_lab/huladoll.mdl")) do
        table.insert(availableHousesIds, house:EntIndex())
    end

    for i, player in ipairs(player.GetAll()) do
        local houseId = table.remove(availableHousesIds, math.random(#availableHousesIds))
        local house = Entity(houseId)

        GM.PlayersHouses[player] = house
    end

    GM:SetPhase(GM.PHASE.DAY)
end

function GM:SetPhase(phase)
    self.CurrentPhase = phase

    if phase == self.PHASE.DAY then
        PrintTable(GM.PlayersSeats)
        for player, seat in pairs(GM.PlayersSeats) do
            player:ExitVehicle()
            player:SetPos(seat:GetPos() + Vector(0, 0, 30))
            player:EnterVehicle(seat)
        end
    end
end

concommand.Add("lg_start_game", StartGame)
hook.Add("InitPostEntity", "LG_LoadSeatsAndHouses", LoadSeatsAndHouses)
hook.Add("PostCleanupMap", "LG_RespawnSeatsAndHouses", LoadSeatsAndHouses)
hook.Add("CanExitVehicle", "LG_CanExitVehicle", function()
    return false
end)