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

require "engine.krtrUtils"

local Talents = require("engine.interface.ActorTalents")
local Stats = require("engine.interface.ActorStats")
local DamageType = require "engine.DamageType"

-------------------------------------------------------
-- Techniques------------------------------------------
-------------------------------------------------------
newEntity{
	power_source = {technique=true},
	name = "barbed ", prefix=true, instant_resolve=true,
	kr_name = "가시박힌 ",
	keywords = {barbed=true},
	level_range = {1, 50},
	rarity = 3,
	cost = 4,
	combat = {
		ranged_project={
			[DamageType.BLEED] = resolvers.mbonus_material(15, 5)
		},
		special_on_crit = {desc="대상에게 상처를 입힘", fct=function(combat, who, target)
			local dam = 5 + (who:combatPhysicalpower()/5)
			if target:canBe("cut") then
				target:setEffect(target.EFF_DEEP_WOUND, 7, {src=who, heal_factor=dam * 2, power=dam, apply_power=who:combatAttack()})
			end
		end},
	},
}

newEntity{
	power_source = {technique=true},
	name = "deadly ", prefix=true, instant_resolve=true,
	kr_name = "치명적인 ",
	keywords = {deadly=true},
	level_range = {1, 50},
	rarity = 3,
	cost = 4,
	combat = {
		dam = resolvers.mbonus_material(10, 5),
	},
}

newEntity{
	power_source = {technique=true},
	name = "high-capacity ", prefix=true, instant_resolve=true,
	kr_name = "대용량 ",
	keywords = {capacity=true},
	level_range = {1, 50},
	rarity = 7,
	cost = 6,
	combat = {
		capacity = resolvers.generic(function(e) return math.ceil(e.combat.capacity * rng.float(1.3, 1.6)) end),
	},
	wielder = {
		ammo_reload_speed = resolvers.mbonus_material(4, 1),
	},
}

newEntity{
	power_source = {technique=true},
	name = " of accuracy", suffix=true, instant_resolve=true,
	kr_name = "정밀공격의 ",
	keywords = {accuracy=true},
	level_range = {1, 50},
	rarity = 3,
	cost = 4,
	cost = 6,
	combat = {
		atk = resolvers.mbonus_material(20, 5),
	},
}

newEntity{
	power_source = {technique=true},
	name = " of crippling", suffix=true, instant_resolve=true,
	kr_name = "무력화의 ",
	keywords = {crippling=true},
	level_range = {1, 50},
	rarity = 15,
	greater_ego = 1,
	cost = 4,
	combat = {
		physcrit = resolvers.mbonus_material(10, 5),
		special_on_crit = {desc="대상을 무력화", fct=function(combat, who, target)
			target:setEffect(target.EFF_CRIPPLE, 4, {src=who, apply_power=who:combatAttack(combat)})
		end},
	},
}

newEntity{
	power_source = {technique=true},
	name = " of annihilation", suffix=true, instant_resolve=true,
	kr_name = "섬멸의 ",
	keywords = {annihilation=true},
	level_range = {30, 50},
	greater_ego = 1,
	cost = 6,
	rarity = 15,
	combat = {
		dam = resolvers.mbonus_material(10, 2),
		physcrit = resolvers.mbonus_material(10, 2),
		apr  = resolvers.mbonus_material(10, 2),
		travel_speed = 2,
	},
}

-------------------------------------------------------
-- Arcane Egos-----------------------------------------
-------------------------------------------------------
newEntity{
	power_source = {arcane=true},
	name = "acidic ", prefix=true, instant_resolve=true,
	kr_name = "산성 ",
	keywords = {acidic=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 10,
	combat = {
		ranged_project={
			[DamageType.ACID] = resolvers.mbonus_material(15, 5)
		},
		special_on_crit = {desc="대상에게 산성액을 튀김", fct=function(combat, who, target)
			local power = 5 + (who:combatSpellpower()/10)
			local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
			target:setEffect(target.EFF_ACID_SPLASH, 5, {apply_power = check, src=who, dam=power, atk=power, armor=power})
		end},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "arcing ", prefix=true, instant_resolve=true,
	kr_name = "전격 ",
	keywords = {arcing=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 10,
	combat = {
		ranged_project={
			[DamageType.LIGHTNING] = resolvers.mbonus_material(15, 5),
		},
		special_on_hit = {desc="25% 확률로 전기가 두 번째 목표를 감전시킴", on_kill=1, fct=function(combat, who, target)
			if not rng.percent(25) then return end
			local tgts = {}
			local x, y = target.x, target.y
			local grids = core.fov.circle_grids(x, y, 5, true)
			for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
				local a = game.level.map(x, y, engine.Map.ACTOR)
				if a and a ~= target and who:reactionToward(a) < 0 then
					tgts[#tgts+1] = a
				end
			end end

			-- Randomly take targets
			local tg = {type="beam", range=10, friendlyfire=false, x=target.x, y=target.y}
			if #tgts <= 0 then return end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)
			local dam = 30 + (who:combatSpellpower())*2
			
			who:project(tg, a.x, a.y, engine.DamageType.LIGHTNING, rng.avg(1, dam, 3))
			game.level.map:particleEmitter(x, y, math.max(math.abs(a.x-x), math.abs(a.y-y)), "lightning", {tx=a.x-x, ty=a.y-y})
			game:playSoundNear(who, "talents/lightning")
		end},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "flaming ", prefix=true, instant_resolve=true,
	kr_name = "불꽃 ",
	keywords = {flaming=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 10,
	combat = {
		burst_on_hit={
			[DamageType.FIRE] = resolvers.mbonus_material(15, 10)
		},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "icy ", prefix=true, instant_resolve=true,
	kr_name = "냉기 ",
	keywords = {icy=true},
	level_range = {15, 50},
	rarity = 5,
	cost = 10,
	combat = {
		ranged_project={
			[DamageType.COLD] = resolvers.mbonus_material(15, 5)
		},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "self-loading ", prefix=true, instant_resolve=true,
	kr_name = "자동장전 ",
	keywords = {self=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 6,
	combat = {
		ammo_regen = resolvers.mbonus_material(3, 1),
	},
	resolvers.genericlast(function(e)
		e.combat.ammo_every = 6 - e.combat.ammo_regen
	end),
}

newEntity{
	power_source = {arcane=true},
	name = " of daylight", suffix=true, instant_resolve=true,
	kr_name = "햇빛의 ",
	keywords = {daylight=true},
	level_range = {1, 50},
	rarity = 10,
	cost = 20,
	combat = {
		ranged_project={[DamageType.LIGHT] = resolvers.mbonus_material(15, 5)},
		inc_damage_type = {undead=resolvers.mbonus_material(25, 5)},
	},
}

newEntity{
	power_source = {arcane=true},
	name = " of vileness", suffix=true, instant_resolve=true,
	kr_name = "혐오의 ",
	keywords = {vile=true},
	level_range = {1, 50},
	rarity = 15,
	cost = 30,
	combat={
		ranged_project = {
			[DamageType.BLIGHT] = resolvers.mbonus_material(15, 5),
			[DamageType.ITEM_BLIGHT_DISEASE] = resolvers.mbonus_material(15, 5),
		},

	},
}

newEntity{
	power_source = {arcane=true},
	name = " of paradox", suffix=true, instant_resolve=true,
	kr_name = "괴리의 ",
	keywords = {paradox=true},
	level_range = {1, 50},
	rarity = 15,
	cost = 30,
	combat = {
		ranged_project = {
			[DamageType.TEMPORAL] = resolvers.mbonus_material(15, 5),
			[DamageType.ITEM_TEMPORAL_ENERGIZE] = resolvers.mbonus_material(10, 5),
		},
	},
}

-- Greater Egos

-- Mostly flat damage because combatSpellpower is so frontloaded
newEntity{
	power_source = {arcane=true},
	name = "elemental ", prefix=true, instant_resolve=true,
	kr_name = "다속성 ",
	keywords = {elemental=true},
	level_range = {35, 50},
	greater_ego = 1,
	rarity = 25,
	cost = 35,
	combat = {
		-- Define this here so it stays in scope
		elements = {
			{engine.DamageType.FIRE, "flame"},
			{engine.DamageType.COLD, "freeze"},
			{engine.DamageType.LIGHTNING, "lightning_explosion"},
			{engine.DamageType.ACID, "acid"},
		},	
		special_on_hit = {desc="임의의 원소 속성 폭발", fct=function(combat, who, target)
			if who.turn_procs.elemental_explosion then return end
			who.turn_procs.elemental_explosion = 1

			local elem = rng.table(combat.elements)
			local dam = 20 + (who:combatSpellpower() ) -- Higher because Weapon's has a wielder table					
			local tg = {type="ball", radius=3, range=10, selffire = false, friendlyfire=false}
			who:project(tg, target.x, target.y, elem[1], rng.avg(dam / 2, dam, 3), {type=elem[2]})		
		end},
	},
}

newEntity{
	power_source = {arcane=true},
	name = "plaguebringer's ", prefix=true, instant_resolve=true,
	kr_name = "질병유발자 ",
	keywords = {plague=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 60,
	combat = {
		ranged_project = {
			[DamageType.BLIGHT] = resolvers.mbonus_material(15, 5),
			[DamageType.ITEM_BLIGHT_DISEASE] = resolvers.mbonus_material(15, 5),
		},
		-- Well, Brawler Gloves do this calc for on hit Talents, and the new disease egos don't do damage, so.. What could possibly go wrong?
		-- SCIENCE
		talent_on_hit = { [Talents.T_EPIDEMIC] = {level=resolvers.genericlast(function(e) return e.material_level end), chance=10} },
	},
}

-- Update Me
newEntity{
	power_source = {arcane=true},
	name = "sentry's ", prefix=true, instant_resolve=true,
	kr_name = "파수꾼 ",
	keywords = {sentry=true},
	level_range = {30, 50},
	rarity = 25,
	greater_ego = 1,
	cost = 6,
	combat = {
		dam = resolvers.mbonus_material(10, 2),
		apr  = resolvers.mbonus_material(10, 2),
		ammo_regen = resolvers.mbonus_material(3, 1),
		capacity = resolvers.generic(function(e) return math.ceil(e.combat.capacity * rng.float(1.2, 1.5)) end),
	},
	resolvers.genericlast(function(e)
		e.combat.ammo_every = 6 - e.combat.ammo_regen
	end),
}

newEntity{
	power_source = {arcane=true},
	name = " of corruption", suffix=true, instant_resolve=true,
	kr_name = "타락의 ",
	keywords = {corruption=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 35,
	cost = 40,
	combat = {
		ranged_project={
			[DamageType.BLIGHT] = resolvers.mbonus_material(15, 5),
			[DamageType.DARKNESS] = resolvers.mbonus_material(15, 5),
		},
		special_on_hit = {desc="20% 확률로 대상을 저주", fct=function(combat, who, target)
			if not rng.percent(20) then return end
			local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
			local eff = rng.table{"vuln", "defenseless", "impotence", "death", }
			if not who:checkHit(check, target:combatSpellResist()) then return end
			if eff == "vuln" then target:setEffect(target.EFF_CURSE_VULNERABILITY, 2, {power=20})
			elseif eff == "defenseless" then target:setEffect(target.EFF_CURSE_DEFENSELESSNESS, 2, {power=20})
			elseif eff == "impotence" then target:setEffect(target.EFF_CURSE_IMPOTENCE, 2, {power=20})
			elseif eff == "death" then target:setEffect(target.EFF_CURSE_DEATH, 2, {src=who, dam=20})
			end
		end},
	},
}

newEntity{
	power_source = {magic=true},
	name = " of warping", suffix=true, instant_resolve=true,
	kr_name = "왜곡의 ",
	keywords = {warp=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 30,
	combat = {
		ranged_project={
			[DamageType.TEMPORAL] = resolvers.mbonus_material(15, 5),
			[DamageType.PHYSICAL] = resolvers.mbonus_material(15, 5),
		},
		special_on_hit = {desc="10% 확률로 대상을 기절, 실명, 속박, 혼란", fct=function(combat, who, target)
			if not rng.percent(10) then return end
			local eff = rng.table{"stun", "blind", "pin", "confusion"}
			if not target:canBe(eff) then return end
			local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
			if not who:checkHit(check, target:combatMentalResist()) then return end
			if eff == "stun" then target:setEffect(target.EFF_STUNNED, 4, {})
			elseif eff == "blind" then target:setEffect(target.EFF_BLINDED, 4, {})
			elseif eff == "pin" then target:setEffect(target.EFF_PINNED, 4, {})
			elseif eff == "confusion" then target:setEffect(target.EFF_CONFUSED, 4, {power=50})
			end
		end},
	},
}

-------------------------------------------------------
-- Nature/Antimagic Egos:------------------------------
-------------------------------------------------------
newEntity{
	power_source = {nature=true},
	name = "blazing ", prefix=true, instant_resolve=true,
	kr_name = "타오르는 ",
	keywords = {fiery=true},
	level_range = {1, 50},
	rarity = 10,
	cost = 20,
	combat = {
		ranged_project = {
			[DamageType.FIRE] = resolvers.mbonus_material(25, 8),
		},
		burst_on_crit = { [DamageType.FIRE] = resolvers.mbonus_material(10, 5),}
	},
}

newEntity{
	power_source = {nature=true},
	name = "insidious ", prefix=true, instant_resolve=true,
	kr_name = "잠식형 ",
	keywords = {insid=true},
	level_range = {10, 50},
	rarity = 5,
	cost = 15,
	combat = {
		ranged_project={
			[DamageType.INSIDIOUS_POISON] = resolvers.mbonus_material(50, 10), -- this gets divided by 7 for damage
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = "storming ", prefix=true, instant_resolve=true,
	kr_name = "폭풍 ",
	keywords = {storm=true},
	level_range = {1, 50},
	rarity = 10,
	cost = 20,
	combat = {
		ranged_project = {
			[DamageType.LIGHTNING] = resolvers.mbonus_material(25, 8),
		},
		burst_on_crit = { [DamageType.LIGHTNING] = resolvers.mbonus_material(10, 5),}
	},
}

newEntity{
	power_source = {nature=true},
	name = "tundral ", prefix=true, instant_resolve=true,
	kr_name = "툰드라 ",
	keywords = {tundral=true},
	level_range = {1, 50},
	rarity = 10,
	cost = 20,
	combat = {
		ranged_project = {
			[DamageType.COLD] = resolvers.mbonus_material(25, 8),
		},
		burst_on_crit = { [DamageType.COLD] = resolvers.mbonus_material(10, 5),}
	},
}

newEntity{
	power_source = {nature=true},
	name = " of erosion", suffix=true, instant_resolve=true,
	kr_name = "침식의 ",
	keywords = {erosion=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 15,
	combat = {
		ranged_project={
			[DamageType.NATURE] = resolvers.mbonus_material(15, 5),
			[DamageType.TEMPORAL] = resolvers.mbonus_material(15, 5),
		},
	},
}

newEntity{
	power_source = {nature=true},
	name = " of wind", suffix=true, instant_resolve=true,
	kr_name = "바람의 ",
	keywords = {wind=true},
	level_range = {1, 50},
	rarity = 7,
	cost = 6,
	combat = {
		travel_speed = 2,
		special_on_hit = {desc="10% 확률로 몰아치는 바람 발생", on_kill=1, fct=function(combat, who, target)
			if not rng.percent(10) then return end
			local dam = 20 + who:combatPhysicalpower()/2
			local distance = 2 + math.floor(who:combatPhysicalpower()/40)
			who:project({type="ball", radius=2, friendlyfire=false}, target.x, target.y, engine.DamageType.PHYSKNOCKBACK, {dist=distance, dam=dam})
		end},
	},
}

-- Greater
newEntity{
	power_source = {nature=true},
	name = " of gravity", suffix=true, instant_resolve=true,
	kr_name = "중력의 ",
	keywords = {gravity=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 30,
	combat = {
		ranged_project={
			[DamageType.GRAVITY] = resolvers.mbonus_material(15, 5),
		},
		special_on_hit = {desc="10% 확률로 대상을 짓눌러 속박", fct=function(combat, who, target)
			if not rng.percent(10) then return end
			if target:attr("never_move") then
				local tg = {type="hit", range=1}
				who:project(tg, target.x, target.y, engine.DamageType.IMPLOSION, 10 + who:combatMindpower()/4)
			elseif target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, 3, {src=who, apply_power=who:combatAttack(combat)})
			else
				game.logSeen(target, "%s 속박되지 않았습니다!", (target.kr_name or target.name):capitalize():addJosa("가"))
			end
		end},
	},
}

-- Antimagic
newEntity{
	power_source = {antimagic=true},
	name = "manaburning ", prefix=true, instant_resolve=true,
	kr_name = "마나를 태우는 ",
	keywords = {manaburning=true},
	level_range = {1, 50},
	rarity = 20,
	cost = 40,
	combat = {
		ranged_project = {
			[DamageType.ITEM_ANTIMAGIC_MANABURN] = resolvers.mbonus_material(15, 10),
		},
	},
}

newEntity{
	power_source = {antimagic=true},
	name = "slimey ", prefix=true, instant_resolve=true,
	kr_name = "끈적이는 ",
	keywords = {slime=true},
	level_range = {1, 50},
	rarity = 20,
	cost = 15,
	combat = {
		ranged_project={[DamageType.ITEM_NATURE_SLOW] = resolvers.mbonus_material(15, 5)},
	},
}

newEntity{
	power_source = {antimagic=true},
	name = " of purging", suffix=true, instant_resolve=true,
	kr_name = "정화의 ",
	keywords = {purging=true},
	level_range = {1, 50},
	rarity = 20,
	cost = 20,
	combat = {
		ranged_project={[DamageType.NATURE] = resolvers.mbonus_material(15, 5)},
		special_on_hit = {desc="25% 확률로 마법적 효과를 하나 제거", fct=function(combat, who, target)
			if not rng.percent(25) then return end
			local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
			if not who:checkHit(check, target:combatMentalResist()) then game.logSeen(target, "%s 저항했습니다!", (target.kr_name or target.name):capitalize():addJosa("가")) return nil end

			local effs = {}
			
			-- Go through all spell effects
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "magical" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			-- Go through all sustained spells
			for tid, act in pairs(target.sustain_talents) do
				if act then
					local talent = target:getTalentFromId(tid)
					if talent.is_spell then effs[#effs+1] = {"talent", tid} end
				end
			end
			
			local eff = rng.tableRemove(effs)
			if eff then
				if eff[1] == "effect" then
					target:removeEffect(eff[2])
				else
					target:forceUseTalent(eff[2], {ignore_energy=true})
				end
				game.logSeen(target, "%s의 마법이 #ORCHID#정화#LAST#됩니다!", (target.kr_name or target.name):capitalize())
			end
		end},
	},
}

-- Greater
newEntity{
	power_source = {antimagic=true},
	name = "inquisitor's ", prefix=true, instant_resolve=true,
	kr_name = "종교재판 ",
	keywords = {inquisitors=true},
	level_range = {30, 50},
	rarity = 45,
	greater_ego = 1,
	cost = 40,
	combat = {
		ranged_project = {
			[DamageType.MANABURN] = resolvers.mbonus_material(15, 10),
		},
		special_on_crit = {desc="주문 에너지를 태워, 재사용 대기시간을 발생시킴", fct=function(combat, who, target)
			local turns = 1 + math.ceil(who:combatMindpower() / 20)
			local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
			if not who:checkHit(check, target:combatMentalResist()) then game.logSeen(target, "%s 저항했습니다!", (target.kr_name or target.name):capitalize():addJosa("가")) return nil end
			
			-- Pick a spell
			local tids = {}
			for tid, lev in pairs(target.talents) do
				local t = target:getTalentFromId(tid)
				if t and not target.talents_cd[tid] and t.mode == "activated" and t.is_spell and not t.innate then tids[#tids+1] = t end
			end
			
			local t = rng.tableRemove(tids)
			if not t then return nil end
			local damage = t.mana or t.vim or t.positive or t.negative or t.paradox or 0
			target.talents_cd[t.id] = turns
			
			local tg = {type="hit", range=1}
			who:project(tg, target.x, target.y, engine.DamageType.ARCANE, tonumber(util.getval(damage, who, t)) or 0)
			
			game.logSeen(target, "%s의 %s #ORCHID#불타#LAST#오릅니다!", (target.kr_name or target.name):capitalize(), (t.kr_name or t.name):addJosa("가"))
		end},
	},
}

newEntity{
	power_source = {antimagic=true},
	name = "slimey-burst ", prefix=true, instant_resolve=true,
	kr_name = "폭발형 슬라임 ",
	keywords = {slimeburst=true},
	level_range = {30, 50},
	rarity = 40,
	cost = 15,
	combat = {
		burst_on_hit={[DamageType.SLIME] = resolvers.mbonus_material(15, 5)},
		burst_on_crit={[DamageType.SLIME] = resolvers.mbonus_material(25, 5)},
	},
}

newEntity{
	power_source = {antimagic=true},
	name = " of persecution", suffix=true, instant_resolve=true,
	kr_name = "박해의 ", 
	keywords = {disruption=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	combat = {
		inc_damage_type = {
			unnatural=resolvers.mbonus_material(25, 5),
		},
		special_on_hit = {desc="주문 사용을 방해", fct=function(combat, who, target)
			local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
			target:setEffect(target.EFF_SPELL_DISRUPTION, 10, {src=who, power = 10, max = 50, apply_power=check})
		end},
	},
}

newEntity{
	power_source = {antimagic=true},
	name = " of the leech", suffix=true, instant_resolve=true,
	kr_name = "강탈의 ",
	keywords = {leech=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 40,
	cost = 40,
	combat = {
		ranged_project={[DamageType.ITEM_NATURE_SLOW] = resolvers.mbonus_material(15, 5)},
		special_on_hit = {desc="대상의 체력 강탈", fct=function(combat, who, target)
			if target and target:getStamina() > 0 then
				local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
				local leech = check / 50
				local leeched = math.min(leech, target:getStamina())
				who:incStamina(leeched)
				target:incStamina(-leeched)
			end				
		end},
	},
}

-------------------------------------------------------
-- Psionic Egos: --------------------------------------
-------------------------------------------------------
newEntity{
	power_source = {psionic=true},
	name = "hateful ", prefix=true, instant_resolve=true,
	kr_name = "증오에 찬 ",
	keywords = {hateful=true},
	level_range = {1, 50},
	rarity = 30,
	cost = 20,
	greater_ego = 1,
	combat = {
		ranged_project={[DamageType.DARKNESS] = resolvers.mbonus_material(25, 5)},
		inc_damage_type = {living=resolvers.mbonus_material(15, 5)},
	},
}

newEntity{
	power_source = {psionic=true},
	name = "thought-forged ", prefix=true, instant_resolve=true,
	kr_name = "사색하는 ",
	keywords = {thought=true},
	level_range = {1, 50},
	rarity = 15,
	cost = 10,
	combat = {
		ranged_project={
			[DamageType.MIND] = resolvers.mbonus_material(20, 5),
			[DamageType.ITEM_MIND_GLOOM] = resolvers.mbonus_material(25, 10)
		},
	},
	resolvers.genericlast(function(e)
		e.combat.ammo_every = 6 - (e.combat.ammo_regen or 0)
	end),
}

newEntity{
	power_source = {psionic=true},
	name = "psychokinetic ", prefix=true, instant_resolve=true,
	kr_name = "염동적 ",
	keywords = {kinesis=true},
	level_range = {1, 50},
	rarity = 5,
	cost = 10,
	combat = {
		ranged_project={
			[DamageType.PHYSICAL] = resolvers.mbonus_material(35, 15),
		},
		special_on_hit = {desc="10% 확률로 대상을 밀어냄", fct=function(combat, who, target)
			if not rng.percent(10) then return nil end
			local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
			if not who:checkHit(check, target:combatPhysicalResist()) then game.logSeen(target, "%s 저항했습니다!", (target.kr_name or target.name):capitalize():addJosa("가")) return nil end
			if target:canBe("knockback") then
				target:knockback(who.x, who.y, 2)
				game.logSeen(target, "%s 밀려났습니다!", (target.kr_name or target.name):capitalize():addJosa("가"))
			end
		end},
	},
}

-- Very, very powerful.  Perhaps turn proc limit
newEntity{
	power_source = {psionic=true},
	name = " of amnesia", suffix=true, instant_resolve=true,
	kr_name = "망각의 ",
	keywords = {amnesia=true},
	level_range = {10, 50},
	rarity = 25, -- very rare because no one can remember how to make them...  haha
	cost = 15,
	greater_ego = 1,
	combat = {
		special_on_hit = {desc="25% 확률로 기술 하나의 사용을 지연시킴", fct=function(combat, who, target)
			if not rng.percent(25) then return nil end
			local turns = 1 + math.ceil(who:combatMindpower() / 20)
			local number = 2 + math.ceil(who:combatMindpower() / 50)
			local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
			if not who:checkHit(check, target:combatMentalResist()) then game.logSeen(target, "%s 저항했습니다!", (target.kr_name or target.name):capitalize():addJosa("가")) return nil end
			
			local tids = {}
			for tid, lev in pairs(target.talents) do
				local t = target:getTalentFromId(tid)
				if t and not target.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
			end
			
			for i = 1, number do
				local t = rng.tableRemove(tids)
				if not t then break end
				target.talents_cd[t.id] = turns
				game.logSeen(target, "%s 일시적으로 %s 잊어버립니다!", (target.kr_name or target.name):capitalize():addJosa("가"), (t.kr_name or t.name):addJosa("를"))
			end
		end},
	},
}

-- Greater
newEntity{
	power_source = {psionic=true},
	name = " of torment", suffix=true, instant_resolve=true,
	kr_name = "고문의 ",
	keywords = {torment=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 30,
	cost = 30,
	combat = {
		ranged_project={
			[DamageType.MIND] = resolvers.mbonus_material(15, 5),
			[DamageType.DARKNESS] = resolvers.mbonus_material(15, 5),
		},
		special_on_hit = {desc="20% 확률로 대상에게 부정적인 상태효과 부여", fct=function(combat, who, target)
			if not rng.percent(20) then return end
			local eff = rng.table{"stun", "blind", "pin", "confusion", "silence",}
			if not target:canBe(eff) then return end
			local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
			if not who:checkHit(check, target:combatMentalResist()) then return end
			if eff == "stun" then target:setEffect(target.EFF_STUNNED, 3, {})
			elseif eff == "blind" then target:setEffect(target.EFF_BLINDED, 3, {})
			elseif eff == "pin" then target:setEffect(target.EFF_PINNED, 3, {})
			elseif eff == "confusion" then target:setEffect(target.EFF_CONFUSED, 3, {power=60})
			elseif eff == "silence" then target:setEffect(target.EFF_SILENCED, 3, {})
			end
		end},
	},
}