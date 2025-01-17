-- A table containing all hooks that should be logged for this gamemode.
local loggedHooks = {
    {
        name = "PlayerInitialSpawn",
        callback = function( ply, transition )

        end
    }
}

-->> Monitored hooks.
    -- PlayerInitialSpawn
    -- PlayerDisconnected
    -- PlayerConnect
    -- PlayerSpawnedProp
    -- PlayerSpawnedNPC
    -- PlayerSpawnedEffect
    -- PlayerSpawnedSENT
    -- PlayerSpawnedSWEP
    -- PlayerSpawnedVehicle
    -- PlayerGiveSWEP
    -- TOOL:Deploy
    -- WEAON:PrimaryAttack
    -- WEAPON:SecondaryAttack


local function _PlayerSpawnedProp()

end

local function _PlayerSpawnedNPC()