# Bryan Bus Stops

Simple bus stops script allowing players to travel in the map between bus stops. It has nice animations to go along with.

## Dependencies
| Script | Download |
| --- | --- |
| ox_lib | https://github.com/overextended/ox_lib |
| ox_target | https://github.com/overextended/ox_target |

## Configuration

1. Price
If you want the players to pay for the bus, then put in a number. Example:
```lua
Config.Price = 10
```

> [!NOTE]
> Remember to change the ``checkMoney()`` and ``removeMoney()`` functions in the ``server.lua`` file

2. Teleport Locations

- label - Bus stop name
- coords - Location of the bus stop (where the player will teleport)

```lua
Config.TeleportLocations = {
    {label = "Alta Street", coords = vector4(-250.2917, -887.5287, 30.0739, 347.1240)},
    {label = "Legion", coords = vector4(115.9833, -781.7462, 31.3972, 166.8457)},
    {label = "Airport", coords = vector3(-1034.62, -2733.83, 13.75)}
}
```

3. Models
- [key] - model hash
- list item - each seat with it's offset

```lua
Config.Models = {
    [`prop_busstop_02`] = {
        vec2(-0.05, -0.3),
        vec2(0.8, -0.3),
        vec2(1.6, -0.3)
    },
    [`prop_busstop_04`] = {
        vec2(-0.7, -0.1),
        vec2(0.0, -0.1),
        vec2(0.7, -0.1)
    },
    [`prop_busstop_05`] = {
        vec2(-0.1, -0.3),
        vec2(0.5, -0.3),
        vec2(1.0, -0.3)
    }
}
```