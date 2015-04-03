raidg = {};
debuffs = {};
incombat = false;
modloaded = false;
local frame = CreateFrame("FRAME", "ScottFrame");
local frame2 = CreateFrame("FRAME", "enterframe");
local frame3 = CreateFrame("FRAME", "exitframe");
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
frame2:RegisterEvent("PLAYER_REGEN_DISABLED");
frame3:RegisterEvent("PLAYER_REGEN_ENABLED");

local function loadKargathModule()
	modloaded = true;
	print("Kargath module loaded.");
	local t = {};
	t["Berserker Rush"] = 1;
	return t;
end;
local function loadTectusModule()
	modloaded = true;
	print("Tectus module loaded.");
	local t = {};
	t["Crystalline Barrage"] = 1;
	return t;
end;
local function loadTestModule()
	modloaded = true;
	print("Test Module Loaded");
	local t = {};
	t["Will of the Necropolis"] = 1;
	return t;
end;

local function makeRaidTable()
	local gnum = GetNumGroupMembers();
	local t = {};
		for i = 1, gnum, 1 do
		local s = "raid" .. i;
		local uname = GetUnitName(s, true);
		print("Adding entry for: " .. uname);
		t[uname] = {};
	end;
	return t;
end;
local function makeTestTable()
	local t = {};
	local uname = UnitName("player");
	print("Adding entry for: " .. uname);
	t[uname] = {};
	return t;
end;
local function printTable(raid, debuff)
	local invraid = {};
	for key, value in pairs(debuff) do
		invraid[key] = {};
	end;
	for key, value in pairs(raid) do
		for key2, value2 in pairs(value) do
			invraid[key2][key] = value2;
		end;
	end;
	for key, value in pairs(invraid) do	
		print("People hit by: " .. key);
		for key2, value2 in pairs(value) do
			print(key2 .. ": " .. value2);
		end;
	end;
end;

local function registerAura(self,event, ...)
	
	local timestamp, etype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...);
	if(modloaded == false) then
		if(destName == "Kargath Bladefist") then
			debuffs = loadKargathModule();
		elseif(destName == "Tectus") then
			debuffs = loadTectusModule();
		elseif(destName == "Dungeoneer's Training Dummy") then
			debuffs = loadTestModule();
		end;
	end;
	if(etype == 'SPELL_AURA_APPLIED' and amount == 'DEBUFF' and incombat == true and UnitInRaid(destName)) then
		if(modloaded == false) then
			print(destName .. " " .. spellName);
			debuffs[spellName] = 1;
			if(raidg[destName][spellName] == nil) then
				raidg[destName][spellName] = 0;
			end;
			raidg[destName][spellName] = raidg[destName][spellName] + 1;
		elseif(modloaded == true and debuffs[spellName] ~= nil and UnitInRaid(destName)) then
			print(destName .. " " .. spellName);
			if(raidg[destName][spellName] == nil) then
				raidg[destName][spellName] = 0;
			end;
			raidg[destName][spellName] = raidg[destName][spellName] + 1;
		end;
	end;
end;

local function enterCombat(self, event, ...)
	print("Generating Table...");
	incombat = true;
	raidg = makeRaidTable();
end;

local function exitCombat(self, event, ...)
	print("Printing...");
	incombat = false;
	printTable(raidg, debuffs);
end;

frame:SetScript("OnEvent", registerAura);
frame2:SetScript("OnEvent", enterCombat);
frame3:SetScript("OnEvent", exitCombat);



SLASH_LOADMOD1 = '/HateLoad';
local function modloader(msg, editbox)
	if msg == 'Kargath' then
		debuffs = loadKargathModule();
	elseif msg == 'Test' then
		debuffs = loadTestModule();
	elseif msg == 'Clear' then
		debuffs = {};
		modloaded = false;
		print("Cleared module. Entering Blank Slate Mode");
	else
		print("Module not found");
	end;
end;
SlashCmdList["LOADMOD"] = modloader;
