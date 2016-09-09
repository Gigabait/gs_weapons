SNDLVL_NONE = 0
SNDLVL_20dB = 20 // rustling leaves
SNDLVL_25dB = 25 // whispering
SNDLVL_30dB = 30 // library
SNDLVL_35dB = 35
SNDLVL_40dB = 40
SNDLVL_45dB = 45 // refrigerator
SNDLVL_50dB = 50 // 3.9 // average home
SNDLVL_55dB = 55 // 3.0
SNDLVL_IDLE = 60 // 2.0	
SNDLVL_60dB = 60 // 2.0 // normal conversation, clothes dryer
SNDLVL_65dB = 65 // 1.5 // washing machine, dishwasher
SNDLVL_STATIC = 66 // 1.25
SNDLVL_70dB = 70 // 1.0 // car, vacuum cleaner, mixer, electric sewing machine
SNDLVL_NORM = 75
SNDLVL_75dB = 75 // 0.8 // busy traffic
SNDLVL_80dB = 80 // 0.7 // mini-bike, alarm clock, noisy restaurant, office tabulator, outboard motor, passing snowmobile
SNDLVL_TALKING = 80 // 0.7
SNDLVL_85dB = 85 // 0.6 // average factory, electric shaver
SNDLVL_90dB = 90 // 0.5 // screaming child, passing motorcycle, convertible ride on frw
SNDLVL_95dB = 95
SNDLVL_100dB = 100 // 0.4 // subway train, diesel truck, woodworking shop, pneumatic drill, boiler shop, jackhammer
SNDLVL_105dB = 105 // helicopter, power mower
SNDLVL_110dB = 110 // snowmobile drvrs seat, inboard motorboat, sandblasting
SNDLVL_120dB = 120 // auto horn, propeller aircraft
SNDLVL_130dB = 130 // air raid siren
SNDLVL_GUNFIRE = 140 // 0.27 // THRESHOLD OF PAIN, gunshot, jet engine
SNDLVL_140dB = 140 // 0.2
SNDLVL_150dB = 150 // 0.2
SNDLVL_180dB = 180 // rocket launching

-- Add Util override and ammo stuff
-- Weapon secondary/special type enums
SPECIAL_SILENCE = 1
SPECIAL_BURST = 2
SPECIAL_ZOOM = 3
SPECIAL_IRONSIGHTS = 4

// -----------------------------------------
//	Vector cones
// -----------------------------------------
// VECTOR_CONE_PRECALCULATED - this resolves to vec3_origin, but adds some
// context indicating that the person writing the code is not allowing
// FireBullets() to modify the direction of the shot because the shot direction
// being passed into the function has already been modified by another piece of
// code and should be fired as specified. See GetActualShotTrajectory(). 

// NOTE: The way these are calculated is that each component == sin (degrees/2)
--VECTOR_CONE_PRECALCULATED = vec3_origin
VECTOR_CONE_1DEGREES = Vector(0.00873, 0.00873, 0.00873)
VECTOR_CONE_2DEGREES = Vector(0.01745, 0.01745, 0.01745)
VECTOR_CONE_3DEGREES = Vector(0.02618, 0.02618, 0.02618)
VECTOR_CONE_4DEGREES = Vector(0.03490, 0.03490, 0.03490)
VECTOR_CONE_5DEGREES = Vector(0.04362, 0.04362, 0.04362)
VECTOR_CONE_6DEGREES = Vector(0.05234, 0.05234, 0.05234)
VECTOR_CONE_7DEGREES = Vector(0.06105, 0.06105, 0.06105)
VECTOR_CONE_8DEGREES = Vector(0.06976, 0.06976, 0.06976)
VECTOR_CONE_9DEGREES = Vector(0.07846, 0.07846, 0.07846)
VECTOR_CONE_10DEGREES = Vector(0.08716, 0.08716, 0.08716)
VECTOR_CONE_15DEGREES = Vector(0.13053, 0.13053, 0.13053)
VECTOR_CONE_20DEGREES = Vector(0.17365, 0.17365, 0.17365)

local developer = GetConVar( "developer" )

function DevMsg( iLevel, ... )
	if ( developer:GetInt() >= iLevel ) then
		print( ... )
	end
end

local band = bit.band
local bnot = bit.bnot
local bor = bit.bor
local bxor = bit.bxor
local floor = math.floor

// The four core functions - F1 is optimized somewhat
// local function f1(x, y, z) bit.bor( bit.band( x, y ), bit.band( bit.bnot( x ), z )) end
// This is the central step in the MD5 algorithm.
local function Step1( w, x, y, z, flData, iStep )
	w = w + bxor( z, band( x, bxor( y, z ))) + flData
	
	return bor( (w * 2^iStep) % 0x100000000, floor(w % 0x100000000 / 2^(0x20 - iStep)) ) + x
end

local function Step2( w, x, y, z, flData, iStep )
	w = w + bxor( y, band( z, bxor( x, y ))) + flData
	
	return bor( (w * 2^iStep) % 0x100000000, floor(w % 0x100000000 / 2^(0x20 - iStep)) ) + x
end

local function Step3( w, x, y, z, flData, iStep )
	w = w + bxor( bxor( x, y ), z ) + flData
	
	return bor( (w * 2^iStep) % 0x100000000, floor(w % 0x100000000 / 2^(0x20 - iStep)) ) + x
end

local function Step4( w, x, y, z, flData, iStep )
	w = w + bxor( y, bor( x, bnot( z ))) + flData
	
	return bor( (w * 2^iStep) % 0x100000000, floor(w % 0x100000000 / 2^(0x20 - iStep)) ) + x
end

function math.MD5Random( nSeed, verbose )
	nSeed = nSeed % 0x100000000
	if ( verbose ) then print( nSeed ) end
	local a = Step1(0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, nSeed + 0xd76aa478, 7)
	local d = Step1(0x10325476, a, 0xefcdab89, 0x98badcfe, 0xe8c7b7d6, 12)
	local c = Step1(0x98badcfe, d, a, 0xefcdab89, 0x242070db, 17)
	local b = Step1(0xefcdab89, c, d, a, 0xc1bdceee, 22)
	a = Step1(a, b, c, d, 0xf57c0faf, 7)
	d = Step1(d, a, b, c, 0x4787c62a, 12)
	c = Step1(c, d, a, b, 0xa8304613, 17)
	b = Step1(b, c, d, a, 0xfd469501, 22)
	a = Step1(a, b, c, d, 0x698098d8, 7)
	d = Step1(d, a, b, c, 0x8b44f7af, 12)
	c = Step1(c, d, a, b, 0xffff5bb1, 17)
	b = Step1(b, c, d, a, 0x895cd7be, 22)
	a = Step1(a, b, c, d, 0x6b901122, 7)
	d = Step1(d, a, b, c, 0xfd987193, 12)
	c = Step1(c, d, a, b, 0xa67943ae, 17)
	b = Step1(b, c, d, a, 0x49b40821, 22)
	if ( verbose ) then print( a, b, c, d ) end
	a = Step2(a, b, c, d, 0xf61e25e2, 5)
	d = Step2(d, a, b, c, 0xc040b340, 9)
	c = Step2(c, d, a, b, 0x265e5a51, 14)
	b = Step2(b, c, d, a, nSeed + 0xe9b6c7aa, 20)
	a = Step2(a, b, c, d, 0xd62f105d, 5)
	d = Step2(d, a, b, c, 0x02441453, 9)
	c = Step2(c, d, a, b, 0xd8a1e681, 14)
	b = Step2(b, c, d, a, 0xe7d3fbc8, 20)
	a = Step2(a, b, c, d, 0x21e1cde6, 5)
	d = Step2(d, a, b, c, 0xc33707f6, 9)
	c = Step2(c, d, a, b, 0xf4d50d87, 14)
	b = Step2(b, c, d, a, 0x455a14ed, 20)
	a = Step2(a, b, c, d, 0xa9e3e905, 5)
	d = Step2(d, a, b, c, 0xfcefa3f8, 9)
	c = Step2(c, d, a, b, 0x676f02d9, 14)
	b = Step2(b, c, d, a, 0x8d2a4c8a, 20)

	a = Step3(a, b, c, d, 0xfffa3942, 4)
	d = Step3(d, a, b, c, 0x8771f681, 11)
	c = Step3(c, d, a, b, 0x6d9d6122, 16)
	b = Step3(b, c, d, a, 0xfde5382c, 23)
	a = Step3(a, b, c, d, 0xa4beeac4, 4)
	d = Step3(d, a, b, c, 0x4bdecfa9, 11)
	c = Step3(c, d, a, b, 0xf6bb4b60, 16)
	b = Step3(b, c, d, a, 0xbebfbc70, 23)
	a = Step3(a, b, c, d, 0x289b7ec6, 4)
	d = Step3(d, a, b, c, nSeed + 0xeaa127fa, 11)
	c = Step3(c, d, a, b, 0xd4ef3085, 16)
	b = Step3(b, c, d, a, 0x04881d05, 23)
	a = Step3(a, b, c, d, 0xd9d4d039, 4)
	d = Step3(d, a, b, c, 0xe6db99e5, 11)
	c = Step3(c, d, a, b, 0x1fa27cf8, 16)
	b = Step3(b, c, d, a, 0xc4ac5665, 23)
	
	a = Step4(a, b, c, d, nSeed + 0xf4292244, 6)
	d = Step4(d, a, b, c, 0x432aff97, 10)
	c = Step4(c, d, a, b, 0xab9423c7, 15)
	b = Step4(b, c, d, a, 0xfc93a039, 21)
	a = Step4(a, b, c, d, 0x655b59c3, 6)
	d = Step4(d, a, b, c, 0x8f0ccc92, 10)
	c = Step4(c, d, a, b, 0xffeff47d, 15)
	b = Step4(b, c, d, a, 0x85845e51, 21)
	a = Step4(a, b, c, d, 0x6fa87e4f, 6)
	d = Step4(d, a, b, c, 0xfe2ce6e0, 10)
	c = Step4(c, d, a, b, 0xa3014314, 15)
	b = Step4(b, c, d, a, 0x4e0811a1, 21)
	a = Step4(a, b, c, d, 0xf7537e82, 6)
	d = Step4(d, a, b, c, 0xbd3af235, 10)
	c = (0x98badcfe + Step4(c, d, a, b, 0x2ad7d2bb, 15)) % 0x100000000
	b = (0xefcdab89 + Step4(b, c, d, a, 0xeb86d391, 21)) % 0x100000000
	if ( verbose ) then print( a, b, c, d ) end
	return floor( b / 0x10000 ) % 0x100 + floor( b / 0x1000000 ) % 0x100 * 0x100 + c % 0x100 * 0x10000 + floor( c / 0x100 ) % 0x100 * 0x1000000
end

local PLAYER = _R.Player

function PLAYER:SetupWeaponDataTables()
	self:DTVar( "Int", 0, "ShotsFired" )
end

function PLAYER:GetShotsFired()
	return self.dt and self.dt.ShotsFired or 0
end

function PLAYER:SetShotsFired( iShots )
	if ( self.dt ) then
		self.dt.ShotsFired = iShots
	end
end

-- Shared version of SelectWeapon
function PLAYER:SwitchWeapon( weapon )
	if ( isstring( weapon )) then
		local pWeapon = self:GetWeapon( weapon )
		
		if ( pWeapon ~= NULL ) then
			self.m_pNewWeapon = pWeapon
		end
	elseif ( weapon:GetOwner() == self ) then
		self.m_pNewWeapon = weapon
	end
end

-- Handles weapon switching
hook.Add( "StartCommand", "GSBase-Shared SelectWeapon", function( pPlayer, cmd )
	if ( pPlayer.m_pNewWeapon ) then
		if ( pPlayer.m_pNewWeapon == NULL or pPlayer.m_pNewWeapon == pPlayer:GetActiveWeapon() ) then
			pPlayer.m_pNewWeapon = nil
		else
			cmd:SelectWeapon( pPlayer.m_pNewWeapon )
		end
	end
end )

-- Fix; check with prediction
-- Scales the player's movement speeds based on their weapon
hook.Add( "Move", "GSBase-Weapon speed", function( pPlayer, mv )
	local pActiveWeapon = pPlayer:GetActiveWeapon()
	
	if ( pActiveWeapon.GetWalkSpeed ) then
		local flOldSpeed = mv:GetMaxSpeed() *
			(pPlayer:KeyDown( IN_SPEED ) and pActiveWeapon:GetRunSpeed() or pActiveWeapon:GetWalkSpeed())
		
		mv:SetMaxSpeed( flOldSpeed )
		mv:SetMaxClientSpeed( flOldSpeed )
	end
end )

function PLAYER:SharedRandomFloat( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))
	
	return random.RandomFloat( flMin, flMax )
end

function PLAYER:SharedRandomInt( sName, iMin, iMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))
	
	return random.RandomInt( iMin, iMax )
end

function PLAYER:SharedRandomVector( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))

	return Vector( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ) )
end

function PLAYER:SharedRandomAngle( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))

	return Angle( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ))
end

function PLAYER:SharedRandomColor( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))
	
	return Color( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ))
end

FIRE_BULLETS_FIRST_SHOT_ACCURATE = 0x1 // Pop the first shot with perfect accuracy
FIRE_BULLETS_DONT_HIT_UNDERWATER = 0x2 // If the shot hits its target underwater, don't damage it
FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS = 0x4 // If the shot hits water surface, still call DoImpactEffect
-- The engine alerts NPCs by pushing a sound onto a static sound manager
-- This cannot be accessed from the Lua state
--FIRE_BULLETS_TEMPORARY_DANGER_SOUND = 0x8 // Danger sounds added from this impact can be stomped immediately if another is queued

local ai_shot_bias_min = GetConVar( "ai_shot_bias_min" )
local ai_shot_bias_max = GetConVar( "ai_shot_bias_max" )
local ai_debug_shoot_positions = GetConVar( "ai_debug_shoot_positions" )
local phys_pushscale = GetConVar( "phys_pushscale" )
local sv_showimpacts = CreateConVar( "sv_showimpacts", "0", FCVAR_REPLICATED, "Shows client (red) and server (blue) bullet impact point (1=both, 2=client-only, 3=server-only)" )
local sv_showpenetration = CreateConVar( "sv_showpenetration", "0", FCVAR_REPLICATED, "Shows penetration trace (if applicable) when the weapon fires" )
local sv_showplayerhitboxes = CreateConVar( "sv_showplayerhitboxes", "0", FCVAR_REPLICATED, "Show lag compensated hitboxes for the specified player index whenever a player fires." )

local iTracerCount = 0 -- Global to interact with FireCSBullets

-- Player only as NPCs could not be overrided to use this function
function PLAYER:LuaFireBullets( bullets )
	if ( hook.Run( "EntityFireBullets", self, bullets ) == false ) then
		return
	end
	
	local pWeapon = self:GetActiveWeapon()
	local bWeaponInvalid = pWeapon == NULL
	
	-- FireBullets info
	local sAmmoType
	local iAmmoType
	
	if ( not bullets.AmmoType ) then
		sAmmoType = ""
		iAmmoType = -1
	elseif ( isstring( bullets.AmmoType )) then
		sAmmoType = bullets.AmmoType
		iAmmoType = game.GetAmmoID( sAmmoType )
	else
		iAmmoType = bullets.AmmoType
		sAmmoType = game.GetAmmoName( iAmmoType )
	end
	
	local pAttacker = bullets.Attacker and bullets.Attacker ~= NULL and bullets.Attacker or self
	local fCallback = bullets.Callback
	local iDamage = bullets.Damage or 1
	local vDir = bullets.Dir:GetNormal() or self:GetAimVector()
	local flDistance = bullets.Distance or MAX_TRACE_LENGTH
	local Filter = bullets.Filter or self
	local iFlags = bullets.Flags or 0
	local flForce = bullets.Force or 1
	local iGibDamage = bullets.GibDamage or 16
	local flHullSize = bullets.HullSize or 3
	local pInflictor = bullets.Inflictor and bullets.Inflictor ~= NULL and bullets.Inflictor or bWeaponInvalid and self or pWeapon
	local iMask = bullets.Mask or MASK_SHOT
	local iNPCDamage = bullets.NPCDamage or 0
	local iNum = bullets.Num or 1
	local iPlayerDamage = bullets.PlayerDamage or 0
	local vSpread = bullets.Spread or vector_origin
	local flSpreadBias = bullets.SpreadBias or 1
	
	if ( flSpreadBias > 1 ) then
		flSpreadBias = 1
	elseif ( flSpreadBias < 0 ) then
		flSpreadBias = 0
	end
	
	local vSrc = bullets.Src or self:GetShootPos()
	local iTracerFreq = bullets.Tracer or 1
	local sTracerName = bullets.TracerName or "Tracer"
	
	-- Ammo
	local iAmmoFlags = game.GetAmmoFlags( sAmmoType )
	local flAmmoForce = game.GetAmmoForce( sAmmoType )
	local iAmmoDamageType = game.GetAmmoDamageType( sAmmoType )
	local iAmmoPlayerDamage = game.GetAmmoPlayerDamage( sAmmoType )
	local iAmmoMinSplash = game.GetAmmoMinSplash( sAmmoType )
	local iAmmoMaxSplash = game.GetAmmoMaxSplash( sAmmoType )
	local iAmmoTracerType = game.GetAmmoTracerType( sAmmoType )
	
	if ( bit.band( iAmmoFlags, AMMO_INTERPRET_PLRDAMAGE_AS_DAMAGE_TO_PLAYER ) ~= 0 ) then
		if ( iPlayerDamage == 0 ) then
			iPlayerDamage = iAmmoPlayerDamage
		end
		
		if ( iNPCDamage == 0 ) then
			iNPCDamage = game.GetAmmoNPCDamage( sAmmoType )
		end
	end
	
	-- Loop values
	local bDebugShoot = ai_debug_shoot_positions:GetBool()
	local bFirstShotInaccurate = bit.band( iFlags, FIRE_BULLETS_FIRST_SHOT_ACCURATE ) == 0
	local flPhysPush = phys_pushscale:GetFloat()
	local bShowPenetration = sv_showpenetration:GetBool()
	local bStartedInWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
	local bFirstTimePredicted = IsFirstTimePredicted()
	local flShotBias, flFlatness, flSpreadX, flSpreadY, vFireBulletMax, vFireBulletMin, vSpreadRight, vSpreadUp
	
	// Wrap it for network traffic so it's the same between client and server
	local iSeed = math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x100 - 1
	
	-- Don't calculate stuff we won't end up using
	if ( bFirstShotInaccurate or iNum ~= 1 ) then
		local flBiasMin = ai_shot_bias_min:GetFloat()
		flShotBias = (ai_shot_bias_max:GetFloat() - flBiasMin) * flSpreadBias + flBiasMin
		flFlatness = flShotBias / (flShotBias < 0 and -2 or 2)
		flSpreadX = vSpread.x
		flSpreadY = vSpread.y
		vFireBulletMax = Vector( flHullSize, flHullSize, flHullSize )
		vFireBulletMin = -vFireBulletMax
		vSpreadRight = vSpread:Right()
		vSpreadUp = vSpread:Up()
	end
	
	//Adrian: visualize server/client player positions
	//This is used to show where the lag compesator thinks the player should be at.
	local iHitNum = sv_showplayerhitboxes:GetInt()
	
	if ( iHitNum > 0 ) then
		local pLagPlayer = Player( iHitNum )
		
		if ( pLagPlayer ~= NULL ) then
			pLagPlayer:DrawHitBoxes( DEBUG_LENGTH )
		end
	end
	
	iHitNum = sv_showimpacts:GetInt()
	
	self:LagCompensation( true )
	
	for iShot = 1, iNum do
		local vShotDir
		iSeed = iSeed + 1 // use new seed for next bullet
		random.SetSeed( iSeed ) // init random system with this seed
		
		// If we're firing multiple shots, and the first shot has to be ba on target, ignore spread
		if ( iShot ~= 1 or bFirstShotInaccurate ) then
			local x
			local y
			local z

			repeat
				x = random.RandomFloat(-1, 1) * flFlatness + random.RandomFloat(-1, 1) * (1 - flFlatness)
				y = random.RandomFloat(-1, 1) * flFlatness + random.RandomFloat(-1, 1) * (1 - flFlatness)

				if ( flShotBias < 0 ) then
					x = x < 0 and -1 - x or 1 - x
					y = y < 0 and -1 - y or 1 - y
				end

				z = x * x + y * y
			until (z <= 1)

			vShotDir = vDir + x * flSpreadX * vSpreadRight + y * flSpreadY * vSpreadUp
			vShotDir:Normalize()
		else
			vShotDir = vDir:GetNormal()
		end
		
		local bHitGlass
		local vEnd = vSrc + vShotDir * flDistance
		local vNewSrc = vSrc
		local vFinalHit
		
		repeat
			local tr = iShot % 2 == 0 and
				// Half of the shotgun pellets are hulls that make it easier to hit targets with the shotgun.
				util.TraceHull({
					start = vNewSrc,
					endpos = vEnd,
					mins = vFireBulletMin,
					maxs = vFireBulletMax,
					mask = iMask,
					filter = Filter
				})
			or
				util.TraceLine({
					start = vNewSrc,
					endpos = vEnd,
					mask = iMask,
					filter = Filter
				})
			
			--[[if ( SERVER ) then
				if ( bHitWater ) then
					local flLengthSqr = vSrc:DistToSqr( tr.HitPos )
					
					if ( flLengthSqr > SHOT_UNDERWATER_BUBBLE_DIST * SHOT_UNDERWATER_BUBBLE_DIST ) then
						util.BubbleTrail( self:ComputeTracerStartPosition( vSrc ),
						vSrc + SHOT_UNDERWATER_BUBBLE_DIST * vShotDir,
						WATER_BULLET_BUBBLES_PER_INCH * SHOT_UNDERWATER_BUBBLE_DIST )
					else
						local flLength = math.sqrt( flLengthSqr ) - 0.1
						util.BubbleTrail( self:ComputeTracerStartPosition( vSrc ),
						vSrc + flLength * vShotDir,
						SHOT_UNDERWATER_BUBBLE_DIST * flLength )
					end
				end
				
				// Now hit all triggers along the ray that respond to shots...
				// Clip the ray to the first collided solid returned from traceline
				-- https://github.com/Facepunch/garrysmod-requests/issues/755
				local triggerInfo = DamageInfo()
					triggerInfo:SetAttacker( pAttacker )
					triggerInfo:SetInflictor( pAttacker )
					triggerInfo:SetDamage( iDamage )
					triggerInfo:SetDamageType( iAmmoDamageType )
					triggerInfo:CalculateBulletDamageForce( sAmmoType, vShotDir, tr.HitPos, tr.HitPos, flForce )
					triggerInfo:SetAmmoType( iAmmoType )
				triggerInfo:TraceAttackToTriggers( triggerInfo, vSrc, tr.HitPos, vShotDir )
			end]]
			
			local pEntity = tr.Entity
			local vHitPos = tr.HitPos
			vFinalHit = vHitPos
			local bHitWater = bStartedInWater
			local bEndNotWater = bit.band( util.PointContents( tr.HitPos ), MASK_WATER ) == 0
			
			-- The bullet left the water
			if ( bHitWater and bEndNotWater ) then
				if ( bFirstTimePredicted ) then
					local data = EffectData()
						local vSplashPos = util.TraceLine({
							start = vEnd,
							endpos = vNewSrc,
							mask = MASK_WATER
						}).HitPos
						
						data:SetOrigin( vSplashPos )
						data:SetScale( random.RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
						
						if ( bit.band( util.PointContents( vSplashPos ), CONTENTS_SLIME ) ~= 0 ) then
							data:SetFlags( FX_WATER_IN_SLIME )
						end
						
					util.Effect( "gunshotsplash", data )
				end
			// See if the bullet ended up underwater + started out of the water
			elseif ( not bHitWater and not bEndNotWater ) then
				if ( bFirstTimePredicted ) then
					local data = EffectData()
						local vSplashPos = util.TraceLine({
							start = vNewSrc,
							endpos = vEnd,
							mask = MASK_WATER
						}).HitPos
						
						data:SetOrigin( vSplashPos )
						data:SetScale( random.RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
						
						if ( bit.band( util.PointContents( vSplashPos ), CONTENTS_SLIME ) ~= 0 ) then
							data:SetFlags( FX_WATER_IN_SLIME )
						end
						
					util.Effect( "gunshotsplash", data )
					
					--[[local pWaterBullet = ents.Create( "waterbullet" )
					
					if ( pWaterBullet ~= NULL ) then
						pWaterBullet:SetPos( trWater.HitPos )
						pWaterBullet:_SetAbsVelocity( vDir * 1500 )
						
						-- Re-use EffectData
							data:SetStart( trWater.HitPos )
							data:SetOrigin( trWater.HitPos + vDir * 400 )
							data:SetFlags( TRACER_TYPE_WATERBULLET )
						util.Effect( "TracerSound", data )
					end]]
				end
			
				bHitWater = true
			end
			
			if ( tr.HitSky or tr.Fraction == 1 or pEntity == NULL ) then
				break // we didn't hit anything, stop tracing shoot
			end
			
			// draw server impact markers
			if ( iHitNum == 1 or (CLIENT and iHitNum == 2) or (SERVER and iHitNum == 3) ) then
				debugoverlay.Box( vHitPos, vector_debug_min, vector_debug_max, DEBUG_LENGTH, color_debug )
			end
			
			// do damage, paint decals
			-- https://github.com/Facepunch/garrysmod-issues/issues/2741
			bHitGlass = --[[tr.MatType == MAT_GLASS]] pEntity:GetClass():find( "func_breakable", 1, true ) and not pEntity:HasSpawnFlags( SF_BREAK_NO_BULLET_PENETRATION )
			local iActualDamageType = iAmmoDamageType
			
			if ( not bHitWater or bit.band( iFlags, FIRE_BULLETS_DONT_HIT_UNDERWATER ) == 0 ) then
				-- The engine considers this a float
				-- Even though no values assigned to it are
				local iActualDamage = iDamage
				
				// If we hit a player, and we have player damage specified, use that instead
				// Adrian: Make sure to use the currect value if we hit a vehicle the player is currently driving.
				-- We don't check for vehicle passengers since GMod has no C++ vehicles with them
				if ( pEntity:IsPlayer() ) then
					if ( iPlayerDamage ~= 0 ) then
						iActualDamage = iPlayerDamage
					end
				elseif ( pEntity:IsNPC() ) then
					if ( iNPCDamage ~= 0 ) then
						iActualDamage = iNPCDamage
					end
				-- https://github.com/Facepunch/garrysmod-requests/issues/760
				elseif ( SERVER and pEntity:IsVehicle() ) then
					local pDriver = pEntity:GetDriver()
					
					if ( iPlayerDamage ~= 0 and pDriver:IsPlayer() ) then
						iActualDamage = iPlayerDamage
					elseif ( iNPCDamage ~= 0 and pDriver:IsNPC() ) then
						iActualDamage = iNPCDamage
					end
				end
				
				if ( iActualDamage == 0 ) then
					iActualDamage = iAmmoPlayerDamage == 0 and iDamage or iAmmoPlayerDamage -- Only players fire through this
				end
				
				if ( iActualDamage >= iGibDamage ) then
					iActualDamageType = bit.bor( iAmmoDamageType, DMG_ALWAYSGIB )
				end
				
				// Damage specified by function parameter
				local info = DamageInfo()
					info:SetAttacker( pAttacker )
					info:SetInflictor( pInflictor )
					info:SetDamage( iActualDamage )
					info:SetDamageType( iActualDamageType )
					info:SetDamagePosition( vHitPos )
					info:SetDamageForce( vShotDir * flAmmoForce * flForce * flPhysPush )
					info:SetAmmoType( iAmmoType )
					info:SetReportedPosition( vSrc )
				pEntity:DispatchTraceAttack( info, tr, vShotDir )
				
				tr.StartPos = vSrc
				
				if ( fCallback ) then
					fCallback( pAttacker, tr, info )
				end
				
				if ( bFirstTimePredicted ) then
					if ( not bHitWater or bStartedInWater or bit.band( iFlags, FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS ) ~= 0 ) then
						if ( bWeaponInvalid or not pWeapon:DoImpactEffect( tr, iActualDamageType )) then
							local data = EffectData()
								data:SetOrigin( tr.HitPos )
								data:SetStart( tr.StartPos )
								data:SetSurfaceProp( tr.SurfaceProps )
								data:SetDamageType( iActualDamageType )
								data:SetHitBox( tr.HitBox )
								data:SetEntity( pEntity )
							util.Effect( "Impact", data )
						end	
					else
						// We may not impact, but we DO need to affect ragdolls on the client
						local data = EffectData()
							data:SetOrigin( tr.HitPos )
							data:SetStart( tr.StartPos )
							data:SetDamageType( iActualDamageType )
						util.Effect( "RagdollImpact", data )
					end
				end
			end
			
			if ( SERVER and bit.band( iAmmoFlags, AMMO_FORCE_DROP_IF_CARRIED ) ~= 0 ) then
				// Make sure if the player is holding this, he drops it
				DropEntityIfHeld( pEntity )
			end
			
			// See if we hit glass
			// Query the func_breakable for whether it wants to allow for bullet penetration
			if ( bHitGlass ) then
				local tEnts = ents.GetAll()
				local iLen = #tEnts
				
				-- Trace for only the entity we hit
				for i = iLen, 1, -1 do
					if ( tEnts[i] == pEntity ) then
						tEnts[i] = tEnts[iLen]
						tEnts[iLen] = nil
						
						break
					end
				end
				
				util.TraceLine({
					start = vEnd,
					endpos = vHitPos,
					mask = iMask,
					filter = tEnts,
					ignoreworld = true,
					output = tr
				})
				
				if ( bShowPenetration ) then
					debugoverlay.Line( vEnd, vHitPos, DEBUG_LENGTH, color_altdebug )
				end
				
				if ( iHitNum == 1 or ( CLIENT and iHitNum == 2 ) or ( SERVER and iHitNum == 3 )) then
					debugoverlay.Box( tr.HitPos, vector_debug_min, vector_debug_max, DEBUG_LENGTH, color_altdebug )
				end
				
				// bullet did penetrate object, exit Decal
				if ( bFirstTimePredicted and (bWeaponInvalid or not pWeapon:DoImpactEffect( tr, iActualDamageType ))) then
					local data = EffectData()
						data:SetOrigin( tr.HitPos )
						data:SetStart( tr.StartPos )
						data:SetSurfaceProp( tr.SurfaceProps )
						data:SetDamageType( iActualDamageType )
						data:SetHitBox( tr.HitBox )
						data:SetEntity( pEntity )
					util.Effect( "Impact", data )
				end
			
				vNewSrc = tr.HitPos
			end
		until ( not bHitGlass )
		
		if ( bDebugShoot ) then
			debugoverlay.Line( vSrc, vFinalHit, DEBUG_LENGTH, color_debug )
		end
		
		if ( bFirstTimePredicted and iTracerFreq > 0 ) then
			if ( iTracerCount % iTracerFreq == 0 ) then
				local data = EffectData()
					data:SetStart( self:ComputeTracerStartPosition( vSrc ))
					data:SetOrigin( vFinalHit )
					data:SetScale(0)
					data:SetEntity( bWeaponInvalid and self or pWeapon )
					data:SetAttachment( bWeaponInvalid and 1 or pWeapon.GetMuzzleAttachment and pWeapon:GetMuzzleAttachment() or 1 )
					
					local iFlags = TRACER_FLAG_USEATTACHMENT
					
					if ( iAmmoTracerType == TRACER_LINE_AND_WHIZ ) then
						iFlags = bit.bor( iFlags, TRACER_FLAG_WHIZ )
					end
					
					data:SetFlags( iFlags )
				util.Effect( sTracerName, data )
			end
			
			iTracerCount = iTracerCount + 1
		end
	end
	
	self:LagCompensation( false )
end

local tMaterialParameters = {
	[MAT_METAL] = {
		Penetration = 0.5,
		Damage = 0.3
	},
	[MAT_DIRT] = {
		Penetration = 0.5,
		Damage = 0.3
	},
	[MAT_CONCRETE] = {
		Penetration = 0.4,
		Damage = 0.25
	},
	[MAT_GRATE] = {
		Penetration = 1,
		Damage = 0.99
	},
	[MAT_VENT] = {
		Penetration = 0.5,
		Damage = 0.45
	},
	[MAT_TILE] = {
		Penetration = 0.65,
		Damage = 0.3
	},
	[MAT_COMPUTER] = {
		Penetration = 0.4,
		Damage = 0.45
	},
	[MAT_WOOD] = {
		Penetration = 1,
		Damage = 0.6
	},
	[MAT_GLASS] = {
		Penetration = 1,
		Damage = 0.99
	},
}

local tDoublePenetration = {
	[MAT_WOOD] = true,
	[MAT_METAL] = true,
	[MAT_GRATE] = true,
	[MAT_GLASS] = true
}

local CS_MASK_HITBOX = bit.bor( bit.bor( MASK_SOLID, CONTENTS_DEBRIS ), CONTENTS_HITBOX )

function PLAYER:FireCSBullets( bullets )
	if ( hook.Run( "EntityFireCSBullets", self, bullets ) == false ) then
		return
	end
	
	local pWeapon = self:GetActiveWeapon()
	local bWeaponInvalid = pWeapon == NULL
	
	-- FireCSBullets info
	local sAmmoType
	local iAmmoType
	
	if ( not bullets.AmmoType ) then
		sAmmoType = ""
		iAmmoType = -1
	elseif ( isstring( bullets.AmmoType )) then
		sAmmoType = bullets.AmmoType
		iAmmoType = game.GetAmmoID( sAmmoType )
	else
		iAmmoType = bullets.AmmoType
		sAmmoType = game.GetAmmoName( iAmmoType )
	end
	
	local pAttacker = bullets.Attacker and bullets.Attacker ~= NULL and bullets.Attacker or self
	local fCallback = bullets.Callback
	local iDamage = bullets.Damage or 1
	local flDistance = bullets.Distance or 56756
	local flExitMaxDistance = bullets.ExitMaxDistance or 128
	local flExitStepSize = bullets.ExitStepSize or 24
	local tFilter = bullets.Filter or { self }
	
	if ( not istable( tFilter )) then
		tFilter = { tFilter }
	end
	
	local iFlags = bullets.Flags or 0
	local flForce = bullets.Force or 1
	local iGibDamage = bullets.GibDamage or 16
	--local flHitboxTolerance = bullets.HitboxTolerance or 40
	local pInflictor = bullets.Inflictor and bullets.Inflictor ~= NULL and bullets.Inflictor or bWeaponInvalid and self or pWeapon
	local iMask = bullets.Mask or CS_MASK_HITBOX
	local iNum = bullets.Num or 1
	local iPenetration = bullets.Penetration or 0
	local flRangeModifier = bullets.RangeModifier or 0
	local aShootAngles = bullets.ShootAngles or angle_zero
	local flSpread = bullets.Spread or 0
	local flSpreadBias = bullets.SpreadBias or 0
	local vSrc = bullets.Src or self:GetShootPos()
	local iTracerFreq = bullets.Tracer or 1
	local sTracerName = bullets.TracerName or "Tracer"
	
	-- Ammo
	local iAmmoFlags = game.GetAmmoFlags( sAmmoType )
	local flAmmoForce = game.GetAmmoForce( sAmmoType )
	local iAmmoDamageType = game.GetAmmoDamageType( sAmmoType )
	local iAmmoMinSplash = game.GetAmmoMinSplash( sAmmoType )
	local iAmmoMaxSplash = game.GetAmmoMaxSplash( sAmmoType )
	local iAmmoTracerType = game.GetAmmoTracerType( sAmmoType )
	local flPenetrationDistance = game.GetAmmoKey( sAmmoType, "penetrationdistance", 0 )
	local flPenetrationPower = game.GetAmmoKey( sAmmoType, "penetrationpower", 0 )
	
	-- Loop values
	local bDebugShoot = ai_debug_shoot_positions:GetBool()
	local iFilterEnd = #tFilter
	local bFirstShotInaccurate = bit.band( iFlags, FIRE_BULLETS_FIRST_SHOT_ACCURATE ) == 0
	local iNewFilterEnd = iFilterEnd - 1
	local flPhysPush = phys_pushscale:GetFloat()
	local vShootForward = aShootAngles:Forward()
	local bShowPenetration = sv_showpenetration:GetBool()
	local bStartedInWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
	local bFirstTimePredicted = IsFirstTimePredicted()
	local vShootRight, vShootUp
	
	// Wrap it for network traffic so it's the same between client and server
	local iSeed = math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x100
	
	-- Don't calculate stuff we won't end up using
	if ( bFirstShotInaccurate or iNum ~= 1 ) then
		vShootRight = flSpread * aShootAngles:Right()
		vShootUp = flSpread * aShootAngles:Up()
	end
	
	//Adrian: visualize server/client player positions
	//This is used to show where the lag compesator thinks the player should be at.
	local iHitNum = sv_showplayerhitboxes:GetInt()
	
	if ( iHitNum > 0 ) then
		local pLagPlayer = Player( iHitNum )
		
		if ( pLagPlayer ~= NULL ) then
			pLagPlayer:DrawHitBoxes( DEBUG_LENGTH )
		end
	end
	
	iHitNum = sv_showimpacts:GetInt()
	
	self:LagCompensation( true )
	
	for iShot = 1, iNum do
		local vShotDir
		iSeed = iSeed + 1 // use new seed for next bullet
		random.SetSeed( iSeed ) // init random system with this seed
		
		-- Loop values
		local flCurrentDamage = iDamage	// damage of the bullet at it's current trajectory
		local flCurrentDistance = 0	// distance that the bullet has traveled so far
		local vNewSrc = vSrc
		local vFinalHit
		
		// add the spray 
		if ( iShot ~= 1 or bFirstShotInaccurate ) then
			vShotDir = vShootForward + vShootRight * (random.RandomFloat( -flSpreadBias, flSpreadBias ) + random.RandomFloat( -flSpreadBias, flSpreadBias ))
			+ vShootUp * (random.RandomFloat( -flSpreadBias, flSpreadBias ) + random.RandomFloat( -flSpreadBias, flSpreadBias ))
			vShotDir:Normalize()
		else
			vShotDir = vShootForward
		end
		
		local vEnd = vNewSrc + vShotDir * flDistance
		
		repeat
			local tr = util.TraceLine({
				start = vNewSrc,
				endpos = vEnd,
				mask = iMask,
				filter = tFilter
			})
			
			// Check for player hitboxes extending outside their collision bounds
			--util.ClipTraceToPlayers( tr, vNewSrc, vEnd + vShotDir * flHitboxTolerance, tFilter, iMask )
			
			local pEntity = tr.Entity
			local vHitPos = tr.HitPos
			vFinalHit = vHitPos
			local bHitWater = bStartedInWater
			local bEndNotWater = bit.band( util.PointContents( vHitPos ), MASK_WATER ) == 0
			
			-- The bullet left the water
			if ( bHitWater and bEndNotWater ) then
				if ( bFirstTimePredicted ) then
					local data = EffectData()
						local vSplashPos = util.TraceLine({
							start = vEnd,
							endpos = vNewSrc,
							mask = MASK_WATER
						}).HitPos
						
						data:SetOrigin( vSplashPos )
						data:SetScale( random.RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
						
						if ( bit.band( util.PointContents( vSplashPos ), CONTENTS_SLIME ) ~= 0 ) then
							data:SetFlags( FX_WATER_IN_SLIME )
						end
						
					util.Effect( "gunshotsplash", data )
				end
			// See if the bullet ended up underwater + started out of the water
			elseif ( not bHitWater and not bEndNotWater ) then
				if ( bFirstTimePredicted ) then
					local data = EffectData()
						local vSplashPos = util.TraceLine({
							start = vNewSrc,
							endpos = vEnd,
							mask = MASK_WATER
						}).HitPos
						
						data:SetOrigin( vSplashPos )
						data:SetScale( random.RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
						
						if ( bit.band( util.PointContents( vSplashPos ), CONTENTS_SLIME ) ~= 0 ) then
							data:SetFlags( FX_WATER_IN_SLIME )
						end
						
					util.Effect( "gunshotsplash", data )
					
					--[[local pWaterBullet = ents.Create( "waterbullet" )
					
					if ( pWaterBullet ~= NULL ) then
						pWaterBullet:SetPos( trWater.HitPos )
						pWaterBullet:_SetAbsVelocity( vDir * 1500 )
						
						-- Re-use EffectData
							data:SetStart( trWater.HitPos )
							data:SetOrigin( trWater.HitPos + vDir * 400 )
							data:SetFlags( TRACER_TYPE_WATERBULLET )
						util.Effect( "TracerSound", data )
					end]]
				end
			
				bHitWater = true
			end
			
			if ( tr.HitSky or tr.Fraction == 1 or pEntity == NULL ) then
				break // we didn't hit anything, stop tracing shoot
			end
			
			// draw server impact markers
			if ( iHitNum == 1 or (CLIENT and iHitNum == 2) or (SERVER and iHitNum == 3) ) then
				debugoverlay.Box( vHitPos, vector_debug_min, vector_debug_max, DEBUG_LENGTH, color_debug )
			end
			
			/************* MATERIAL DETECTION ***********/
			-- FIXME: Change this to use SurfaceProps if we can load our own version
			local iEnterMaterial = tr.MatType
			
			-- https://github.com/Facepunch/garrysmod-requests/issues/787
			// since some railings in de_inferno are CONTENTS_GRATE but CHAR_TEX_CONCRETE, we'll trust the
			// CONTENTS_GRATE and use a high damage modifier.
			// If we're a concrete grate (TOOLS/TOOLSINVISIBLE texture) allow more penetrating power.
			local bHitGrate = iEnterMaterial == MAT_GRATE or bit.band( util.PointContents( vHitPos ), CONTENTS_GRATE ) ~= 0
			
			// calculate the damage based on the distance the bullet travelled.
			flCurrentDistance = flCurrentDistance + tr.Fraction * flDistance
			flCurrentDamage = flCurrentDamage * flRangeModifier ^ (flCurrentDistance / 500)
			
			// check if we reach penetration distance, no more penetrations after that
			if ( flCurrentDistance > flPenetrationDistance and iPenetration > 0 ) then
				iPenetration = 0
			end
			
			local iActualDamageType = flCurrentDamage < iGibDamage and iAmmoDamageType
			or bit.bor( iAmmoDamageType, DMG_ALWAYSGIB )
			
			if ( not bHitWater or bit.band( iFlags, FIRE_BULLETS_DONT_HIT_UNDERWATER ) == 0 ) then
				// add damage to entity that we hit
				local info = DamageInfo()
					info:SetAttacker( pAttacker )
					info:SetInflictor( pInflictor )
					info:SetDamage( flCurrentDamage )
					info:SetDamageType( iActualDamageType )
					info:SetDamagePosition( vHitPos )
					info:SetDamageForce( vShotDir * flAmmoForce * flForce * flPhysPush )
					info:SetAmmoType( iAmmoType )
					info:SetReportedPosition( vSrc )
				pEntity:DispatchTraceAttack( info, tr, vShotDir )
				
				tr.StartPos = vSrc
				
				if ( fCallback ) then
					fCallback( pAttacker, tr, info )
				end
				
				if ( bFirstTimePredicted ) then
					if ( not bHitWater or bStartedInWater or bit.band( iFlags, FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS ) ~= 0 ) then
						if ( bWeaponInvalid or not pWeapon:DoImpactEffect( tr, iActualDamageType )) then
							local data = EffectData()
								data:SetOrigin( tr.HitPos )
								data:SetStart( tr.StartPos )
								data:SetSurfaceProp( tr.SurfaceProps )
								data:SetDamageType( iActualDamageType )
								data:SetHitBox( tr.HitBox )
								data:SetEntity( pEntity )
							util.Effect( "Impact", data )
						end	
					else
						// We may not impact, but we DO need to affect ragdolls on the client
						local data = EffectData()
							data:SetOrigin( tr.HitPos )
							data:SetStart( tr.StartPos )
							data:SetDamageType( iActualDamageType )
						util.Effect( "RagdollImpact", data )
					end
				end
			end
			
			if ( SERVER and bit.band( iAmmoFlags, AMMO_FORCE_DROP_IF_CARRIED ) ~= 0 ) then
				// Make sure if the player is holding this, he drops it
				DropEntityIfHeld( pEntity )
			end
			
			// check if bullet can penetrate another entity
			// If we hit a grate with iPenetration == 0, stop on the next thing we hit
			if ( iPenetration == 0 and not bHitGrate or iPenetration < 0 or pEntity:GetClass():find( "func_breakable", 1, true ) and pEntity:HasSpawnFlags( SF_BREAK_NO_BULLET_PENETRATION )) then
				break // no, stop
			end
			
			if ( pEntity:IsWorld() ) then
				local flExitDistance = 0
				local vPenetrationEnd
				
				// try to penetrate object, maximum penetration is 128 inch
				while ( flExitDistance <= flExitMaxDistance ) do
					flExitDistance = flExitDistance + flExitStepSize
				
					local vHit = vHitPos + flExitDistance * vShotDir
				
					if ( bit.band( util.PointContents( vHit ), MASK_SOLID ) == 0 ) then
						// found first free point
						vPenetrationEnd = vHit
					end
				end
			
				-- Nowhere to penetrate
				if ( not vPenetrationEnd ) then
					break
				end
				
				util.TraceLine({
					start = vPenetrationEnd,
					endpos = vHitPos,
					mask = CONTENTS_SOLID,
					filter = ents.GetAll(),
					output = tr
				})
				
				if ( bShowPenetration ) then
					debugoverlay.Line( vPenetrationEnd, vHitPos, DEBUG_LENGTH, color_red )
				end
			else
				local tEnts = ents.GetAll()
				local iLen = #tEnts
				
				-- Trace for only the entity we hit
				for i = iLen, 1, -1 do
					if ( tEnts[i] == pEntity ) then
						tEnts[i] = tEnts[iLen]
						tEnts[iLen] = nil
						
						break
					end
				end
				
				util.TraceLine({
					start = vEnd,
					endpos = vHitPos,
					mask = iMask,
					filter = tEnts,
					ignoreworld = true,
					output = tr
				})
				
				if ( bShowPenetration ) then
					debugoverlay.Line( vEnd, vHitPos, DEBUG_LENGTH, color_altdebug )
				end
			end
			
			local iExitMaterial = tr.MatType
			local tMatParams = tMaterialParameters[iEnterMaterial]
			local flPenetrationModifier = bHitGrate and 1 or tMatParams and tMatParams.Penetration or 1
			local flDamageModifier = bHitGrate and 0.99 or tMatParams and tMatParams.Damage or 0.5
			local flTraceDistance = (tr.HitPos - vHitPos):LengthSqr()
			
			// get material at exit point
			-- https://github.com/Facepunch/garrysmod-requests/issues/787
			if ( bHitGrate ) then
				bHitGrate = iExitMaterial == MAT_GRATE or bit.band( util.PointContents( tr.HitPos ), CONTENTS_GRATE ) ~= 0
			end
			
			// if enter & exit point is wood or metal we assume this is 
			// a hollow crate or barrel and give a penetration bonus
			if ( bHitGrate and (iExitMaterial == MAT_GRATE or bit.band( util.PointContents( tr.HitPos ), CONTENTS_GRATE ) ~= 0) or iEnterMaterial == iExitMaterial and tDoublePenetration[iExitMaterial] ) then
				flPenetrationModifier = flPenetrationModifier * 2	
			end

			// check if bullet has enough power to penetrate this distance for this material
			if ( flTraceDistance > (flPenetrationPower * flPenetrationModifier)^2 ) then
				break // bullet hasn't enough power to penetrate this distance
			end
			
			if ( iHitNum == 1 or ( CLIENT and iHitNum == 2 ) or ( SERVER and iHitNum == 3 )) then
				debugoverlay.Box( tr.HitPos, vector_debug_min, vector_debug_max, DEBUG_LENGTH, color_altdebug )
			end
			
			// bullet did penetrate object, exit Decal
			if ( bFirstTimePredicted and (bWeaponInvalid or not pWeapon:DoImpactEffect( tr, iActualDamageType ))) then
				local data = EffectData()
					data:SetOrigin( tr.HitPos )
					data:SetStart( tr.StartPos )
					data:SetSurfaceProp( tr.SurfaceProps )
					data:SetDamageType( iActualDamageType )
					data:SetHitBox( tr.HitBox )
					data:SetEntity( pEntity )
				util.Effect( "Impact", data )
			end	
			
			// penetration was successful
			flTraceDistance = math.sqrt( flTraceDistance )
			
			// setup new start end parameters for successive trace
			flPenetrationPower = flPenetrationPower - flTraceDistance / flPenetrationModifier
			flCurrentDistance = flCurrentDistance + flTraceDistance
			
			// reduce damage power each time we hit something other than a grate
			flCurrentDamage = flCurrentDamage * flDamageModifier
			flDistance = (flDistance - flCurrentDistance) * 0.5
			
			vNewSrc = tr.HitPos
			vEnd = vNewSrc + vShotDir * flDistance
			
			// reduce penetration counter
			iPenetration = iPenetration - 1
			
			-- Can't hit players more than once
			if ( pEntity:IsPlayer() or pEntity:IsNPC() ) then
				iNewFilterEnd = iNewFilterEnd + 1
				tFilter[iNewFilterEnd] = pEntity
			end
		until ( flCurrentDamage < FLT_EPSILON ) -- Account for float handling; very rare case
		
		for i = iFilterEnd, iNewFilterEnd do
			tFilter[i] = nil -- Restore the table
		end
		
		if ( bDebugShoot ) then
			debugoverlay.Line( vSrc, vFinalHit, DEBUG_LENGTH, color_debug )
		end
		
		if ( bFirstTimePredicted and iTracerFreq > 0 ) then
			if ( iTracerCount % iTracerFreq == 0 ) then
				local data = EffectData()
					data:SetStart( self:ComputeTracerStartPosition( vSrc ))
					data:SetOrigin( vFinalHit )
					data:SetScale(0)
					data:SetEntity( bWeaponInvalid and self or pWeapon )
					data:SetAttachment( bWeaponInvalid and 1 or pWeapon.GetMuzzleAttachment and pWeapon:GetMuzzleAttachment() or 1 )
					
					local iFlags = TRACER_FLAG_USEATTACHMENT
					
					if ( iAmmoTracerType == TRACER_LINE_AND_WHIZ ) then
						iFlags = bit.bor( iFlags, TRACER_FLAG_WHIZ )
					end
					
					data:SetFlags( iFlags )
				util.Effect( sTracerName, data )
			end
			
			iTracerCount = iTracerCount + 1
		end
	end
	
	self:LagCompensation( false )
end

// GOOSEMAN : Kick the view..
function PLAYER:KickBack( tKickTable )
	if ( not IsFirstTimePredicted() ) then
		return 
	end
	
	local flKickUp = tKickTable.UpBase
	local flKickLateral = tKickTable.LateralBase
	local iShotsFired = self:GetShotsFired()
	
	-- Not the first round fired
	if ( iShotsFired > 1 ) then
		flKickUp = flKickUp + iShotsFired * tKickTable.UpModifier
		flKickLateral = flKickLateral + iShotsFired * tKickTable.LateralModifier
	end
	
	local ang = self:GetPunchAngle()
	
	ang.p = ang.p - flKickUp
	
	if ( ang.p < -1 * tKickTable.UpMax ) then
		ang.p = -1 * tKickTable.UpMax
	end
	
	if ( self.m_bDirection ) then
		ang.y = ang.y + flKickLateral
		
		if ( ang.y > tKickTable.LateralMax ) then
			ang.y = tKickTable.LateralMax
		end
	else
		ang.y = ang.y - flKickLateral
		
		if ( ang.y < -1 * tKickTable.LateralMax ) then
			ang.y = -1 * tKickTable.LateralMax
		end
	end
	
	if ( self:SharedRandomInt( "KickBack", 0, tKickTable.DirectionChange ) == 0 ) then
		self.m_bDirection = not self.m_bDirection
	end
	
	self:SetViewPunchAngles( ang )
end

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

game.AddAmmoType({
	name = "Hopwire",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 3,
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

-- More Half-Life 1 ammo types
-- FIXME: Look at the cfg files for actual carries
game.AddAmmoType({
	name = "357Round",
	dmgtype = bit.bor(DMG_BULLET, DMG_NEVERGIB),
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = BulletImpulse(650, 6000, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Buckshot_HL",
	dmgtype = bit.bor(DMG_BULLET, DMG_BUCKSHOT),
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = BulletImpulse(200, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "XBowBolt_HL",
	dmgtype = bit.bor(DMG_BULLET, DMG_BUCKSHOT),
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = BulletImpulse(200, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "RPG_Rocket",
	dmgtype = bit.bor(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Uranium",
	dmgtype = DMG_ENERGYBEAM,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Grenade_HL",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Snark",
	dmgtype = DMG_SLASH,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "TripMine",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Satchel",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "12mmRound",
	dmgtype = bit.band(DMG_BULLET, DMG_NEVERGIB),
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
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
	name = "Bullets",
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

-- Counter-Strike: Source ammo types
game.AddAmmoType({
	name = "50AE",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 35,
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 30,
	penetrationdistance = 1000
})

game.AddAmmoType({
	name = "762mmRound",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 90,
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 39,
	penetrationdistance = 5000
})

game.AddAmmoType({
	name = "556mmRound",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 90,
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 35,
	penetrationdistance = 4000
})

game.AddAmmoType({
	name = "556mmRound_Box",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 200,
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 35,
	penetrationdistance = 4000
})

game.AddAmmoType({
	name = "338",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 30,
	force = 2800 * 1,
	flags = 0,
	minsplash = 12,
	maxsplash = 16,
	penetrationpower = 45,
	penetrationdistance = 8000
})

game.AddAmmoType({
	name = "9mmRound_CSS",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 120,
	force = 2000 * 1,
	flags = 0,
	minsplash = 5,
	maxsplash = 10,
	penetrationpower = 21,
	penetrationdistance = 800
})

game.AddAmmoType({
	name = "Buckshot_CSS",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 32,
	force = 600 * 1,
	flags = 0,
	minsplash = 3,
	maxsplash = 6,
	penetrationpower = 0,
	penetrationdistance = 0
})

game.AddAmmoType({
	name = "45ACP",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 100,
	force = 2100 * 1,
	flags = 0,
	minsplash = 6,
	maxsplash = 10,
	penetrationpower = 15,
	penetrationdistance = 500
})

game.AddAmmoType({
	name = "357SIG",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 52,
	force = 2000 * 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8,
	penetrationpower = 25,
	penetrationdistance = 800
})

game.AddAmmoType({
	name = "57mmRound",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 100,
	force = 2000 * 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8,
	penetrationpower = 30,
	penetrationdistance = 2000
})

game.AddAmmoType({
	name = "HEGrenade",
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
	name = "Flashbang",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "SmokeGrenade",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
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
	name = "30Cal",
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
