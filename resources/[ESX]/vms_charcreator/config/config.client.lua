Config.AfterCreatedFirstCharacter = function()
    -- HERE YOU CAN ADD CINEMATIC JOIN OF ANYTHING OTHER
    if GetResourceState("vms_spawnselector") == 'started' then
        exports['vms_spawnselector']:OpenSpawnSelector(true)
    end
    
    -- Ajoute cette ligne pour rafraîchir l'HUD après création du personnage
    TriggerEvent('foltone_hud_nemo:refreshAge')
end