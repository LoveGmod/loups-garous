local GM = GM

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
    NIGHT2 = 3,
}

function GM:CreateTeams()
    team.SetUp(GM.TEAM.SPECTATOR, "Spectateur")
    team.SetUp(GM.TEAM.DEAD, "Mort")
    team.SetUp(GM.TEAM.VILLAGER, "Villageois")
    team.SetUp(GM.TEAM.WEREWOLF, "Loup Garou")
end