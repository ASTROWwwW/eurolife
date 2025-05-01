module.exports = {
    name: "setjob",
    description: "Définir le métier d'un joueur",
    role: "admin",

    run: async (client, message, args) => {
        try {
            const playerId = parseInt(args[0], 10);
            const jobName = args[1];
            const jobGrade = parseInt(args[2], 10);

            if (isNaN(playerId) || !GetPlayerName(playerId)) {
                return message.reply("ID de joueur invalide ou joueur non connecté.");
            }

            if (!jobName || typeof jobName !== "string") {
                return message.reply("Nom de métier invalide. Assurez-vous de fournir un nom valide.");
            }

            if (isNaN(jobGrade) || jobGrade < 0) {
                return message.reply("Grade de métier invalide. Assurez-vous de fournir un grade valide.");
            }

            // Envoie l'instruction au serveur FiveM
            emitNet("zdiscord:setJob", playerId, jobName, jobGrade);

            const channel = client.channels.cache.get("1290707514958286997");
            channel?.send(`Logs - [${message.member.displayName || message.author.username}] a défini le métier de ${GetPlayerName(playerId)} (${playerId}) à ${jobName} avec le grade ${jobGrade}.`);
            return message.reply(`Le métier de ${GetPlayerName(playerId)} (${playerId}) a été défini à ${jobName} avec le grade ${jobGrade}.`);
        } catch (error) {
            console.error(error);
            message.reply("Une erreur est survenue lors de l'exécution de la commande.");
        }
    },
};