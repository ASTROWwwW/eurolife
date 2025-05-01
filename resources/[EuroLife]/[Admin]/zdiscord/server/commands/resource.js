module.exports = {
    name: "ressource",
    description: "Gérer les ressources du serveur",
    role: "god",

    run: async (client, context, args) => {
        const isMessage = !!context.content; // Vérifie si la commande est un message ou une interaction
        const logChannel = client.channels.cache.get("1290707514958286997");

        try {
            let subCommand, script;
            if (isMessage) {
                // Gestion avec préfixe `!`
                subCommand = args[0]; // Exemple : !ressource start nom_script
                script = args[1];
            } else {
                // Gestion avec interaction `/`
                subCommand = context.options.getSubcommand();
                script = context.options.getString("script");
            }

            if (subCommand === "refresh") {
                ExecuteCommand("refresh");
                const msg = "Les ressources ont été actualisées.";
                if (isMessage) context.reply(msg);
                else context.reply({ content: msg, ephemeral: true });
                if (logChannel) logChannel.send(`[Logs] ${context.member.displayName} a actualisé les ressources.`);
            } else if (subCommand === "list") {
                const resources = [];
                for (let i = 0; i < GetNumResources(); i++) {
                    const resource = GetResourceByFindIndex(i);
                    if (GetResourceState(resource) === "started") {
                        resources.push(resource);
                    }
                }
                const embed = new client.Embed()
                    .setTitle("Ressources actives")
                    .setDescription(resources.length > 0 ? resources.join("\n") : "Aucune ressource active.")
                    .setFooter({ text: `Total : ${resources.length}` });

                if (isMessage) context.reply({ embeds: [embed] });
                else context.reply({ embeds: [embed], ephemeral: true });
                if (logChannel) logChannel.send(`[Logs] ${context.member.displayName} a listé les ressources actives.`);
            } else if (subCommand === "start" || subCommand === "stop") {
                if (!script) {
                    const errorMsg = "Veuillez fournir un nom de ressource valide.";
                    if (isMessage) return context.reply(errorMsg);
                    else return context.reply({ content: errorMsg, ephemeral: true });
                }

                const action = subCommand === "start" ? StartResource(script) : StopResource(script);
                const resultMsg = action
                    ? `${script} a été ${subCommand === "start" ? "démarré" : "arrêté"}.`
                    : `Impossible de ${subCommand === "start" ? "démarrer" : "arrêter"} ${script}.`;

                if (isMessage) context.reply(resultMsg);
                else context.reply({ content: resultMsg, ephemeral: true });
                if (logChannel) logChannel.send(`[Logs] ${context.member.displayName} a ${subCommand === "start" ? "démarré" : "arrêté"} ${script}.`);
            }
        } catch (error) {
            console.error("Erreur dans la commande 'ressource' :", error);
            if (isMessage) context.reply("Une erreur est survenue lors de l'exécution de la commande.");
            else context.reply({ content: "Une erreur est survenue.", ephemeral: true });
        }
    },
};
