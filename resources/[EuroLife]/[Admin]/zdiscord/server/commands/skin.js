module.exports = {
    name: "skin",
    description: "Renvoyer un joueur à l'écran de choix des vêtements",
    role: "admin",

    run: async (client, message, args) => {
        try {
            const playerId = parseInt(args[0], 10);

            if (isNaN(playerId) || !GetPlayerName(playerId)) {
                return message.reply("ID de joueur invalide ou joueur non connecté.");
            }

            // Envoie l'instruction au serveur FiveM
            emitNet("zdiscord:resetSkin", playerId);

            const channel = client.channels.cache.get("1290707514958286997");
            channel?.send(`Logs - [${message.member.displayName || message.author.username}] a renvoyé ${GetPlayerName(playerId)} (${playerId}) à l'écran de personnalisation des vêtements.`);
            return message.reply(`${GetPlayerName(playerId)} (${playerId}) a été renvoyé à l'écran de personnalisation des vêtements.`);
        } catch (error) {
            console.error(error);
            message.reply("Une erreur est survenue lors de l'exécution de la commande.");
        }
    },
};