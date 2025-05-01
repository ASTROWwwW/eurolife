module.exports = {
    name: "car",
    description: "Spawn un véhicule à une position donnée",
    role: "admin",

    run: async (client, message, args) => {
        try {
            const vehicleName = args[0];
            const x = parseFloat(args[1]);
            const y = parseFloat(args[2]);
            const z = parseFloat(args[3]);

            if (!vehicleName) {
                return message.reply("Vous devez spécifier le nom du véhicule.");
            }

            if (isNaN(x) || isNaN(y) || isNaN(z)) {
                return message.reply("Coordonnées invalides. Assurez-vous de fournir des nombres valides.");
            }

            // Envoie l'instruction au serveur FiveM
            emitNet("zdiscord:spawnVehicle", -1, vehicleName, x, y, z);

            const channel = client.channels.cache.get("1290707514958286997");
            channel?.send(`Logs - [${message.member.displayName || message.author.username}] a spawn un véhicule (${vehicleName}) à (${x}, ${y}, ${z}).`);
            return message.reply(`Le véhicule ${vehicleName} a été spawn à (${x}, ${y}, ${z}).`);
        } catch (error) {
            console.error(error);
            message.reply("Une erreur est survenue lors de l'exécution de la commande.");
        }
    },
};