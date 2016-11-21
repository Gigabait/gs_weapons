SWEP.Base = "weapon_cs_base"

SWEP.PrintName = "CSBase_Gun"

SWEP.Sounds = {
	empty = "Default.ClipEmpty_Rifle"
}

SWEP.Primary = {
	RangeModifier = 0.98, -- Damage decay over the shot range
	TracerFreq = 0
}

SWEP.Secondary.RangeModifier = -1

SWEP.Penetration = 1

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
end

local BaseClass = baseclass.Get( SWEP.Base )
local PLAYER = FindMetaTable( "Player" )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.FireCSSBullets
end

function SWEP:UpdateBurstShotTable( tbl, bSecondary )
	tbl.ShootAngles = self:GetShootAngles( bSecondary )
	tbl.Src = self:GetShootSrc( bSecondary )
end

function SWEP:GetShotTable( bSecondary )
	return {
		AmmoType = bSecondary and not self.CheckClip1ForSecondary
			and self:GetSecondaryAmmoName() or self:GetPrimaryAmmoName(),
		Damage = self:GetSpecialKey( "Damage", bSecondary ),
		Distance = self:GetSpecialKey( "Range", bSecondary ),
		--Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
		Num = self:GetSpecialKey( "Bullets", bSecondary ),
		Penetration = self.Penetration,
		RangeModifier = self:GetSpecialKey( "RangeModifier", bSecondary ),
		ShootAngles = self:GetShootAngles( bSecondary ),
		Spread = self:GetSpecialKey( "Spread", bSecondary ),
		SpreadBias = self:GetSpecialKey( "SpreadBias", bSecondary ),
		Src = self:GetShootSrc( bSecondary ),
		Tracer = self:GetSpecialKey( "TracerFreq", bSecondary ),
		TracerName = self:GetSpecialKey( "TracerName", bSecondary, true )
	}
end
