DEFINE_BASECLASS( "weapon_csbase_gun" )

--- GSBase
SWEP.PrintName = "CSBase_Rifle"
SWEP.Spawnable = false
SWEP.Slot = 2

SWEP.HoldType = "ar2"
SWEP.Weight = 25

SWEP.Primary = {
	Range = 8192,
	Spread = {
		Air = 0,
		Move = 0
	}
}

SWEP.Secondary = {
	Spread = {
		Air = -1,
		Move = -1
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	
	SWEP.EventStyle = {
		-- CS:S muzzle flash
		[5001] = "cstrike_x",
		[5011] = "cstrike_x",
		[5021] = "cstrike_x",
		[5031] = "cstrike_x"
	}
end

--- CSBase_Gun
SWEP.Penetration = 2

--- CSBase_SMG
SWEP.Accuracy = {
	Base = 0.2,
	Divisor = 0, // 0 = off
	Offset = 0,
	Max = 0,
	Quadratic = false,
	Speed = 140/250,
	Additive = 0
}

SWEP.Kick = {
	Move = {
		UpBase = 0,
		LateralBase = 0,
		UpModifier = 0,
		LateralModifier = 0,
		UpMax = 0,
		LateralMax = 0,
		DirectionChange = 0
	},
	Air = {
		UpBase = 0,
		LateralBase = 0,
		UpModifier = 0,
		LateralModifier = 0,
		UpMax = 0,
		LateralMax = 0,
		DirectionChange = 0
	},
	Crouch = {
		UpBase = 0,
		LateralBase = 0,
		UpModifier = 0,
		LateralModifier = 0,
		UpMax = 0,
		LateralMax = 0,
		DirectionChange = 0
	},
	Base = {
		UpBase = 0,
		LateralBase = 0,
		UpModifier = 0,
		LateralModifier = 0,
		UpMax = 0,
		LateralMax = 0,
		DirectionChange = 0
	},
	Speed = 5/250
}

--- GSBase
function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:SharedDeploy( bDelayed )
	BaseClass.SharedDeploy( self, bDelayed )
	
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:FinishReload()
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:ShootBullets( tbl, bSecondary, iClipDeduction )
	BaseClass.ShootBullets( self, tbl, bSecondary, iClipDeduction )
	
	// These modifications feed back into flSpread eventually.
	if ( self.Accuracy.Divisor ~= 0 ) then
		local pPlayer = self:GetOwner()
		local flAccuracy = ( (self.Accuracy.Quadratic and pPlayer:GetShotsFired() ^ 2 or pPlayer:GetShotsFired() ^ 3) / self.Accuracy.Divisor ) + self.Accuracy.Offset
		
		if ( flAccuracy > self.Accuracy.Max ) then
			self.m_flAccuracy = self.Accuracy.Max
		else
			self.m_flAccuracy = flAccuracy
		end
	end
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local tKick = self.Kick
	
	// Kick the gun based on the state of the player.
	-- Speed first, ground second
	if ( pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * tKick.Speed) ^ 2 ) then
		pPlayer:KickBack( tKick.Move )
	elseif ( not pPlayer:OnGround() ) then
		pPlayer:KickBack( tKick.Air )
	elseif ( pPlayer:Crouching() ) then
		pPlayer:KickBack( tKick.Crouch )
	else
		pPlayer:KickBack( tKick.Base )
	end
end

--- CSBase_Gun
function SWEP:GetSpread( bSecondary --[[= self:SpecialActive()]] )
	local pPlayer = self:GetOwner()
	
	-- We're jumping; takes accuracy priority
	if ( not pPlayer:OnGround() ) then
		if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
			local flSpecial = self.Secondary.Spread.Air
			
			if ( flSpecial ~= -1 ) then
				return self.Accuracy.Additive + flSpecial * self.m_flAccuracy
			end
		end
		
		return self.Accuracy.Additive + self.Primary.Spread.Air * self.m_flAccuracy
	end
	
	if ( pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * self.Accuracy.Speed) ^ 2 ) then
		if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
			local flSpecial = self.Secondary.Spread.Move
			
			if ( flSpecial ~= -1 ) then
				return self.Accuracy.Additive + flSpecial * self.m_flAccuracy
			end
		end
		
		return self.Accuracy.Additive + self.Primary.Spread.Move * self.m_flAccuracy
	end
	
	return BaseClass.GetSpread( self, bSecondary ) * self.m_flAccuracy
end