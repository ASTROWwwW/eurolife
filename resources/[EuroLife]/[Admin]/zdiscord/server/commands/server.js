module.exports = {
    name: "serveur",
    description: "Informations serveur FiveM et Discord",

    run: async (client, message) => {
        const embed = new client.Embed()
            .setThumbnail(message.guild.iconURL({ format: "png", size: 512 }))
            .addField("Serveur FiveM:", `**Version:** ${GetConvar("version", "Unknown")}
                **Nom du serveur:** ${client.config.FiveMServerName}
                **Ip du serveur:** ${client.config.FiveMServerIP}
                **Nombre de ressources:** ${GetNumResources()}
                **Game Build:** ${GetConvar("sv_enforceGameBuild", "Unknown")}
                **Joueur max:** ${GetConvar("sv_maxClients", "Unknown")}
                **OneSync:** ${GetConvar("onesync_enabled", "Unknown")}
                **Uptime:** ${(GetGameTimer() / 1000 / 60).toFixed(2)} minutes
                **Joueurs en ligne:** ${GetNumPlayerIndices()}`, false)
            .addField("Serveur Discord:", `**ID:** ${message.guild.id}
                **Invitations:** ${client.config.DiscordInviteLink}
                **Rôles:** ${message.guild.roles.cache.size}
                **Salons:** ${message.guild.channels.cache.filter((chan) => chan.type === "GUILD_TEXT").size}
                **Membres:** ${message.guild.memberCount}${getWhitelisted(client, message)}
                **Fondateur:** <@${message.guild.ownerId}> (${message.guild.ownerId})`, true)
            .setFooter({ text: "" });

        // Journalisation dans le canal de logs
        const logChannel = client.channels.cache.get("1290707514958286997");
        logChannel.send(`Logs - [${message.member.displayName || message.author.username}] a consulté les informations du serveur.`);

        return message.reply({ embeds: [embed] });
    },
};

function getWhitelisted(client, message) {
    if (!client.config.EnableWhitelistChecking) return "";
    const membersWithRole = message.guild.members.cache.filter((member) => {
        let found = false;
        client.config.DiscordWhitelistRoleIds.forEach((role) => {
            if (member.roles.cache.has(role)) found = true;
        });
        return found;
    });
    return `\n**Whitelisted:** ${membersWithRole.size}`;
}
