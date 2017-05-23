if GetObjectName(GetMyHero()) ~= "Annie" then
	return end

require("OpenPredict")

local AnnieMenu = Menu("Annie", "Annie")
AnnieMenu:SubMenu("Combo", "Combo")	
AnnieMenu.Combo:Boolean("Q", "Use Q", true)
AnnieMenu.Combo:Boolean("W", "Use W", true)
AnnieMenu.Combo:Boolean("R", "Use R", true)
AnnieMenu.Combo:Boolean("KSQ", "Killsteal with Q", true)
AnnieMenu.Combo:Boolean("UOP", "Use OpenPredict for R", true)

local AnnieR = {delay = 0.075, range = 600, radius = 150, speed = math.huge}

OnTick(function ()
	
	local target = GetCurrentTarget
		
	if IOW:Mode() == "Combo" then		
		if AnnieMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 624) then	
			CastTargetSpell(target , _Q)
		end
	
		if AnnieMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 624) then
			local targetPos = GetOrigin(target)
			CastSkillShot(_W , targetPos)
		end
		
		if AnnieMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 599) then
			if not AnnieMenu.Combo.UOP:Value() then
				local RPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), math.huge, 75, 600, 150, false, true)
				if RPred.HitChance == 1 then
					CastSkillShot(_R,RPred.PredPos)
				end
			else
				local RPred = GetCircularAOEPrediction(target,AnnieR)
				if RPred.hitChance >= 0.3 then
					CastSkillShot(_R,RPred.castPos)
				end
			end
		end
	end
	for _, enemy in pairs(GetEnemyHeroes()) do
		if AnnieMenu.Combo.Q:Value() and AnnieMenu.Combo.KSQ:Value() and Ready(_Q) and ValidTarget(enemy, 625) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, 45 + 35 * GetCastLevel(myHero,_Q) + GetBonusAP(myHero) * 0.8) then
				CastTargetSpell(enemy , _Q)
			end
		end
	end
end

print("Annie loaded")
