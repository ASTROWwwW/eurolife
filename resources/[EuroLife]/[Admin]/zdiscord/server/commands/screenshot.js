module.exports = {
    name: "screenshot",
    description: "Capture d'écran du point de vue d'un joueur",
    role: "god",

    run: async (client, message, args) => {
        try {
            // Récupérer l'ID du joueur depuis les arguments
            const playerId = parseInt(args[0], 10);

            if (isNaN(playerId) || !GetPlayerName(playerId)) {
                return message.reply("Cet ID est invalide ou le joueur est déconnecté.");
            }

            // Vérifier si le script screenshot-basic est actif
            if (GetResourceState("screenshot-basic") !== "started") {
                return message.reply("La ressource `screenshot-basic` n'est pas active. Veuillez l'activer pour utiliser cette commande.");
            }

            await message.reply("Prise de capture d'écran en cours...");

            // Nom de fichier pour le screenshot
            const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
            const fileName = `screenshot_${playerId}_${timestamp}.jpg`;

            // Prise de screenshot
            const data = await takeScreenshot(playerId);

            // Conversion des données en buffer pour Discord
            const buffer = Buffer.from(data, "base64");

            // Création d'un embed avec la capture d'écran
            const embed = new client.Embed()
                .setTitle(`Capture d'écran de ${GetPlayerName(playerId)}`)
                .setImage(`attachment://${fileName}`)
                .setFooter({ text: `Prise à ${timestamp}` });

            // Envoi dans le canal
            await message.channel.send({
                embeds: [embed],
                files: [{ attachment: buffer, name: fileName }],
            });

            // Sauvegarde sur le serveur si activé dans la configuration
            if (client.config.SaveScreenshotsToServer) {
                const fs = require("fs/promises");
                const screenshotPath = `${client.root}/screenshots`;
                await fs.mkdir(screenshotPath, { recursive: true });
                await fs.writeFile(`${screenshotPath}/${fileName}`, data, "base64");
            }

            // Logs dans le canal
            const logChannel = client.channels.cache.get("1290707514958286997");
            if (logChannel) {
                logChannel.send(`Logs - [${message.member.displayName || message.author.username}] a pris une capture d'écran de ${GetPlayerName(playerId)} (${playerId}).`);
            }
        } catch (error) {
            console.error("Erreur lors de la capture d'écran :", error);
            return message.reply("Une erreur est survenue lors de la prise de la capture d'écran.");
        }
    },
};

// Fonction utilitaire pour prendre une capture d'écran
const takeScreenshot = (id) => {
    return new Promise((resolve, reject) => {
        global.exports["screenshot-basic"].requestClientScreenshot(id, {}, (error, data) => {
            if (error) {
                return reject(`Erreur lors de la capture d'écran : ${error.message}`);
            }
            resolve(data.split(";base64,").pop());
        });
    });
};
