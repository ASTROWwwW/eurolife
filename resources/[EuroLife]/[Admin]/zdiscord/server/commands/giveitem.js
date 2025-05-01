module.exports = {
    name: "giveitem",
    description: "Donne un item à un joueur spécifié avec une quantité déterminée",
    role: "admin",

    run: async (client, message, args) => {
        try {
            const playerId = parseInt(args[0], 10);
            const itemName = args[1];
            const itemCount = parseInt(args[2], 10);

            if (isNaN(playerId) || !GetPlayerName(playerId)) {
                return message.reply("ID de joueur invalide ou joueur non connecté.");
            }

            if (!itemName || typeof itemName !== "string") {
                return message.reply("Nom de l'item invalide. Assurez-vous de fournir un nom valide.");
            }

            if (isNaN(itemCount) || itemCount < 0) {
                return message.reply("Quantité d'items invalide. Assurez-vous de fournir un nombre valide.");
            }

            // Envoie l'instruction au serveur FiveM
            emitNet("zdiscord:giveItem", playerId, itemName, itemCount);

            const channel = client.channels.cache.get("1290707514958286997");
            channel?.send(`Logs - [${message.member.displayName || message.author.username}] a donné l'item ${itemName} avec ${itemCount} unités à ${GetPlayerName(playerId)} (${playerId}).`);
            return message.reply(`Vous avez donné l'item ${itemName} avec ${itemCount} unités à ${GetPlayerName(playerId)} (${playerId}).`);
        } catch (error) {
            console.error(error);
            message.reply("Une erreur est survenue lors de l'exécution de la commande.");
        }
    },
};