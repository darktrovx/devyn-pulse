# Pulse Interact Targets
Script is in no form ready and still requires work.
Default keybind is "O" to create a pulse and it will display nearby targets.

Exports
```
-- Coords : Vector3
-- Options: Table
exports['devyn-pulse']:AddTarget(coords, options)
```

Example
```
exports['devyn-pulse']:AddTarget(vec3(-463.39, 185.55, 94.4), {
    {
        label = "Test 1",
        client = "pulse:client"
    },
    {
        label = "Test 2",
        serverr = "pulse:server"
    },
})
```
