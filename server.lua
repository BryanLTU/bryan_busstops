local busySeats = {}

---Check if the player has the required amount of money
---@param source number
---@return boolean
local checkMoney = function(source)
    -- ESX exmaple:
    -- return ESX.GetPlayerFromId(source).getMoney() >= Config.Price

    return true
end

---Remove player's money
---@param source number
local removeMoney = function(source)
    -- ESX exmaple:
    -- ESX.GetPlayerFromId(source).removeAccountMoney('money', Config.Price)
end

local setSeatValue = function(netId, seatIndex, value)
    if not busySeats[netId] then
        busySeats[netId] = {}
    end

    busySeats[netId][seatIndex] = value
end

lib.callback.register('busstop:server:getEmptySeat', function(source, netId, seats)
    if not busySeats[netId] then
        setSeatValue(netId, 1, true)
        return 1
    end

    for index, _ in ipairs(seats) do
        if not busySeats[netId][index] then
            setSeatValue(netId, index, true)
            return index
        end
    end

    return false
end)

lib.callback.register('busstop:server:checkMoney', function(source)
    if not Config.Price then
        return true
    end

    if not checkMoney(source) then
        lib.notify(source, {
            title = 'Not enough money on hand',
            type = 'error'
        })

        return false
    end

    removeMoney(source)

    return true
end)

RegisterNetEvent('busstop:server:setSeatValue', function(netId, seatIndex, value)
    setSeatValue(netId, seatIndex, value)
end)