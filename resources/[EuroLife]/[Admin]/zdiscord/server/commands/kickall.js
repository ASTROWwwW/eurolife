module.exports = {
    name: "kickall",
    description: "Kick tout le monde",
    role: "admin",

    run: async (client, message, args) => {
        const reason = args.join(" ");
        if (!reason) return message.reply("Veuillez fournir une raison pour kick tout le monde.");

        const numberOnline = GetNumPlayerIndices();
        if (numberOnline === 0) return message.reply("Personne n'est connecté.");

        getPlayers().forEach((player) => {
            DropPlayer(player, reason);
        });

        message.reply(`${numberOnline} joueurs ont été kick. Raison : ${reason}`);
    },
};
