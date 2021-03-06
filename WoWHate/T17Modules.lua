function WHA_loadBlackHandModule()
	WHA_modloaded = true;
	print("Blackhand module loaded");
	local t = {};
	t[156096] = "Marked for Death";
	return t, "Blackhand", 1;
end;
function WHA_loadOperatorModule()
	WHA_modloaded = true;
	print("Operator Thogar loaded");
	local t = {};
	t[159481] = "Delayed Siege Bomb";
	return t, "Operator Thogar", 1;
end;
function WHA_loadMaidsModule()
	WHA_modloaded = true;
	print("Iron Maidens module loaded");
	local t = {};
	t[156631] = "Rapid Fire";
	t[164271] = "Penetrating Shot";
	return t, "Iron Maidens", 2;
end;
function WHA_loadBeastLordModule()
	WHA_modloaded = true;
	print("Beastlord Darmac module loaded");
	local t = {};
	t[154981] = "Conflagration";
	return t, "Beastlord Darmac", 1;
end;
function WHA_loadFlameBenderModule()
	WHA_modloaded = true;
	print("Flamebender Ka'graz module loaded");
	local t = {};
	t[154932] = "Molten Torrent";
	t[154952] = "Fixate";
	t[155277] = "Blazing Radiance"
	return t, "Flamebender Ka'graz", 3;
end;
function WHA_loadBFurnModule()
	WHA_modloaded = true;
	print("Blast Furnace module loaded");
	local t = {};
	t[155192] = "Bomb";
	t[155196] = "Fixate";
	t[176121] = "Volatile Fire"
	t[156934] = "Rupture"
	return t, "Blast Furnace", 4;
end;
function WHA_loadGruulModule()
	WHA_modloaded = true;
	print("Gruul module loaded");
	local t = {};
	t[155330] = "Petrify";
	return t, "Gruul", 1;
end;
function WHA_loadKargathModule()
	WHA_modloaded = true;
	print("Kargath module loaded.");
	local t = {};
	t[158986] = "Berserker Rush";
	return t, "Kargath Bladefist", 1;
end;
function WHA_loadTectusModule()
	WHA_modloaded = true;
	print("Tectus module loaded.");
	local t = {};
	t[162346] = "Crystalline Barrage", 1;
end;
function WHA_loadTestModule()
	WHA_modloaded = true;
	print("Test Module Loaded");
	local t = {};
	t[157335] = "Will of the Necropolis";
	t[48743] = "Death Pact"
	return t, "Test", 2;
end;
function WHA_loadRTestModule()
	WHA_modloaded = true;
	print("Raid Test Module Loaded");
	local t = {};
	t[163241] = "Rot";
	return t, "RTest", 1;
end;