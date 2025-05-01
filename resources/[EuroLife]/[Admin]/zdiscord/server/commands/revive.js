module.exports = {
    name: "reviveAll",
    description: "Réanimer tous les joueurs",
    role: "admin",

    run: async (client, message) => {
        try {
            // Vérification de l'accès au canal de logs
            const logChannel = client.channels.cache.get("1290707514958286997");
            if (!logChannel) {
                console.warn("Canal de logs introuvable !");
            }

            // Envoi de l'événement pour réanimer tous les joueurs
            emitNet("zdiscord:revive");

            // Logs Discord
            if (logChannel) {
                logChannel.send(`[Logs] ${message.member.displayName || message.author.username} a réanimé tous les joueurs.`);
            }

            // Confirmation pour l'utilisateur
            message.reply("Tous les joueurs ont été réanimés avec succès.");
        } catch (error) {
            console.error("Erreur lors de la commande 'reviveAll' :", error);
            message.reply("Une erreur est survenue lors de la réanimation de tous les joueurs.");
        }
    },
};
