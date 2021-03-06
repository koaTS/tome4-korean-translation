﻿-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

newTalent{
	name = "Bow Mastery",
	kr_name = "활 수련",
	type = {"technique/archery-bow", 1},
	points = 5,
	require = { stat = { dex=function(level) return 12 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return self:getTalentLevel(t) * 10 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 2 end,
	ammo_mastery_reload = function(self, t)
		return math.floor(self:combatTalentScale(t, 0, 2.7, "log"))
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, 'ammo_mastery_reload', t.ammo_mastery_reload(self, t))
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[활을 사용하면 물리력이 %d / 활의 피해량이 %d%% 증가합니다.
		또한, 한번에 %d 발의 화살을 추가로 재장전할 수 있게 됩니다.]]):format(damage, inc * 100, reloads) 
	end,
}

newTalent{
	name = "Piercing Arrow",
	kr_name = "관통 사격",
	type = {"technique/archery-bow", 2},
	no_energy = "fake",
	points = 5,
	cooldown = 8,
	stamina = 15,
	require = techs_dex_req2,
	range = archery_range,
	tactical = { ATTACK = { weapon = 2 } },
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon("bow") then if not silent then game.logPlayer(self, "이 기술을 사용하려면 활이 필요합니다.") end return false end return true end,
	action = function(self, t)
		if not self:hasArcheryWeapon("bow") then game.logPlayer(self, "활을 장착해야 합니다!") return nil end

		local targets = self:archeryAcquireTargets({type="beam"}, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, {type="beam"}, {mult=self:combatTalentWeaponDamage(t, 1, 1.5), apr=1000})
		return true
	end,
	info = function(self, t)
		return ([[어떤 것이든 꿰뚫는 화살을 쏴서, %d%% 의 무기 피해를 주고 적을 관통합니다.
		아주 특수한 경우가 아닌 한, 적의 방어도를 무시할 수 있습니다.]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.5))
	end,
}

newTalent{
	name = "Dual Arrows",
	kr_name = "이중 사격",
	type = {"technique/archery-bow", 3},
	no_energy = "fake",
	points = 5,
	cooldown = 8,
	require = techs_dex_req3,
	range = archery_range,
	radius = 1,
	tactical = { ATTACKAREA = { weapon = 1 } },
	requires_target = true,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t)}
	end,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon("bow") then if not silent then game.logPlayer(self, "이 기술을 사용하려면 활이 필요합니다.") end return false end return true end,
	action = function(self, t)
		if not self:hasArcheryWeapon("bow") then game.logPlayer(self, "활을 장착해야 합니다!") return nil end

		local tg = self:getTalentTarget(t)
		local targets = self:archeryAcquireTargets(tg, {limit_shots=2})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=self:combatTalentWeaponDamage(t, 1.2, 1.9)})
		return true
	end,
	info = function(self, t)
		return ([[화살을 동시에 두 발 쏴서 대상과, (가능하다면) 인접한 다른 대상에게 %d%% 의 무기 피해를 줍니다.
		이 기술은 체력을 전혀 소모하지 않습니다.]]):format(100 * self:combatTalentWeaponDamage(t, 1.2, 1.9))
	end,
}

newTalent{
	name = "Volley of Arrows",
	kr_name = "일제 사격",
	type = {"technique/archery-bow", 4},
	no_energy = "fake",
	points = 5,
	cooldown = 12,
	stamina = 35,
	require = techs_dex_req4,
	range = archery_range,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.3, 3.7)) end,
	direct_hit = true,
	tactical = { ATTACKAREA = { weapon = 2 } },
	requires_target = true,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), selffire=false}
	end,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon("bow") then if not silent then game.logPlayer(self, "이 기술을 사용하려면 활이 필요합니다.") end return false end return true end,
	action = function(self, t)
		if not self:hasArcheryWeapon("bow") then game.logPlayer(self, "활을 장착해야 합니다!") return nil end

		local tg = self:getTalentTarget(t)
		local targets = self:archeryAcquireTargets(tg)
		if not targets then return end
		self:archeryShoot(targets, t, {type="bolt", selffire=false}, {mult=self:combatTalentWeaponDamage(t, 0.6, 1.3)})
		return true
	end,
	info = function(self, t)
		return ([[주변 %d 칸 반경의 지역에 화살을 퍼부어, 각 화살마다 %d%% 의 무기 피해를 줍니다.]])
		:format(self:getTalentRadius(t), 100 * self:combatTalentWeaponDamage(t, 0.6, 1.3))
	end,
}
