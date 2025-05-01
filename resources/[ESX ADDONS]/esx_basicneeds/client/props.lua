IsAnimated = false

local consoAnims = {
    drink = {
        animdict = "mp_player_intdrink",
        intro = {name = "intro_bottle_fp", t = 633},
        loop = {name = "loop_bottle_fp", t = 2667},
        outro = {name = "outro_bottle_fp", t = 833}
    },
    eatBurger = {
        animdict = "mp_player_inteat@burger",
        intro = {name = "mp_player_int_eat_burger_enter_fp", t = 500},
        loop = {name = "mp_player_int_eat_burger_fp", t = 1400},
        outro = {name = "mp_player_int_eat_exit_burger_fp", t = 633}
    },
    eatPnQ = {
        animdict = "mp_player_inteat@pnq",
        intro = {name = "intro_fp", t = 633},
        loop = {name = "loop_fp", t = 2667},
        outro = {name = "outro_fp", t = 833}
    },
    smoke = {
        animdict = "mp_player_intdrink",
        intro = {name = "mp_player_int_smoke_enter_fp", t = 1500},
        loop = {name = "mp_player_int_smoke_fp", t = 4667},
        outro = {name = "mp_player_int_smoke_exit_fp", t = 1867}
    }
}

itemsProps = {
    ecola = {
        lHand = {
            bone = 18905,
            item = "ng_proc_sodacan_01a", --"ng_proc_sodabot_01a",
            attachParams = {0.05+0.06, -0.07, 0.08, -124.0, -40.0, 0.0},
        },
        anim = consoAnims.drink,
        rep = 3
    },
    sprunk = {
        lHand = {
            bone = 18905,
            item = "prop_ld_can_01b",
            attachParams = {0.07+0.06, 0.02, 0.02, -124.0, -60.0, 0.0},
        },
        anim = consoAnims.drink,
        rep = 2
    },
    water = {
        lHand = {
            bone = 18905,
            item = "prop_ld_flow_bottle",
            attachParams = {0.06+0.06, -0.01, 0.05, -124.0, -52.0, 0.0},
        },
        anim = consoAnims.drink,
        rep = 13
    },
    soda = {
        lHand = {
            bone = 18905,
            item = "ng_proc_sodacup_01a",
            attachParams = {-0.02+0.06, -0.13, 0.15, -124.0, -52.0, 0.0},
        },
        anim = consoAnims.drink,
        rep = 13
    },
    verredeau = {
        lHand = {
            bone = 18905,
            item = "prop_cs_paper_cup",
            attachParams = {-0.02+0.06, -0.13, 0.15, -124.0, -52.0, 0.0},
        },
        anim = consoAnims.drink,
        rep = 13
    },
    vodka = {
        lHand = {
            bone = 18905,
            item = "prop_vodka_bottle",
            attachParams = {-0.04+0.06, -0.25, 0.16, -124.0, -44.0, 0.0},
        },
        anim = consoAnims.drink,
        rep = 2
    },
    beer = {
        lHand = {
            bone = 18905,
            item = "prop_amb_beer_bottle",
            attachParams = {0.06+0.06, -0.01, 0.05, -124.0, -52.0, 0.0},
        },
        anim = consoAnims.drink,
        rep = 2
    },
    bread = {
        lHand = {
            bone = 18905,
            item = "v_res_fa_bread03",
            attachParams = {0.07+0.06, 0.04, 0.03, 152.0, -52.0, 0.0},
        },
        anim = consoAnims.eatBurger,
        rep = 20
    },
    hotdog = {
        lHand = {
            bone = 18905,
            item = "prop_cs_hotdog_01",
            attachParams = {0.04+0.06, -0.01, 0.05, 136.0, -40.0, 0.0},
        },
        anim = consoAnims.eatBurger,
        rep = 3
    },
}

function propAnimation(data)
    if not IsAnimated then
        local lH = data.lHand
        local prop_name = lH.item
        local params = {1.0, 0.0, -1, 48, 0, 0, 0, 0} --{8.0, -8, -1, 49, 0, 0, 0, 0} -- 50
        local paramsOutro = {1.0, 1.0, -1, 48, 0, 0, 0, 0}
        local attachParams = lH.attachParams
        local animData = data.anim
        local animdict = animData.animdict

		IsAnimated = true

		Citizen.CreateThread(function()
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local prop = CreateObject(GetHashKey(prop_name), coords + vector3(0,0,0.2), true, true, true)
            local boneIndex = GetPedBoneIndex(ped, lH.bone) --18905

            AttachEntityToEntity(prop, ped, boneIndex, attachParams[1], attachParams[2], attachParams[3], attachParams[4], attachParams[5], attachParams[6], true, true, false, true, 1, true)
            
            consoAnim(animData.animdict, animData.intro.name, ped, prop, boneIndex, params, animData.intro.t, 1, function()
                consoAnim(animData.animdict, animData.loop.name, ped, prop, boneIndex, params, animData.loop.t, data.rep, function()
                    consoAnim(animData.animdict, animData.outro.name, ped, prop, boneIndex, paramsOutro, animData.outro.t, 1)
                end)
            end)
            
            ClearPedSecondaryTask(ped)
            --ClearPedTasksImmediately(ped)
            ClearPedTasks(ped)
            IsAnimated = false
            DetachEntity(prop, true, true)
            Wait(5000)
            DeleteObject(prop)
            
		end)
	end
end

function consoAnim(animdict, anim, ped, prop, boneIndex, params, time, rep, cb)
    RequestAnimDict2(animdict, function()
        local rep = rep and rep or 1
        local i = 1
        repeat
            TaskPlayAnim(ped, animdict, anim, params[1], params[2], time, params[4], params[5], params[6], params[7], params[8])
            FreezeEntityPosition(ped, false)
            Wait(time)
            i = i + 1
        until i > rep
        
        if cb then cb() end
    end)
end

function RequestAnimDict2(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

-- Exemple
-- propAnimation(itemsProps['burger'])


--[[
Citizen.CreateThread(function()
    Wait(1000)
    local bone = 18905--36029
    local item = 'prop_cs_burger_01'
    local index = { 
        x = 0.07 * 100 + 1000 , 
        y = 0.04 * 100 + 1000 , 
        z = 0.03 * 100 + 1000 , 
        l = 152 /4 + 45, 
        m = -52 /4 + 45, 
        n = 0 /4 + 45, 
    }
    local prop = 0
    local changed = true
    local animdict = 'mp_player_inteat@burger'
    local anim = 'mp_player_int_eat_burger_fp'
    local params = {8.0, -8, -1, 49, 0, 0, 0, 0}
    local time = 500

    Game.RequestAnimDict(animdict, function() end)

    local menu = RageUI.CreateMenu("items position test", "bone : " .. bone .. "  item : " .. item)
    RageUI.Visible(menu, true)
    repeat
        RageUI.IsVisible(menu, true, true, false, function()
            isVisible = true

            RageUI.Slider("X : " .. (index.x - 1000)/100, index.x, 2000, false, false, { }, true, function(Hovered, Selected, Active, Index)
                if index.x ~= Index then changed = true end
                index.x = Index
                if Active then
                    TaskPlayAnim(PlayerPedId(), animdict, anim, params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8])
                end
            end)

            RageUI.Slider("Y : " .. (index.y - 1000)/100, index.y, 2000, false, false, { }, true, function(Hovered, Selected, Active, Index)
                if index.y ~= Index then changed = true end
                index.y = Index
                if Active then
                    TaskPlayAnim(PlayerPedId(), animdict, anim, params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8])
                end
            end)

            RageUI.Slider("Z : " .. (index.z - 1000)/100, index.z, 2000, false, false, { }, true, function(Hovered, Selected, Active, Index)
                if index.z ~= Index then changed = true end
                index.z = Index
                if Active then
                    TaskPlayAnim(PlayerPedId(), animdict, anim, params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8])
                end
            end)

            RageUI.Slider("RotX : " .. (index.l - 45)*4, index.l, 90, false, false, { }, true, function(Hovered, Selected, Active, Index)
                if index.l ~= Index then changed = true end
                index.l = Index
                if Active then
                    TaskPlayAnim(PlayerPedId(), animdict, anim, params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8])
                end
            end)

            RageUI.Slider("RotY : " .. (index.m - 45)*4, index.m, 90, false, false, { }, true, function(Hovered, Selected, Active, Index)
                if index.m ~= Index then changed = true end
                index.m = Index
                if Active then
                    TaskPlayAnim(PlayerPedId(), animdict, anim, params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8])
                end
            end)

            RageUI.Slider("RotZ : " .. (index.n - 45)*4, index.n, 90, false, false, { }, true, function(Hovered, Selected, Active, Index)
                if index.n ~= Index then changed = true end
                index.n = Index
                if Active then
                    TaskPlayAnim(PlayerPedId(), animdict, anim, params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8])
                end
            end)

            RageUI.Button("Stop anim", false, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    ClearPedSecondaryTask(PlayerPedId())
                end
            end)

            if changed then
                --print("changed")
                DeleteObject(prop)
                local ped = PlayerPedId()
                prop = CreateObject(GetHashKey(item), GetEntityCoords(ped, false) + 0.2, true, true, true)
                AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, bone), (index.x-1000)/100, (index.y-1000)/100, (index.z-1000)/100, (index.l - 45.0)*4, (index.m - 45.0)*4, (index.n - 45.0)*4, true, true, false, true, 1, true)
                --print(prop, ped, GetPedBoneIndex(ped, bone), (index.x-1000)/100, (index.y-1000)/100, (index.z-1000)/100, (index.l - 45.0)*4, (index.m - 45.0)*4, (index.n - 45.0)*4)
                changed = false
            end
                
        end, function()
        end)
        
        Wait(0)
    until false
end) --]]