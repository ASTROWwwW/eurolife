Config = {}

Config.EnableBlip = true
Config.ExersiceKey = 38 -- E
Config.ExersiceString = 'Appuyez sur ~INPUT_CONTEXT~ pour faire ~s~'
Config.AbortString = 'Appuyez sur ~INPUT_CONTEXT~ pour interrompre votre entraînement.'
Config.ExersiceDuration = 30 -- in seconds
Config.FinishString = '~g~Exercice terminé ! ~s~Respirez profondément avant de continuer.'

-- Liste des salles de sport
Config.Gyms = {
    -- Première salle (celle existante)
    {
        Name = "Ls Beach",
        Blip = {
            Pos     = {x = -1203.3242, y = -1570.6184, z = 4.6115},
            Sprite  = 311,
            Display = 4,
            Scale   = 0.7,
            Colour  = 26,
            Name    = 'Salle De Sport',
        },
        Exercises = {
            {type = 'des alteres', scenario = "world_human_muscle_free_weights", x = -1202.9837, y = -1565.1718, z = 4.6115},
            {type = 'des pompes', scenario = "world_human_push_ups", x = -1203.3242, y = -1570.6184, z = 4.6115},
            {type = 'du yoga', scenario = "world_human_yoga", x = -1204.7958, y = -1560.1906, z = 4.6115},
            {type = 'des abdos', scenario = "world_human_sit_ups", x = -1206.1055, y = -1565.1589, z = 4.6115},
            {type = 'des Tractions', scenario = "prop_human_muscle_chin_ups", x = -1200.1284, y = -1570.9903, z = 4.6115, fixedChinPos = {x = -1199.84, y = -1571.40, z = 4.61, rot = 40.0}},
        }
    },
    
    -- Deuxième salle (exemple - à modifier selon vos besoins)
    {
        Name = "Paleto Bay",
        Blip = {
            Pos     = {x = -379.9147, y = 6047.5557, z = 31.4814}, -- Ajustez les coordonnées
            Sprite  = 311,
            Display = 4,
            Scale   = 0.7,
            Colour  = 7,
            Name    = 'Salle De Sport',
        },
        Exercises = {
            {type = 'des alteres', scenario = "world_human_muscle_free_weights", x = -378.8296, y = 6046.7441, z = 31.4805},
            {type = 'des pompes', scenario = "world_human_push_ups", x = -373.0872, y = 6044.0635, z = 31.4759},
            {type = 'des Tractions', scenario = "prop_human_muscle_chin_ups", x = -375.8400, y = 6041.6914, z = 31.4773, fixedChinPos = {x = -1199.84, y = -1571.40, z = 4.61, rot = 40.0}}, 
            {type = 'des abdos', scenario = "world_human_sit_ups", x = -382.0770, y = 6044.9058, z = 31.4566},
            -- Ajoutez d'autres exercices selon vos besoins
        }
    },
    
    -- Vous pouvez ajouter d'autres salles ici...
}