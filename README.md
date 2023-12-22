# Pulse Interact Targets
Script is in no form ready and still requires work. (Not optimized, uses coords instead of zones, no entity handling, etc)
Default keybind is "O" to create a pulse and it will display nearby targets.

![image](https://github.com/darktrovx/devyn-pulse/assets/7463741/e61f2552-779e-44c0-8f5d-c1c61cfec7f4)

![image](https://github.com/darktrovx/devyn-pulse/assets/7463741/ab5aba70-21d9-4b50-b93f-cbd09236e19f)



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
        server = "pulse:server"
    },
})
```
