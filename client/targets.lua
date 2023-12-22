TARGETS = {}

function AddTarget(coords, options)
    local targetID = #TARGETS + 1
    TARGETS[targetID] = {
        id = targetID,
        coords = coords,
        options = options
    }
    return targetID
end
exports('AddTarget', AddTarget)

function AddTargetEntity(entity, options)
    local targetID = #TARGETS + 1
    TARGETS[targetID] = {
        id = targetID,
        entity = entity,
        options = options
    }
    return targetID
end
exports('AddTargetEntity', AddTargetEntity)

function RemoveTarget(targetID)
    if TARGETS[targetID] then
        TARGETS[targetID] = nil
    end
end
exports('RemoveTarget', RemoveTarget)

function UpdateTarget(targetID, options)
    if TARGETS[targetID] then
        TARGETS[targetID].options = options
    end
end
exports('UpdateTarget', UpdateTarget)