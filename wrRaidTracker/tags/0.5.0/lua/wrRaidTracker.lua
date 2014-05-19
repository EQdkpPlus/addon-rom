local wrRaidTracker = {}
_G["wrRaidTracker"] = wrRaidTracker;


local wrRaidTracker_Options = {}
wrRaidTracker_Options["DebugFlag"] = false;
wrRaidTracker_Options["informparty"] = true;
wrRaidTracker_Options["minQuality"] = 3;

--[[ LOCALES ]]--

local enabled = false;
wrRaidTracker_isLoaded = false;
local wrRaidTracker_version = 0.4
wrRaidTracker_raidLog = { }
local wrRaidTracker_currentRaid = nil;
local wrRaidTracker_rarityTable = { 
	["ffffff"] = 1, --normal
	["00ff00"] = 2, -- außergewöhnlich
	["0072bc"] = 3, -- selten
	["c805f8"] = 4, -- episch
	["f68e56"] = 5, -- legendär
}

local wrRaidTracker_currentRaidZone = nil;
local wrRaidTracker_currentRaidLogZoneId = nil
local wrRaidTracker_numBossKills = 0;

--[[ FUNCTIONS ]]--


function wrRaidTracker_Initialise(this)
	dofile("Interface/AddOns/wrRaidTracker/lang/"..GetLocation()..".lua");
	this:RegisterEvent("CHAT_MSG_SYSTEM_GET");
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("ZONE_CHANGED");
	this:RegisterEvent("PARTY_MEMBER_CHANGED");
	DEFAULT_CHAT_FRAME:AddMessage(wrRaidTracker_lang["Messages"]["ADDONLOADED"],0,255,255);
	wrRaidTracker_DropFrame_Title:SetText("Withoutrulez RaidTracker v"..wrRaidTracker_version);
	wrRaidTracker_isLoaded = true;
end


function wrRaidTracker_showFrame()
	wrRaidTracker_DropFrame:Show();
end

function wrRaidtracker_fixSex(sex)
	if(sex == 1) then
		return "f"
	else 
		return "m"
	end
end

function wrRaidTracker_getNumRaids()
	if( wrRaidTracker_raidLog) then
		wrRaidTracker_Debug("Log vorhanden", table.getn(wrRaidTracker_raidLog));
		return table.getn(wrRaidTracker_raidLog);
	end
	return 0;
end

function wrRaidTracker_createNewRaid()
	if (wrRaidTracker_currentRaid) then
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["endraidfirst"]);
		return;
	end
	local zone = GetZoneName();
	local sDate = wrRaidTracker_Time();
	wrRaidTracker_Online = { };
	wrRaidTracker_Offline = { };
	table.insert(wrRaidTracker_raidLog, 1, { 
		["BossKills"] = { },
		["Zones"] = { },
		["Loot"] = { },
		["PlayerInfos"] = { },
		["key"] = wrRaidTracker_Date(sDate),
	});
	wrRaidTracker_currentRaid = 1;
	
	-- Zone Eintragen	
	wrRaidTracker_addZone(zone);	
	-- Member Eintragen
	if(GetNumRaidMembers() > 0) then
	wrRaidTracker_Debug("Adding Raidmembers");
		for i = 1, GetNumRaidMembers()-1 do
			-- Informationen sammeln
			local sPlayer = UnitName("raid" .. i);
			--local guild = GetGuildInfo("raid" .. i);
			local name, online = GetRaidMember(i);
			local level = UnitLevel("raid" .. i);
			local class = UnitClass("raid" .. i);
			local sex = wrRaidtracker_fixSex(UnitSex("raid" .. i));
			-- Eintragen
			if(sPlayer) then
				if (not wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]) then
					wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name] = { };
				end
			--	if (guild) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["guild"] = guild; end;
				if (level) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["level"] = level; end;
				if (class) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["class"] = class;	end;
				if (sex) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["sex"] = sex;	end;
				
				wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"] = {}
				table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"],{sDate , "join"});
				if ( not online ) then
					table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"],{sDate+1 , "leave"});
					table.insert(wrRaidTracker_Offline, name);
				else
					table.insert(wrRaidTracker_Online, name);
				end
			end;
		end;
		isRaid = true;
	elseif (GetNumPartyMembers() > 0) then
		wrRaidTracker_Debug("Adding Partymembers");
		for i = 1, GetNumPartyMembers()-1, 1 do
			-- Infos sammeln
			local sPlayer = UnitName("party" .. i);
			--local guild = GetGuildInfo("party" .. i);
			local name, online = GetPartyMember(i);
			local level = UnitLevel("party" .. i);
			local class = UnitClass("party" .. i);
			local sex = wrRaidtracker_fixSex(UnitSex("party" .. i));
			
			wrRaidTracker_Debug("Name: ",name);
			if not(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]) then
				wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name] = {};
			end
			--if (guild) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["guild"] = guild; end;
			if (level) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["level"] = level; end;
			if (class) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["class"] = class;	end;
			if (sex) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["sex"] = sex;	end;
			
			wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"] = {}
			table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"],{sDate , "join"});
				if ( not online ) then
					table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"],{sDate+1 , "leave"});
					table.insert(wrRaidTracker_Offline, name);
				else 
					table.insert(wrRaidTracker_Online,name);
				end
		end;		
	end;
		
	if( not isRaid) then
		wrRaidTracker_Debug("Adding Player");
		-- Spieler eintragen
		-- Informationen
		local name = UnitName("player");
		local level = UnitLevel("player");
		local class = UnitClass("player");
		--local guild = GetGuildInfo("player");
		local sex = wrRaidtracker_fixSex(UnitSex("player"));
		local online = true;
		-- Eintragen
		if not(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]) then
			wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name] = {};
		end
		--if (guild) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["guild"] = guild; end;
		if (level) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["level"] = level; end;
		if (class) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["class"] = class;	end;
		if (sex) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["sex"] = sex;	end;
		
		wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"] = {}
		table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"],{sDate , "join"});
			if ( not online ) then
				table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"],{sDate+1 , "leave"});
				table.insert(wrRaidTracker_Offline, name);
			else
				table.insert(wrRaidTracker_Online,name);
			end
	end;
	local inform = wrRaidTracker_lang["Messages"]["raidstart"]..zone;
	wrRaidTracker_Print(inform, true);
	wrRaidTracker_Debug("ZONEID: "..wrRaidTracker_currentRaidLogZoneId);
	enabled=true;
end;

function wrRT_on()
	for k, v in pairs (wrRaidTracker_Online) do
		wrRaidTracker_Debug("ONLINE:", v);
	end
	for k, v in pairs (wrRaidTracker_Offline) do
		wrRaidTracker_Debug("OFFLINE:", v);
	end
	wrRaidTracker_Debug("---------------------");
end


function wrRaidTracker_Time()
	return os.time();
end

function wrRaidTracker_endRaid()
	local raidendtime = wrRaidTracker_Time()
	if(wrRaidTracker_currentRaid) then
        wrRaidTracker_Debug("Ending current raid at "..raidendtime, 1, 1, 0);
    	for k, v in pairs(wrRaidTracker_Online) do
			--wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][k]["leave"] = raidendtime;
			table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][v]["times"],{raidendtime , "leave"});
    	end
    	if(not wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["End"]) then
    		wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["End"] = raidendtime;
    	end
		if(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Zones"][wrRaidTracker_currentRaidLogZoneId]) then
			wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Zones"][wrRaidTracker_currentRaidLogZoneId]["leave"] = raidendtime;
		else
			wrRaidTracker_Print("no raid recorded, no raid zone entered.");
			wrRaidTracker_Online = { };
			wrRaidTracker_Offline = { };
			wrRaidTracker_deleteRaid(wrRaidTracker_currentRaid);
			wrRaidTracker_currentRaid = nil;
			wrRaidTracker_currentRaidZone = nil;
			enabled = false;
			
			return;
		end
		-- Nur in Unbekannter Zone ohne Worldbosskill = Löschung des Raids...
		if(wrRaidTracker_currentRaidLogZoneId == 1 and wrRaidTracker_currentRaidZone == "Unknown" and wrRaidTracker_numBossKills == 0) then
			wrRaidTracker_Debug("Nur in Unknown Zone gewesen, ohne bosskill");
			wrRaidTracker_deleteRaid(wrRaidTracker_currentRaid);
		else
			wrRaidTracker_generateXml(wrRaidTracker_currentRaid);
		end
    	wrRaidTracker_currentRaid = nil;
    	wrRaidTracker_Online = { };
		wrRaidTracker_Offline = { };
    else
		wrRaidTracker_Print("no raid running");
		return;
	end
	--wrRaidTracker_showFrame();
	wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["raidend"],true);
	wrRaidTracker_currentRaid = nil;
	wrRaidTracker_currentRaidZone = nil;
	enabled = false;
end

function wrRaidTracker_addZone(zone)
-- letzte Zone verlassen
wrRaidtracker_leaveZone();

-- neue Zone Betreten
wrRaidTracker_enterZone(zone);
end

function wrRaidtracker_leaveZone()
	local eTime = os.time();
	if(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Zones"][wrRaidTracker_currentRaidLogZoneId]) then
			wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Zones"][wrRaidTracker_currentRaidLogZoneId]["leave"] = eTime;
	end
end

function wrRaidTracker_enterZone(zone)
	local eTime = os.time();
	local oldZone = wrRaidTracker_currentRaidZone;
	
	-- todo : wenn die Alte Zone Unknown ist, und keine Bosskills, dann loesche die Zone...
	if(not wrRaidTracker_currentRaid) then
		wrRaidTracker_Debug("NO RAID STARTED");
		return
	end
	
	if(not wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Zones"]) then
		wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Zones"] = {};
	end;	
	
	-- Zone Eintragen
	wrRaidTracker_currentRaidZone = nil;
	for k,v in pairs (wrRaidTracker_lang["Zones"]) do
		if (v == zone) then
			wrRaidTracker_Debug("Bekannte ZOne...", k); 
			wrRaidTracker_currentRaidZone = k;
		end
	end

	if (not wrRaidTracker_currentRaidZone) then
		wrRaidTracker_currentRaidZone = "Unknown";
	end;
	
	wrRaidTracker_Debug("ZONE", wrRaidTracker_currentRaidZone,"OLDZONE", oldZone, "REALNAME", GetZoneName());
	
	if not(oldZone == wrRaidTracker_currentRaidZone) then
		-- Wenn Zone geändert...
		wrRaidTracker_Debug("Adding Zone: ", wrRaidTracker_currentRaidZone);
		local zoneentry = { ["name"] = wrRaidTracker_currentRaidZone, ["enter"] = eTime, ["leave"] = 0 };
		table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Zones"], zoneentry)
	end	
	wrRaidTracker_currentRaidLogZoneId = table.getn(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Zones"]);
	wrRaidTracker_Debug("CURR:",wrRaidTracker_currentRaidLogZoneId);
end

function wrRaidTracker_deleteRaid(id)
	if(wrRaidTracker_raidLog[id]) then
		if(not wrRaidTracker_raidLog[id]["End"]) then
			wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["endbeforedelete"]);
			return;
		end
		local toDel = wrRaidTracker_GetRaidTitle(id, false, true, true);
		table.remove(wrRaidTracker_raidLog,id);
		wrRaidTracker_Print("[ "..toDel.. " ]"..wrRaidTracker_lang["Messages"]["deleteraidsuccess"]);
	else
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["invalidraidid"]);
	end
	
end

function wrRaidTracker_generateXml(id)	
	if (not wrRaidTracker_raidLog[id]["End"]) then
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["endraidbeforeexport"]);
		return;
	end;
	-- global 
	local xml  = "<string>";
	-- head
	xml = xml.."<head><export><name>EQdkp Plus XML</name><version>1.0</version></export><tracker><name>wrRaidTracker</name><version>";
	xml = xml..wrRaidTracker_version.."</version></tracker><gameinfo><game>Runes of Magic</game><language>"..wrRaidTracker_getLanguage();
	xml = xml.."</language><charactername>"..UnitName("player").."</charactername></gameinfo></head>";
	
	-- raiddata
	xml = xml.."<raiddata>";
		if(wrRaidTracker_raidLog[id]["Zones"]) then
		xml = xml.."<zones>";
			for k,v in pairs(wrRaidTracker_raidLog[id]["Zones"]) do
				xml = xml.."<zone>";
					for k1, v1 in pairs(wrRaidTracker_raidLog[id]["Zones"][k]) do
						xml = xml.."<"..k1..">"..v1.."</"..k1..">";
					end					
				xml = xml.."</zone>";
			end
		xml = xml.."</zones>";
		end;
		xml = xml.."<bosskills>";
		if(wrRaidTracker_raidLog[id]["BossKills"]) then
			for k, v in pairs(wrRaidTracker_raidLog[id]["BossKills"]) do
			xml = xml.."<bosskill>";
				for k1, v1 in pairs(v) do
					xml = xml .. "<"..k1..">"..v1.."</"..k1..">";
				end
			xml = xml.."</bosskill>";
			end
		end
			--xml = xml.."<bosskill>";
				--xml = xml.."<name></name>";
				--xml = xml.."<time></time>";
			--xml = xml.."</bosskill>";
	
		xml = xml.."</bosskills>";
		if(wrRaidTracker_raidLog[id]["PlayerInfos"]) then
		xml = xml.."<members>";
			for k,v in pairs(wrRaidTracker_raidLog[id]["PlayerInfos"]) do
				xml = xml.."<member>";
					xml = xml.."<name>"..k.."</name>";
					for k1, v1 in pairs(wrRaidTracker_raidLog[id]["PlayerInfos"][k]) do
						if(type(v1) ~= "table") then
							xml = xml.."<"..k1..">"..v1.."</"..k1..">";
						else
							-- times
							xml = xml.."<"..k1..">";
								for k2, v2 in pairs(v1) do
									xml = xml.."<time type=\""..v2[2].."\">"..v2[1].."</time>";
								end
							xml = xml.."</"..k1..">";
						end
					end
					--xml = xml.."<class>"..wrRaidTracker_raidLog[id]["PlayerInfos"][k]["class"].."</class>";
					--xml = xml.."<level>"..wrRaidTracker_raidLog[id]["PlayerInfos"][k]["level"].."</level>";
					--xml = xml.."<sex>"..wrRaidTracker_raidLog[id]["PlayerInfos"][k]["sex"].."</sex>";
					--xml = xml.."<times>";
						--xml = xml.."<time type=\"join\">"..wrRaidTracker_raidLog[id]["PlayerInfos"][k]["join"].."</time>";
						--xml = xml.."<time type=\"leave\">"..wrRaidTracker_raidLog[id]["PlayerInfos"][k]["leave"].."</time>";
					--xml = xml.."</times>";
				xml = xml.."</member>";
			end;
		xml = xml.."</members>";
		end;
		xml = xml.."<items>";
		if(wrRaidTracker_raidLog[id]["Loot"]) then
		
			for k,v in pairs(wrRaidTracker_raidLog[id]["Loot"]) do
				xml = xml.."<item>";
					xml = xml.."<name>"..wrRaidTracker_raidLog[id]["Loot"][k]["name"].."</name>";
					xml = xml.."<time>"..wrRaidTracker_raidLog[id]["Loot"][k]["droptime"].."</time>";
					xml = xml.."<member>"..wrRaidTracker_raidLog[id]["Loot"][k]["finder"].."</member>";
					xml = xml.."<cost>"..wrRaidTracker_raidLog[id]["Loot"][k]["cost"].."</cost>";
				xml = xml.."</item>";
			end;
		end;
		xml = xml.."</items>";
	-- /raiddata
	xml = xml.."</raiddata></string>";
	wrRaidTracker_ShowDkpString(xml);
end

function wrRaidTracker_ShowDkpString(xml)
	wrRaidTracker_DKP_EditBox:SetText(xml);
	wrRaidTracker_DKP_EditBox:HighlightText();
	wrRaidTracker_DKP_EditBox:SetFocus();
	wrRaidTracker_showFrame();
end

function wrRaidTracker_getLanguage()
	local lang = GetLocation();
	if(lang == "DE") then
		return "deDE";
	elseif(lang == "ENEU") then
		return "enGB"
	else
		return "enUS"
	end
end

function wrRaidTracker_Print(msg, chat, r, g, b)
	if ( CT_Print ) then
		CT_Print("wrRaidTracker: "..msg, r, g, b);
	else
		if (wrRaidTracker_Options["informparty"] and chat) then
		SendChatMessage("wrRaidTracker: "..msg,"PARTY");
		end
		DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
	end
end

function wrRaidTracker_FixZero(num)
	if ( num < 10 ) then
		return "0" .. num;
	else
		return num;
	end
end

function wrRaidTracker_Date(timestamp)
	local t = os.date("*t", timestamp);
	return wrRaidTracker_FixZero(t.month) .. "/" .. wrRaidTracker_FixZero(t.day) .. "/" .. string.sub(t.year, 3) .. " " .. wrRaidTracker_FixZero(t.hour) .. ":" .. wrRaidTracker_FixZero(t.min) .. ":" .. wrRaidTracker_FixZero(t.sec);
end

function wrRaidTracker_OnEvent(this, event)
	local found=false;
	if(enabled) then
		if (event == "CHAT_MSG_SYSTEM_GET" or event == "CHAT_MSG_SYSTEM") then
			local finder, item, color, count, itemlink;
			local droptime = wrRaidTracker_Time();
			-- Check for events firing before Streamline_Settings has loaded
			if string.find(arg1,wrRaidTracker_lang["Patterns"]["ITEMDROPPED1"]) then
				-- item aufgenommen von partymember
				_, _, finder, color, item, count = string.find(arg1,wrRaidTracker_lang["Patterns"]["ITEMDROPPED1"]); -- finder, rarität und itemnamen herausmatchen
				_, _, itemlink = string.find(arg1,"(|Hitem:.*|r|h)");
				found=true;
			elseif (string.find(arg1,wrRaidTracker_lang["Patterns"]["ITEMDROPPED2"]) and not found) then
				-- item aufgenommen von partymember
				count = 1;
				_, _, finder, color, item = string.find(arg1,wrRaidTracker_lang["Patterns"]["ITEMDROPPED2"]); -- finder, rarität und itemnamen herausmatchen		
				_, _, itemlink = string.find(arg1,"(|Hitem:.*|r|h)");
				found=true;
			elseif (string.find(arg1, wrRaidTracker_lang["Patterns"]["ITEMDROPPED3"]) and not found) then
				finder = UnitName("player");
				_,_,color, item, count = string.find(arg1,wrRaidTracker_lang["Patterns"]["ITEMDROPPED3"]);
				_, _, itemlink = string.find(arg1,"(|Hitem:.*|r|h)");
				-- item aufgenommen selber gluecklicher gewesen ;)
				found=true;
			elseif (string.find(arg1, wrRaidTracker_lang["Patterns"]["ITEMDROPPED4"]) and not found) then
				finder = UnitName("player");
				count = 1;
				_,_,color, item = string.find(arg1,wrRaidTracker_lang["Patterns"]["ITEMDROPPED4"]);
				_, _, itemlink = string.find(arg1,"(|Hitem:.*|r|h)");
				-- item aufgenommen selber gluecklicher gewesen ;)			
			end			
			if (finder and item and color) then
				-- test, ob die rarität ueberhaupt gelogt werden soll
				if (wrRaidTracker_rarityTable[color] >= wrRaidTracker_Options["minQuality"] ) then
						wrRaidTracker_trackDrop(item,finder,color, tonumber(count), droptime, itemlink);
				end
			end	   
		elseif (event == "ZONE_CHANGED") then
			local zone = GetZoneName();
			wrRaidTracker_addZone(zone);
		elseif (event == "PARTY_MEMBER_CHANGED") then
			--wrRaidTracker_Debug("PTMEMCHANGE:", arg1, arg2, arg3, arg4);
				wrRaidTracker_HandleMemberChange();
		end
	end
end

function wrRaidTracker_HandleMemberChange()
	local Partylist = {};
	if(GetNumRaidMembers() > 0) then
		-- Raidhandling later
	else
		for i = 1, GetNumPartyMembers()-1 do			
			local name, online = GetPartyMember(i);
			if (not online) then
				if (wrRaidTracker_inArray(name,wrRaidTracker_Online)) then
					table.insert(Partylist,name);
					table.insert(wrRaidTracker_Offline,name);
					local pos = wrRaidTracker_inArray(name, wrRaidTracker_Online);
					table.remove(wrRaidTracker_Online,pos);
					wrRaidTracker_Debug("Disconnect: ",name);					
					-- Disconnect
					wrRaidtracker_AddLeave(name)					
				
				else
					wrRaidTracker_Debug("nicht in online liste und nicht online");
				end
			else
				
				if(wrRaidTracker_inArray(name,wrRaidTracker_Offline)) then
					table.insert(wrRaidTracker_Online,name);
					table.insert(Partylist,name);
					local pos = wrRaidTracker_inArray(name, wrRaidTracker_Offline);
					wrRaidTracker_Debug("POS", pos);
					table.remove(wrRaidTracker_Offline,pos);
					wrRaidTracker_Debug("Reconnect: ",name);
					-- Reconnect
					wrRaidTracker_AddJoin(name);
				elseif(not wrRaidTracker_inArray(name,wrRaidTracker_Online)) then
					table.insert(Partylist,name);
					table.insert(wrRaidTracker_Online, name);
					wrRaidTracker_Debug("Join: ",name);	
					-- Join
					wrRaidTracker_AddJoin(name);
				end
			end
		end
		local memberlist = {}
		for _,v in pairs(wrRaidTracker_Online) do
			table.insert(memberlist, v);
		end
		for _,v in pairs(wrRaidTracker_Offline) do
			table.insert(memberlist, v);
		end
		for i = 1, GetNumPartyMembers()-1 do
			name = GetPartyMember(i)
			local pos = wrRaidTracker_inArray(name, memberlist);
			table.remove(memberlist, pos)
		end
		local pos = wrRaidTracker_inArray(UnitName("player"), memberlist);
		table.remove(memberlist, pos);
		for k,v in pairs(memberlist) do
			wrRaidTracker_Debug("Leave: ",v);
			if(wrRaidTracker_inArray(v, wrRaidTracker_Offline)) then
				-- offline, nur von der Liste nehmen
				local pos = wrRaidTracker_inArray(v, wrRaidTracker_Offline);
				table.remove(wrRaidTracker_Offline,pos);
			else 
				wrRaidtracker_AddLeave(v);
				local pos = wrRaidTracker_inArray(v, wrRaidTracker_Online);
				table.remove(wrRaidTracker_Online,pos);	
			end
		end
	end
end

function wrRaidTracker_inArray(val, tab)
	for k, v in pairs (tab) do
		if (v == val) then
			return k;
		end
	end
	return nil;
end

function wrRaidtracker_AddLeave(member)
wrRaidTracker_Debug("Adding Leave for", member);
	local leavetime = os.time()
	table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][member]["times"],{leavetime , "leave"});
end

function wrRaidTracker_AddJoin(member)
	local jointime = os.time();
	local partypos = nil
	
	while (not partypos) do
		for i=1, GetNumPartyMembers() do
			if (UnitName("party"..i) == member) then
				partypos = i;
			end
		end
	end
	
	if(not wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][member]) then
		wrRaidTracker_Debug("Creating Member Data", member);
		-- Spieler noch nichct im Log
		local sPlayer = UnitName("party" .. partypos);
		local guild = GetGuildInfo("party" .. partypos);
		local name, online = GetPartyMember(partypos);
		local level = UnitLevel("party" .. partypos);
		local class = UnitClass("party" .. partypos);
		local sex = wrRaidtracker_fixSex(UnitSex("party" .. partypos));
			
		wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name] = {};
		if (guild) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["guild"] = guild; end;
		if (level) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["level"] = level; end;
		if (class) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["class"] = class;	end;
		if (sex) then wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["sex"] = sex;	end;
			
		wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"] = {}
		wrRaidTracker_Debug("Adding Join for ", name);
		table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][name]["times"],{jointime , "join"});
			
	else
		wrRaidTracker_Debug("Adding Join for ", member);
		-- Spieler schon im log, nur Jointime adden...
		table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["PlayerInfos"][member]["times"],{jointime , "join"});
	end
	-- Infos sammeln
end

function wrRaidTracker_clearRaidLog()
	if(wrRaidTracker_currentRaid) then
		wrRaidTracker_Debug("ENDRAIDBEFORECLEAR");
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["endraidbeforeclear"]);
	else
		wrRaidTracker_raidLog = { }
		wrRaidTracker_Debug("LOG CLEARED");
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["logclearsuccess"]);
	end
end

function wrRaidTracker_GetRaidTitle(id, hideid, showzone, shortdate)
	local RaidTitle = "";
	if ( wrRaidTracker_raidLog[id] and wrRaidTracker_raidLog[id].key ) then
		local _, _, mon, day, year, hr, min, sec = string.find(wrRaidTracker_raidLog[id].key, "(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)");
		if ( mon ) then
			local months = {
				"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
			};
			if ( not hideid ) then
				RaidTitle = RaidTitle .. "[" .. (table.getn(wrRaidTracker_raidLog)-id+1) .. "] ";
			end
			if ( not shortdate ) then
				RaidTitle = RaidTitle .. months[tonumber(mon)] .. " " .. day .. " '" .. year .. ", " .. hr .. ":" .. min;
			else
				RaidTitle = RaidTitle .. mon .. "/" .. day .. " " .. hr .. ":" .. min;
			end
			if ( showzone and wrRaidTracker_raidLog[id]["Zones"][1]) then
				RaidTitle = RaidTitle .. " " .. wrRaidTracker_raidLog[id]["Zones"][1]["name"];
			end
			return RaidTitle;
		else
			return "";
		end
	end
	return "";
end

function wrRaidTracker_listRaids()
	if(wrRaidTracker_raidLog[1]) then
		wrRaidTracker_Debug("printing raidlog");
		for k, _ in pairs(wrRaidTracker_raidLog) do
			wrRaidTracker_Print(wrRaidTracker_GetRaidTitle(k, false, true, true));
		end
	else
		wrRaidTracker_Debug("noraidlogforlist");
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["noraidsinlist"]);
	end	
end

function wrRaidTracker_showHelp()
	text = "";
	text = text..wrRaidTracker_lang["Messages"]["helpl01"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl02"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl01"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl03"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl04"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl05"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl06"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl07"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl08"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl09"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl10"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl11"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl12"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl13"].."\n";
	text = text..wrRaidTracker_lang["Messages"]["helpl01"].."\n";
	wrRaidTracker_DKP_EditBox:SetText(text);
	wrRaidTracker_showFrame();	
end

function wrRaidTracker_Debug(...)
	--local a = ...;
	if ( wrRaidTracker_Options["DebugFlag"] ) then
		local sDebug = "#";
		for i = 1, select("#", ...) , 1 do
			if ( select(i, ...) ) then
				sDebug = sDebug .. tostring(select(i, ...) ) .. "#";
			end
		end
		DEFAULT_CHAT_FRAME:AddMessage(sDebug, 1, 0.5, 0);
	end
end

function wrRaidTracker_col2rar(c)
	for i,v in pairs(wrRaidTracker_rarityTable) do
		if i == c then
			return wrRaidTracker_lang["Rarity"][v];
		end;
	end;
	return wrRaidTracker_lang["Messages"]["UNKNOWNRARITY"];
end;

function wrRaidTracker_getTableValueByIterator(tab ,i)
	local it = 0;
	for k,v in pairs (tab) do
		if(i == it) then
			return v;
		end
		it = it + 1;
	end
	return nil;
end

function wrRaidTracker_listBossesForCurrentZone()
	local zone = GetZoneName();
	if(not wrRaidTracker_currentRaid) then
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["noraidrunning"]);
		return
	end
	if(not wrRaidTracker_lang["Bosses"][zone]) then
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["nobossinzone"]);
		return
	end
	local tab = wrRaidTracker_lang["Bosses"][zone];
	for k, v in ipairs (tab) do
		wrRaidTracker_Print("["..k.."] : ["..v[2].."]");
	end	
end

function wrRaidTracker_addBossKill(id)
	local boss;
	local bossEn = nil
	local zone = GetZoneName();
	if(not wrRaidTracker_currentRaid) then
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["noraidrunning"]);
		return
	end
	if(not wrRaidTracker_currentRaidZone) then
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["wrongbossid"]);
		return;
	end
	local killtime = os.time();	
	if(wrRaidTracker_lang["Bosses"][zone][id]) then
		boss = wrRaidTracker_lang["Bosses"][zone][id][2];
		bossEn = wrRaidTracker_lang["Bosses"][zone][id][1];
		wrRaidTracker_Debug("bossSP",boss, "bossEn", bossEn);
	else
		wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["wrongbossid"]);
		return;
	end;
	wrRaidTracker_trackBoss(bossEn,killtime);
	killtime = wrRaidTracker_Date(killtime);
end

function wrRaidTracker_trackBoss(name,time1)
	local zone = GetZoneName();
	wrRaidTracker_Debug("Bosskill:" , name, time1);
	local boss = { ["name"] = name, ["time"] = time1 }
	if (not wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["BossKills"]) then
		wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["BossKills"] = { };
	end
	wrRaidTracker_numBossKills = wrRaidTracker_numBossKills + 1;
	bossLang = wrRaidTracker_getBossLangName(zone, name);
	wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["bossadded1"]..bossLang..wrRaidTracker_lang["Messages"]["bossadded2"]..wrRaidTracker_Date(time1),true);
	table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["BossKills"], boss);
end

function wrRaidTracker_getBossLangName(zone,name)
	if(wrRaidTracker_lang["Bosses"][zone]) then
		for k,v in ipairs(wrRaidTracker_lang["Bosses"][zone]) do
			if( v[1] == name ) then
				return v[2]
			end
		end
	end
	return nil;
end

function wrRaidTracker_resumeRaid(id)
	if(wrRaidTracker_currentRaid) then
		wrRaidTracker_Print("endraidfirst");
	else
		wrRaidTracker_Print("resumed raid"..id.." feature will be added later ^^");
	end
end

function wrRaidTracker_addCostsToItem(costs, id, raidid)
	wrRaidTracker_Debug("adding Costs",costs, id, raidid);
	if not(costs) then
		wrRaidTracker_Print("No Price specified");
		return;
	end
	if not(id) then
		wrRaidTracker_Print("No Item-ID given, use /rt listitems to view the dropped items");
		return;
	end
	if (not raidid) then
		if(not wrRaidTracker_currentRaid) then
			wrRaidTracker_Print("You have to start a raid or enter the id of an existing raid");
			return;
		else
			raidid = wrRaidTracker_currentRaid;
		end
	end

	if( not wrRaidTracker_raidLog[raidid]) then
		wrRaidTracker_Print("Wrong Raid-Id");
		return
	end
	if(not wrRaidTracker_raidLog[raidid]["Loot"][id]) then
		wrRaidTracker_Print("This Item does not exist");
	else
		wrRaidTracker_Print("Adding Price "..costs.." for "..wrRaidTracker_raidLog[raidid]["Loot"][id]["finder"].." 's item "..wrRaidTracker_raidLog[raidid]["Loot"][id]["itemlink"]);
		wrRaidTracker_raidLog[raidid]["Loot"][id]["cost"] = costs;
	end
end

function wrRaidTracker_listItems(raidid)
	wrRaidTracker_Debug("Listing Items",raidid);
	if (not raidid) then
		raidid = wrRaidTracker_currentRaid;
	end
	if (raidid) then
		if (not wrRaidTracker_raidLog[raidid]) then
			wrRaidTracker_Print("This Raid does not exist, use /rt list to view the recorded raids.");
			return;
		end
		if (not wrRaidTracker_raidLog[raidid]["Items"]) then
			wrRaidTracker_Print("There are no Items in this raid.");
		else
			for k,v in pairs (wrRaidTracker_raidLog[raidid]["Loot"]) do
				local output = "["..k.."] "..v["itemlink"];
				if(v["count"] > 1) then 
					output = output.." x "..v["count"];
				end
				output = output.." to"..v["finder"].."( "..v["cost"].." DKP)";			
				wrRaidTracker_Print(output);
			end
		end
	else
		if(not wrRaidTracker_currentRaid) then
			wrRaidTracker_Print("You have to start a raid first, or enter the id of an existing raid.");
		else
			wrRaidTracker_Debug("keine RaidID Bei Listitems");
		end
	end
end


function wrRaidTracker_trackDrop(itemname,luckyOne, color, count, droptime, itemlink)
	local Item_rarity = wrRaidTracker_col2rar(color);
	local item = {}
	item["name"] = itemname;
	item["rarity"] = Item_rarity;
	item["color"] = color;
	item["count"] = count;
	item["finder"] = luckyOne;
	item["droptime"] = droptime;
	item["itemlink"] = itemlink;
	item["cost"] = 0;
	if( not wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Loot"]) then 
		wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Loot"] = {}
	end
	table.insert(wrRaidTracker_raidLog[wrRaidTracker_currentRaid]["Loot"],item);	
end

function wrRaidTracker_parsecmd(ebox, cmd)
	if(cmd == "start") then
		wrRaidTracker_createNewRaid();
	elseif(cmd == "list") then
		wrRaidTracker_listRaids();
	elseif(cmd == "clear") then
		wrRaidTracker_clearRaidLog();
	elseif(string.find(cmd, "del")) then
		_, _, raidid = string.find(cmd,"del (%d+)");
		raidid = tonumber(raidid);
		if(raidid ~= nil and raidid > 0 and raidid <= wrRaidTracker_getNumRaids()) then
			wrRaidTracker_deleteRaid(raidid);
		else
			wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["invalidraidid"]);
		end
	elseif(string.find(cmd,"show")) then
		_, _, raidid = string.find(cmd,"show (%d+)");
		raidid = tonumber(raidid);
		if(raidid ~= nil and raidid > 0 and raidid <= wrRaidTracker_getNumRaids()) then
			wrRaidTracker_generateXml(raidid);
		else
			wrRaidTracker_Print(wrRaidTracker_lang["Messages"]["invalidraidid"]);
		end
	elseif(cmd == "stop") then
		wrRaidTracker_endRaid();
	elseif(cmd == "addboss") then
		 wrRaidTracker_listBossesForCurrentZone()
	elseif(string.find(cmd, "addboss %d+")) then
		_, _, bossid = string.find(cmd, "addboss (%d+)");
		bossid = tonumber(bossid);
		wrRaidTracker_addBossKill(bossid);
	elseif(cmd == "help" or cmd == "" or cmd == nil ) then
		wrRaidTracker_showHelp()
	elseif(cmd == "listitems") then
		wrRaidTracker_listItems();
	elseif(string.find(cmd, "listitems (%d*)")) then
		_, _, raidid = string.find(cmd, "listitems%s?([%d+]?)");
		raidid = tonumber(raidid);
		wrRaidTracker_listItems(raidid);
	elseif(string.find(cmd,"addprice")) then
		_, _, price, itemid, raidid = string.find(cmd, "addprice%s?([%d]*)%s?([%d]*)%s?([%d]*)");
		price = tonumber(price);
		itemid = tonumber(itemid);
		raidid = tonumber(raidid);
		wrRaidTracker_addCostsToItem(price, itemid, raidid);	
	end
end

-- SLASH CMDS
SLASH_wrRaidTracker1 = "/rt";

SlashCmdList["wrRaidTracker"] = wrRaidTracker_parsecmd;