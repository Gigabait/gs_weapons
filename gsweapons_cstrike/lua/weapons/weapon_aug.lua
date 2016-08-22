DEFINE_BASECLASS( "weapon_csbase_rifle" )

--- GSBase
SWEP.PrintName = "#CStrike_AUG"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_aug.mdl"
SWEP.WorldModel = "models/weapons/w_rif_aug.mdl"

SWEP.Sounds = {
	primary = "Weapon_AUG.Single"
}

SWEP.Primary = {
	Ammo = "762mmRound",
	ClipSize = 30,
	DefaultClip = 120,
	Damage = 32,
	Cooldown = 0.09,
	WalkSpeed = 221/250,
	RangeModifier = 0.96,
	Spread = {
		Base = 0.02,
		Air = 0.4,
		Move = 0.07
	}
}

SWEP.Secondary.Cooldown = 0.135
SWEP.SpecialType = SPECIAL_ZOOM

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'e'
	SWEP.SelectionIcon = 'e'
	
	SWEP.CSSCrosshair = {
		Min = 3
	}
	
	SWEP.MuzzleFlashScale = 1.3
end

--- CSBase_SMG
SWEP.Accuracy = {
	Divisor = 215,
	Offset = 0.3,
	Max = 1,
	Additive = 0.035
}

SWEP.Kick = {
	Move = {
		UpBase = 1,
		LateralBase = 0.45,
		UpModifier = 0.275,
		LateralModifier = 0.05,
		UpMax = 4,
		LateralMax = 2.5,
		DirectionChange = 7
	},
	Air = {
		UpBase = 1.25,
		LateralBase = 0.45,
		UpModifier = 0.22,
		LateralModifier = 0.18,
		UpMax = 5.5,
		LateralMax = 4,
		DirectionChange = 5
	},
	Crouch = {
		UpBase = 0.575,
		LateralBase = 0.325,
		UpModifier = 0.2,
		LateralModifier = 0.011,
		UpMax = 3.25,
		LateralMax = 2,
		DirectionChange = 8
	},
	Base = {
		UpBase = 0.625,
		LateralBase = 0.375,
		UpModifier = 0.25,
		LateralModifier = 0.0125,
		UpMax = 3.5,
		LateralMax = 2.25,
		DirectionChange = 8
	}
}
