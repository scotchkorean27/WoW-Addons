WHA_raidg = {};
WHA_debuffs = {};
WHA_rdbtable = {};
WHA_pasttable = {};
WHA_devmod = false;
WHA_fname = "";
WHA_incombat = false;
WHA_modloaded = false;
local WHA_ItVal = nil;
local WHA_frame = CreateFrame("FRAME", "WHA_RaidFrame");
local WHA_frame2 = CreateFrame("FRAME", "WHA_enterframe");
local WHA_frame3 = CreateFrame("FRAME", "WHA_exitframe");
WHA_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
WHA_frame2:RegisterEvent("PLAYER_REGEN_DISABLED");
WHA_frame3:RegisterEvent("PLAYER_REGEN_ENABLED");



local function WHA_raidInCombat()
	local gnum = GetNumGroupMembers();
	for i = 1, gnum, 1 do
		local s = "raid" .. i;
		local uname = GetUnitName(s, true);
		if(UnitAffectingCombat(uname) == true) then
			return true;
		end;
	end;	
	if(IsInRaid() == false and UnitAffectingCombat("Player") == true) then
		return true;
	end;
	return false;
end;

local function WHA_buildRDBTable(raid, debuff)
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
local function WHA_makeRaidTable()
	local gnum = GetNumGroupMembers();
	local t = {};
		for i = 1, gnum, 1 do
		local s = "raid" .. i;
		local uname = GetUnitName(s, true);
		t[uname] = {};
	end;
	return t;
end;
local function WHA_makeTestTable()
	local t = {};
	local uname = UnitName("player");
	t[uname] = {};
	return t;
end;
local function WHA_reportTable(raid, channel)
	SendChatMessage("WoW Hates Aurorraa report for: " .. WHA_fname ,channel);
	for key, value in pairs(raid) do	
		SendChatMessage("People targetted by: " .. key, channel);
		for key2, value2 in pairs(value) do
			if(value2 > 20) then
				SendChatMessage(key2 .. ": " .. value2, channel);
			end;
		end;
		for i = 20, 1, -1 do
			for key2, value2 in pairs(value) do
				if(value2 == i) then
					SendChatMessage(key2 .. ": " .. value2, channel);
				end;
			end;
		end
		SendChatMessage(" ", channel);
	end;
end;
local function WHA_printTable(invraid)
	print("|cff00ffffWoW Hates Aurorraa report for " .. WHA_fname);
	for key, value in pairs(invraid) do	
		print("|cffff0000People targetted by: " .. key);
		for key2, value2 in pairs(value) do
			if(value2 > 20) then
				print(key2 .. ": " .. value2);
			end;
		end;
		for i = 20, 1, -1 do
			for key2, value2 in pairs(value) do
				if(value2 == i) then
					print(key2 .. ": " .. value2);
				end;
			end;
		end
		print(" ");
	end;
end;

local function WHA_SinDB(raidt, dname)
	local t5t = {};
	for player, pdset in pairs(raidt) do
		if(pdset[dname] ~= nil) then
			t5t[player] = pdset[dname];
		end;
	end;
	return t5t;
end;	

local function WHA_makeResult(raid, debuff)
	
	local invraid = {};
	for key, value in pairs(debuff) do
		invraid[value] = {};
	end;
	for player, pdset in pairs(raid) do
		for dname, count in pairs(pdset) do
			invraid[dname][player] = count;
		end;
	end;
	return invraid;
end;

local function WHA_exitCombat(self, event, ...)
	WHA_incombat = false;
	if(WHA_modloaded == true) then
		WHA_pasttable = WHA_makeResult(WHA_raidg, WHA_debuffs);
		WHA_printTable(WHA_pasttable);
		WHA_modloaded = false;
	end;
end;


local function WHA_registerAura(self,event, ...)
	
	local timestamp, etype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...);
	if(WHA_modloaded == false and WHA_incombat == true) then
		WHATally:Show();
		if(destName == "Kargath Bladefist") then
			WHA_debuffs, WHA_fname = WHA_loadKargathModule();
			WHA_BUP(WHA_fname);
			WHA_rdbtable = WHA_buildRDBTable(WHA_raidg, WHA_debuffs);
			WHA_INC();
		elseif(destName == "Blackhand") then
			WHA_debuffs, WHA_fname = WHA_loadBlackHandModule();
			WHA_BUP(WHA_fname);
			WHA_rdbtable = WHA_buildRDBTable(WHA_raidg, WHA_debuffs);
			WHA_INC();
		elseif(destName == "Marak the Blooded") then
			WHA_debuffs, WHA_fname = WHA_loadMaidsModule();
			WHA_BUP(WHA_fname);
			WHA_rdbtable = WHA_buildRDBTable(WHA_raidg, WHA_debuffs);
			WHA_INC();
		elseif(destName == "Operator Thogar") then
			WHA_debuffs, WHA_fname = WHA_loadOperatorModule();
			WHA_BUP(WHA_fname);
			WHA_rdbtable = WHA_buildRDBTable(WHA_raidg, WHA_debuffs);
			WHA_INC();
		elseif(destName == "Beastlord Darmac") then
			WHA_debuffs, WHA_fname = WHA_loadBeastLordModule();
			WHA_BUP(WHA_fname);
			WHA_rdbtable = WHA_buildRDBTable(WHA_raidg, WHA_debuffs);
			WHA_INC();
		elseif(destName == "Flamebender Ka'graz") then
			WHA_debuffs, WHA_fname = WHA_loadFlameBenderModule();
			WHA_BUP(WHA_fname);
			WHA_rdbtable = WHA_buildRDBTable(WHA_raidg, WHA_debuffs);
			WHA_INC();
		elseif(destName == "Gruul") then
			WHA_debuffs, WHA_fname = WHA_loadGruulModule();
			WHA_BUP(WHA_fname);
			WHA_rdbtable = WHA_buildRDBTable(WHA_raidg, WHA_debuffs);
			WHA_INC();
		elseif(destName == "Foreman Feldspar") then
			WHA_debuffs, WHA_fname = WHA_loadBFurnModule();
			WHA_BUP(WHA_fname);
			WHA_rdbtable = WHA_buildRDBTable(WHA_raidg, WHA_debuffs);
			WHA_INC();
		elseif(destName == "Tectus") then
			WHA_debuffs, WHA_fname = WHA_loadTectusModule();
			WHA_BUP(WHA_fname);
			WHA_rdbtable = WHA_buildRDBTable(WHA_raidg, WHA_debuffs);
			WHA_INC();
		elseif(destName == "Dungeoneer's Training Dummy" and WHA_devmod == true) then
			WHA_debuffs, WHA_fname = WHA_loadTestModule();
			WHA_BUP(WHA_fname);
			WHA_rdbtable = WHA_buildRDBTable(WHA_raidg, WHA_debuffs);
			WHA_INC();
		else
			WHATally:Hide();
		end;
	end;
	if((etype == 'SPELL_AURA_APPLIED' or etype == 'SPELL_AURA_REMOVED') and amount == 'DEBUFF' and WHA_incombat == true and (destName == GetUnitName("player") or UnitInRaid(destName))) then
		if(WHA_modloaded == true) then
			local name, rank, icon, count, dispel, duration, expires, caster, steal, console, ID, canapp, boss, v1, v2, v3 = UnitDebuff(destName, spellName);
			if(name ~= nil and WHA_devmod == true) then
				print(name .. " " .. ID .. " " ..destName);
			end;
			if(name ~= nil and WHA_debuffs[ID] ~= nil and WHA_rdbtable[destName][spellName] == false) then
				if(WHA_devmod == true) then
					print(destName .. " " .. spellName);
				end;
				if(WHA_raidg[destName][spellName] == nil) then
					WHA_raidg[destName][spellName] = 0;
				end;
				WHA_raidg[destName][spellName] = WHA_raidg[destName][spellName] + 1;
				WHA_rdbtable[destName][spellName] = true;
				WHA_UPD();
			elseif(name == nil and WHA_rdbtable[destName][spellName] ~= nil and WHA_rdbtable[destName][spellName] == true) then
				WHA_rdbtable[destName][spellName] = false;
				if(WHA_devmod == true) then
					print(spellName .. " has fallen off " .. destName);
				end;
			end;
		end;
	end;
	if(WHA_raidInCombat() == false) then
		WHA_exitCombat();
	end;
end;

local function WHA_enterCombat(self, event, ...)
	if(WHA_devmod == true) then
		print("Generating Table...");
	end;
	WHA_incombat = true;
	if(IsInRaid() == true) then
		WHA_raidg = WHA_makeRaidTable();
	else
		WHA_raidg = WHA_makeTestTable();
	end;
	WHA_ItVal = nil;
end;

local function WHA_chexitCombat()
	if(WHA_raidInCombat() == false) then
		WHA_exitCombat();
	end;
end;

WHA_frame:SetScript("OnEvent", WHA_registerAura);
WHA_frame2:SetScript("OnEvent", WHA_enterCombat);
WHA_frame3:SetScript("OnEvent", WHA_chexitCombat);


SLASH_LOADMOD1 = '/WHA';
local function WHA_modloader(msg, editbox)
	if msg == 'grep' then
		WHA_reportTable(WHA_pasttable, "GUILD");
	elseif msg == 'irep' then
		WHA_reportTable(WHA_pasttable, "RAID");
	elseif msg == 'trep' then
		WHA_reportTable(WHA_pasttable, "SAY");
	elseif msg == 'devmode' then
		WHA_devmod = not WHA_devmod;
		if(WHA_devmod == true) then
			print("Dev Mode Enabled");
		else
			print("Dev Mode Disabled");
		end;
	elseif msg == 'clear' then
		WHA_modloaded = false;
		WHA_raidg = {};
		WHA_debuffs = {};
		WHA_fname = {};
		WHA_pasttable = {};
		WHA_rdbtable = {};
	elseif msg == 'exit' then
		WHA_exitCombat();
	elseif msg == 'print' then
		WHA_printTable(WHA_raidg, WHA_debuffs);
	else
		print("WoW Hates Aurorra options");
		print("Type /WHA grep to print your report to your guild");
		print("Type /WHA irep to print your report to your raid");
		print("Type /WHA clear to clear all values.");
	end;
end;
SlashCmdList["LOADMOD"] = WHA_modloader;

function WHA_PPT()
	WHA_printTable(WHA_pasttable);
end;
function WHA_PGT()
	WHA_reportTable(WHA_pasttable, "GUILD");
end;
function WHA_PIT()
	WHA_reportTable(WHA_pasttable, "RAID");
end;
function WHA_BUP(name)
	WHATBName:SetText(name);
end;
function WHA_INC()
	local did, dname = next(WHA_debuffs, WHA_ItVal);
	WHA_ItVal = did;
	if(WHA_ItVal == nil) then
		did, dname = next(WHA_debuffs, WHA_ItVal);
		WHA_ItVal = did;
	end;
	WHA_UPD();
	
end;
function WHA_UPD()
	dname = WHA_debuffs[WHA_ItVal];
	if(WHA_modloaded == true or WHA_pasttable[dname] ~= nil) then
		local t5t = WHA_SinDB(WHA_raidg, dname);
		p1 = {["n"] = "Player 1", ["c"] = 0};
		p2 = {["n"] = "Player 2", ["c"] = 0};
		p3 = {["n"] = "Player 3", ["c"] = 0};
		p4 = {["n"] = "Player 4", ["c"] = 0};
		p5 = {["n"] = "Player 5", ["c"] = 0};
		if(t5t ~= nil) then
			for pname, co in pairs(t5t) do
				if(co > p1["c"]) then
					p5 = p4;
					p4 = p3;
					p3 = p2;
					p2 = p1;
					p1 = {["n"] = pname, ["c"] = co};
				elseif(co > p2["c"]) then
					p5 = p4;
					p4 = p3;
					p3 = p2;
					p2 = {["n"] = pname, ["c"] = co};
				elseif(co > p3["c"]) then
					p5 = p4;
					p4 = p3;
					p3 = {["n"] = pname, ["c"] = co};
				elseif(co > p4["c"]) then
					p5 = p4;
					p4 = {["n"] = pname, ["c"] = co};
				elseif(co > p5["c"]) then
					p5 = {["n"] = pname, ["c"] = co};
				end;
			end;	
		end;
		WHATP1:SetText(strsub(p1["n"], 1, 13));
		WHATT1:SetText(p1["c"]);
		WHATP2:SetText(strsub(p2["n"], 1, 13));
		WHATT2:SetText(p2["c"]);
		WHATP3:SetText(strsub(p3["n"], 1, 13));
		WHATT3:SetText(p3["c"]);
		WHATP4:SetText(strsub(p4["n"], 1, 13));
		WHATT4:SetText(p4["c"]);
		WHATP5:SetText(strsub(p5["n"], 1, 13));
		WHATT5:SetText(p5["c"]);
	end;
	WHATSName:SetText(dname);
end;
