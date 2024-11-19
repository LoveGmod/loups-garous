include("shared.lua")

function HideHud(name)
    for index, value in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
        if name == value then
            return false
        end
    end
end

hook.Add("HudShouldDraw", "HideDefaultHud", HideHud)