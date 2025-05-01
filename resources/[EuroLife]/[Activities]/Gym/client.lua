
-- Variables globales
local isNearExersices = false
local isAtExersice = false
local isTraining = false
local exerciseProgress = 0
local currentExersice = nil
local lowMuscleEffectActive = false  -- État de la pénalité
local consecutiveTrainingTime = 0    -- Temps d'entraînement consécutif
local isOverheated = false           -- État de surchauffe
local lastReminder = 0               -- Dernier rappel d'entraînement

-- Configuration du Gym
local GymConfig = {
    -- Progression de musculation
    ExerciseIncrement = 4,         -- Augmentation par exercice
    MaxProgress = 100,
    NotificationDuration = 8000,
    MuscleGaugeDecreaseRate = 1,
    MuscleGaugeThreshold = 20,
    
    -- Pénalité de vitesse
    LowMuscleThreshold = 30,       -- Seuil en dessous duquel le joueur est ralenti
    SpeedPenaltyFactor = 0.7,      -- 70% de la vitesse normale quand faible
    
    -- Soif
    ThirstDecreaseRate = 1,        -- Diminution de la soif par cycle d'exercice
    
    -- Surchauffe
    MaxConsecutiveTraining = 10,   -- Nombre max d'exercices consécutifs (en cycles de 5 secondes)
    OverheatRecoveryTime = 30000,  -- Temps de récupération après surchauffe (30 secondes)
    OverheatBlackoutTime = 20000,  -- Durée pendant laquelle le joueur est KO (20 secondes)
    
    -- Rappels pour s'entraîner
    ReminderInterval = 1800000,    -- 30 minutes entre les rappels
    
    -- Messages de notification pour différents niveaux de musculation
    MuscleTierMessages = {
        [25] = {title = "Muscles faibles", message = "Vous manquez de forme physique."},
        [50] = {title = "Muscles développés", message = "Votre forme physique s'améliore."},
        [75] = {title = "Muscles impressionnants", message = "Votre corps est tonique et fort."},
        [100] = {title = "Muscles parfaits", message = "Vous êtes au sommet de votre forme physique!"}
    }
}

Citizen.CreateThread(function()
    -- Vérifier si les blips sont activés dans la config
    if Config.EnableBlip then
        -- Parcourir chaque salle de sport et créer son blip
        for _, gym in ipairs(Config.Gyms) do
            local blip = AddBlipForCoord(
                gym.Blip.Pos.x, 
                gym.Blip.Pos.y, 
                gym.Blip.Pos.z
            )
            
            -- Configurer le blip selon les paramètres de la config
            SetBlipSprite(blip, gym.Blip.Sprite)
            SetBlipDisplay(blip, gym.Blip.Display)
            SetBlipScale(blip, gym.Blip.Scale)
            SetBlipColour(blip, gym.Blip.Colour)
            SetBlipAsShortRange(blip, true)
            
            -- Ajouter le nom
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(gym.Blip.Name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

------------------------------------------
-- FONCTIONS UTILITAIRES
------------------------------------------

-- Mise à jour HUD
function UpdateMuscleBar(value)
    --print("[GYM] Envoi muscle: " .. tostring(value))
    exports["foltone_hud_nemo"]:updateMuscle(value)
    
    -- Notifications basées sur les paliers de musculation
    for tier, data in pairs(GymConfig.MuscleTierMessages) do
        if value == tier then
            exports["foltone_hud_nemo"]:FoltoneNotification(
                "Sport",
                data.title,
                data.message,
                "LOGO",
                GymConfig.NotificationDuration
            )
            break
        end
    end
end

-- Debug
function DebugPrint(message)
    --print(string.format("[GYM DEBUG] %s", message))
end

-- Fonction pour diminuer la soif
function DecreaseThirst()
    TriggerEvent("esx_status:getStatus", "thirst", function(status)
        local currentThirst = status.val / 10000
        local newThirst = math.max(currentThirst - GymConfig.ThirstDecreaseRate, 0)
        TriggerEvent("esx_status:set", "thirst", newThirst * 10000)
        
        if newThirst < 20 then
            exports["foltone_hud_nemo"]:FoltoneNotification(
                "Sport",
                "Déshydratation",
                "Vous avez ~r~soif, ~w~hydratez-vous pour continuer ~b~efficacement!",
                "LOGO",
                GymConfig.NotificationDuration
            )
        end
    end)
end

-- Fonction pour afficher les messages d'aide
function showInfobar(msg)
    CurrentActionMsg = msg
    SetTextComponentFormat('STRING')
    AddTextComponentString(CurrentActionMsg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

------------------------------------------
-- FONCTIONS PRINCIPALES
------------------------------------------

-- Fonction pour appliquer l'effet de surchauffe avec transition améliorée
function ApplyOverheatEffect()
    if isOverheated then return end
    isOverheated = true
    
    exports["foltone_hud_nemo"]:FoltoneNotification(
        "Sport",
        "Signes d'épuisement",
        "~r~Vous avez trop forcé sur vos muscles...",
        "LOGO",
        GymConfig.NotificationDuration
    )
    
    -- Effet visuel de surchauffe progressif
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        ClearPedTasksImmediately(playerPed)
        
        -- Phase 1: Premiers signes de fatigue
        SetTimecycleModifier("hud_def_desat_slight")
        AnimpostfxPlay("HeistLocate", 0, false)
        ShakeGameplayCam("DRUNK_SHAKE", 0.5)
        
        -- Animation d'essoufflement
        RequestAnimSet("move_m@buzzed")
        while not HasAnimSetLoaded("move_m@buzzed") do
            Citizen.Wait(5)
        end
        SetPedMovementClipset(playerPed, "move_m@buzzed", 1.0)
        
        -- Le joueur tient ses genoux/fait un geste de fatigue
        TaskPlayAnim(playerPed, "amb@world_human_jog_standing@male@idle_b", "idle_d", 8.0, -8.0, 3000, 0, 0, false, false, false)
        Citizen.Wait(3000)
        
        -- Phase 2: Intensification des effets
        exports["foltone_hud_nemo"]:FoltoneNotification(
            "Sport",
            "Épuisement intense",
            "~o~Votre vision se trouble et vos jambes fléchissent...",
            "LOGO",
            GymConfig.NotificationDuration
        )
        
        SetTimecycleModifier("hud_def_desat_cold")
        AnimpostfxStop("HeistLocate")
        AnimpostfxPlay("DrugsMichaelAliensFight", 0, true)
        ShakeGameplayCam("DRUNK_SHAKE", 1.5)
        
        -- Animation de titubement
        TaskPlayAnim(playerPed, "missfam5_blackout", "pass_out", 8.0, -8.0, 5000, 0, 0, false, false, false)
        Citizen.Wait(4500) -- Attendre presque la fin de l'animation
        
        -- Phase 3: Évanouissement
        exports["foltone_hud_nemo"]:FoltoneNotification(
            "Sport",
            "Perte de conscience",
            "~r~Vous vous évanouissez à cause de la surcharge musculaire!",
            "LOGO",
            GymConfig.NotificationDuration
        )
        
        SetTimecycleModifier("hud_def_desat_cold_kill")
        AnimpostfxStop("DrugsMichaelAliensFight")
        StartScreenEffect("DeathFailOut", 0, true)
        ShakeGameplayCam("DRUNK_SHAKE", 2.0)
        
        -- Joueur KO
        if not IsPedRagdoll(playerPed) and not IsEntityDead(playerPed) then
            SetPedToRagdoll(playerPed, GymConfig.OverheatBlackoutTime, GymConfig.OverheatBlackoutTime, 0, false, false, false)
            Citizen.Wait(GymConfig.OverheatBlackoutTime)
        end
        
        -- Phase 4: Récupération progressive
        StopScreenEffect("DeathFailOut")
        ShakeGameplayCam("DRUNK_SHAKE", 0.5)
        SetTimecycleModifier("hud_def_desat_slight")
        
        -- Animation de réveil
        TaskPlayAnim(playerPed, "mp_sleep", "sleep_getup_lside", 8.0, -8.0, 5000, 0, 0, false, false, false)
        Citizen.Wait(5000)
        
        -- Fin des effets
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        SetTimecycleModifier("")
        ClearTimecycleModifier()
        ResetPedMovementClipset(playerPed, 0.0)

        isOverheated = false
        consecutiveTrainingTime = 0
        
        exports["foltone_hud_nemo"]:FoltoneNotification(
            "Sport",
            "Récupération",
            "Vous vous sentez mieux, mais vos muscles ont ~r~besoin de repos.",
            "LOGO",
            GymConfig.NotificationDuration
        )
        
        -- Citizen.Wait(GymConfig.OverheatRecoveryTime - 10000) -- Ajusté pour compenser le temps des animations
        -- isOverheated = false
        -- consecutiveTrainingTime = 0
    end)
end

------------------------------------------
-- THREADS PRINCIPAUX
------------------------------------------

-- Diminution progressive de la musculation
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(780000) -- Toutes les 13 minutes
        if not isTraining then -- Diminue seulement si pas en train de s'entraîner
            exerciseProgress = math.max(exerciseProgress - GymConfig.MuscleGaugeDecreaseRate, 0)
            UpdateMuscleBar(exerciseProgress)
            TriggerServerEvent("gym:updateProgress", exerciseProgress) -- Sync serveur
            
            -- Message d'avertissement quand niveau bas
            if exerciseProgress <= GymConfig.MuscleGaugeThreshold then
                exports["foltone_hud_nemo"]:FoltoneNotification(
                    "Sport",
                    "Avertissement",
                    "Votre masse musculaire ~r~diminue. ~b~Faites du sport !",
                    "LOGO",
                    GymConfig.NotificationDuration
                )
            end
        end
    end
end)

-- Initialisation HUD - Chargement de la valeur du serveur au démarrage
Citizen.CreateThread(function()
    Citizen.Wait(2000) -- Attente pour que tout soit chargé
    --print("[GYM] Demande de progression au serveur...")
    TriggerServerEvent("gym:requestProgress") -- Demande la valeur initiale au serveur
end)

-- Thread pour gérer la pénalité de vitesse
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Vérification toutes les secondes
        local playerPed = PlayerPedId()
        
        -- Vérifier le niveau de musculation et appliquer/supprimer les pénalités
        if exerciseProgress < GymConfig.LowMuscleThreshold then
            -- Appliquer la pénalité de vitesse si pas déjà active
            if not lowMuscleEffectActive then
                lowMuscleEffectActive = true
                
                -- Notification au joueur
                exports["foltone_hud_nemo"]:FoltoneNotification(
                    "Sport",
                    "Faiblesse musculaire",
                    "Vos muscles affaiblis vous ~o~ralentissent.",
                    "LOGO",
                    GymConfig.NotificationDuration
                )
            end
            
            -- Réduire la vitesse de déplacement
            SetPedMoveRateOverride(playerPed, GymConfig.SpeedPenaltyFactor)
            SetPedMaxMoveBlendRatio(playerPed, GymConfig.SpeedPenaltyFactor)
            
        else
            -- Retirer la pénalité si elle était active
            if lowMuscleEffectActive then
                lowMuscleEffectActive = false
                
                -- Notification de récupération
                exports["foltone_hud_nemo"]:FoltoneNotification(
                    "Sport",
                    "Récupération musculaire",
                    "Votre force retrouvée vous permet de vous déplacer ~g~normalement.",
                    "LOGO",
                    GymConfig.NotificationDuration
                )
                
                -- Restaurer la vitesse normale
                SetPedMoveRateOverride(playerPed, 1.0)
                SetPedMaxMoveBlendRatio(playerPed, 1.0)
            end
        end
    end
end)

-- Rappels périodiques pour s'entraîner quand la jauge est basse
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(GymConfig.ReminderInterval) -- 30 minutes entre chaque rappel
        
        -- Si la musculation est basse et qu'on n'est pas en train de s'entraîner
        local currentTime = GetGameTimer()
        if exerciseProgress < 40 and not isTraining and currentTime - lastReminder > GymConfig.ReminderInterval then
            lastReminder = currentTime
            
            if exerciseProgress < 20 then
                -- Rappel urgent (très faible)
                exports["foltone_hud_nemo"]:FoltoneNotification(
                    "Sport",
                    "Urgence sportive",
                    "Votre corps s'affaiblit dangereusement. ~b~Rendez-vous à la salle de sport!",
                    "LOGO",
                    GymConfig.NotificationDuration
                )
            else
                -- Rappel normal (faible)
                exports["foltone_hud_nemo"]:FoltoneNotification(
                    "Sport",
                    "Pensez à vous entraîner",
                    "Un peu d'exercice vous ferait du bien pour maintenir ~b~votre forme.",
                    "LOGO",
                    GymConfig.NotificationDuration
                )
            end
        end
    end
end)

-- Détection des zones d'exercice
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(350)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed, false)

        isNearExersices = false
        isAtExersice = false

        -- Parcourir tous les gyms et tous leurs exercices
        for _, gym in ipairs(Config.Gyms) do
            for k, v in pairs(gym.Exercises) do
                local distance = Vdist(playerCoords, v.x, v.y, v.z)
                if distance < 20.0 then
                    isNearExersices = true
                end
                if distance < 0.6 then
                    isAtExersice = true
                    currentExersice = v
                end
            end
        end
    end
end)

-- Gestion des exercices
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isNearExersices then
            -- Optionnel : DrawMarker pour visualiser les spots
        end

        if isAtExersice then
            if not isTraining then
                showInfobar(Config.ExersiceString .. '~y~' .. currentExersice.type)
            else
                showInfobar(Config.AbortString)
            end

            if IsControlJustReleased(0, Config.ExersiceKey) then
                if isTraining then
                    isTraining = false
                    ClearPedTasksImmediately(PlayerPedId())
                    
                    -- Réinitialiser le compteur quand on arrête volontairement
                    consecutiveTrainingTime = 0
                    
                    -- Augmentation de la jauge musculaire
                    local oldProgress = exerciseProgress
                    exerciseProgress = math.min(exerciseProgress + GymConfig.ExerciseIncrement, GymConfig.MaxProgress)
                    UpdateMuscleBar(exerciseProgress)
                    TriggerServerEvent("gym:updateProgress", exerciseProgress)
                    
                    -- Notification dynamique en fonction de la progression
                    local message
                    if exerciseProgress < 30 then
                        message = "Continuez pour développer vos ~p~muscles."
                    elseif exerciseProgress < 60 then
                        message = "Votre corps commence à se ~y~tonifier."
                    elseif exerciseProgress < 90 then
                        message = "Vos muscles sont bien ~o~développés!"
                    else
                        message = "Impressionnant! ~g~Vous êtes au sommet de votre forme."
                    end
                    
                    -- exports["foltone_hud_nemo"]:FoltoneNotification(
                    --     "~g~Musculation",
                    --     currentExersice.type,
                    --     string.format("~g~+%d%% ~w~%s", exerciseProgress - oldProgress, message),
                    --     "gym",
                    --     GymConfig.NotificationDuration
                    -- )
                else
                    -- Vérifier si le joueur peut s'entraîner
                    -- if isOverheated then
                    --     exports["foltone_hud_nemo"]:FoltoneNotification(
                    --         "Sport",
                    --         "Récupération nécessaire",
                    --         "Vos muscles sont encore endoloris. Attendez avant de reprendre l'entraînement.",
                    --         "LOGO",
                    --         GymConfig.NotificationDuration
                    --     )
                    --     return
                    -- end
                    
                    -- Démarrer l'exercice
                    isTraining = true
                    if currentExersice.type == 'chins' then
                        SetEntityCoords(PlayerPedId(), currentExersice.fixedChinPos.x, currentExersice.fixedChinPos.y, currentExersice.fixedChinPos.z - 1)
                        SetEntityHeading(PlayerPedId(), currentExersice.fixedChinPos.rot)
                    end
                    TaskStartScenarioInPlace(PlayerPedId(), currentExersice.scenario, 0, true)
                    
                    -- Notification de début d'exercice
                    exports["foltone_hud_nemo"]:FoltoneNotification(
                        "Sport",
                        "Entraînement commencé",
                        "Vous commencez un " .. currentExersice.type .. ". ~b~Gardez un rythme régulier.",
                        "LOGO",
                        GymConfig.NotificationDuration
                    )
                    
                    -- Progression pendant l'exercice avec suivi du temps consécutif
                    Citizen.CreateThread(function()
                        while isTraining do
                            Citizen.Wait(5000) -- Toutes les 5 secondes pendant l'exercice
                            
                            -- Augmenter le temps d'entraînement consécutif
                            consecutiveTrainingTime = consecutiveTrainingTime + 1
                            
                            -- Avertissement de fatigue imminente
                            if consecutiveTrainingTime == GymConfig.MaxConsecutiveTraining - 2 then
                                exports["foltone_hud_nemo"]:FoltoneNotification(
                                    "Sport",
                                    "Attention",
                                    "Vous commencez à sentir de la fatigue. ~r~Faites une pause bientôt !",
                                    "LOGO",
                                    GymConfig.NotificationDuration
                                )
                            end
                            
                            -- Vérifier si le joueur est en surchauffe
                            if consecutiveTrainingTime >= GymConfig.MaxConsecutiveTraining then
                                isTraining = false
                                ClearPedTasksImmediately(PlayerPedId())
                                ApplyOverheatEffect()
                                break -- Sortir de la boucle
                            end
                            
                            -- Diminuer la soif
                            DecreaseThirst()
                            
                            -- Augmenter la musculation
                            local oldProgress = exerciseProgress
                            exerciseProgress = math.min(exerciseProgress + 1, GymConfig.MaxProgress)
                            
                            -- Notification de progression tous les 5%
                            if math.floor(oldProgress/5) < math.floor(exerciseProgress/5) then
                                exports["foltone_hud_nemo"]:FoltoneNotification(
                                    "Sport",
                                    "Progression",
                                    "Vous sentez vos muscles se développer.",
                                    "LOGO",
                                    GymConfig.NotificationDuration
                                )
                            end
                            
                            UpdateMuscleBar(exerciseProgress)
                            TriggerServerEvent("gym:updateProgress", exerciseProgress)
                        end
                    end)
                end
            end
        else
            -- Si le joueur s'éloigne, réinitialiser le compteur de temps consécutif
            if not isOverheated and not isAtExersice and isTraining then
                isTraining = false
                consecutiveTrainingTime = 0
                
                exports["foltone_hud_nemo"]:FoltoneNotification(
                    "Sport",
                    "Exercice interrompu",
                    "Vous avez quitté la zone d'exercice.",
                    "LOGO",
                    GymConfig.NotificationDuration
                )
            end
        end
    end
end)

------------------------------------------
-- GESTION DES ÉVÉNEMENTS
------------------------------------------

-- Réception de la progression initiale du serveur
RegisterNetEvent("gym:setProgress")
AddEventHandler("gym:setProgress", function(value)
    exerciseProgress = value or 0 -- Force à 0 si aucune valeur
    --print("[GYM DEBUG] Réception serveur: exerciseProgress = " .. tostring(exerciseProgress))
    UpdateMuscleBar(exerciseProgress) -- Mise à jour immédiate de l'affichage
    
    -- Message de bienvenue au chargement initial
    if value > 0 then
        Citizen.Wait(2000) -- Petit délai pour ne pas spammer
        exports["foltone_hud_nemo"]:FoltoneNotification(
            "Sport",
            "Niveau musculaire",
            string.format("Votre niveau de musculation actuel est de ~p~%d%%.", value),
            "LOGO",
            GymConfig.NotificationDuration
        )
    end
end)