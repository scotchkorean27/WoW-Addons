local frame = CreateFrame("FRAME", "ScottFrame");
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
local lastcast = 0;
local igon = false;
local rigval = 0;
local function eventHandler(self, event, ...)
	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...);
	if(event == 'SPELL_AURA_APPLIED' and amount == "DEBUFF" and destName == GetUnitName("player")) then
		local name, rank, icon, count, dispel, duration, expires, caster, steal, console, ID, canapp, boss, v1, v2, v3 = UnitDebuff(destName, spellName);
		print(name .. ID .. count);
		responsetime = duration + (GetTime() - expires);
		print("response time is" .. responsetime);
	end;
end;
frame:SetScript("OnEvent", eventHandler);