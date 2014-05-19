--[[
Accends Umlaute etc...

   à : \195\160    è : \195\168    ì : \195\172    ò : \195\178    ù : \195\185
   á : \195\161    é : \195\169    í : \195\173    ó : \195\179    ú : \195\186
   â : \195\162    ê : \195\170    î : \195\174    ô : \195\180    û : \195\187
   ã : \195\163    ë : \195\171    ï : \195\175    õ : \195\181    ü : \195\188
   ä : \195\164                    ñ : \195\177    ö : \195\182
   æ : \195\166                                    ø : \195\184
   ç : \195\167                                    œ : \197\147
   
   Ä : \195\132
   Ö : \195\150
   Ü : \195\156
   ß : \195\159





--]]

wrRaidTracker_lang = {
	["Messages"] = {
		["ADDONLOADED"] = "wrAddon: RaidTracker geladen",
		["ADDONCLEARLOG"] = "Log gel\195\182scht.",
		["UNKNOWNRARITY"] = "Unbekannt",
		["raidstart"] = "Raidtracking gestartet. Zone: ",
		["raidend"] = "Raidtracking beendet.",
		["noraidzone"] = "Keine Instanz...",
		["endraidbeforeexport"] = "Du Musst den Raid beenden, bevor du ihn exportierst.",
		["invalidraidid"] = "Ung\195\188ltige ID",
		["noraidsinlist"] = "You have no Raids recorded.",
		["helpl01"] = "#########################################",
		["helpl02"] = "# wrRaidTracker Help                    #",
		["helpl03"] = "# /rt oder /rt help -> shows this help text         #",
		["helpl04"] = "# /rt start -> starts new raid   #",
		["helpl05"] = "# /rt stop -> stops the raid            #",
		["helpl06"] = "# and shows the eqDKP-Plus String       #",
		["helpl07"] = "# /rt list -> lists your recorded raids #",
		["helpl08"] = "# /rt show #id -> shows dkp string      #",
		["helpl09"] = "# and shows the eqDKP-Plus String       #",
		["helpl10"] = "# /rt del #id -> deletes the given raid \n#",
		["helpl11"] = "# /rt clear -> cleared the Raid-Log \n#",
		["helpl12"] = "# /rt addboss -> Lists the available Bosses for the Zone \n#",
		["helpl13"] = "# /rt addboss #id -> Adds a BossKill \n#",
		["helpl14"] = "# /rt listitems [#id] -> lists the dropped items \n#",
		["helpl15"] = "# /rt addprice #price #itemid [#raidid] ->",
		["helpl16"] = "# adds a price to the specified item \n#",
		
		["endraidfirst"] = "Bitte beende den laufenden Raid bevor du einen neuen startest.",
		["deleteraidsuccess"] = " gel\195\182scht",
		["endbeforedelete"] = " Raid erst beenden bevor er gel\195\182scht wird.",
		["endraidbeforeclear"] = " Bitte beende den Raid bevor du das Log löschst.",
		["logclearsuccess"] = "Das Raid-Log wurde geleert.",
		["wrongbossid"] = "Falsche Boss - ID",
		["bossadded1"] = "BossKill hinzugef\195\188gt: ",
		["bossadded2"] = " um ",
		["noraidrunning"] = "You have to start a raid first",
		["unknownzone"]= "Unbekannte Zone",
		["nobossinzone"] = "There is no Boss in the current Zone.",
		["zonechanged"] = "Zone Ge\195\164ndert",		
	},
	["Rarity"] = { "Standard", "Normal", "Gut", "Selten"," Episch" },
	["Patterns"] = {
		["ITEMDROPPED1"] = "([^%s]+) hat Folgendes erhalten.*cff(.+)%[(.*)%].*x (%d+)",
		["ITEMDROPPED2"] = "([^%s]+) hat Folgendes erhalten.*cff(.+)%[(.*)%]",
		["ITEMDROPPED3"] = "Ihr erhaltet.*cff(.+)%[(.*)%].*x (%d+)",
		["ITEMDROPPED4"] = "Ihr erhaltet.*cff(.+)%[(.*)%]",		
	},
	["Class"] = { "RITTER", "KRIEGER", "PRIESTER", "MAGIER", "SCHURKE", "KUNDSCHAFTER" },
	["Zones"] = {
		["Cavern of Trials"] = "H\195\182hle der Pr\195\188fungen",
		["Forsaken Abbey"] = "Verlassene Abtei",
		["Necropolis of Mirrors"] = "Gr\195\164berstadt der Spiegel",
		["Mystic Altar"] = "Mystischer Altar",
		["Queen's Chamber"] = "K\195\182niginnenkammer",
		["Pasper's Shrine"] = "Schrein von Pasper",
		["Kalin Shrine"] = "Schrein von Kalin",
		["Treasure Trove"] = "Schatzh\195\182hle",
		["Barren Caves"] = "Karge H\195\182hlen",
		["Bloody Gallery"] = "Blutige Galerie",
		["Revivers' Corridor"] = "Auferstehungskorridor",
		["Guards Corridor"] = "Korridor der W\195\164chter",
		["Royals' Refuge"] = "K\195\182nigliche Zufluckt",
		["Windmill Basement"] = "Windm\195\188hlenkeller",
		["Arcane Chamber of Sathkur"] = "Arkane Kammer des Sathkur",
		["Cyclops Lair"] = "H\195\182hle der Zyklopen",
		["Fungus Garden"] = "Pilzgarten",
		["Spirit of Tempest Height"] = "Seele der Sturmh\195\182he",
	},
	["Bosses"] = {
		["Windm\195\188hlenkeller"] = {
			[1] = {	"Hodu Hammertooth", "Hodu Hammerzahn" }, 
			[0] = {	"Geianth", "Knochenbrecher" }			
		},	
		["Verlassene Abtei"] = {
			[1] = { "Ghoul Duke", "Ghul Duke" },
			[2] = { "Flowing Chaos", "Flie\195\159endes Chaos" },
			[3] = { "Cruel Eater", "Gr\195\164uelfresser" },
			[4] = { "Hollow Shell", "Leere H\195\188lle" },
			[5] = { "Demon Witch Ancalon", "D\195\164monenhexe Ancalon" },
		},
		["Gr\195\164berstadt der Spiegel"] = {
			[1] = { "Magister Gumas", "Magister Gumas" },
			[2] = { "Androlier's Prisoner", "Androliers Gefangener" },
			[3] = { "Androlier's Shadow", "Androliers Schatten" },
			[4] = { "Androlier's Strength", "Androliers St\195\164rke" },
			[5] = { "Krodamar", "Krodamar" },
			[6] = { "Krodamon", "Krodamon" },
		},
		["Mystischer Altar"] = {
			[1] = { "Cursed lron Golem", "Verw\195\188nschter Eisengolem" },
			[2] = { "Razeela", "Razeela" },
			[3] = { "Aukuda", "Aukuda der Verw\195\188nschte" },
			[4] = { "Dorlos", "Dorlos" },			
			[5] = { "Worr Binpike", "Worr Binpike" },
			[6] = { "Lynn Binpike", "Lynn Binbike" },
		},
		["K\195\182niginnenkammer"] = {
			[1] = { "Kal Turok Queen", "K\195\182nigin von Kal-Turok" },
		},
		["Schrein von Pasper"] = {
			[1] = { "Blackhorn Nisorn", "Schwarzhorn Nisorn" },
			[2] = { "Blackhorn Hafiz", "Schwarzhorn Hafiz" },
			[3] = { "Blackhorn Dorglas", "Schwarzhorn-Dorglas" },
			[4] = { "Blackhorn Bareth", "Schwarzhorn Bareth" },
			[5] = { "Blackhorn Afalen", "Schwarzhorn Afalen" },
		},
		["Schrein von Kalin"] = {
			[1] = {	"Iron Rune Warrior", "Eisenrunenkrieger" },
			[2] = { "Yusalien", "Yusalien" },
			[3] = { "Locatha", "Locatha" },
			[4] = { "Goddess of Art's Disciple", "Adept der G\195\182ttin der K\195\188nste" },
			[5] = { "Ensia", "Ensia" },
			[6] = { "Regin", "Regin" }, -- need to be checked
		},
		["Blutige Galerie"] = {
			[1] = { "Count Hibara", "Graf Hibara" },			
		},
		["H\195\182hle der Zyklopen"] = {
			[1] = { "Boddosh", "Podag" },
			[2] = { "Zurhidon Negotiator", "Zurhidon-Unterh\195\164ndler" },
			[3] = { "Ordig", "Ortiga" },
			[4] = { "Gorn", "Gaia" },
			[5] = { "Masso", "Matthew" },
			[6] = { "Uguda", "Wagoda" },
		},
		["Neumondwald"] = {
			[1] = { "Perodia", "Perodia"}			
		},
		["Nord-Aslan"] = {
			[1] = { "Taylin Fishbone", "Taylin Fishbone"},
			[2] = { "Chester Iron Armor", "Chester Eisenpanzer" },
		},
		["Goblindorf"] = {
			[1] = { "Marclaw Hammertooth", "Kratzklaue Hammerzahn" }			
		},
		["Tagena"] = {
			[1] = { "Giant Guardian", "Riesenh\195\188ter", },
			[2] = { "Bronze Shell Scooray", "Bronzepanzer-Scooray", }			
		},
		["Schrein des Vergessens"] = {
			[1] = { "Giant Guardian", "Riesenh\195\188ter" },
		},
	},
};
