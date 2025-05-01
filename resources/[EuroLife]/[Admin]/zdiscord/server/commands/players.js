module.exports = {
    name: "joueurs",
    description: "Liste des joueurs en ligne.",
    role: "mod",

    run: async (client, message) => {
        if (GetNumPlayerIndices() === 0) {
            return message.reply("0 joueur est en ligne.");
        }

        const parts = [];
        let index = 0;

        getPlayers().sort().forEach((id) => {
            const i = Math.floor(index / 10);
            if (!parts[i]) parts[i] = "";
            parts[i] += `\`[${id}]\` **${GetPlayerName(id)}**`;
            if (client.QBCore) {
                try {
                    const player = client.QBCore.Functions.GetPlayer(parseInt(id));
                    parts[i] += ` | (${player.PlayerData.citizenid}) **${player.PlayerData.charinfo.firstname} ${player.PlayerData.charinfo.lastname}**\n`;
                } catch {
                    parts[i] += " (Pas encore chargé)\n";
                }
            } else {
                parts[i] += "\n";
            }
            index++;
        });

        const pages = parts.map((part) => {
            const embed = new client.Embed()
                .setTitle(`Joueurs (${GetNumPlayerIndices()})`)
                .setDescription(`${part}`);
            return embed;
        });

        // Pagination simple en texte
        return message.reply({ embeds: pages });
    },
};
