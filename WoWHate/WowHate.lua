raidg = {};
debuffs = {};
rdbtable = {};
pasttable = {};
devmod = false;
fname = "";
incombat = false;
modloaded = false;
local frame = CreateFrame("FRAME", "ScottFrame");
local frame2 = CreateFrame("FRAME", "enterframe");
local frame3 = CreateFrame("FRAME", "exitframe");
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
frame2:RegisterEvent("PLAYER_REGEN_DISABLED");
frame3:RegisterEvent("PLAYER_REGEN_ENABLED");



local function buildRDBTable(raid, debuff)
	local t = {};
	for key, value in pairs(raid) do
		t[key] = {};
	end;
	for player, db in pairs(t) do
		for ID, dname in pairs(debuff) do
			t[player][dname] = false;
		end;
	end;
	return t;
end;
local function makeRaidTable()
	local gnum = GetNumGroupMembers();
	local t = {};
		for i = 1, gnum, 1 do
		local s = "raid" .. i;
		local uname = GetUnitName(s, true);
		--print("Adding entry for: " .. uname);
		t[uname] = {};
	end;
	return t;
end;
local function makeTestTable()
	local t = {};
	local uname = UnitName("player");
	--print("Adding entry for: " .. uname);
	t[uname] = {};
	return t;
end;
local function reportTable(raid, channel)
	SendChatMessage("WoW Hates Aurorraa report for: " .. fname ,channel);
	for key, value in pairs(raid) do	
		SendChatMessage("People targetted by: " .. key, channel);
		for key2, value2 in pairs(value) do
			if(value2 > 10) then
				SendChatMessage(key2 .. ": " .. value2, channel);
			end;
		end;
		for i = 10, 1, -1 do
			for key2, value2 in pairs(value) do
				if(value2 == i) then
					SendChatMessage(key2 .. ": " .. value2, channel);
				end;
			end;
		end
		SendChatMessage(" ", channel);
	end;
end;
local function printTable(raid, debuff)
	print("|cff00ffffValues for " .. fname);
	local invraid = {};
	for key, value in pairs(debuff) do
		invraid[value] = {};
	end;
	for player, pdset in pairs(raid) do
		for dname, count in pairs(pdset) do
			invraid[dname][player] = count;
		end;
	end;
	for key, value in pairs(invraid) do	
		print("|cffff0000People targetted by: " .. key);
		for key2, value2 in pairs(value) do
			if(value2 > 10) then
				print(key2 .. ": " .. value2);
			end;
		end;
		for i = 10, 1, -1 do
			for key2, value2 in pairs(value) do
				if(value2 == i) then
					print(key2 .. ": " .. value2);
				end;
			end;
		end
		print(" ");
	end;
	return invraid;
end;

local function registerAura(self,event, ...)
	
	local timestamp, etype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...);
	if(modloaded == false and incombat == true) then
		if(destName == "Kargath Bladefist") then
			debuffs, fname = loadKargathModule();
			rdbtable = buildRDBTable(raidg, debuffs);
		elseif(destName == "Blackhand") then
			debuffs, fname = loadBlackHandModule();
			rdbtable = buildRDBTable(raidg, debuffs);
		elseif(destName == "Marak the Blooded") then
			debuffs, fname = loadMaidsModule();
			rdbtable = buildRDBTable(raidg, debuffs);
		elseif(destName == "Beastlord Darmac") then
			debuffs, fname = loadBeastLordModule();
			rdbtable = buildRDBTable(raidg, debuffs);
		elseif(destName == "Flamebender Ka'graz") then
			debuffs, fname = loadFlameBenderModule();
			rdbtable = buildRDBTable(raidg, debuffs);
		elseif(destName == "Gruul") then
			debuffs, fname = loadGruulModule();
			rdbtable = buildRDBTable(raidg, debuffs);
		elseif(destName == "Foreman Feldspar") then
			debuffs, fname = loadBFurnModule();
			rdbtable = buildRDBTable(raidg, debuffs);
		elseif(destName == "Tectus") then
			debuffs, fname = loadTectusModule();
			rdbtable = buildRDBTable(raidg, debuffs);
		elseif(destName == "Dungeoneer's Training Dummy") then
			debuffs, fname = loadTestModule();
			rdbtable = buildRDBTable(raidg, debuffs);
		end;
	end;
	if((etype == 'SPELL_AURA_APPLIED' or etype == 'SPELL_AURA_REMOVED') and amount == 'DEBUFF' and incombat == true and (destName == GetUnitName("player") or UnitInRaid(destName))) then
		--if(modloaded == false and etype == 'SPELL_AURA_APPLIED') then
			--print(destName .. " " .. spellName);
			--local name, rank, icon, count, dispel, duration, expires, caster, steal, console, ID, canapp, boss, v1, v2, v3 = UnitDebuff(destName, spellName);
			--responsetime = duration + (GetTime() - expires);
			--print("response time is" .. responsetime);
			--debuffs[ID] = spellName;
				--print(name .. ID );
				--if(raidg[destName][spellName] == nil) then
					--raidg[destName][spellName] = 0;
				--end;
				--raidg[destName][spellName] = raidg[destName][spellName] + 1;
		if(modloaded == true) then
			local name, rank, icon, count, dispel, duration, expires, caster, steal, console, ID, canapp, boss, v1, v2, v3 = UnitDebuff(destName, spellName);
			if(name ~= nil and devmod == true) then
				print(name .. " " .. ID .. " " ..destName);
			end;
			if(name ~= nil and debuffs[ID] ~= nil and rdbtable[destName][spellName] == false) then
				if(devmod == true) then
					print(destName .. " " .. spellName);
				end;
				if(raidg[destName][spellName] == nil) then
					raidg[destName][spellName] = 0;
				end;
				raidg[destName][spellName] = raidg[destName][spellName] + 1;
				rdbtable[destName][spellName] = true;
			elseif(name == nil and rdbtable[destName][spellName] ~= nil and rdbtable[destName][spellName] == true) then
				rdbtable[destName][spellName] = false;
				if(devmod == true) then
					print(spellName .. " has fallen off " .. destName);
				end;
			end;
		end;
	end;
end;

local function enterCombat(self, event, ...)
	if(devmod == true) then
		print("Generating Table...");
	end;
	incombat = true;
	if(IsInRaid() == true) then
		raidg = makeRaidTable();
	else
		raidg = makeTestTable();
	end;
end;

local function exitCombat(self, event, ...)
	incombat = false;
	if(modloaded == true) then
		pasttable = printTable(raidg, debuffs);
		modloaded = false;
	end;
	debuffs = {};
end;

frame:SetScript("OnEvent", registerAura);
frame2:SetScript("OnEvent", enterCombat);
frame3:SetScript("OnEvent", exitCombat);



SLASH_LOADMOD1 = '/WHA';
local function modloader(msg, editbox)
	if msg == 'grep' then
		reportTable(pasttable, "GUILD");
	elseif msg == 'irep' then
		reportTable(pasttable, "RAID");
	elseif msg == 'trep' then
		reportTable(pasttable, "SAY");
	elseif msg == 'devmode' then
		devmod = true;
	elseif msg == 'clear' then
		modloaded = false;
		raidg = {};
		debuffs = {};
		fname = {};
		pasttable = {};
		rdbtable = {};
	else
		print("WoW Hates Aurorra options");
		print("Type /WHA grep to print your report to your guild");
		print("Type /WHA irep to print your report to your raid");
		print("Type /WHA clear to clear all values.");
	end;
end;
SlashCmdList["LOADMOD"] = modloader;
