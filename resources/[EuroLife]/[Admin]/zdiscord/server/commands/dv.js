module.exports = {
    name: "dv",
    description: "Supprime tous les véhicules autour d'un joueur spécifié",
    role: "admin",

    run: async (client, message, args) => {
        try {
            const playerId = parseInt(args[0], 10);

            if (isNaN(playerId)) {
                return message.reply("❌ ID de joueur invalide.");
            }

            if (!GetPlayerName(playerId)) {
                return message.reply("❌ Joueur non connecté.");
            }

            // Envoie l'événement au serveur FiveM
            emitNet("zdiscord:deleteVehicles", playerId);

            return message.reply(`✅ Tous les véhicules autour du joueur ${playerId} vont être supprimés.`);
        } catch (error) {
            console.error(error);
            message.reply("❌ Une erreur est survenue.");
        }
    },
};
