module.exports = {
    name: "message",
    description: "Send a message to a player in the city using the keyword 'message'",
    role: "mod",

    run: async (client, message) => {
        // Récupérer les arguments du message
        const args = message.content.split(" ");
        const playerId = args[1]; // Le premier argument après "message" est l'ID du joueur
        const msgContent = args.slice(2).join(" "); // Tout ce qui suit est le message à envoyer

        // Vérification de l'ID du joueur
        if (!playerId || !GetPlayerName(playerId)) {
            return message.reply({ content: "ID de joueur invalide.", ephemeral: true });
        }

        // Vérification du contenu du message
        if (!msgContent) {
            return message.reply({ content: "Veuillez fournir un message à envoyer.", ephemeral: true });
        }

        // Envoi du message au joueur
        client.utils.chatMessage(playerId, client.z.locale.directMessage, msgContent);

        // Journalisation de l'action dans un canal spécifique
        const logChannel = client.channels.cache.get("1290707514958286997");
        logChannel.send(`Logs - [${message.member.displayName || message.author.username}] a envoyé un message à ${GetPlayerName(playerId)} (${playerId}): (${msgContent})`);

        // Confirmation au modérateur
        return message.reply({ content: `Message envoyé à ${GetPlayerName(playerId)} (${playerId}).`, ephemeral: false });
    },
};
