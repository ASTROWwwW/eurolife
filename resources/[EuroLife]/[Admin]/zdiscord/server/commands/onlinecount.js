module.exports = {
    name: "onlinecount",
    description: "Nombre de joueurs en ligne",

    run: async (client, interaction) => {
        const playerNumber = GetNumPlayerIndices();
        let message = "Personne n'est connecté au serveur.";
        if (playerNumber === 1) message = "Il y a une personne en ligne.";
        else if (playerNumber > 1) message = `Il y a ${playerNumber} personnes en ligne.`;
        return interaction.reply({ content: message, ephemeral: false });
    },
};
