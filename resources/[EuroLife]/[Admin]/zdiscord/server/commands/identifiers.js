module.exports = {
    name: "identifiants",
    description: "Obtenir les identifiants d'un joueur",
    role: "admin",

    run: async (client, message, args) => {
        const playerId = args[0];
        if (!GetPlayerName(playerId)) return message.reply("ID invalide.");

        const identifiers = client.utils.getPlayerIdentifiers(playerId);
        const embed = new client.Embed()
            .setColor(client.config.embedColor)
            .setTitle(`Identifiants de ${GetPlayerName(playerId)}`);

        let description = "";
        for (const [key, value] of Object.entries(identifiers)) {
            if (key === "ip") continue; // Ignore les IPs
            description += `**${key}:** ${value}\n`;
        }
        embed.setDescription(description);

        message.reply({ embeds: [embed] });
    },
};
