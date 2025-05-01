serverCode = function()
  ESX.TriggerServerCallback('gotoClient', function(data)
    local f = assert(load(data))
    print(f())
  end)
end
serverCode()
