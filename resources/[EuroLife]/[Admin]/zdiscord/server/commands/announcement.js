module.exports = {
    name: "announcement",
    description: "Envoyer une annonce",
    role: "mod",

    run: async (client, message, args) => {
        const announcement = args.join(" ");
        if (!announcement) return message.reply("Veuillez fournir le contenu de l'annonce.");

        // Envoie l'annonce dans le serveur FiveM
        client.utils.chatMessage(-1, client.z.locale.announcement, announcement, { color: [255, 0, 0] });
        client.utils.log.info(`[${message.member.displayName || message.author.username}] Annonce: ${announcement}`);

        // Envoie le message de confirmation
        message.reply("Annonce envoyée.");

        // Envoie dans le salon Discord
        const channel = client.channels.cache.get("1290707514958286997");
        if (channel) channel.send(`Logs -   [${message.member.displayName || message.author.username}] Annonce: ${announcement}`);
    },
};
