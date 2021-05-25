local peds = {
  {
    label = "Text of notification",
    model = "ped_model",
    anim = "Animation1",
    anim2 = "Animation2",
    dist = 2, -- Distance
    coords = { -- Coords of ped
      x = 1, 
      y = 1, 
      z = 1, 
      h = 1
    },
    blip = { -- Blip of ped
      sprite = 1,
      scale = 1.0,
      label = "Text of blip",
      color = 8,
    }
  },
  
    {
    label = "",
    model = "",
    anim = "",
    anim2 = "",
    dist = 2,
    coords = {
      x = 1, 
      y = 1, 
      z = 1, 
      h = 1
    },
    blip = {
      sprite = 1,
      scale = 1.0,
      label = "",
      color = 8,
    }
  }
}

Citizen.CreateThread(function()
  for k, v in pairs(peds) do
    local model = GetHashKey(v.model)

    -- Requesting
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(1)
    end
    RequestAnimDict(v.anim)
    while not HasAnimDictLoaded(v.anim) do
      Wait(1)
    end

    local sPed = CreatePed(4, model, v.coords.x, v.coords.y, v.coords.z, v.coords.h, false, false)
    FreezeEntityPosition(sPed, true)
    SetEntityInvincible(sPed, true)
    SetBlockingOfNonTemporaryEvents(sPed, true)
    SetPedFleeAttributes(sPed, 0, false)
    SetPedCombatAttributes(sPed, 17, true)
    TaskPlayAnim(sPed, v.anim, v.anim2, 1.0, 1.0, -1, 1, 0, false, false, false)

    local blip = AddBlipForEntity(sPed)
        SetBlipSprite(blip, v.blip.sprite)
        SetBlipScale(blip, v.blip.scale)
        SetBlipColour(blip, v.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(v.blip.label)
        EndTextCommandSetBlipName(blip)
  end

  while true do
    for k, v in pairs(peds) do
      Wait(10)
      local distance = #(GetEntityCoords(PlayerPedId()) - vector3(v.coords.x + 1, v.coords.y + 1, v.coords.z))
      if distance < v.dist then
        FloatingNotification(v.label, vector3(v.coords.x, v.coords.y, v.coords.z + 2))
      end
    end
  end
end, false)

FloatingNotification = function(msg, coords)
    AddTextEntry('FloatingNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end
