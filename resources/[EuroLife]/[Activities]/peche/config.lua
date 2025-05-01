Config = {}

-- Zones de pêche avec blips (exemple de coordonnées)
Config.FishingZones = {
    {x = -1600.0, y = 5200.0, z = 4.0, radius = 13.0, blip = {sprite = 68, color = 38, name = "Zone de Pêche"}},
    {x = -1869.1523, y = -1221.5879, z = 13.0170, radius = 10.0, blip = {sprite = 68, color = 38, name = "Zone de Pêche"}}
    -- Sprite 68 = icône de poisson, color 38 = bleu clair, ajustable selon tes préférences
}

-- Hameçons disponibles
-- Hameçons disponibles avec durabilité
Config.Hooks = {
    ['hook_basic'] = {name = 'Hameçon Basique', durability = 5, breakChance = 0.08}, -- 5 utilisations, 18% de chance de casser
    ['hook_sturdy'] = {name = 'Hameçon Robuste', durability = 12, breakChance = 0.05}, -- 12 utilisations, 12% de chance de casser
    ['hook_premium'] = {name = 'Hameçon Premium', durability = 25, breakChance = 0.05} -- 25 utilisations, 5% de chance de casser
}

-- Canne à pêche
Config.FishingRod = 'cannep' -- Item requis pour pêcher

-- Items poissons avec rareté (valeur entre 0 et 1, plus c'est bas, plus c'est rare)
Config.Fish = {
    {item = 'poisson-chat', name = 'Poisson Chat', weight = 100},           -- Commun
    {item = 'poisson-moustique', name = 'Poisson Moustique', weight = 100},           -- Commun
    {item = 'algue', name = 'Algue', weight = 80},                          -- Commun
    {item = 'brochet', name = 'Brochet', weight = 15},               -- Rare
    {item = 'graine', name = 'Graine', weight = 50},                        -- Très rare
    {item = 'black bass', name = 'Black Bass', weight = 1}      -- Très rare} 
}


Config.FishBuyer = {
    position = vector3(3.7768, -201.0801, 52.7419), -- Position du PNJ (près du port) 
    heading = 160.1565,
    model = "s_m_y_factory_01", -- Modèle de PNJ (pêcheur)
    blip = {
        sprite = 280, -- Icône de balance/commerce
        color = 11,   -- Orange
        name = "poissonnerie"
    }
}

-- Items vendables dans le menu du vendeur de poissons
Config.SellableItems = {
    'poisson-chat',
    'poisson-moustique',
    'brochet',
    'black bass'
    -- Ajoutez ou retirez des items selon vos besoins
}

-- Prix d'achat des poissons
Config.FishPrices = {
    ['poisson-chat'] = 8,      -- Prix du poisson chat
    ['poisson-moustique'] = 6, -- Prix du poisson moustique
    ['brochet'] = 32,          -- Prix du brochet
    ['black bass'] = 68        -- Prix du black bass
}

-- Temps de pêche (en secondes)
Config.FishTimeMin = 5
Config.FishTimeMax = 15