ConfigWCambriolage = {

    NewEsx = true, 
    DefaultInventory = false, 
    OxInventory = true, 

    NomCommande = "buildermenu",

    Marker = {
        Type = 1,
        Size = {1.0, 1.0, 0.1},
        Color = {0, 0, 0},
        Rotation = 0.0,
    },

    infoBlip = {
        showBlip = false,
        Name = "Cambriolage",
        Sprite = 84,
        Display = 2,
        Scale = 0.6,
        Color = 23,
        Range = true,
        pedposition = {
            {name = "a_m_m_salton_02", pos = vector4(-378.5293, 6035.2705, 30.5322, 134.9761)}, -- Ped Vente
        },
    },

    MenuVente = vec3(-378.6797, 6035.2993, 31.5290),

    DistanceMarker = 2.0,
    ChanceDeReussite = 99, -- EN %
    TempsRemoveBlipsAlerte = 12000,
    TempsAnimationKnockKnock = 1000,
    NomItemCrochetage = "lockpick",
    Activer1BraquagePar1Braquage = true, 
    ActiverLeCoolDownEntreLesBraquages = true,
    Timer = 300, -- En Seconde
    PourcentageBruitQuandCours = 10, -- En %
    PourcentageBruitSiTire = 30, -- En %
    PourcentageBruitSiSaute = 20, -- En %
    ActiverRestrictionCountPolice = true, 
    NombrePoliceNecessaire = 0, -- Flic Nécessaire pour faire un cambriolage
    tempsInactivite = 10,-- Temps en secondes après lequel la jauge diminue
    reductionParInactivite = 10, --Valeur à réduire par période d'inactivité
    ActiverAttaqueChienSi100PCTBruit = true, 
    TypeDeChien = 'a_c_rottweiler', 

    ItemVendable = {
        {Name = "flare_ammo", Label = "Code Carte Bleu", Prix = 1},
        {Name = "molotov_ammo", Label = "Disque Dur", Prix = 1 },
    }, 

    ArgentPropre = true, -- Si false donne en sale 

    PermAutoriser = {
        'admin',
        'dev',
    }, 

    TableJobInterdit = {
        "police",
        "bcso",
    },

    TableJobsAlerter = {
        "police",
        "bcso",
    },

    TypeIpl = {
        {Name = "Appartement Modern 2", Value = 1, CoordsX = -786.9563, CoordsY = 315.6229, CoordsZ = 187.9136},
        {Name = "Appartement Modern 3", Value = 2, CoordsX = -774.0126, CoordsY = 342.0428, CoordsZ =196.6864},
        {Name = "Arcadius", Value = 3, CoordsX = -75.8466, CoordsY = -826.9893, CoordsZ =243.3859},
        {Name = "Maze Bank Building", Value = 4, CoordsX = -1579.756, CoordsY = -565.0661, CoordsZ =108.523}, 
        {Name = "Maze Bank West", Value = 5, CoordsX = -1392.667, CoordsY = -480.4736, CoordsZ =72.04217}, 
        {Name = "Petit Appartement", Value = 6, CoordsX = 266.11526489258, CoordsY = -1007.5467529297, CoordsZ =-101.00848388672},
        {Name = "Moyen Appartement", Value = 7, CoordsX = 346.56539916992, CoordsY = -1012.7724609375, CoordsZ =-99.196273803711},

        ---- Pas Encore Disponible ( Cela arrive )
        --[[{Name = "4 Integrity Way, Apt 28", Value = 8, CoordsX = -31.537536621094, CoordsY = -595.03619384766, CoordsZ =80.030906677246},
        {Name = "4 Integrity Way, Apt 30", Value = 9 , CoordsX = -18.438011169434, CoordsY = -591.41430664062, CoordsZ =90.114814758301},
        {Name = "Dell Perro Heights , Apt 4", Value = 10, CoordsX = -1452.1026611328, CoordsY = -540.69647216797, CoordsZ =74.044326782227},
        {Name = "Dell Perro Heights, Apt 7", Value = 11, CoordsX = -1449.8735351562, CoordsY = -525.90490722656, CoordsZ =56.9289894104},
        {Name = "Richard Majestic, Apt 2", Value = 12, CoordsX = -912.39123535156, CoordsY = -365.1203918457, CoordsZ =114.27475738525},
        {Name = "Tinsel Towers, Apt 42", Value = 13, CoordsX = -602.95446777344, CoordsY = 58.92395401001, CoordsZ =98.200218200684},
        {Name = "Eclipse Towers, Apt 3", Value = 14, CoordsX = -785.07110595703, CoordsY = 323.65270996094, CoordsZ =211.99726867676},
        {Name = "3655 Wild Oats Drive", Value = 15, CoordsX = -174.29547119141, CoordsY = 497.92916870117, CoordsZ =137.65371704102},
        {Name = "2044 North Conker Avenue", Value = 16, CoordsX = 342.14254760742, CoordsY = 438.00659179688, CoordsZ =149.38076782227},
        {Name = "2045 North Conker Avenue", Value = 17, CoordsX = 373.64349365234, CoordsY = 423.92813110352, CoordsZ =145.90745544434},
        {Name = "2682 Hillcrest Avenue", Value =  18, CoordsX = -682.50555419922, CoordsY = 592.67291259766, CoordsZ =145.37977600098},
        {Name = "2868 Hillcrest Avenue", Value = 19, CoordsX = -758.13391113281, CoordsY = 619.01330566406, CoordsZ =144.14065551758},
        {Name = "2874 Hillcrest Avenue", Value = 20, CoordsX = -859.89416503906, CoordsY = 691.51568603516, CoordsZ =152.85884094238},
        {Name = "Whispymound Drive", Value = 21, CoordsX = 117.14987945557, CoordsY = 560.11474609375, CoordsZ =184.30485534668},
        {Name = "Mad Wayne Thunder", Value = 22 , CoordsX = -1289.8215332031,CoordsY =  449.85723876953, CoordsZ =97.902519226074},
        {Name = "Solomon's Office", Value = 23, CoordsX = -1002.8165893555, CoordsY = -477.81771850586, CoordsZ =50.027236938477},
        {Name = "Psychiatrist's Office", Value = 24, CoordsX = -1902.1907958984, CoordsY = -572.20147705078, CoordsZ =19.097215652466},
        {Name = "Motel", Value = 25, CoordsX = 151.38670349121, CoordsY = -1007.9696044922, CoordsZ =-99.000022888184},
        {Name = "Morgue", Value = 26 , CoordsX = 275.446, CoordsY = -1361.11, CoordsZ =24.5378}, 
        {Name = "Sous Marin", Value = 27, CoordsX = 1561.562, CoordsY = 410.45, CoordsZ =-48.0}, 
        {Name = "NightClub", Value = 28, CoordsX = 1550.0, CoordsY = 250.0,CoordsZ = -48.0}, 
        {Name = "Bunker", Value = 29, CoordsX = 896.27136230469, CoordsY = -3245.8413085938, CoordsZ =-98.244201660156},
        {Name = "FBI", Value = 30, CoordsX = 136.05706787109, CoordsY = -761.81091308594, CoordsZ =234.15196228027},
        {Name = "Facility", Value = 31, CoordsX = 337.60125732422,CoordsY =  4869.2783203125, CoordsZ =-58.999416351318},
        {Name = "Server Farm", Value = 32, CoordsX = 2154.9060058594,CoordsY =  2920.8498535156, CoordsZ =-81.075523376465},
        {Name = "Sous Marin 2", Value = 33, CoordsX = 514.37799072266,CoordsY =  4888.3232421875, CoordsZ =-62.589569091797},
        {Name = "IAA Facility", Value = 34, CoordsX = 2154.9099121094,CoordsY =  2921.0559082031, CoordsZ =-61.902423858643},
        {Name = "Nightclub Warehouse", Value = 35, CoordsX = -1507.4572753906,CoordsY =  -3017.0375976562, CoordsZ =-79.242065429688},
        {Name = "Penthouse Casino", Value = 36, CoordsX =969.15283203125,CoordsY =  63.221122741699, CoordsZ =112.55403137207},]]
    },

    Rewards = {

        --typee == item / money / arme (si typee = weapon le count = munitions dans l'arme)
        [1] = {typee = 'item', 		    name = 'weed', 		    count = 3,  		probability = {a = 0, b = 8}},
        -- [2] = {typee = 'item', 		    name = 'gold', 				    count = 6, 			probability = {a = 9, b = 23}},
        -- [3]  = {typee = 'item', 		name = 'rolex', 			    count = 2, 		    probability = {a =   24, b =   37}},
        -- [4]  = {typee = 'item', 		name = 'weed_pooch', 			count = 4, 		    probability = {a =   38, b =   43}},
        -- [5]  = {typee = 'item', 		name = 'coke_pooch', 			count = 2, 		    probability = {a =   44, b =   48}},
        -- [6]  = {typee = 'item', 		name = 'meth_pooch', 			count = 1, 		    probability = {a =   49, b =   52}},
        -- [7]  = {typee = 'item', 		name = 'oldphone', 			    count = 2, 		    probability = {a =   53, b =   56}},
        -- [8]  = {typee = 'item', 		name = 'oldlaptop', 			count = 2, 		    probability = {a =   57, b =   57}},
        -- [9]  = {typee = 'item', 		name = 'jewels', 		    	count = 1, 		    probability = {a =   58, b =   58}},
        -- [10]  = {typee = 'item', 	    name = 'malboro', 		    	count = 3, 		    probability = {a =   59, b =   65}},
        -- [11]  = {typee = 'item', 	    name = 'ring', 		    	    count = 3, 		    probability = {a =   66, b =   67}},
        -- [12]  = {typee = 'item', 	    name = 'vodka', 		    	count = 1, 		    probability = {a =   68, b =   71}},
        -- [13]  = {typee = 'item', 	    name = 'bag', 			        count = 1, 		    probability = {a =   72, b =   81}},
        -- [14]  = {typee = 'money', 	    name = 'black_money', 		    count = 400, 	    probability = {a =   82, b =   88}},
        -- [15]  = {typee = 'item', 	    name = 'cutter', 		    	count = 1, 		    probability = {a =   89, b =   91}},
        -- [16]  = {typee = 'item',	    name = 'hack_usb', 		    	count = 1, 		    probability = {a =   92, b =   94}},
        -- [17]  = {typee = 'item',	    name = 'necklace', 		        count = 1, 		    probability = {a =   95, b =   95}},
        -- [18]  = {typee = 'item', 	    name = 'bague', 			    count = 1, 	    	probability = {a =   96, b =   100}},


    },
    
    RewardsProbaMax = 100,

    ChoseAndAddRewards = function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local rnd = -1
        --local itemLabel = "Error"

        rnd = math.random(1, ConfigWCambriolage.RewardsProbaMax)
        --    print("rnd : "..rnd )
            local price = 0
            local priceIndex = 0
            for k,v in pairs(ConfigWCambriolage.Rewards) do
                Wait(1)
                if (rnd >= v.probability.a) and (rnd <= v.probability.b) then
                    price = v
                    priceIndex = k
                    break
                end
            end
            
            if price.typee == 'item' then
               xPlayer.addInventoryItem(price.name, price.count)
            elseif price.typee == 'money' then
                xPlayer.addMoney(price.count)
            elseif price.typee == 'arme' then
                xPlayer.addWeapon(price.name, price.count)
            end
            --TriggerEvent('kotonier:log', xPlayer, price.typee, itemLabel, price.count)  

    end,

} 