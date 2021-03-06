SWEP.Base = "stick_base"

SWEP.Spawnable = true
SWEP.Slot = 1
SWEP.SlotPos = 3

SWEP.StickColor = color_green or Color(0, 255, 0)

if (SERVER) then
	local color_cyan = color_cyan or Color(0, 255, 255)
	local sLog = "%s (%s) unarrested %s"
	local hookCanUnarrest = {canUnarrest = fp{fn.Id, true}}
	
	function SWEP:SmackDamage(tr)
		local pPlayer = self:GetOwner()
		local pEntity = tr.Entity
		
		if (pEntity.onUnArrestStickUsed) then
			pEntity:onUnArrestStickUsed(pPlayer)
		elseif (pEntity:IsPlayer()) then
			local bCanUnarrest, sMessage = hook.Call("canUnarrest", hookCanUnarrest, pPlayer, pEntity)
			
			if (bCanArrest) then
				pEntity:unArrest(pPlayer)
				
				local sName = pPlayer:Nick()
				DarkRP.notify(pEntity, 0, 4, DarkRP.getPhrase("youre_unarrested_by", sName))
				
				if (pPlayer.SteamName) then
					DarkRP.log(string.format(sLog, sName, pPlayer:SteamID(), pEntity:Nick()), color_cyan)
				end
			elseif (sMessage) then
				DarkRP.notify(pPlayer, 1, 5, sMessage)
			end
		end
	end
end

function SWEP:SecondaryAttack()
	local pPlayer = self:GetOwner()
	local sClass = code_gs.weapons.ActualClassName("arrest_stick", "darkrp")
	
	if (pPlayer:HasWeapon(sClass)) then
		pPlayer.m_pNewWeapon = pPlayer:GetWeapon(sClass)
	end
end
