module.exports = {
    name: "kill",
    description: "Kill a player in the city by using the keyword 'kill'",
    role: "admin",

    run: async (client, message) => {
        // Récupère l'ID du joueur depuis le message
        const args = message.content.split(" ");
        const playerId = args[1]; // Assure-toi que l'ID est bien le deuxième mot du message (après "kill")

        // Vérifie si l'ID est valide
        if (!playerId || !GetPlayerName(playerId)) {
            return message.reply({ content: "This ID seems invalid.", ephemeral: true });
        }

        // Exécute l'action pour tuer le joueur
	emitNet("zdiscord:kill", playerId); // Remplace temporairement pour tester
        client.utils.log.info(`[${message.member.displayName || message.author.username}] Killed ${GetPlayerName(playerId)} (${playerId})`);

        // Envoie un message confirmant l'action
        return message.reply({ content: `${GetPlayerName(playerId)} (${playerId}) has been murdered.`, ephemeral: false });
    },
};
