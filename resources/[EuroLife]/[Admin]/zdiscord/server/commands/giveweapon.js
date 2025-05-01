module.exports = {
    name: "giveweapon",
    description: "Donne une arme à un joueur spécifié avec un nombre de munitions déterminé",
    role: "admin",

    run: async (client, message, args) => {
        try {
            const playerId = parseInt(args[0], 10);
            const weaponName = args[1];
            const ammoCount = parseInt(args[2], 10);

            if (isNaN(playerId) || !GetPlayerName(playerId)) {
                return message.reply("ID de joueur invalide ou joueur non connecté.");
            }

            if (!weaponName || typeof weaponName !== "string") {
                return message.reply("Nom de l'arme invalide. Assurez-vous de fournir un nom valide.");
            }

            if (isNaN(ammoCount) || ammoCount < 0) {
                return message.reply("Quantité de munitions invalide. Assurez-vous de fournir un nombre valide.");
            }

            // Envoie l'instruction au serveur FiveM
            emitNet("zdiscord:giveWeapon", playerId, weaponName, ammoCount);

            const channel = client.channels.cache.get("1290707514958286997");
            channel?.send(`Logs - [${message.member.displayName || message.author.username}] a donné l'arme ${weaponName} avec ${ammoCount} munitions à ${GetPlayerName(playerId)} (${playerId}).`);
            return message.reply(`Vous avez donné l'arme ${weaponName} avec ${ammoCount} munitions à ${GetPlayerName(playerId)} (${playerId}).`);
        } catch (error) {
            console.error(error);
            message.reply("Une erreur est survenue lors de l'exécution de la commande.");
        }
    },
};