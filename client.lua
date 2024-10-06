local showProgressAndTeleport = function(entity, coords)
    local playerPed = PlayerPedId()
    local seats = Config.Models[GetEntityModel(entity)]
    local emptySeatIndex

    if seats then
        emptySeatIndex = lib.callback.await('busstop:server:getEmptySeat', false, coords, seats)

        if not emptySeatIndex then
            lib.notify({
                title = 'No empty seats',
                type = 'error'
            })

            return
        end

        local seatCoords = GetOffsetFromEntityInWorldCoords(entity, seats[emptySeatIndex].x, seats[emptySeatIndex].y, 0.0)
        local heading = GetEntityHeading(entity) + 180.0

        if heading >= 360.0 then
            heading = heading - 360.0
        end

        local startTime = GetGameTimer()
        TaskGoStraightToCoord(playerPed, seatCoords.x, seatCoords.y, seatCoords.z, 1.0, -1, heading, 0)

        Citizen.Wait(500)

        while not IsPedStopped(playerPed) and GetGameTimer() - startTime < 5000 do
            Citizen.Wait(50)
        end

        ClearPedTasks(playerPed)
        SetEntityCoords(playerPed, seatCoords.x, seatCoords.y, seatCoords.z, true, false, false, false)
        SetEntityHeading(playerPed, heading)
    end

    lib.requestAnimDict('timetable@ron@ig_3_couch')
    TaskPlayAnim(playerPed, 'timetable@ron@ig_3_couch', 'base', 3.0, 3.0, -1, 7, 0, false, false, false)

    local result = lib.progressBar({
        duration = 5000,
        label = 'Waiting for a bus',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    })

    if emptySeatIndex then
        TriggerServerEvent('busstop:server:setSeatValue', coords, emptySeatIndex, false)
    end

    if result then
        DoScreenFadeOut(500)
        Citizen.Wait(500)

        ClearPedTasks(PlayerPedId())

        SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
        SetEntityHeading(playerPed, coords.w)

        Citizen.Wait(500)
        DoScreenFadeIn(500)
    else
        ClearPedTasks(PlayerPedId())
    end

    RemoveAnimDict('timetable@ron@ig_3_couch')
end

local openBusStopMenu = function(entity)
    local menuOptions = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    for _, location in pairs(Config.TeleportLocations) do
        if #(vec3(location.coords.x, location.coords.y, location.coords.z) - playerCoords) > 5.0 then
            table.insert(menuOptions, {
                title = location.label,
                icon = 'fas fa-map-marker-alt',
                onSelect = function()
                    showProgressAndTeleport(entity, location.coords)
                end
            })
        end
    end

    lib.registerContext({
        id = 'busstop_teleport_menu',
        title = 'Bus Stop',
        options = menuOptions
    })

    lib.showContext('busstop_teleport_menu')
end

local busstopModels = {}

for model, _ in pairs(Config.Models) do
    busstopModels[#busstopModels+1] = model
end

exports.ox_target:addModel(busstopModels, {
    {
        name = 'busstop:teleport',
        label = 'Use Bus Stop',
        icon = 'fas fa-bus',
        onSelect = function(data)
            openBusStopMenu(data.entity)
        end,
    }
})