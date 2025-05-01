Config = {}

Config.MinPasswordLength = 4            -- Mot de passe minimum
Config.MaxPasswordLength = 12           -- Mot de passe maximum

Config.DefaultMaxWeight = 150           -- Poids maximum par défaut si non précisé

Config.AdminCommand = "buildcoffre"     -- Commande pour ouvrir le menu Builder
Config.AdminGroups = {                   -- Groupes autorisés pour utiliser la commande
    "admin",
    "superadmin"
}
Config.Debug = true                    -- Mode debug serveur
