module.exports = {
    name: "tp",
    description: "Téléporter un joueur",
    role: "mod",

    run: async (client, message, args) => {
        try {
            const subCommand = args[0]; // "coords" ou "preset"
            const playerId = parseInt(args[1], 10);

            if (isNaN(playerId) || !GetPlayerName(playerId)) {
                return message.reply("ID de joueur invalide ou joueur non connecté.");
            }

            const channel = client.channels.cache.get("1290707514958286997");

            if (subCommand === "coords") {
                const [x, y, z, vehicule] = [parseFloat(args[2]), parseFloat(args[3]), parseFloat(args[4]), args[5] === "true"];

                if (isNaN(x) || isNaN(y) || isNaN(z)) {
                    return message.reply("Coordonnées invalides.");
                }

                teleport(playerId, x, y, z, vehicule);
                channel?.send(`Logs - [${message.member.displayName || message.author.username}] a téléporté ${GetPlayerName(playerId)} (${playerId}) à ${x}, ${y}, ${z}`);
                return message.reply(`${GetPlayerName(playerId)} (${playerId}) a été téléporté aux coordonnées spécifiées.`);
            } else if (subCommand === "preset") {
                const location = args[2];
                const vehicule = args[3] === "true";

                const locations = {
                    "airport": [-1096.19, -3501.1, 17.18],
                    "mazeroof": [-75.57, -818.88, 327.96],
                    "pier": [-1712.06, -1136.48, 13.08],
                    "militarybase": [-2105.88, 2871.16, 32.81],
                    "chiliad": [453.73, 5572.2, 781.18],
                };

                if (!locations[location]) {
                    return message.reply("Emplacement prédéfini invalide.");
                }

                teleport(playerId, ...locations[location], vehicule);
                channel?.send(`Logs - [${message.member.displayName || message.author.username}] a téléporté ${GetPlayerName(playerId)} (${playerId}) à ${location}`);
                return message.reply(`${GetPlayerName(playerId)} (${playerId}) a été téléporté à ${location}.`);
            } else {
                return message.reply("Commande invalide. Utilisez `tp coords` ou `tp preset`.");
            }
        } catch (error) {
            console.error(error);
            message.reply("Une erreur est survenue lors de l'exécution de la commande.");
        }
    },
};

function teleport(id, x, y, z, withVehicle = false) {
    if (NetworkGetEntityOwner(GetPlayerPed(id)) == id) {
        emitNet(`${GetCurrentResourceName()}:teleport`, id, x.toFixed(2), y.toFixed(2), z.toFixed(2), withVehicle);
    } else {
        SetEntityCoords(GetPlayerPed(id), x.toFixed(2), y.toFixed(2), z.toFixed(2));
    }
}
