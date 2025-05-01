CoffreManager = {}
CoffreManager.__index = CoffreManager

function CoffreManager:Create(data)
    local self = setmetatable({}, CoffreManager)

    self.id = data.id
    self.label = data.label
    self.job = data.job
    self.password = data.password

    if type(data.position) == "vector3" then
        self.position = data.position
    elseif type(data.position) == "table" then
        self.position = vector3(data.position.x, data.position.y, data.position.z)
    elseif type(data.position) == "string" then
        local decoded = json.decode(data.position)
        if decoded and decoded.x and decoded.y and decoded.z then
            self.position = vector3(decoded.x, decoded.y, decoded.z)
        else
            print("[EUROLIFE COFFRE] ERREUR Décodage Position Coffre ID: "..tostring(data.id))
            self.position = vector3(0,0,0)
        end
    else
        print("[EUROLIFE COFFRE] ERREUR Format Position Inconnu Coffre ID: "..tostring(data.id))
        self.position = vector3(0,0,0)
    end
    

    self.maxWeight = data.max_weight or 100
    self.items = {}

    self.markerType = data.markerType or 1
    self.markerSize = data.markerSize or 1.0
    self.markerHeight = data.markerHeight or 1.0
    self.markerOpacity = data.markerOpacity or 150
    self.markerColor = data.markerColor or {r=0, g=150, b=255}

    self.money = data.money or 0
    self.black_money = data.black_money or 0

    return self
end


function CoffreManager:Open()
    -- Trigger menu d'ouverture ici
    TriggerEvent('eurolife_coffre:openCoffre', self)
end

function CoffreManager:SetItems(items)
    self.items = items
end

function CoffreManager:AddItem(itemName, count)
    table.insert(self.items, {name = itemName, count = count})
end

function CoffreManager:RemoveItem(itemName, count)
    for k,v in pairs(self.items) do
        if v.name == itemName then
            v.count = v.count - count
            if v.count <= 0 then
                table.remove(self.items, k)
            end
            break
        end
    end
end

function CoffreManager:GetItems()
    return self.items
end
