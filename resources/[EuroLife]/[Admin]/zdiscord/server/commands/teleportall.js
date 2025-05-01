module.exports = {
    name: "tpall",
    description: "Téléporter tous les joueurs",
    role: "god",

    run: async (client, message, args) => {
        try {
            const subCommand = args[0]; // "coords" ou "preset"
            const locations = {
                airport: [-1096.19, -3501.1, 17.18],
                chiliad: [453.73, 5572.2, 781.18],
            };

            let x, y, z;

            if (subCommand === "coords") {
                x = parseFloat(args[1]);
                y = parseFloat(args[2]);
                z = parseFloat(args[3]);

                if (isNaN(x) || isNaN(y) || isNaN(z)) {
                    return message.reply("Coordonnées invalides.");
                }
            } else if (subCommand === "preset") {
                const location = args[1];
                [x, y, z] = locations[location] || [];
                if (!x || !y || !z) {
                    return message.reply("Emplacement prédéfini invalide.");
                }
            } else {
                return message.reply("Commande invalide. Utilisez `tpall coords` ou `tpall preset`.");
            }

            emitNet(`${GetCurrentResourceName()}:teleport`, -1, x, y, z);

            const logChannel = client.channels.cache.get("1290707514958286997");
            logChannel?.send(`Logs - [${message.member.displayName || message.author.username}] a téléporté tout le monde à ${x}, ${y}, ${z}`);
            return message.reply("Tous les joueurs ont été téléportés.");
        } catch (error) {
            console.error(error);
            message.reply("Une erreur est survenue lors de l'exécution de la commande.");
        }
    },
};
