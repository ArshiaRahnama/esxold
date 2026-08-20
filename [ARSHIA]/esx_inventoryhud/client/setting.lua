function saveUISetting()
    SetResourceKvp('inventory:setting', json.encode(settings))
end

RegisterNUICallback('inventory:blurState', function(state, cb)

    if state == 'on' then
        TriggerScreenblurFadeIn()
    else
        TriggerScreenblurFadeOut()
    end

    cb('ok')
end)