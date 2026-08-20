

local function bump(triggerName, source)
    TriggerEvent(triggerName, source)
end

AddEventHandler('esx_jk_drugs:pickedUpCannabis', function() TriggerEvent('quest-drug:cannabis') end)
AddEventHandler('esx_jk_drugs:pickedUpCocaPlant', function() TriggerEvent('quest-drug:coca') end)
AddEventHandler('esx_jk_drugs:pickedUpEphedra',   function() TriggerEvent('quest-drug:ephedra') end)
AddEventHandler('esx_jk_drugs:pickedUpmushroom',  function() TriggerEvent('quest-drug:mushroom') end)
AddEventHandler('esx_jk_drugs:pickedUpPoppy',     function() TriggerEvent('quest-drug:poppy') end)

AddEventHandler('esx_jk_drugs:processCannabis',  function() TriggerEvent('quest-drug:marijuana') end)
AddEventHandler('esx_jk_drugs:processCocaPlant', function() TriggerEvent('quest-drug:cocaine') end)
AddEventHandler('esx_jk_drugs:processEphedra',   function() TriggerEvent('quest-drug:ephedrine') end)
AddEventHandler('esx_jk_drugs:processEphedrine', function() TriggerEvent('quest-drug:meth') end)
AddEventHandler('esx_jk_drugs:processCoke',      function() TriggerEvent('quest-drug:crack') end)
AddEventHandler('esx_jk_drugs:processPoppy',     function() TriggerEvent('quest-drug:opium') end)
AddEventHandler('esx_jk_drugs:processOpium',     function() TriggerEvent('quest-drug:heroine') end)

local sellQuestByItem = {
    marijuana = 'quest-drug:sellmarjuana',
    cocaine   = 'quest-drug:sellcocaine',
    crack     = 'quest-drug:sellcrack',
    heroine   = 'quest-drug:sellheroine',
    meth      = 'quest-drug:sellmeth',
    mushroom  = 'quest-drug:sellmushroom',
}
AddEventHandler('esx_drugs:sellDrug', function(itemName)
    local trig = sellQuestByItem[itemName]
    if trig then TriggerEvent(trig) end
end)

AddEventHandler('esx_society:logAction', function(job, action)
    if job == 'ambulance' and action == 'Player Revived' then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer and xPlayer.job.name == 'ambulance' then
            TriggerEvent('quest-ambulance:revive', _source)
        end
    end
end)

AddEventHandler('mining:PutStoneInVehicle', function() TriggerEvent('quest-jobcenter:stonemine') end)
AddEventHandler('mining:SellStone',         function() TriggerEvent('quest-jobcenter:sellstone') end)
AddEventHandler('mining:WashStonePieces',   function() TriggerEvent('quest-jobcenter:washstone') end)

AddEventHandler('mining:MeltItems', function(smeltType)
    if smeltType == 'iron_piece' then
        TriggerEvent('quest-jobcenter:zobahan')
    elseif smeltType == 'gold_piece' then
        TriggerEvent('quest-jobcenter:zobtala')
    end
end)
