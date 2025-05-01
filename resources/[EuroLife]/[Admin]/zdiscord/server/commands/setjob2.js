module.exports = {
    name: "setjob2",
    description: "Définir le gang d'un joueur",
    role: "admin",

    run: async (client, message, args) => {
        try {
            const playerId = parseInt(args[0], 10);
            const gangName = args[1];
            const gangGrade = parseInt(args[2], 10);

            if (isNaN(playerId) || !GetPlayerName(playerId)) {
                return message.reply("ID de joueur invalide ou joueur non connecté.");
            }

            if (!gangName || typeof gangName !== "string") {
                return message.reply("Nom de gang invalide. Assurez-vous de fournir un nom valide.");
            }

            if (isNaN(gangGrade) || gangGrade < 0) {
                return message.reply("Grade de gang invalide. Assurez-vous de fournir un grade valide.");
            }

            // Envoie l'instruction au serveur FiveM
            emitNet("zdiscord:setJob2", playerId, gangName, gangGrade);

            const channel = client.channels.cache.get("1290707514958286997");
            channel?.send(`Logs - [${message.member.displayName || message.author.username}] a défini le gang de ${GetPlayerName(playerId)} (${playerId}) à ${gangName} avec le grade ${gangGrade}.`);
            return message.reply(`Le gang de ${GetPlayerName(playerId)} (${playerId}) a été défini à ${gangName} avec le grade ${gangGrade}.`);
        } catch (error) {
            console.error(error);
            message.reply("Une erreur est survenue lors de l'exécution de la commande.");
        }
    },
};