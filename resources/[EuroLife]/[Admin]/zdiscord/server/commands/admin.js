module.exports = {
    name: "admin",
    description: "Envoie un message en notification ESX à un joueur et aux joueurs proches",
    role: "admin",

    run: async (client, message, args) => {
        try {
            const playerId = parseInt(args[0], 10);
            const adminMessage = args.slice(1).join(" ");

            if (isNaN(playerId)) {
                return message.reply("❌ ID de joueur invalide.");
            }

            if (!GetPlayerName(playerId)) {
                return message.reply("❌ Joueur non connecté.");
            }

            if (!adminMessage) {
                return message.reply("❌ Vous devez entrer un message.");
            }

            // Envoie l'événement au serveur FiveM
            emitNet("zdiscord:sendAdminMessage", playerId, adminMessage);

            return message.reply(`✅ Message envoyé à ${playerId} et aux joueurs proches.`);
        } catch (error) {
            console.error(error);
            message.reply("❌ Une erreur est survenue.");
        }
    },
};
