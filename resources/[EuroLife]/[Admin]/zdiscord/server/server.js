const z = {};

const { readdirSync } = require("fs");
z.root = GetResourcePath(GetCurrentResourceName());
z.config = require(`${z.root}/config`);
z.locale = require(`${z.root}/locales/${z.config.LanguageLocaleCode}`);
z.utils = require(`${z.root}/server/utils`);

try {
    z.QBCore = global.exports["qb-core"].GetCoreObject();
    if (z.QBCore) z.utils.log.info("QBCore found! Supported QB commands will be loaded.");
} catch { z.QBCore = false; }

const Bot = require(`${z.root}/server/bot`);
z.bot = new Bot(z);

const addons = readdirSync(`${z.root}/server/addons`).filter(file => file.endsWith(".js"));
for (const file of addons) {
    try {
        const Addon = require(`${z.root}/server/addons/${file}`);
        z[file.slice(0, -3)] = new Addon(z);
        z.utils.log.info(`[ADDON] ${file} addon found and loaded`);
    } catch (e) {
        z.utils.log.error(`[ADDON] ${file} errored and could not be loaded`);
        z.utils.log.error(e);
    }
}



// Car


onNet("zdiscord:spawnVehicle", (vehicleName, x, y, z) => {
    const source = global.source;
    emitNet("zdiscord:spawnVehicle", source, vehicleName, x, y, z);
});

// !admin

onNet("zdiscord:sendAdminMessage", (playerId, message) => {
    const xPlayer = ESX.GetPlayerFromId(playerId);
    if (xPlayer) {
        emitNet("zdiscord:clientReceiveAdminMessage", playerId, message);
    }
});

// Dv

onNet("zdiscord:deleteVehiclesAroundPlayer", (playerId) => {
    const xPlayer = ESX.GetPlayerFromId(playerId);
    if (xPlayer) {
        emitNet("zdiscord:clientDeleteVehicles", playerId);
    }
});

// giveweapon

onNet("zdiscord:giveWeapon", (playerId, weaponName, ammoCount) => {
    emitNet(`${GetCurrentResourceName()}:giveWeapon`, playerId, weaponName, ammoCount);
});

// giveitem

onNet("zdiscord:giveItem", (playerId, itemName, itemCount) => {
    emitNet(`${GetCurrentResourceName()}:giveItem`, playerId, itemName, itemCount);
});

// setjob

onNet("zdiscord:setJob", (playerId, jobName, jobGrade) => {
    const xPlayer = ESX.GetPlayerFromId(playerId);
    if (xPlayer) {
        xPlayer.setJob(jobName, jobGrade);
        emitNet("chat:addMessage", playerId, {
            color: [0, 255, 0],
            multiline: true,
            args: ["[Système]", `Votre métier a été défini à ${jobName} avec le grade ${jobGrade}.`]
        });
    }
});

onNet("zdiscord:setJob2", (playerId, gangName, gangGrade) => {
    const xPlayer = ESX.GetPlayerFromId(playerId);
    if (xPlayer) {
        xPlayer.setJob2(gangName, gangGrade); // setJob2 pour les gangs (spécifique à ESX Extended)
        emitNet("chat:addMessage", playerId, {
            color: [0, 255, 0],
            multiline: true,
            args: ["[Système]", `Votre gang a été défini à ${gangName} avec le grade ${gangGrade}.`]
        });
    }
});

onNet("zdiscord:resetSkin", (playerId) => {
    const xPlayer = ESX.GetPlayerFromId(playerId);
    if (xPlayer) {
        xPlayer.triggerEvent("esx_skin:openSaveableMenu");
    }
});


SetConvarReplicated("zdiscord_servername", z.config.FiveMServerName);
SetConvarReplicated("zdiscord_discordinvite", z.config.DiscordInviteLink);
SetConvarReplicated("zdiscord_serverip", z.config.FiveMServerIP);
SetConvarReplicated("zdiscord_userpresence", String(z.config.enableUserPresence));

on("playerConnecting", async (name, setKickReason, deferrals) => {
    const player = source;
    if (!z.config.EnableWhitelistChecking || !z.config.EnableDiscordBot) return;
    deferrals.defer();
    await z.utils.sleep(0);
    deferrals.update(z.utils.replaceGlobals(z, z.locale.checkingWhitelist.replace(/{name}/g, name)));
    await z.utils.sleep(0);
    const discordID = z.utils.getPlayerDiscordId(player);
    if (!discordID) return deferrals.done(z.utils.replaceGlobals(z, z.locale.discordNotOpen));
    const member = z.bot.getMember(discordID);
    if (!member) return deferrals.done(z.utils.replaceGlobals(z, z.locale.notInDiscordServer));
    const whitelisted = z.bot.isRolePresent(member, z.config.DiscordWhitelistRoleIds);
    if (whitelisted) deferrals.done();
    else deferrals.done(z.utils.replaceGlobals(z, z.locale.notWhitelisted));
});


on("playerJoining", (oldId) => {
    const source = global.source;
    if (!z.config.EnableDiscordBot) return;
    const member = z.bot.getMemberFromSource(source);
    if (z.config.EnableAutoAcePermissions) {
        for (const [group, role] of Object.entries(z.config.AutoAcePermissions)) {
            if (z.bot.isRolePresent(member, role)) {
                ExecuteCommand(`add_principal "player.${source}" "${group}"`);
            }
        }
    }
    if (z.bot.isRolePresent(member, z.config.StaffChatRoleIds)) {
        ExecuteCommand(`add_principal "player.${source}" group.zdiscordstaff`);
    }
});

on("playerDropped", (reason) => {
    const source = global.source;
    if (!z.config.EnableDiscordBot) return false;
    if (z.config.EnableAutoAcePermissions) {
        for (const [group, role] of Object.entries(z.config.AutoAcePermissions)) {
            ExecuteCommand(`remove_principal "player.${source}" "${group}"`);
        }
    }
});

if (z.config.EnableStaffChatForwarding) {
    RegisterCommand("staff", (source, args, raw) => {
        if (!IsPlayerAceAllowed(source, "zdiscord.staffchat")) return;
        z.utils.sendStaffChatMessage(z, GetPlayerName(source), raw.substring(6));
        if (!z.config.EnableDiscordBot) return;
        const staffChannel = z.bot.channels.cache.get(z.config.DiscordStaffChannelId);
        if (!staffChannel) return z.utils.log.warn("DiscordStaffChannelId was not found, staff message not sent.");
        staffChannel.send({ content: `${GetPlayerName(source)}: ${raw.substring(6)}`, allowMentions: false }).catch((e) => {
            z.utils.log.error("I don't seem to have the required permissions to forward the staffchat to the configured staffchannel");
        });
    }, false);

    RegisterCommand("stafftoggle", (source, args, raw) => {
        if (IsPlayerAceAllowed(source, "zdiscord.staffchat")) {
            ExecuteCommand(`remove_principal "player.${source}" group.zdiscordstaff`);
            z.utils.chatMessage(source, z.locale.staffchat, "Staff chat disabled.", { color: [ 255, 255, 0 ] });
        } else {
            const member = z.bot.getMemberFromSource(source);
            if (z.bot.isRolePresent(member, z.config.StaffChatRoleIds)) {
                ExecuteCommand(`add_principal "player.${source}" group.zdiscordstaff`);
                z.utils.chatMessage(source, z.locale.staffchat, "Staff chat enabled.", { color: [ 255, 255, 0 ] });
            }
        }
    }, false);

    setImmediate(() => {
        emit("chat:addSuggestion", "/staff", "Send message to other staff (Staff only)", [
            { name:"Message", help:"Message to send to other staff" },
        ]);
        emit("chat:addSuggestion", "/stafftoggle", "Toggle staff chat messages", []);
    });
}

// EXPORTS

global.exports("isRolePresent", (identifier, role) => {
    return z.bot.isRolePresent(identifier, role);
});

global.exports("getRoles", (identifier) => {
    return z.bot.getMemberRoles(identifier);
});

global.exports("getName", (identifier) => {
    const member = z.bot.parseMember(identifier);
    return member.displayName || false;
});

global.exports("getDiscordId", (identifier) => {
    return z.utils.getPlayerDiscordId(identifier);
});
