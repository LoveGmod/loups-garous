AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function GM:PlayerSpawn(player, transition)
    player:SetupHands()
    player:Give("weapon_physgun")
end