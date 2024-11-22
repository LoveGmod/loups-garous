local function SaveSeatsAndHouses(player, args)
    local seats = {}
    local houses = {}

    for i, seat in ipairs(ents.FindByModel("models/nova/airboat_seat.mdl")) do
        table.insert(seats, {seat:GetPos().x, seat:GetPos().y, seat:GetPos().z, seat:GetAngles().p, seat:GetAngles().y, seat:GetAngles().r})
    end

    for i, house in ipairs(ents.FindByModel("models/props_lab/huladoll.mdl")) do
        table.insert(houses, {house:GetPos().x, house:GetPos().y, house:GetPos().z, house:GetAngles().p, house:GetAngles().y, house:GetAngles().r})
    end

    if not file.Exists("loups-garous", "DATA") then
        file.CreateDir("loups-garous")
    end

    local data = {
        seats = seats,
        houses = houses,
    }

    file.Write("loups-garous/"..game.GetMap().."_data.txt", util.TableToJSON(data, true))
    player:ChatPrint("Les sièges et maisons ont été sauvegardés avec succès.")
    game.CleanUpMap()
end

local function DebugSeatsAndHouses(player, args)
    if args[3] == "show" then
        for i, ent in ipairs(ents.GetAll()) do
            if ent:GetModel() == "models/nova/airboat_seat.mdl" or ent:GetModel() == "models/props_lab/huladoll.mdl" then
                ent:SetColor(Color(255, 255, 255, 255))
                ent:SetSolid(SOLID_VPHYSICS)
            end
        end

        player:ChatPrint("Les sièges et maisons sont désormais visibles.")
    elseif args[3] == "hide" then
        for i, ent in ipairs(ents.GetAll()) do
            if ent:GetModel() == "models/nova/airboat_seat.mdl" or ent:GetModel() == "models/props_lab/huladoll.mdl" then
                ent:SetColor(Color(255, 255, 255, 0))
                ent:SetSolid(SOLID_NONE)
                ent:GetPhysicsObject():EnableMotion(false)
            end
        end

        player:ChatPrint("Les sièges et maisons sont désormais invisibles.")
    end
end

local function GetEntityModel(player, args)
    local trace = player:GetEyeTrace()

    if IsValid(trace.Entity) then
        local model = trace.Entity:GetModel()

        if model then
            player:ChatPrint(model)
        else
            player.ChatPrint("Aucun modèle pour cette entité.")
        end
    else
        player:ChatPrint("Vous ne regardez aucune entité.")
    end
end

local cmds = {}

local function RegisterCommand(cmd, callback)
    cmds[cmd] = callback
end

RegisterCommand("getEntity", GetEntityModel)
RegisterCommand("debug", DebugSeatsAndHouses)
RegisterCommand("save", SaveSeatsAndHouses)

hook.Add("PlayerSay", "LG_Commands", function(player, text)
    text = string.lower(text)
    local args = string.Split(text, " ")

    if args[1] == "!lg" then
        if not player:IsSuperAdmin() then return end

        if not cmds[args[2]] then return end

        cmds[args[2]](player, args)

        return ""
    end
end)