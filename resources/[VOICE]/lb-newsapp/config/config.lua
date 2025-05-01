Config = {}

Config.Debug = true

Config.Framework = "auto"
Config.Language = "en" -- add your own language in config/locales/
Config.Notifications = "online" -- who should get notified when an article is published? options: "all", "online" or false

Config.Logs = {}
Config.Logs.Enabled = false
Config.Logs.Service = "discord" -- fivemanage, discord or ox_lib. if discord, set your webhook in server/apiKeys.lua
Config.Logs.Actions = {
    CreateArticle = true,   -- create new articles
    CreateCategory = true,  -- create new categories
    UpdateArticle = true,   -- update own articles
    DeleteArticle = true,   -- delete own articles
    DeleteOther = true,     -- delete other's articles
    UnpublishOther = true,  -- unpublish other's articles
    UpdateProfile = true,   -- update own profile
}

-- if you want to use the discord notifications, you need to enter your webhooks in server/apiKeys.lua
Config.DiscordNotifications = {
    newArticle = true,
    articleUpdated = true
}

Config.DefaultApp = false

Config.JobName = "journaliste"

Config.Permissions = {
    create = 0, -- the grade required to create articles & have a profile on the app
    categories = 0, -- the grade required to be able to create new categories
    unpublish = 3, -- the grade required to unpublish others articles
}

Config.Header = {
    text = "Weazel News",
    fontSize = "2em",
    color = {
        light = "#000000",
        dark = "#FFFFFF",
    },
    image = false -- here you can set a link to an image, please note that you can't use both image and text, we recommend an aspect ratio of 1430:175
}
