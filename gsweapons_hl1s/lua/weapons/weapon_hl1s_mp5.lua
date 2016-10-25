DEFINE_BASECLASS( "hl1s_basehl1combatweapon" )

--- GSBase
SWEP.PrintName = "#HL1_MP5"
SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/v_9mmAR.mdl"
SWEP.WorldModel = "models/w_9mmAR.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 15

SWEP.Activities = {
	priamry = {
		ACT_VM_PRIMARYATTACK,
		idle = {10, 15} -- FIXME: Not working
	},
	secondary = {
		ACT_VM_SECONDARYATTACK,
		idle = 5
	},
	idle = {
		ACT_VM_IDLE,
		idle = {3, 5}
	}
}

SWEP.Sounds = {
	primary = "Weapon_MP5.Single",
	secondary = "Weapon_MP5.Double"
}

SWEP.Primary = {
	Ammo = "9mmRound",
	ClipSize = 50,
	DefaultClip = 75,
	Cooldown = 0.1,
	Spread = game.SinglePlayer() and VECTOR_CONE_3DEGREES or VECTOR_CONE_6DEGREES
}

SWEP.Secondary = {
	Ammo = "MP5_Grenade",
	DefaultClip = 2,
	Cooldown = 1,
	PunchAngle = Angle(-10, 0, 0)
}

SWEP.EmptyCooldown = 0.15

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
end

--- MP5
SWEP.SecondaryClass = "grenade_mp5"

SWEP.PunchBounds = {
	Min = -2,
	Max = 2
}

--- GSBase
function SWEP:Precache()
	BaseClass.Precache( self )
	
	-- Secondary fire grenade model
	util.PrecacheModel( "models/grenade.mdl" )
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		self:DoMuzzleFlash()
		self:Punch( true )
		
		local pPlayer = self:GetOwner()
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
		pPlayer:RemoveAmmo( 1, self:GetSecondaryAmmoName() )
		self:PlaySound( "secondary" )
		self:PlayActivity( "secondary" )
		
		local flNextTime = CurTime() + self:GetCooldown( true )
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
		self:SetNextReload( flNextTime )
		
		if ( SERVER ) then
			local pGrenade = ents.Create( self.SecondaryClass )
			pGrenade:SetPos( self:GetShootSrc() )
			local vThrow = self:GetShootAngles():Forward() * 800
			pGrenade:SetAngles( vThrow:Angle() )
			pGrenade:_SetAbsVelocity( vThrow )
			pGrenade:SetOwner( pPlayer )
			
			-- Don't need to set the seed here since it's serverside only
			pGrenade:SetLocalAngularVelocity( Angle( random.RandomFloat(-100, -500), 0, 0 ))
			pGrenade:Spawn()
			pGrenade:SetMoveType( MOVETYPE_FLYGRAVITY )
		end
	end
end

function SWEP:Shoot( bSecondary --[[= false]], iIndex --[[= 0]], iClipDeduction --[[= 1]] )
	BaseClass.Shoot( self, bSecondary, iIndex, iClipDeduction )
	-- FIXME: Add this as config?
	self:SetNextSecondaryFire(0) -- Don't penalise secondary time
end

--- HLBase
function SWEP:GetPunchAngle( bSecondary )
	if ( bSecondary ) then
		return BaseClass.GetPunchAngle( self, bSecondary )
	end
	
	local tBounds = self.PunchBounds
	
	return Angle( random.RandomFloat( tBounds.Min, tBounds.Max ), 0, 0 )
end
