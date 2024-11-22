GM.Name = "Loups Garous"
GM.Author = "Love Gmod"
GM.Email = "N/A"
GM.Website = "N/A"

DeriveGamemode("sandbox")

function GM:Initialize()
    
end

function GM:HUDShouldDraw(name)
    local hudToHide = {
        ["CHudHealth"] = true,
        ["CHudBattery"] = true,
        ["CHudAmmo"] = true,
        ["CHudSecondaryAmmo"] = true,
    }

    if hudToHide[name] then
        return false
    end

    return true
end

GM.TEAM = {
    NONE = TEAM_UNASSIGNED,
    SPECTATOR = 1,
    DEAD = 2,
    VILLAGER = 3,
    WEREWOLF = 4,
}

GM.PHASE = {
    LOBBY = 0,
    DAY = 1,
    NIGHT = 2,
}

function GM:CreateTeams()
    team.SetUp(TEAM.SPECTATOR, "Spectateur")
    team.SetUp(TEAM.DEAD, "Mort")
    team.SetUp(TEAM.VILLAGER, "Villageois")
    team.SetUp(TEAM.WEREWOLF, "Loup Garou")
end