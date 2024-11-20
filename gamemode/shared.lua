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