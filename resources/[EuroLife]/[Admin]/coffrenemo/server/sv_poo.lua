CoffreServerManager = {}
CoffreServerManager.__index = CoffreServerManager

function CoffreServerManager:Create(data)
    local self = setmetatable({}, CoffreServerManager)

    self.id = data.id
    self.label = data.label
    self.job = data.job
    self.password = data.password
    self.position = data.position
    self.maxWeight = data.max_weight or 100

    self.markerType = data.markerType or 1
    self.markerSize = data.markerSize or 1.0
    self.markerHeight = data.markerHeight or 1.0
    self.markerOpacity = data.markerOpacity or 150
    self.markerColor = data.markerColor or {r=0, g=150, b=255}

    self.money = data.money or 0 
    self.black_money = data.black_money or 0 

    return self
end


function CoffreServerManager:Save()
    local insert = [[
        INSERT INTO eurolife_coffres
        (label, job, password, position, max_weight, marker_type, marker_size, marker_height, marker_opacity, marker_color, money, black_money)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]]
    exports.oxmysql:insert(insert, {
        self.label,
        self.job,
        self.password,
        json.encode(self.position),
        self.maxWeight,
        self.markerType,
        self.markerSize,
        self.markerHeight,
        self.markerOpacity,
        json.encode(self.markerColor),
        self.money or 0,
        self.black_money or 0
    })
end



function CoffreServerManager:UpdatePassword(newPassword)
    local update = [[
        UPDATE eurolife_coffres SET password = ? WHERE id = ?
    ]]
    exports.oxmysql:update(update, {newPassword, self.id})
end

function CoffreServerManager:UpdatePosition(newPosition)
    local update = [[
        UPDATE eurolife_coffres SET position = ? WHERE id = ?
    ]]
    exports.oxmysql:update(update, {json.encode(newPosition), self.id})
end
