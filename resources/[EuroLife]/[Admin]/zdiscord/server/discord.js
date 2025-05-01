const express = require('express');
const cors = require('cors');
const path = require('path');
const { Client, GatewayIntentBits } = require('discord.js');

const app = express();
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent
    ]
});

// Configuration
const DISCORD_TOKEN = 'MTM0NTAwMDkyNzM2MjI4OTcwNQ.GgxQaa.bUY3HwT-iQGldnj8_C6nHgxziiMXmZkubvjDGQ';
const CHANNEL_ID = '1315725144437821500';

// Middleware
app.use(cors({ origin: '*' }));
app.use(express.json());

// Route pour servir index.html
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Route pour envoyer des commandes au bot depuis le site web
app.post('/send-command', async (req, res) => {
    const command = req.body.command;
    if (!command) return res.status(400).send('Aucune commande spécifiée.');

    try {
        const channel = await client.channels.fetch(CHANNEL_ID);
        if (!channel) return res.status(404).send('Salon Discord introuvable.');

        await channel.send(`${command}`);
        res.status(200).send('Commande envoyée avec succès.');
    } catch (error) {
        console.error("Erreur lors de l'envoi de la commande: ", error);
        res.status(500).send("Erreur lors de l'envoi de la commande.");
    }
});

// Commande Discord "serveur" pour envoyer des informations
client.on('messageCreate', async (message) => {
    if (message.channel.id === CHANNEL_ID && message.content.toLowerCase() === 'serveur') {
        const embed = {
            title: "Informations du Serveur",
            description: "Voici les détails du serveur FiveM et Discord.",
            fields: [
                { name: "Nom du serveur", value: "Mon Serveur", inline: true },
                { name: "Adresse IP", value: "127.0.0.1", inline: true },
                { name: "Joueurs en ligne", value: "10/100", inline: true }
            ],
            footer: { text: "Données du serveur FiveM et Discord" }
        };
        await message.channel.send({ embeds: [embed] });
    }
});

// Événement lorsque le bot est prêt
client.once('ready', () => {
    console.log(`Connecté en tant que ${client.user.tag}`);
});

// Démarrage du bot et du serveur web
client.login(DISCORD_TOKEN);
app.listen(3001, '0.0.0.0', () => {
    console.log("Serveur web démarré sur https://eurolifecity.fr");
});
