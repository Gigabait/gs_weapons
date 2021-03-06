local function BulletImpulse(flGrains, flFtPerSec, flImpulse)
	return flFtPerSec * flGrains * flImpulse * 0.00077897727272727
end

-- Episodic ammo types
game.AddAmmoType({
	name = "StriderMinigun_Episodic",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 5,
	npcdmg = 5,
	maxcarry = 15,
	force = 1 * 750 * 12,
	flags = AMMO_FORCE_DROP_IF_CARRIED,
	minsplash = 4,
	maxsplash = 8
}) // hit like a 1kg weight at 750 ft/s

CreateConVar("sk_max_hopwire", "3", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Hopwire",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_grenade",
	npcdmg = "sk_npc_dmg_grenade",
	maxcarry = "sk_max_hopwire",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "ammo_proto1",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 10,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

--[[ Portal ammo type
game.AddAmmoType({
	name = "HunterGun",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = "sk_hunter_dmg",
	npcdmg = "sk_hunter_dmg",
	maxcarry = "sk_hunter_max_round",
	force = BulletImpulse(200, 1225, 3.5),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})]]

CreateConVar("sk_plr_dmg_357round", "40", FCVAR_REPLICATED)
CreateConVar("sk_max_357round", "36", FCVAR_REPLICATED)

-- More Half-Life 1 ammo types
game.AddAmmoType({
	name = "357Round",
	dmgtype = bit.bor(DMG_BULLET, DMG_NEVERGIB),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_357round",
	npcdmg = 0,
	maxcarry = "sk_max_357round",
	force = BulletImpulse(650, 6000, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_buckshot_hl", "5", FCVAR_REPLICATED)
CreateConVar("sk_max_buckshot_hl", "125", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Buckshot_HL",
	dmgtype = bit.bor(DMG_BULLET, DMG_BUCKSHOT),
	tracer = TRACER_LINE,
	plydmg = "sk_plr_dmg_buckshot_hl",
	npcdmg = 0,
	maxcarry = "sk_max_buckshot_hl",
	force = BulletImpulse(200, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_crossbow_hl", "10", FCVAR_REPLICATED)
CreateConVar("sk_max_crossbow_hl", "50", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "XBowBolt_HL",
	dmgtype = bit.bor(DMG_BULLET, DMG_BUCKSHOT),
	tracer = TRACER_LINE,
	plydmg = "sk_plr_dmg_crossbow_hl",
	npcdmg = 0,
	maxcarry = "sk_max_crossbow_hl",
	force = BulletImpulse(200, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_rpg_rocket", "100", FCVAR_REPLICATED)
CreateConVar("sk_max_rpg_rocket", "5", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "RPG_Rocket",
	dmgtype = bit.bor(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_rpg_rocket",
	npcdmg = 0,
	maxcarry = "sk_max_rpg_rocket",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_max_uranium", "100", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Uranium",
	dmgtype = DMG_ENERGYBEAM,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "sk_max_uranium",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_grenade_hl", "100", FCVAR_REPLICATED)
CreateConVar("sk_max_grenade_hl", "10", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Grenade_HL",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_grenade_hl",
	npcdmg = 0,
	maxcarry = "sk_max_grenade_hl",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_max_snark", "15", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Snark",
	dmgtype = DMG_SLASH,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "sk_max_snark",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_tripmine", "150", FCVAR_REPLICATED)
CreateConVar("sk_max_tripmine", "5", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "TripMine",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_tripmine",
	npcdmg = 0,
	maxcarry = "sk_max_tripmine",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_satchel", "150", FCVAR_REPLICATED)
CreateConVar("sk_max_satchel", "5", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Satchel",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_satchel",
	npcdmg = 0,
	maxcarry = "sk_max_satchel",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_npc_dmg_12mmround", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_npc_dmg_12mmround", {"8", "10", "10"})
end

game.AddAmmoType({
	name = "12mmRound",
	dmgtype = bit.band(DMG_BULLET, DMG_NEVERGIB),
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = "sk_npc_dmg_12mmround",
	maxcarry = 0,
	force = BulletImpulse(300, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

-- Half-Life 2: Beta ammo type
game.AddAmmoType({
	name = "Extinguisher",
	dmgtype = DMG_BURN,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 100,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

-- SDK ammo types
game.AddAmmoType({
	name = "Grenade_SDK",
	dmgtype = DMG_BLAST,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Bullets_SDK",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("ammo_50ae_max", "35", FCVAR_REPLICATED)

-- Counter-Strike: Source ammo types
game.AddAmmoType({
	name = "50AE",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_50ae_max",
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 30,
	penetrationdistance = 1000
})

CreateConVar("ammo_762mm_max", "90", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "762mm",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_762mm_max",
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 39,
	penetrationdistance = 5000
})

CreateConVar("ammo_556mm_max", "90", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "556mm",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_556mm_max",
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 35,
	penetrationdistance = 4000
})

CreateConVar("ammo_556mm_box_max", "200", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "556mm_Box",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_556mm_box_max",
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 35,
	penetrationdistance = 4000
})

CreateConVar("ammo_338mag_max", "30", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "338mag",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_338mag_max",
	force = 2800 * 1,
	flags = 0,
	minsplash = 12,
	maxsplash = 16,
	penetrationpower = 45,
	penetrationdistance = 8000
})

CreateConVar("ammo_9mm_max", "120", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "9mm",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_9mm_max",
	force = 2000 * 1,
	flags = 0,
	minsplash = 5,
	maxsplash = 10,
	penetrationpower = 21,
	penetrationdistance = 800
})

CreateConVar("ammo_buckshot_max", "32", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Buckshot_CSS",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_buckshot_max",
	force = 600 * 1,
	flags = 0,
	minsplash = 3,
	maxsplash = 6,
	penetrationpower = 0,
	penetrationdistance = 0
})

CreateConVar("ammo_45acp_max", "100", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "45acp",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_45acp_max",
	force = 2100 * 1,
	flags = 0,
	minsplash = 6,
	maxsplash = 10,
	penetrationpower = 15,
	penetrationdistance = 500
})

CreateConVar("ammo_357sig_max", "52", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "357sig",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_357sig_max",
	force = 2000 * 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8,
	penetrationpower = 25,
	penetrationdistance = 800
})

CreateConVar("ammo_57mm_max", "100", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "57mm",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_57mm_max",
	force = 2000 * 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8,
	penetrationpower = 30,
	penetrationdistance = 2000
})

CreateConVar("ammo_hegrenade_max", "1", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "HEGrenade",
	dmgtype = DMG_BLAST,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_hegrenade_max",
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("ammo_flashbang_max", "2", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Flashbang",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_flashbang_max",
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("ammo_smokegrenade_max", "1", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "SmokeGrenade",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_smokegrenade_max",
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

-- Day of Defeat: Source ammo types
game.AddAmmoType({
	name = "Colt",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 21,
	force = 5000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "P38",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 24,
	force = 5000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "C96",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 60,
	force = 5000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "Garand",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 88,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "K98",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 65,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "M1Carbine",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 165,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "Spring",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 55,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "SubMG",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 210,
	force = 7000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "BAR",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE_AND_WHIZ,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 260,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "30cal",
	dmgtype = bit.bor(DMG_BULLET, DMG_MACHINEGUN),
	tracer = TRACER_LINE_AND_WHIZ,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 300,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "MG42",
	dmgtype = bit.bor(DMG_BULLET, DMG_MACHINEGUN),
	tracer = TRACER_LINE_AND_WHIZ,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 500,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "Rocket",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 5,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "HandGrenade",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "StickGrenade",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "HandGrenade_Ex", // the EX is for EXploding! :)
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "StickGrenade_Ex",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "SmokeGrenade_US",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "SmokeGrenade_Ger",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "SmokeGrenade_US_Live",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "SmokeGrenade_Ger_Live",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "RifleGrenade_US",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "RifleGrenade_Ger",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "RifleGrenade_US_Live",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "RifleGrenade_Ger_Live",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})
