wrRaidTracker_lang = {
	["Messages"] = {
		["ADDONLOADED"] = "wrAddon: RaidTracker loaded",
		["ADDONCLEARLOG"] = "Log cleared.",
		["UNKNOWNRARITY"] = "Unknow Rarity",
		["raidstart"] = "Raidtracking started. Zone: ",
		["raidend"] = "Raidtracking finished",
		["noraidzone"] = "No Instance...",
		["endraidbeforeexport"] = "You have to end the raid before you exporting it",
		["invalidraidid"] = "Invalid raid Raid-ID",
		["noraidsinlist"] = "You have no Raids recorded.",
		["helpl01"] = "#########################################",
		["helpl02"] = "# wrRaidTracker Help                    ",
		["helpl03"] = "# /rt or /rt help -> shows this help text         \n#",
		["helpl04"] = "# /rt start -> starts new raid   \n#",
		["helpl05"] = "# /rt stop -> stops the raid            ",
		["helpl06"] = "# and shows the eqDKP-Plus String       \n#",
		["helpl07"] = "# /rt list -> lists your recorded raids \n#",
		["helpl08"] = "# /rt show #id -> shows eqDKP-Plus String",
		["helpl09"] = "# of the given raid                      \n#",
		["helpl10"] = "# /rt del #id -> deletes the given raid \n#",
		["helpl11"] = "# /rt clear -> cleared the Raid-Log \n#",
		["helpl12"] = "# /rt addboss -> Lists the available Bosses for the Zone \n#",
		["helpl13"] = "# /rt addboss #id -> Adds a BossKill \n#",
		["helpl14"] = "# /rt listitems [#id] -> lists the dropped items \n#",
		["helpl15"] = "# /rt addprice #price #itemid [#raidid] ->",
		["helpl16"] = "# adds a price to the specified item \n#",
		
		["endraidfirst"] = "Please end the current raid before starting a new one.",
		["deleteraidsuccess"] = " successfully deleted",
		["endbeforedelete"] = " You have to end the raid before you delete it.",
		["endraidbeforeclear"] = " You have to end the raid before you clear the log.",
		["logclearsuccess"] = "The Raid-Log has been cleared.",
		["wrongbossid"] = "Wrong Boss ID",
		["bossadded1"] = "BossKill added: ",
		["bossadded2"] = " at ",
		["noraidrunning"] = "You have to start a raid first",
		["unknownzone"] = "Unknown Zone",
		["nobossinzone"] = "There is no Boss in the current Zone.", 
		["zonechanged"] = "Zone Changed",
	},
	["Rarity"] = { "Common", "Normal", "Good", "Rare"," Epic" },
	["Patterns"] = {
		["ITEMDROPPED1"] = "([^%s]+) got.*cff(.+)%[(.*)%].*x (%d+)",
		["ITEMDROPPED2"] = "([^%s]+) got.*cff(.+)%[(.*)%]",
		["ITEMDROPPED3"] = "You receive.*cff(.+)%[(.*)%].*x (%d+)",
		["ITEMDROPPED4"] = "You receive.*cff(.+)%[(.*)%]",		
	},
	["Class"] = { "RITTER", "KRIEGER", "PRIESTER", "MAGIER", "SCHURKE", "KUNDSCHAFTER" },
	["Zones"] = {
		--["Cavern of Trials"] = "Cavern of Trials",
		["Forsaken Abbey"] = "Forsaken Abbey",
		["Necropolis of Mirrors"] = "Necropolis of Mirrors",
		["Mystic Altar"] = "Mystic Altar",
		["Queen's Chamber"] = "Queen's Chamber",
		["Pasper's Shrine"] = "Pasper's Shrine",
		["Kalin Shrine"] = "Kalin Shrine",
		["Treasure Trove"] = "Treasure Trove",
		["Barren Caves"] = "Barren Caves",
		["Bloody Gallery"] = "Bloody Gallery",
		["Revivers' Corridor"] = "Revivers' Corridor",
		["Guards Corridor"] = "Guards Corridor",
		["Royals' Refuge"] = "Royals' Refuge",
		["Windmill Basement"] = "Windmill Basement",
		["Arcane Chamber of Sathkur"] = "Arcane Chamber of Sathkur",
		["Cyclops Lair"] = "Cyclops Lair",
		["Fungus Garden"] = "Fungus Garden",
		["Spirit of Tempest Height"] = "Spirit of Tempest Height",
	},
	["Bosses"] = {
		["Windmill Basement"] = {
			[1] = {	"Hodu Hammertooth", "Hodu Hammertooth" }, 
			[0] = {	"Geianth", "Geianth" }			
		},		
		["Forsaken Abbey"] = {
			[1] = { "Ghoul Duke", "Ghoul Duke" },
			[2] = { "Flowing Chaos", "Flowing Chaos" },
			[3] = { "Cruel Eater", "Cruel Eater" },
			[4] = { "Hollow Shell", "Hollow Shell" },
			[5] = { "Demon Witch Ancalon", "Demon Witch Ancalon" },
		},
		["Necropolis of Mirrors"] = {
			[1] = { "Krodamar", "Krodamar" },
			[2] = { "Krodamon", "Krodamon" },
			[3] = { "Magister Gumas", "Magister Gumas" },
			[4] = { "Androlier's Prisoner", "Androlier's Prisoner" },
			[5] = { "Androlier's Shadow", "Androlier's Shadow" },
			[6] = { "Androlier's Strength", "Androlier's Strength" },
		},
		["Mystic Altar"] = {
			[1] = { "Cursed lron Golem", "Cursed lron Golem" },
			[2] = { "Razeela", "Razeela" },
			[3] = { "Aukuda", "Aukuda, the Cursed" },
			[4] = { "Dorlos", "Dorlos" },			
			[5] = { "Worr Binpike", "Worr Binpike" },
			[6] = { "Lynn Binpike", "Lynn Binbike" },
		},
		["Queen's Chamber"] = {
			[1] = { "Kal Turok Queen", "Kal Turok Queen" },
		},
		["Pasper's Shrine"] = {
			[1] = { "Blackhorn Nisorn", "Blackhorn Nisorn" },
			[2] = { "Blackhorn Hafiz", "Blackhorn Hafiz" },
			[3] = { "Blackhorn Dorglas", "Blackhorn Dorglas" },
			[4] = { "Blackhorn Bareth", "Blackhorn Bareth" },
			[5] = { "Blackhorn Afalen", "Blackhorn Afalen" },
		},
		["Kalin Shrine"] = {
			[1] = {	"Iron Rune Warrior", "Iron Rune Warrior" },
			[2] = { "Yusalien", "Yusalien" },
			[3] = { "Locatha", "Locatha" },
			[4] = { "Goddess of Art's Disciple", "Goddess of Art's Disciple" },
			[5] = { "Ensia", "Ensia" },
			[6] = { "Regin", "Regin" }, -- need to be checked
		},
		["Bloody Gallery"] = {
			[1] = { "Count Hibara", "Count Hibara" },			
		},
		["Cyclops Lair"] = {
			[1] = { "Boddosh", "Boddosh" },
			[2] = { "Zurhidon Negotiator", "Zurhidon Negotiator" },
			[3] = { "Ordig", "Ordig" },
			[4] = { "Gorn", "Gorn" },
			[5] = { "Masso", "Masso" },
			[6] = { "Uguda", "Uguda" },
		},
		["New Moon Forest"] = {
			[1] = {},
			["Perodia"] = "Perodia",
		},
		["Aslan North"] = {
			[1] = { "Taylin Fishbone", "Taylin Fishbone"},
			[2] = { "Chester Iron Armor", "Chester Iron Armor" },
		},
		["Gobline Village"] = {
			[1] = {	"Marclaw Hammertooth", "Kratzklaue Hammerzahn"},		
		},
		["Tagena"] = {
			[1] = { "Giant Guardian", "Riesenh\195\188ter" },
			[2] = { "Bronze Shell Scooray", "Bronze Shell Scooray" },		
		},
		["Oblivion Shrine"] = {
			[1] = { "Giant Guardian", "Riesenh\195\188ter" },			
		},
	},
};