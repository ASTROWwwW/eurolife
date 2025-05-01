module.exports = {
    name: "kick",
    description: "Kick un joueur",
    role: "mod",

    run: async (client, message, args) => {
        const playerId = args[0];
        const reason = args.slice(1).join(" ") || "Raison non spécifiée";

        if (!GetPlayerName(playerId)) {
            return message.reply("ID invalide.");
        }

        DropPlayer(playerId, reason);
        const playerName = GetPlayerName(playerId);
        message.reply(`${playerName} (${playerId}) a été kick. Raison : ${reason}`);
    },
};
