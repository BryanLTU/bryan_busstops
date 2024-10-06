local busySeats = {}

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

RegisterNetEvent('busstop:server:setSeatValue', function(netId, seatIndex, value)
    setSeatValue(netId, seatIndex, value)
end)