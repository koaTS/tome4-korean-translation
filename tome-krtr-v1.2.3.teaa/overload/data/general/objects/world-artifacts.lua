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

local Stats = require "engine.interface.ActorStats"
local Talents = require "engine.interface.ActorTalents"

--- Load additional artifacts
for def, e in pairs(game.state:getWorldArtifacts()) do
	importEntity(e)
	print("Importing "..e.name.." into world artifacts")
end

-- This file describes artifacts not bound to a special location, they can be found anywhere

newEntity{ base = "BASE_GEM", 
	power_source = {arcane=true},
	unique = true,
	unided_name = "windy gem",
	name = "Windborne Azurite", subtype = "blue",
	color = colors.BLUE, image = "object/artifact/windborn_azurite.png",
	level_range = {18, 40},
	kr_name = "풍화된 남동광", kr_unided_name = "바람의 보석",
	desc = [[반짝이는 푸른 귀중품 주위로, 대기가 소용돌이치고 있습니다.]],
	rarity = 240,
	cost = 200,
	identified = false,
	material_level = 4,
	wielder = {
		inc_stats = {[Stats.STAT_DEX] = 8, [Stats.STAT_CUN] = 8 },
		inc_damage = {[DamageType.LIGHTNING] = 20 },
		cancel_damage_chance = 8, -- add to tooltip
		damage_affinity={
			[DamageType.LIGHTNING] = 20,
		},
		movement_speed = 0.2,
	},
	imbue_powers = {
		inc_stats = {[Stats.STAT_DEX] = 8, [Stats.STAT_CUN] = 8 },
		inc_damage = {[DamageType.LIGHTNING] = 20 },
		cancel_damage_chance = 8,
		damage_affinity={
			[DamageType.LIGHTNING] = 20,
		},
		movement_speed = 0.15,
	},
}

-- Low base values because you can stack affinity and resist
-- The 3rd type is pretty meaningless balance-wise.  Magic debuffs hardly matter.  The real advantage is the affinity.
newEntity{ base = "BASE_INFUSION",
	name = "Primal Infusion", unique=true, image = "object/artifact/primal_infusion.png",
	kr_name = "근원의 주입물", kr_unided_name = "맥동하는 주입물",
	desc = [[진화를 거친 야생 주입물입니다.]],
	unided_name = "pulsing infusion",
	level_range = {15, 40},
	rarity = 300,
	cost = 300,
	material_level = 3,

	inscription_kind = "protect",
	inscription_data = {
		cooldown = 18,
		dur = 6,
		power = 10,
		use_stat_mod = 0.1, 
		what = {physical=true, mental=true, magical=true},
	},
	inscription_talent = "INFUSION:_PRIMAL",
}

newEntity{ base = "BASE_STAFF",
	power_source = {arcane=true},
	unique = true,
	name = "Staff of Destruction",
	flavor_name = "magestaff",
	unided_name = "darkness infused staff", image = "object/artifact/staff_of_destruction.png",
	level_range = {20, 25},
	color=colors.VIOLET,
	rarity = 170,
	kr_name = "파괴의 지팡이", kr_unided_name = "어둠이 주입된 지팡이",
	desc = [[굉장히 특이하게 생긴 지팡이로, 파괴의 룬이 새겨져 있습니다.]],
	cost = 200,
	material_level = 3,

	require = { stat = { mag=24 }, },
	modes = {"fire", "cold", "lightning", "arcane"},
	combat = {
		dam = 20,
		apr = 4,
		dammod = {mag=1.5},
		damtype = DamageType.FIRE,
		is_greater = true,
	},
	wielder = {
		combat_spellpower = 10,
		combat_spellcrit = 15,
		inc_damage={
			[DamageType.FIRE] = 20,
			[DamageType.LIGHTNING] = 20,
			[DamageType.COLD] = 20,
			[DamageType.ARCANE] = 20,
		},
		learn_talent = {[Talents.T_COMMAND_STAFF] = 1},
	},
	talent_on_spell = { {chance=10, talent=Talents.T_IMPENDING_DOOM, level=1}},
}

newEntity{ base = "BASE_RING",
	power_source = {nature=true},
	unique = true,
	name = "Vargh Redemption", color = colors.LIGHT_BLUE, image="object/artifact/ring_vargh_redemption.png",
	unided_name = "sea-blue ring",
	kr_name = "바르그의 구원", kr_unided_name = "바닷빛 반지",
	desc = [[이 하늘빛 반지는 언제나 촉촉함을 유지하고 있습니다.]],
	level_range = {10, 20},
	rarity = 150,
	cost = 500,
	material_level = 2,

	max_power = 60, power_regen = 1,
	use_power = { name = "summon a tidal wave", kr_name = "해일 소환", power = 60,
		use = function(self, who)
			local duration = 7
			local radius = 1
			local dam = 20
			-- Add a lasting map effect
			game.level.map:addEffect(who,
				who.x, who.y, duration,
				engine.DamageType.WAVE, {dam=dam, x=who.x, y=who.y},
				radius,
				5, nil,
				engine.MapEffect.new{color_br=30, color_bg=60, color_bb=200, effect_shader="shader_images/water_effect1.png"},
				function(e)
					e.radius = e.radius + 0.4
					return true
				end,
				false
			)
			game.logSeen(who, "%s %s 휘두르자, 바다의 힘이 몰아치기 시작합니다!", (who.kr_name or who.name):capitalize():addJosa("가"), self:getName():addJosa("를"))
			return {id=true, used=true}
		end
	},
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 4, [Stats.STAT_CON] = 6 },
		max_mana = 20,
		max_stamina = 20,
		max_psi = 20,
		max_air = 50,
		resists = {
			[DamageType.COLD] = 25,
			[DamageType.NATURE] = 10,
		},
	},
}

newEntity{ base = "BASE_RING",
	power_source = {nature=true},
	unique = true,
	name = "Ring of the Dead", color = colors.DARK_GREY, image = "object/artifact/jewelry_ring_of_the_dead.png",
	unided_name = "dull black ring",
	kr_name = "죽은 자의 반지", kr_unided_name = "칙칙한 검은색 반지",
	desc = [[이 반지에는 무덤 저 너머의 힘이 들어 있습니다. 이 반지의 착용자는, 모든 길이 희미해질 때 새로운 다른 길을 찾을 수 있게 된다고 합니다.]],
	level_range = {35, 42},
	rarity = 250,
	cost = 500,
	material_level = 4,
	special_desc = function(self) return "사망시에 단 한번 부활시켜 줍니다!!" end,
	wielder = {
		inc_stats = { [Stats.STAT_LCK] = 10, },
		die_at = -100,
		combat_physresist = 10,
		combat_mentalresist = 10,
		combat_spellresist = 10,
	},
	one_shot_life_saving = true,
}

newEntity{ base = "BASE_RING",
	power_source = {arcane=true},
	unique = true,
	name = "Elemental Fury", color = colors.PURPLE, image = "object/artifact/ring_elemental_fury.png",
	unided_name = "multi-hued ring",
	kr_name = "원소의 분노", kr_unided_name = "무지개빛 반지",
	desc = [[이 반지는 다양한 색깔로 빛나고 있습니다.]],
	level_range = {15, 30},
	rarity = 200,
	cost = 200,
	material_level = 3,
	special_desc = function(self) return "당신이 적들에게 주는 모든 피해가 마법/화염/냉기/전기 속성으로 나뉘어 변화됩니다." end,
	wielder = {
		elemental_mastery = 0.25,
		inc_stats = { [Stats.STAT_MAG] = 3,[Stats.STAT_CUN] = 3, },
		inc_damage = {
			[DamageType.ARCANE]    = 12,
			[DamageType.FIRE]      = 12,
			[DamageType.COLD]      = 12,
			[DamageType.LIGHTNING] = 12,
		},
	},
}

newEntity{ base = "BASE_AMULET",
	power_source = {technique=true},
	unique = true,
	name = "Feathersteel Amulet", color = colors.WHITE, image = "object/artifact/feathersteel_amulet.png",
	unided_name = "light amulet",
	kr_name = "깃털강철 목걸이", kr_unided_name = "가벼운 목걸이",
	desc = [[이 목걸이를 착용하면, 주변에 있는 세상 모든 것들의 무게가 가벼워집니다.]],
	level_range = {5, 15},
	rarity = 200,
	cost = 90,
	material_level = 2,
	wielder = {
		max_encumber = 20,
		fatigue = -20,
		avoid_pressure_traps = 1,
		movement_speed = 0.2,
	},
}

newEntity{ base = "BASE_AMULET", define_as = "SET_GARKUL_TEETH",
	power_source = {technique=true},
	unique = true,
	name = "Garkul's Teeth", color = colors.YELLOW, image = "object/artifact/amulet_garkuls_teeth.png",
	unided_name = "a necklace made of teeth",
	kr_name = "가르쿨의 이빨", kr_unided_name = "이빨로 만들어진 목걸이",
	desc = [[인간과 하플링 수백 명의 이빨을 여러 겹으로 꼬인 가죽끈으로 엮어 만든, 원시적 목걸이입니다. 한 가지 확실한 것은 이 이빨들이 포식자 가르쿨의 것이 아니라, 그가 잡아먹은 것들의 이빨이라는 점입니다.]],
	level_range = {40, 50},
	rarity = 300,
	cost = 1000,
	material_level = 5,
	wielder = {
		inc_stats = {
			[Stats.STAT_STR] = 10,
			[Stats.STAT_CON] = 6,
		},
		talents_types_mastery = {
			["technique/2hweapon-cripple"] = 0.1,
			["technique/2hweapon-offense"] = 0.1,
			["technique/warcries"] = 0.1,
			["technique/bloodthirst"] = 0.1,
		},
		combat_physresist = 18,
		combat_mentalresist = 18,
		pin_immune = 1,
	},
	max_power = 48, power_regen = 1,
	use_talent = { id = Talents.T_SHATTERING_SHOUT, level = 4, power = 10 },

	set_list = { {"define_as", "HELM_OF_GARKUL"} },
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","die_at"}, -100)
		game.logSeen(who, "#CRIMSON#가르쿨의 두 가지 유물을 동시에 착용하자, 강력한 전사의 영혼이 당신에게 흘러 들어오는 것이 느껴집니다.")
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#CRIMSON#가르쿨의 영혼이 희미하게 사라집니다.")
	end,
}

newEntity{ base = "BASE_LITE",
	power_source = {nature=true},
	unique = true,
	name = "Summertide Phial", image="object/artifact/summertide_phial.png",
	unided_name = "glowing phial",
	level_range = {1, 10},
	color=colors.YELLOW,
	encumber = 1,
	rarity = 100,
	kr_name = "밀려오는 여름의 유리병", kr_unided_name = "타오르는 듯한 유리병",
	desc = [[밀려오는 여름의 달에 햇빛을 모아 담은, 수정으로 만들어진 작은 병입니다.]],
	cost = 200,

	max_power = 15, power_regen = 1,
	use_power = { name = "call light", kr_name = "주변 밝히기", power = 10,
		use = function(self, who)
			who:project({type="ball", range=0, radius=20}, who.x, who.y, engine.DamageType.LITE, 100)
			game.logSeen(who, "%s %s 휘두르자, 주변이 밝게 빛납니다!", (who.kr_name or who.name):capitalize():addJosa("가"), self:getName():addJosa("를"))
			return {id=true, used=true}
		end
	},
	wielder = {
		lite = 4,
		healing_factor = 0.1,
		inc_damage = {[DamageType.LIGHT]=10},
		resists = {[DamageType.LIGHT]=30},
	},
}

newEntity{ base = "BASE_GEM",
	power_source = {arcane=true},
	unique = true,
	name = "Burning Star", image = "object/artifact/jewel_gem_burning_star.png",
	unided_name = "burning jewel",
	level_range = {20, 30},
	color=colors.YELLOW,
	encumber = 1,
	identified = false,
	rarity = 250,
	material_level = 3,
	kr_name = "타오르는 별", kr_unided_name = "타오르는 보석",
	desc = [[매혹의 시대에, 햇빛을 보석에 담는 방법을 발견한 최초의 하플링 마법사가 있었습니다.
이 별은 그중에서도 가장 뛰어난 보석으로, 끊임없이 모양이 변하는 노란 표면에서 빛이 뿜어져 나옵니다.]],
	cost = 400,

	max_power = 30, power_regen = 1,
	use_power = { name = "map surroundings", kr_name = "주변 지형 감지", power = 30,
		use = function(self, who)
			who:magicMap(20)
			game.logSeen(who, "%s %s 휘두르자, 모든 방향으로 빛이 뿜어져 나갑니다!", (who.kr_name or who.name):capitalize():addJosa("가"), self:getName():addJosa("를"))
			return {id=true, used=true}
		end
	},
	carrier = {
		lite = 1,
	},
}

newEntity{ base = "BASE_LITE",
	power_source = {arcane=true},
	unique = true,
	name = "Dúathedlen Heart",
	unided_name = "a dark, fleshy mass", image = "object/artifact/dark_red_heart.png",
	level_range = {30, 40},
	color = colors.RED,
	encumber = 1,
	rarity = 300,
	material_level = 4,
	kr_name = "듀아세들렌의 심장", kr_unided_name = "어두운 살점 덩어리",
	desc = [[이 검붉은 심장은 그 주인으로부터 떨어져 나왔음에도 불구하고, 여전히 뛰고 있습니다. 이것은 주변에 있는 모든 빛을 찾아 소멸시킵니다.]],
	cost = 100,

	wielder = {
		lite = -1000,
		infravision = 6,
		resists_cap = { [DamageType.LIGHT] = 10 },
		resists = { [DamageType.LIGHT] = 30 },
		talents_types_mastery = { ["cunning/stealth"] = 0.1 },
		combat_dam = 7,
	},

	max_power = 15, power_regen = 1,
	use_talent = { id = Talents.T_BLOOD_GRASP, level = 3, power = 10 },
}

newEntity{
	power_source = {nature=true},
	unique = true,
	type = "potion", subtype="potion",
	name = "Blood of Life",
	unided_name = "bloody phial",
	level_range = {1, 50},
	display = '!', color=colors.VIOLET, image="object/artifact/potion_blood_of_life.png",
	encumber = 0.4,
	rarity = 350,
	kr_name = "생명의 피", kr_unided_name = "핏빛 물약",
	desc = [[이 약병에 들어있는 피는 아지랑이의 시대에 살던 고대 종족으로부터 추출한 것입니다. 초기 세상의 힘과 생명력의 일부가 그 속에서 흐르고 있습니다. "마시거라, 필멸자여," 붉은 액체가 당신의 정신 속으로 속삭이는 것 같습니다. "어둠을 넘어서까지 나는 너에게 빛을 가져다 주리니. 내 정수를 맛본 이는 육체의 죽음조차 두려워 않도다. 마시거라, 필멸자여, 네 생명이 소중하다면..."]],
	cost = 1000,
	special = true,

	use_simple = { name = "quaff the Blood of Life to grant an extra life", kr_name = "생명의 피를 마셔 여분의 생명 획득", use = function(self, who)
		game.logSeen(who, "%s quaffs the %s!", who.name:capitalize(), self:getName())
		if not who:attr("undead") then
			who.blood_life = true
			game.logPlayer(who, "#LIGHT_RED#생명의 피가 혈관을 따라 질주하는 것이 느껴집니다.")
		else
			game.logPlayer(who, "생명의 피가 당신에게는 아무런 영향도 주지 않습니다.")
		end
		return {used=true, id=true, destroy=true}
	end},
}

newEntity{ base = "BASE_LEATHER_BOOT",
	power_source = {technique=true},
	unique = true,
	name = "Eden's Guile", image = "object/artifact/boots_edens_guile.png",
	unided_name = "pair of yellow boots",
	kr_name = "에덴의 꾀", kr_unided_name = "노란색 신발",
	desc = [[문제를 해결하는 최고의 방법은 도망치는 것이라고 생각했던, 어느 추방된 도둑의 신발입니다.]],
	on_id_lore = "eden-guile",
	color = colors.YELLOW,
	level_range = {1, 20},
	rarity = 300,
	cost = 100,
	material_level = 2,
	wielder = {
		combat_armor = 1,
		combat_def = 2,
		fatigue = 2,
		talents_types_mastery = { ["cunning/survival"] = 0.2 },
		inc_stats = { [Stats.STAT_CUN] = 3, },
	},

	max_power = 50, power_regen = 1,
	use_power = { name = "boost speed", kr_name = "속도 증가", power = 50,
		use = function(self, who)
			who:setEffect(who.EFF_SPEED, 8, {power=math.min(0.20 + who:getCun() / 200, 0.7)})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {nature=true, technique=true},
	unique = true,
	name = "Fire Dragon Shield", image = "object/artifact/fire_dragon_shield.png",
	unided_name = "dragon shield",
	moddable_tile = "special/%s_fire_dragon_shield",
	moddable_tile_big = true,
	kr_name = "화염 용 방패", kr_unided_name = "용 방패",
	desc = [[이제는 잊혀진 땅, 타르'에이알에 살던 수많은 화염 용의 비늘로 만들어진 방패입니다.]],
	color = colors.LIGHT_RED,
	metallic = false,
	level_range = {27, 35},
	rarity = 300,
	require = { stat = { str=28 }, },
	cost = 350,
	material_level = 4,
	special_combat = {
		dam = 58,
		block = 220,
		physcrit = 4.5,
		dammod = {str=1},
		damtype = DamageType.FIRE,
	},
	wielder = {
		resists={[DamageType.FIRE] = 35},
		on_melee_hit={[DamageType.FIRE] = 17},
		combat_armor = 9,
		combat_def = 16,
		combat_def_ranged = 15,
		fatigue = 20,
		learn_talent = { [Talents.T_BLOCK] = 5, },
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {technique=true},
	unique = true,
	name = "Titanic", image = "object/artifact/shield_titanic.png",
	moddable_tile = "special/%s_titanic",
	moddable_tile_big = true,
	unided_name = "huge shield",
	kr_name = "타이타닉", kr_unided_name = "거대한 방패",
	desc = [[가장 어두운 스트라라이트로 만들어진 방패로, 거대하고 무겁고 아주 단단합니다.]],
	color = colors.GREY,
	level_range = {20, 30},
	rarity = 270,
	require = { stat = { str=37 }, },
	cost = 300,
	material_level = 3,
	special_combat = {
		dam = 48,
		block = 320,
		physcrit = 4.5,
		dammod = {str=1},
	},
	wielder = {
		combat_armor = 18,
		combat_def = 20,
		combat_def_ranged = 10,
		fatigue = 30,
		combat_armor_hardiness = 20,
		learn_talent = { [Talents.T_BLOCK] = 4, },
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {nature=true},
	unique = true,
	name = "Black Mesh", image = "object/artifact/shield_mesh.png",
	unided_name = "pile of tendrils",
	kr_name = "검은 덩굴망", kr_unided_name = "덩굴 덩어리",
	desc = [[검은 덩굴을 엮어 만든 망으로, 방패로 사용할 수 있을 것 같습니다. 건드리면 움직이는 것이 눈에 보일 정도이며, 팔에 들러붙어 따뜻하고 검은 덩굴 안쪽으로 팔을 끌어들이려 합니다.]],
	color = colors.BLACK,
	level_range = {15, 30},
	rarity = 270,
	require = { stat = { str=20 }, },
	cost = 400,
	material_level = 3,
	moddable_tile = "special/%s_black_mesh",
	moddable_tile_big = true,
	metallic = false,
	special_combat = {
		dam = resolvers.rngavg(25,35),
		block = resolvers.rngavg(90, 120),
		physcrit = 5,
		dammod = {str=1},
	},
	wielder = {
		combat_armor = 2,
		combat_def = 8,
		combat_def_ranged = 8,
		fatigue = 12,
		learn_talent = { [Talents.T_BLOCK] = 3, },
		resists = { [DamageType.BLIGHT] = 15, [DamageType.DARKNESS] = 30, },
		stamina_regen = 2,
	},
	on_block = {desc = "30% 확률로 공격자 끌어당기기", fct = function(self, who, src, type, dam, eff)
		if rng.percent(30) then
			if not src then return end

			src:pull(who.x, who.y, 15)
			game.logSeen(src, "검은 덩굴이 뻗어나가 %s 끌어 당겨옵니다!", (src.kr_name or src.name):capitalize():addJosa("를"))
			if core.fov.distance(who.x, who.y, src.x, src.y) <= 1 and src:canBe('pin') then
				src:setEffect(src.EFF_CONSTRICTED, 6, {src=who})
			end
		end
	end,}
}

newEntity{ base = "BASE_LIGHT_ARMOR",
	power_source = {technique=true},
	unique = true,
	name = "Rogue Plight", image = "object/artifact/armor_rogue_plight.png",
	define_as = "ROGUE_PLIGHT",
	unided_name = "blackened leather armour",
	kr_name = "도둑의 맹세", kr_unided_name = "검은 가죽 갑옷",
	desc = [[이 갑옷을 입었던 도둑들은, 그 어느 누구도 무능한 모습을 보이지 않았습니다.]],
	level_range = {25, 40},
	rarity = 270,
	cost = 200,
	sentient = true,
	global_speed = 0.25, -- act every 4th turn
	require = { stat = { str=22 }, },
	material_level = 3,
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
	end,
	special_desc = function(self) return "4 턴 마다 착용자의 출혈, 중독 혹은 상처를 그 원천이나 인근의 적에게로 옮깁니다."
	end,
	wielder = {
		combat_def = 6,
		combat_armor = 7,
		fatigue = 7,
		ignore_direct_crits = 30,
		inc_stats = { [Stats.STAT_WIL] = 5, [Stats.STAT_CON] = 4, },
		resists={[DamageType.NATURE] = 35},
	},
	act = function(self)
		self:useEnergy()
	
		if not self.worn_by then return end -- items act even when not equipped
		local who = self.worn_by

		-- Make sure the item is worn
		-- This should be redundant but whatever
		local o, item, inven_id = who:findInAllInventoriesBy("define_as", "ROGUE_PLIGHT")
		if not o or not who:getInven(inven_id).worn then return end
		
		local Map = require "engine.Map"
		
		for eff_id, p in pairs(who.tmp) do
			-- p only has parameters, we need to get the effect definition (e) to check subtypes
			local e = who.tempeffect_def[eff_id]
			if e.status == "detrimental" and e.subtype and (e.subtype.bleed or e.subtype.poison or e.subtype.wound) then	
				
				-- Copy the effect parameters then change only the source
				-- This will preserve everything passed to the debuff in setEffect but will use the new source for +damage%, etc
				local effectParam = who:copyEffect(eff_id)
				effectParam.src = who
					
				if p.src and p.src.setEffect and not p.src.dead then -- Most debuffs don't define a source
					p.src:setEffect(eff_id, p.dur, effectParam)
					who:removeEffect(eff_id)
					game.logPlayer(who, "#CRIMSON#'도둑의 맹세'가 원천에게로 상태 효과를 옮겼습니다!")
					return true
				else 
					-- If there is no source move the debuff to an adjacent enemy instead
					-- If there is no source or adjacent enemy the effect fails		
					for _, coor in pairs(util.adjacentCoords(who.x, who.y)) do
						local act = game.level.map(coor[1], coor[2], Map.ACTOR)
						if act then
							act:setEffect(eff_id, p.dur, effectParam)
							who:removeEffect(eff_id)
							game.logPlayer(who, "#CRIMSON#'도둑의 맹세'가 인근의 적에게로 상태 효과를 옮겼습니다!")
							return true
						end		
					end
				end
			end
		end	
		return true	
	end,
}

newEntity{
	power_source = {nature=true},
	unique = true,
	type = "misc", subtype="egg",
	unided_name = "dark egg",
	name = "Mummified Egg-sac of Ungolë", image = "object/artifact/mummified_eggsack.png",
	level_range = {20, 35},
	rarity = 190,
	display = "*", color=colors.DARK_GREY,
	encumber = 2,
	not_in_stores = true,
	kr_name = "운골뢰의 미이라화된 알주머니", kr_unided_name = "어두운 알",
	desc = [[건드려보면 푸석푸석하게 말라있는 알주머니입니다. 그 안에는 아직도 생명의 그림자가 들어있는 것 같습니다.]],

	carrier = {
		lite = -2,
	},
	max_power = 100, power_regen = 1,
	use_power = { name = "summon spiders", kr_name = "거미 소환", power = 80, use = function(self, who)
		if not who:canBe("summon") then game.logPlayer(who, "소환 할 수 없습니다. 억압된 상태입니다!") return end

		local NPC = require "mod.class.NPC"
		local list = NPC:loadList("/data/general/npcs/spider.lua")

		for i = 1, 2 do
			-- Find space
			local x, y = util.findFreeGrid(who.x, who.y, 5, true, {[engine.Map.ACTOR]=true})
			if not x then break end

			local e
			repeat e = rng.tableRemove(list)
			until not e.unique and e.rarity

			local spider = game.zone:finishEntity(game.level, "actor", e)
			spider.make_escort = nil
			spider.silent_levelup = true
			spider.faction = who.faction
			spider.ai = "summoned"
			spider.ai_real = "dumb_talented_simple"
			spider.summoner = who
			spider.summon_time = 10
			spider.exp_worth = 0

			local setupSummon = getfenv(who:getTalentFromId(who.T_SPIDER).action).setupSummon
			setupSummon(who, spider, x, y)
			game:playSoundNear(who, "talents/slime")
		end
		return {id=true, used=true}
	end },
}

newEntity{ base = "BASE_HELM",
	power_source = {technique=true},
	unique = true,
	name = "Helm of the Dwarven Emperors", image = "object/artifact/helm_of_the_dwarven_emperors.png",
	unided_name = "shining helm",
	kr_name = "드워프 황제의 투구", kr_unided_name = "빛나는 투구",
	desc = [[지하세계의 모든 그림자를 내쫓을 수 있는 다이아몬드가 박힌, 드워프 투구입니다.]],
	level_range = {20, 28},
	rarity = 240,
	cost = 700,
	material_level = 2,
	wielder = {
		lite = 1,
		combat_armor = 6,
		fatigue = 4,
		blind_immune = 0.3,
		confusion_immune = 0.3,
		inc_stats = { [Stats.STAT_WIL] = 3, [Stats.STAT_MAG] = 4, },
		inc_damage={
			[DamageType.LIGHT] = 8,
		},
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_SUN_FLARE, level = 3, power = 30 },
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Dwarf" then
			local Stats = require "engine.interface.ActorStats"

			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_CUN] = 5, [Stats.STAT_MAG] = 5, [Stats.STAT_WIL] = 5, })
			game.logPlayer(who, "#LIGHT_BLUE#드워프 황제의 유물이 당신에게 그들의 지혜를 부여합니다.")
		end
	end,
}

newEntity{ base = "BASE_KNIFE",
	power_source = {technique=true},
	unique = true,
	name = "Silent Blade", image = "object/artifact/dagger_silent_blade.png",
	unided_name = "shining dagger",
	kr_name = "침묵의 칼날", kr_unided_name = "빛나는 단검",
	desc = [[얇고 어두운 단검으로, 그림자와 쉽게 동화됩니다.]],
	level_range = {23, 28},
	rarity = 200,
	require = { stat = { cun=25 }, },
	cost = 250,
	material_level = 2,
	combat = {
		dam = 25,
		apr = 10,
		physcrit = 8,
		dammod = {dex=0.55,str=0.35},
		no_stealth_break = true,
		melee_project={[DamageType.RANDOM_SILENCE] = 10},
	},
	wielder = {combat_atk = 10},
}

newEntity{ base = "BASE_KNIFE", define_as = "ART_PAIR_MOON",
	power_source = {arcane=true},
	unique = true,
	name = "Moon", image = "object/artifact/dagger_moon.png",
	unided_name = "crescent blade",
	kr_name = "달", kr_unided_name = "초승달 단검",
	desc = [[달에서 나온 재료로 만들었다는 전설이 있는, 섬뜩하게 휜 칼날입니다. 주변의 빛을 삼켜, 투명해집니다.]],
	level_range = {20, 30},
	rarity = 200,
	require = { stat = { dex=24, cun=24 }, },
	cost = 300,
	material_level = 3,
	combat = {
		dam = 30,
		apr = 30,
		physcrit = 10,
		dammod = {dex=0.45,str=0.45},
		melee_project={[DamageType.DARKNESS] = 20},
	},
	wielder = {
		lite = -1,
		inc_damage={
			[DamageType.DARKNESS] = 10,
		},
	},
	set_list = { {"define_as","ART_PAIR_STAR"} },
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","lite"}, 1)
		self:specialSetAdd({"combat","melee_project"}, {[engine.DamageType.RANDOM_CONFUSION]=10})
		self:specialSetAdd({"wielder","inc_damage"}, {[engine.DamageType.DARKNESS]=15})
		game.logSeen(who, "#ANTIQUE_WHITE#두 자루의 단검이 근접하자, 밝게 빛나기 시작합니다.")
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#ANTIQUE_WHITE#두 자루 단검의 빛이 희미해집니다.")
	end,
}

newEntity{ base = "BASE_KNIFE", define_as = "ART_PAIR_STAR",
	power_source = {arcane=true},
	unique = true,
	name = "Star",
	unided_name = "jagged blade", image = "object/artifact/dagger_star.png",
	kr_name = "별", kr_unided_name = "뾰족한 단검",
	desc = [[전설에 따르면, 별과 같이 밝게 빛나는 단검이라고 합니다. 하늘에서 떨어진 것을 연마하여 만들었다고 하며, 은은하게 빛이 납니다.]],
	level_range = {20, 30},
	rarity = 200,
	require = { stat = { dex=24, cun=24 }, },
	cost = 300,
	material_level = 3,
	combat = {
		dam = 25,
		apr = 20,
		physcrit = 20,
		dammod = {dex=0.45,str=0.45},
		melee_project={[DamageType.LIGHT] = 20},
	},
	wielder = {
		lite = 1,
		inc_damage={
			[DamageType.LIGHT] = 10,
		},
	},
	set_list = { {"define_as","ART_PAIR_MOON"} },
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","lite"}, 1)
		self:specialSetAdd({"combat","melee_project"}, {[engine.DamageType.RANDOM_BLIND]=10})
		self:specialSetAdd({"wielder","inc_damage"}, {[engine.DamageType.LIGHT]=15})
	end,

}

newEntity{ base = "BASE_RING",
	power_source = {technique=true},
	unique = true,
	name = "Ring of the War Master", color = colors.DARK_GREY, image = "object/artifact/ring_of_war_master.png",
	unided_name = "blade-edged ring",
	kr_name = "전투 명인의 반지", kr_unided_name = "날이 선 반지",
	desc = [[힘을 뿜어내고 있으며, 날이 서 있는 반지입니다. 반지를 손가락에 끼면, 고통과 파괴에 대한 기묘한 생각들이 마음 속으로 밀려옵니다.]],
	level_range = {40, 50},
	rarity = 200,
	cost = 500,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 3, [Stats.STAT_DEX] = 3, [Stats.STAT_CON] = 3, },
		combat_apr = 15,
		combat_dam = 10,
		combat_physcrit = 5,
		talents_types_mastery = {
			["technique/2hweapon-cripple"] = 0.3,
			["technique/2hweapon-offense"] = 0.3,
			["technique/2hweapon-assault"] = 0.3,
			["technique/archery-bow"] = 0.3,
			["technique/archery-sling"] = 0.3,
			["technique/archery-training"] = 0.3,
			["technique/archery-utility"] = 0.3,
			["technique/archery-excellence"] = 0.3,
			["technique/combat-techniques-active"] = 0.3,
			["technique/combat-techniques-passive"] = 0.3,
			["technique/combat-training"] = 0.3,
			["technique/dualweapon-attack"] = 0.3,
			["technique/dualweapon-training"] = 0.3,
			["technique/shield-defense"] = 0.3,
			["technique/shield-offense"] = 0.3,
			["technique/warcries"] = 0.3,
			["technique/superiority"] = 0.3,
			["technique/thuggery"] = 0.3,
			["technique/pugilism"] = 0.3,
			["technique/unarmed-discipline"] = 0.3,
			["technique/unarmed-training"] = 0.3,
			["technique/grappling"] = 0.3,
			["technique/finishing-moves"] = 0.3,
		},
	},
}

newEntity{ base = "BASE_GREATMAUL",
	power_source = {technique=true},
	unique = true,
	name = "Unstoppable Mauler", color = colors.UMBER, image = "object/artifact/unstoppable_mauler.png",
	unided_name = "heavy maul",
	kr_name = "멈추지 않는 망치질", kr_unided_name = "무거운 대형망치",
	desc = [[놀랍도록 무거운, 거대한 대형망치입니다. 망치를 한번 들면, 멈출 수 없는 충동이 일어나기 시작합니다.]],
	level_range = {23, 30},
	rarity = 270,
	require = { stat = { str=40 }, },
	cost = 250,
	material_level = 3,
	combat = {
		dam = 48,
		apr = 15,
		physcrit = 3,
		dammod = {str=1.2},
		talent_on_hit = { [Talents.T_SUNDER_ARMOUR] = {level=3, chance=15} },
	},
	wielder = {
		combat_atk = 20,
		pin_immune = 1,
		knockback_immune = 1,
	},
	max_power = 18, power_regen = 1,
	use_talent = { id = Talents.T_FEARLESS_CLEAVE, level = 3, power = 18 },
}

newEntity{ base = "BASE_MACE",
	power_source = {technique=true},
	unique = true,
	name = "Crooked Club", color = colors.GREEN, image = "object/artifact/weapon_crooked_club.png",
	unided_name = "weird club",
	kr_name = "구부정한 곤봉", kr_unided_name = "이상한 곤봉",
	desc = [[육중한 무게가 끝쪽으로 쏠린, 기묘하게 비틀린 곤봉입니다. 정말로 기묘한 곤봉입니다.]],
	level_range = {12, 20},
	rarity = 192,
	require = { stat = { str=20 }, },
	cost = 250,
	material_level = 2,
	combat = {
		dam = 25,
		apr = 4,
		physcrit = 10,
		dammod = {str=1},
		melee_project={[DamageType.RANDOM_CONFUSION_PHYS] = 14},
		talent_on_hit = { T_BATTLE_CALL = {level=1, chance=10},},
		burst_on_crit = {
			[DamageType.PHYSKNOCKBACK] = 20,
		},
	},
	wielder = {combat_atk=12,},
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {nature=true},
	unique = true,
	name = "Spider-Silk Robe of Spydrë", color = colors.DARK_GREEN, image = "object/artifact/robe_spider_silk_robe_spydre.png",
	unided_name = "spider-silk robe",
	kr_name = "거미 비단 로브", kr_unided_name = "거미 비단 로브",
	desc = [[거미줄을 이용한 비단만으로 만들어진, 기이한 로브입니다. 어떤 현자는 아마도 이 로브가 장거리 관문을 통해 온, 다른 세계의 물건일지도 모른다고 합니다.]],
	level_range = {20, 30},
	rarity = 190,
	cost = 250,
	material_level = 3,
	wielder = {
		combat_def = 10,
		combat_armor = 15,
		combat_armor_hardiness = 30,
		inc_stats = { [Stats.STAT_CON] = 5, [Stats.STAT_WIL] = 4, },
		combat_mindpower = 10,
		combat_mindcrit = 5,
		combat_spellresist = 10,
		combat_physresist = 10,
		inc_damage={[DamageType.NATURE] = 10, [DamageType.MIND] = 10, [DamageType.ACID] = 10},
		resists={[DamageType.NATURE] = 30},
		on_melee_hit={[DamageType.POISON] = 20, [DamageType.SLIME] = 20},
	},
}

newEntity{ base = "BASE_HELM", define_as = "HELM_KROLTAR",
	power_source = {technique=true},
	unique = true,
	name = "Dragon-helm of Kroltar", image = "object/artifact/dragon_helm_of_kroltar.png",
	unided_name = "dragon-helm",
	kr_name = "크롤타르의 용투구", kr_unided_name = "용투구",
	desc = [[도드라진 금 장식이 달린 강철 투구입니다. 가장 위대한 화염 드레이크 크롤타르의 깃 장식이 되어 있습니다.]],
	require = { talent = { {Talents.T_ARMOUR_TRAINING,3} }, stat = { str=35 }, },
	level_range = {37, 45},
	rarity = 280,
	cost = 400,
	material_level = 4,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_CON] = 5, [Stats.STAT_LCK] = -4, },
		combat_def = 5,
		combat_armor = 9,
		fatigue = 10,
	},
	max_power = 45, power_regen = 1,
	use_talent = { id = Talents.T_WARSHOUT, level = 2, power = 45 },
	set_list = { {"define_as","SCALE_MAIL_KROLTAR"} },
	on_set_complete = function(self, who)
		self:specialSetAdd("skullcracker_mult", 1)
		self:specialSetAdd({"wielder","combat_spellresist"}, 15)
		self:specialSetAdd({"wielder","combat_mentalresist"}, 15)
		self:specialSetAdd({"wielder","combat_physresist"}, 15)
		game.logPlayer(who, "#GOLD#크롤타르의 투구와 비늘 갑옷을 착용하자, 그것들이 연기와 함께 불꽃을 내뿜기 시작합니다.")
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#GOLD#연기와 불꽃이 사라집니다.")
	end,
}

newEntity{ base = "BASE_HELM",
	power_source = {technique=true},
	unique = true,
	name = "Crown of Command", image = "object/artifact/crown_of_command.png",
	unided_name = "unblemished silver crown",
	kr_name = "명령의 왕관", kr_unided_name = "흠 없는 은제 왕관",
	desc = [[황혼의 시대에 나르골 왕국을 지배하던 하플링 왕, 로우파르가 쓰던 왕관입니다. 이 시대는 암흑의 시기였고, 왕이 엄격하게 명령과 징벌을 시행하던 시기였습니다. 다른 의견은 처벌받았고, 이의는 억압되었으며, 많은 이들이 흔적조차 남기지 못한 채 감옥에 끌려갔습니다. 모든 것들은 왕관 앞에 충성을 바치거나, 끔찍하게 처벌되었습니다. 왕이 후계자를 남기지 못하고 죽자, 왕관은 사라졌고 그의 왕국은 혼돈에 빠졌습니다.]],
	require = { stat = { cun=25 } },
	level_range = {20, 35},
	rarity = 280,
	cost = 300,
	material_level = 3,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 3, [Stats.STAT_WIL] = 10, },
		combat_def = 3,
		combat_armor = 6,
		combat_mindpower = 5,
		fatigue = 4,
		resists = { [DamageType.PHYSICAL] = 8},
		talents_types_mastery = { ["technique/superiority"] = 0.2, ["technique/field-control"] = 0.2 },
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_INDOMITABLE, level = 1, power = 60 },
	on_wear = function(self, who)
		self.worn_by = who
		if who.descriptor and who.descriptor.race == "Halfling" then
			local Stats = require "engine.interface.ActorStats"
			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_CUN] = 7, [Stats.STAT_STR] = 7, }) 
			game.logPlayer(who, "#LIGHT_BLUE#당신의 종족이 가진 힘을 이해하게 되었습니다.", self:getName())
		end
	end,
	on_takeoff = function(self)
		self.worn_by = nil

	end,
}

newEntity{ base = "BASE_GLOVES",
	power_source = {technique=true},
	unique = true,
	name = "Gloves of the Firm Hand", image = "object/artifact/gloves_of_the_firm_hand.png",
	unided_name = "heavy gloves",
	kr_name = "견고한 손의 장갑", kr_unided_name = "단단한 장갑",
	desc = [[이 장갑은 굉장히 단단하면서도, 안정적인 느낌을 줍니다! 장갑 안쪽의 촉감은 정말 부드러우며, 바깥쪽에는 마법의 암석질이 계속 변화하면서 거친 표면을 만들어냅니다. 이 장갑을 착용하면 장갑에 들어있는 땅의 힘이 대지와 자동적으로 결속하여, 안정성을 크게 늘려줍니다.]],
	level_range = {17, 27},
	rarity = 210,
	cost = 150,
	material_level = 3,
	wielder = {
		talent_cd_reduction={[Talents.T_CLINCH]=2},
		inc_stats = { [Stats.STAT_CON] = 4 },
		combat_armor = 8,
		disarm_immune=0.4,
		knockback_immune=0.3,
		stun_immune = 0.3,
		combat = {
			dam = 18,
			apr = 1,
			physcrit = 7,
			talent_on_hit = { T_CLINCH = {level=3, chance=20}, T_MAIM = {level=3, chance=10}, T_TAKE_DOWN = {level=3, chance=10} },
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
		},
	},
}

newEntity{ base = "BASE_GAUNTLETS",
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Dakhtun's Gauntlets", color = colors.STEEL_BLUE, image = "object/artifact/dakhtuns_gauntlets.png",
	unided_name = "expertly-crafted dwarven-steel gauntlets",
	kr_name = "다크툰의 전투장갑", kr_unided_name = "명인이 만든 드워프강철 전투장갑",
	desc = [[매혹의 시대에 위대한 대장장이 다크툰이 만든 것으로, 이 드워프강철 전투장갑에는 금빛 마법 룬이 새겨져 있습니다. 착용자에게 전대미문의 물리적 힘과 마법적 힘을 부여한다고 알려져 있습니다.]],
	level_range = {40, 50},
	rarity = 300,
	cost = 2000,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 6, [Stats.STAT_MAG] = 6 },
		inc_damage = { [DamageType.PHYSICAL] = 10 },
		combat_physcrit = 10,
		combat_spellcrit = 10,
		combat_critical_power = 50,
		combat_armor = 6,
		combat = {
			dam = 35,
			apr = 10,
			physcrit = 10,
			physspeed = 0.2,
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
			melee_project={[DamageType.ARCANE] = 20},
			talent_on_hit = { T_GREATER_WEAPON_FOCUS = {level=1, chance=10}, T_DISPLACEMENT_SHIELD = {level=1, chance=10} },
			damrange = 0.3,
		},
	},
}

newEntity{ base = "BASE_GREATMAUL",
	power_source = {technique=true, arcane=true},
	unique = true,
	name = "Voratun Hammer of the Deep Bellow", color = colors.LIGHT_RED, image = "object/artifact/voratun_hammer_of_the_deep_bellow.png",
	unided_name = "flame scorched voratun hammer",
	kr_name = "깊은 울림의 보라툰 망치", kr_unided_name = "타오르는 보라툰 망치",
	desc = [[드워프 대장장이 중에서도 대가의 손에서 만들어진, 전설적인 망치입니다. 오랜 세월 동안 불타는 열기 속에서 강력한 무기를 만드는데 사용되었고, 나중에는 스스로가 강력한 힘을 가진 물건이 되었습니다.]],
	level_range = {38, 50},
	rarity = 250,
	require = { stat = { str=48 }, },
	cost = 650,
	material_level = 5,
	combat = {
		dam = 82,
		apr = 7,
		physcrit = 4,
		dammod = {str=1.2},
		talent_on_hit = { [Talents.T_FLAMESHOCK] = {level=3, chance=10} },
		melee_project={[DamageType.FIRE] = 30},
	},
	wielder = {
		inc_damage={
			[DamageType.PHYSICAL] = 15,
		},
	},
}

newEntity{ base = "BASE_GLOVES",
	power_source = {nature=true}, define_as = "SET_GIANT_WRAPS",
	unique = true,
	name = "Snow Giant Wraps", color = colors.SANDY_BROWN, image = "object/artifact/snow_giant_arm_wraps.png",
	unided_name = "fur-lined leather wraps",
	kr_name = "설원 거인 감싸개", kr_unided_name = "털 안감을 덧댄 가죽 감싸개",
	desc = [[손과 팔뚝을 칭칭 감싸기 위해 만들어진, 두 개의 커다란 가죽 뭉치입니다. 이 특별한 감싸개에는 착용자에게 엄청난 힘을 주는 기능이 부여되어 있습니다.]],
	level_range = {15, 25},
	rarity = 200,
	cost = 500,
	material_level = 3,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 4, },
		resists = { [DamageType.COLD]= 10, [DamageType.LIGHTNING] = 10, },
		knockback_immune = 0.5,
		combat_armor = 2,
		max_life = 60,
		combat = {
			dam = 16,
			apr = 1,
			physcrit = 4,
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
			talent_on_hit = { T_CALL_LIGHTNING = {level=5, chance=25}},
			melee_project={ [DamageType.COLD] = 10, [DamageType.LIGHTNING] = 10, },
		},
	},
	max_power = 6, power_regen = 1,
	use_talent = { id = Talents.T_THROW_BOULDER, level = 2, power = 6 },

	set_list = { {"define_as", "SET_MIGHTY_GIRDLE"} },
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","combat_dam"}, 10)
		self:specialSetAdd({"wielder","combat_physresist"}, 10)
	end,
}

newEntity{ base = "BASE_LEATHER_BELT",
	power_source = {technique=true}, define_as = "SET_MIGHTY_GIRDLE",
	unique = true,
	name = "Mighty Girdle", image = "object/artifact/belt_mighty_girdle.png",
	unided_name = "massive, stained girdle",
	kr_name = "거인의 허리띠", kr_unided_name = "얼룩투성이의 무거운 허리띠",
	desc = [[이 허리띠에는 허리 두께가 늘어나는 것을 보호해주는 강력한 기능이 들어있습니다. 이 기이한 힘의 원천이 무엇인지는 모르겠지만, 무거운 짐을 옮길 때에는 큰 도움이 될 것 같습니다.]],
	color = colors.LIGHT_RED,
	level_range = {1, 25},
	rarity = 170,
	cost = 350,
	material_level = 2,
	wielder = {
		knockback_immune = 0.4,
		max_encumber = 70,
		combat_armor = 4,
	},

	set_list = { {"define_as", "SET_GIANT_WRAPS"} },
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","max_life"}, 100)
		self:specialSetAdd({"wielder","size_category"}, 2)
		game.logPlayer(who, "#GOLD#덩치가 엄청나게 커졌습니다!")
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#LIGHT_BLUE#덩치가 작아지는 것을 느낍니다...")
	end,
}

newEntity{ base = "BASE_CLOAK",
	power_source = {nature=true},
	unique = true,
	name = "Serpentine Cloak", image = "object/artifact/serpentine_cloak.png",
	unided_name = "tattered cloak",
	kr_name = "뱀의 망토", kr_unided_name = "누더기 망토",
	desc = [[교활함과 원한이 이 망토에서 퍼져나오고 있습니다.]],
	level_range = {20, 29},
	rarity = 240,
	cost = 200,
	material_level = 3,
	wielder = {
		combat_def = 10,
		inc_stats = { [Stats.STAT_CUN] = 6, [Stats.STAT_CON] = 5, },
		resists_pen = { [DamageType.NATURE] = 15 },
		talents_types_mastery = { ["cunning/stealth"] = 0.1, },
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_PHASE_DOOR, level = 2, power = 30 },
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "Vestments of the Conclave", color = colors.DARK_GREY, image = "object/artifact/robe_vestments_of_the_conclave.png",
	unided_name = "tattered robe",
	kr_name = "은둔자의 예복", kr_unided_name = "누더기 로브",
	desc = [[매혹의 시대에 만들어져 지금까지 간직된, 고대의 로브입니다. 마법의 근원적 힘이 깃들어 있습니다.
인간이 인간을 위해 만든 것으로, 인간만이 로브의 진정한 힘을 사용할 수 있습니다.]],
	level_range = {12, 22},
	rarity = 220,
	cost = 150,
	material_level = 2,
	wielder = {
		inc_damage = {[DamageType.ARCANE]=10},
		inc_stats = { [Stats.STAT_MAG] = 6 },
		combat_spellcrit = 15,
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Human" then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_MAG] = 3, [Stats.STAT_CUN] = 9, })
			self:specialWearAdd({"wielder","inc_damage"}, {[DamageType.ARCANE]=7})
			self:specialWearAdd({"wielder","combat_spellcrit"}, 2)
			game.logPlayer(who, "#LIGHT_BLUE#오래된 인간 은둔자의 예복을 입자, 힘이 밀려 들어오는 것이 느껴집니다!")
		end
	end,
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "Firewalker", color = colors.RED, image = "object/artifact/robe_firewalker.png",
	unided_name = "blazing robe",
	kr_name = "불 속을 걷는 자", kr_unided_name = "불타는 로브",
	desc = [[이 불붙은 로브는 정신 나간 화염술사, 할콧이 입던 것입니다. 황혼의 시대 말기에 그는 많은 도시를 위협했으며, 마법폭발의 피해로부터 회복하려 노력하는 마을 사람들을 불태우고 약탈했습니다. 결국 그는 지구르 추종자들에게 잡혀, 먼저 혀를 잘리고, 머리도 잘린 다음, 온 몸이 갈기갈기 찢겨졌습니다. 그 머리는 얼음덩이 속에 넣은 채로 주변 마을들을 순회하여, 지역 주민들의 환호 속에서 행진을 벌였습니다. 단지 그 로브만이, 할콧의 불꽃을 간직한 채로 남아있습니다.]],
	level_range = {20, 30},
	rarity = 300,
	cost = 280,
	material_level = 3,
	wielder = {
		inc_damage = {[DamageType.FIRE]=20},
		combat_def = 8,
		combat_armor = 2,
		inc_stats = { [Stats.STAT_MAG] = 6, [Stats.STAT_CUN] = 6, },
		resists = {[DamageType.FIRE] = 20, [DamageType.COLD] = -10},
		resists_pen = { [DamageType.FIRE] = 20 },
		on_melee_hit = {[DamageType.FIRE] = 18},
	},
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "Robe of the Archmage", color = colors.RED, image = "object/artifact/robe_of_the_archmage.png",
	unided_name = "glittering robe",
	kr_name = "마도사의 로브", kr_unided_name = "반짝거리는 로브",
	desc = [[평범한 엘프비단 로브입니다. 순수한 힘을 내뿜고 있다는 것만 빼면, 정말 평범합니다.]],
	level_range = {30, 40},
	rarity = 290,
	cost = 550,
	material_level = 4,
	moddable_tile = "special/robe_of_the_archmage",
	moddable_tile_big = true,
	wielder = {
		lite = 1,
		inc_damage = {all=12},
		blind_immune = 0.4,
		combat_def = 10,
		combat_armor = 10,
		inc_stats = { [Stats.STAT_MAG] = 4, [Stats.STAT_WIL] = 4, [Stats.STAT_CUN] = 4, },
		combat_spellpower = 15,
		combat_spellresist = 18,
		combat_mentalresist = 15,
		resists={[DamageType.FIRE] = 10, [DamageType.COLD] = 10},
		on_melee_hit={[DamageType.ARCANE] = 15},
		mana_regen = 1,
	},
}

newEntity{ base = "BASE_CLOTH_ARMOR", define_as = "SET_TEMPORAL_ROBE",
	power_source = {arcane=true},
	unique = true,
	name = "Temporal Augmentation Robe - Designed In-Style", color = colors.BLACK, image = "object/artifact/robe_temporal_augmentation_robe.png",
	unided_name = "stylish robe with a scarf",
	kr_name = "최신 유행의 시간증대 로브", kr_unided_name = "스카프 달린 멋진 로브",
	desc = [[조금 기발한 괴리 마법사가 설계한 것으로, 이 로브는 언제나 발견되는 시기에 유행하는 디자인으로 나타납니다. 많은 모험가들이 괴리 마법사의 제작을 도와 만들어진 이 로브는, 시간이란 것이 얼마나 변덕스럽게 제멋대로인지를 이해하는데 커다란 도움이 됩니다. 신기하게도, 그 네 번째 소유자가 속한 전쟁이 아주 장기화되자, 이 로브에는 아주 길고 무지개빛을 가진 스카프가 달렸습니다.]],
	level_range = {30, 40},
	rarity = 310,
	cost = 540,
	material_level = 4,
	wielder = {
		combat_spellpower = 23,
		inc_damage = {[DamageType.TEMPORAL]=20},
		combat_def = 9,
		combat_armor = 3,
		inc_stats = { [Stats.STAT_MAG] = 5, [Stats.STAT_WIL] = 3, },
		resists={[DamageType.TEMPORAL] = 20},
		resists_pen = { [DamageType.TEMPORAL] = 20 },
		on_melee_hit={[DamageType.TEMPORAL] = 10},
	},
	max_power = 25, power_regen = 1,
	use_talent = { id = Talents.T_DAMAGE_SMEARING, level = 1, power = 25 },

	set_list = { {"define_as", "SET_TEMPORAL_FEZ"} },
	on_set_complete = function(self, who)
	end,
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_WIZARD_HAT", define_as = "SET_TEMPORAL_FEZ",
	power_source = {arcane=true, psionic=true},
	unique = true,
	name = "Un'fezan's Cap",
	kr_name = "운'페잔의 모자",
	unided_name = "red stylish hat",
	kr_unided_name = "멋진 붉은색 모자",
	desc = [[이 페즈는 한 여행자의 소유물이었던 것으로, 언제나 기묘한 곳에 떨어져 있습니다.
#{italic}#페즈는 멋져. (닥터 후 패러디)#{normal}#]],
	color = colors.BLUE, image = "object/artifact/fez.png",
	moddable_tile = "special/fez",
	moddable_tile_big = true,
	level_range = {20, 40},
	rarity = 300,
	cost = 100,
	material_level = 3,
	wielder = {
		combat_def = 1,
		combat_spellpower = 8,
		combat_mindpower = 8,
		inc_stats = { [Stats.STAT_WIL] = 4, [Stats.STAT_CUN] = 8, },
		paradox_reduce_fails = 10,
		resists = {
			[DamageType.TEMPORAL] = 20,
		},
		talents_types_mastery = {
			["chronomancy/timetravel"]=0.2,
		},
	},
	max_power = 15, power_regen = 1,
	use_talent = { id = Talents.T_WORMHOLE, level = 1, power = 15 },

	set_list = { {"define_as", "SET_TEMPORAL_ROBE"} },
	on_set_complete = function(self, who)
		game.logPlayer(who, "#STEEL_BLUE#시간의 소용돌이가 당신 앞에 잠깐 나타났습니다.")
		self:specialSetAdd({"wielder","paradox_reduce_fails"}, 40)
		self:specialSetAdd({"wielder","confusion_immune"}, 0.4)
		self:specialSetAdd({"wielder","combat_spellspeed"}, 0.1)
		self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.TEMPORAL] = 10 })
	end,
	on_set_broken = function(self, who)
		self.use_talent = nil
		game.logPlayer(who, "#STEEL_BLUE#시간의 소용돌이가 당신 앞에 잠깐 나타났습니다.")
	end,
}

newEntity{ base = "BASE_BATTLEAXE",
	power_source = {technique=true},
	unique = true,
	unided_name = "crude iron battle axe",
	name = "Crude Iron Battle Axe of Kroll", color = colors.GREY, image = "object/artifact/crude_iron_battleaxe_of_kroll.png",
	kr_name = "크롤의 조잡한 무쇠 대형도끼", kr_unided_name = "조잡한 무쇠 대형도끼",
	desc = [[드워프가 아름다운 손재주를 배우기 이전의 시절에 만든, 거친 모습의 도끼입니다. 비록 그 생김새는 조잡하지만, 이 도끼는 거대한 힘을 숨기고 있습니다. 드워프만이 그 진정한 힘을 사용할 수 있습니다.]],
	require = { stat = { str=50 }, },
	level_range = {39, 46},
	rarity = 300,
	material_level = 4,
	combat = {
		dam = 68,
		apr = 7,
		physcrit = 10,
		dammod = {str=1.3},
	},
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 2, [Stats.STAT_DEX] = 2, },
		combat_def = 6, combat_armor = 6,
		inc_damage = { [DamageType.PHYSICAL]=10 },
		stun_immune = 0.3,
		knockback_immune = 0.3,
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Dwarf" then
			local Stats = require "engine.interface.ActorStats"

			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_CON] = 7, [Stats.STAT_DEX] = 7, })
			self:specialWearAdd({"wielder","stun_immune"}, 0.7)
			self:specialWearAdd({"wielder","knockback_immune"}, 0.7)
			game.logPlayer(who, "#LIGHT_BLUE#도끼를 쥐자, 조상으로부터 이어진 힘이 밀려오는 것을 느꼈습니다!")
		end
	end,
}

newEntity{ base = "BASE_WHIP",
	power_source = {nature=true},
	unided_name = "metal whip",
	name = "Scorpion's Tail", color=colors.GREEN, unique = true, image = "object/artifact/whip_scorpions_tail.png",
	kr_name = "전갈의 꼬리", kr_unided_name = "금속 채찍",
	desc = [[금속 조각들이 연결된, 기다란 채찍입니다. 그 끝에는 맹독이 새어나오는 날카로운 가시가 달려 있습니다.]],
	require = { stat = { dex=28 }, },
	cost = 150,
	rarity = 340,
	level_range = {20, 30},
	material_level = 3,
	combat = {
		dam = 28,
		apr = 8,
		physcrit = 5,
		dammod = {dex=1},
		melee_project={[DamageType.POISON] = 22, [DamageType.BLEED] = 22},
		talent_on_hit = { T_DISARM = {level=3, chance=10} },
	},
	wielder = {
		combat_atk = 10,
		see_invisible = 9,
		see_stealth = 9,
	},
}

newEntity{ base = "BASE_LEATHER_BELT",
	power_source = {nature=true},
	unique = true,
	name = "Girdle of Preservation", image = "object/artifact/belt_girdle_of_preservation.png",
	unided_name = "shimmering, flawless belt",
	kr_name = "보존의 허리띠", kr_unided_name = "희미하게 빛나는 깨끗한 허리띠",
	desc = [[룬이 새겨진 보라툰 죔쇠가 달린, 가장 순수한 흰 가죽의 완벽한 허리띠입니다. 이 허리띠는 시간이나 환경적인 손상을 전혀 받지 않은 것 같습니다.]],
	color = colors.WHITE,
	level_range = {45, 50},
	rarity = 400,
	cost = 750,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 5, [Stats.STAT_WIL] = 5,  },
		resists = {
			[DamageType.ACID] = 15,
			[DamageType.LIGHTNING] = 15,
			[DamageType.FIRE] = 15,
			[DamageType.COLD] = 15,
			[DamageType.LIGHT] = 15,
			[DamageType.DARKNESS] = 15,
			[DamageType.BLIGHT] = 15,
			[DamageType.TEMPORAL] = 15,
			[DamageType.NATURE] = 15,
			[DamageType.PHYSICAL] = 10,
			[DamageType.ARCANE] = 10,
		},
		confusion_immune = 0.2,
		combat_physresist = 15,
		combat_mentalresist = 15,
		combat_spellresist = 15,
	},
}

newEntity{ base = "BASE_LEATHER_BELT",
	power_source = {nature=true},
	unique = true,
	name = "Girdle of the Calm Waters", image = "object/artifact/girdle_of_the_calm_waters.png",
	unided_name = "golden belt",
	kr_name = "차분한 물의 허리띠", kr_unided_name = "금빛 허리띠",
	desc = [[자연 속에 은둔하던 치료사가 사용하던 것이라는 소문이 있는, 금빛 허리띠입니다.]],
	color = colors.GOLD,
	level_range = {5, 14},
	rarity = 120,
	cost = 75,
	material_level = 1,
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 3,  },
		resists = {
			[DamageType.COLD] = 20,
			[DamageType.BLIGHT] = 20,
			[DamageType.NATURE] = 20,
		},
		healing_factor = 0.3,
	},
}

newEntity{ base = "BASE_LIGHT_ARMOR",
	power_source = {technique=true},
	unique = true,
	name = "Behemoth Hide", image = "object/artifact/behemoth_skin.png",
	unided_name = "tough weathered hide",
	kr_name = "베헤모스 가죽", kr_unided_name = "거칠게 풍화된 가죽",
	desc = [[거대한 짐승에게서 떼어낸, 거친 가죽입니다. 좀 낡아 보이지만 아직 쓸만하고, 어딘가 특별한 기운도 느껴집니다...]],
	color = colors.BROWN,
	level_range = {18, 23},
	rarity = 230,
	require = { stat = { str=22 }, },
	cost = 250,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 2, [Stats.STAT_CON] = 2 },

		combat_armor = 6,
		combat_def = 4,
		combat_def_ranged = 8,

		max_encumber = 20,
		life_regen = 0.7,
		stamina_regen = 0.7,
		fatigue = 10,
		max_stamina = 43,
		max_life = 45,
		knockback_immune = 0.1,
		size_category = 1,
	},
}

newEntity{ base = "BASE_LIGHT_ARMOR",
	power_source = {technique=true},
	unique = true,
	name = "Skin of Many", image = "object/artifact/robe_skin_of_many.png",
	unided_name = "stitched skin armour",
	kr_name = "여러가지의 가죽", kr_unided_name = "꿰맨 가죽 갑옷",
	desc = [[많은 생명체의 가죽을 하나로 꿰매어 만든 것입니다. 몇몇 눈과 입이 그대로 달려 있고, 그 중 일부는 여전히 살아있어 고통에 찬 비명을 지릅니다.]],
	color = colors.BROWN,
	level_range = {12, 22},
	rarity = 200,
	require = { stat = { str=16 }, },
	cost = 200,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 4 },
		combat_armor = 6,
		combat_def = 12,
		fatigue = 7,
		max_life = 40,
		infravision = 3,
		talents_types_mastery = { ["cunning/stealth"] = -0.2, },
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Undead" then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"wielder", "talents_types_mastery"}, { ["cunning/stealth"] = 0.2 })
			self:specialWearAdd({"wielder","confusion_immune"}, 0.3)
			self:specialWearAdd({"wielder","fear_immune"}, 0.3)
			game.logPlayer(who, "#DARK_BLUE#이 가죽은 언데드에게 입힌 것을 만족하면서, 조용해졌습니다.")
		end
	end,
}

newEntity{ base = "BASE_HEAVY_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "Iron Mail of Bloodletting", image = "object/artifact/iron_mail_of_bloodletting.png",
	unided_name = "gore-encrusted suit of iron mail",
	kr_name = "피흘리는 무쇠 갑옷", kr_unided_name = "피로 덮인 무쇠 갑옷",
	desc = [[이 무서운 무쇠 갑옷에서는 끊임없이 피가 흐르고 있으며, 어둠의 마법이 그 주변을 휘감고 있는 것이 뚜렷하게 보입니다. 이것의 착용자와 맞서 싸우는 적에게, 피의 파멸을 부릅니다.]],
	color = colors.RED,
	level_range = {15, 25},
	rarity = 190,
	require = { stat = { str=14 }, },
	cost = 200,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 2, [Stats.STAT_STR] = 2 },
		resists = {
			[DamageType.ACID] = 10,
			[DamageType.DARKNESS] = 10,
			[DamageType.FIRE] = 10,
			[DamageType.BLIGHT] = 10,
		},
		talents_types_mastery = { ["technique/bloodthirst"] = 0.1 },
		life_regen = 0.5,
		healing_factor = 0.3,
		combat_def = 2,
		combat_armor = 4,
		fatigue = 12,
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_BLOODCASTING, level = 2, power = 60 },
}


newEntity{ base = "BASE_HEAVY_ARMOR", define_as = "SCALE_MAIL_KROLTAR",
	power_source = {technique=true, nature=true},
	unique = true,
	name = "Scale Mail of Kroltar", image = "object/artifact/scale_mail_of_kroltar.png",
	unided_name = "perfectly-wrought suit of dragon scales",
	kr_name = "크롤타르의 비늘 갑옷", kr_unided_name = "완벽하게 무두질된 용 비늘 갑옷",
	desc = [[크롤타르가 남긴 비늘로 만든 갑옷으로, 열 겹으로 겹친 방패와도 같은 훌륭한 방어력을 제공합니다.]],
	color = colors.LIGHT_RED,
	metallic = false,
	level_range = {38, 45},
	rarity = 300,
	require = { stat = { str=38 }, },
	cost = 500,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 4, [Stats.STAT_STR] = 5, [Stats.STAT_DEX] = 3 },
		resists = {
			[DamageType.ACID] = 20,
			[DamageType.LIGHTNING] = 20,
			[DamageType.FIRE] = 20,
			[DamageType.BLIGHT] = 20,
			[DamageType.NATURE] = 20,
		},
		max_life=120,
		combat_def = 10,
		combat_armor = 18,
		fatigue = 16,
	},
	max_power = 80, power_regen = 1,
	use_talent = { id = Talents.T_INFERNO, level = 3, power = 50 },
	set_list = { {"define_as","HELM_KROLTAR"} },
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","max_life"}, 120)
		self:specialSetAdd({"wielder","fatigue"}, -8)
		self:specialSetAdd({"wielder","combat_def"}, 10)
	end,
}

newEntity{ base = "BASE_MASSIVE_ARMOR",
	power_source = {technique=true},
	unique = true,
	name = "Cuirass of the Thronesmen", image = "object/artifact/armor_cuirass_of_the_thronesmen.png",
	unided_name = "heavy dwarven-steel armour",
	kr_name = "왕좌의 이들을 위한 흉갑", kr_unided_name = "무거운 드워프강철 갑옷",
	desc = [[이 무거운 드워프강철 갑옷은 철의 왕좌에서도 가장 깊고 은밀한 대장간에서 만든 것입니다. 비교할 수 없을 정도의 방어력을 보여주지만, 그만큼 강력한 힘을 요구합니다.]],
	color = colors.WHITE,
	level_range = {35, 40},
	rarity = 320,
	require = { stat = { str=44 }, },
	cost = 500,
	material_level = 4,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 6, },
		resists = {
			[DamageType.FIRE] = 25,
			[DamageType.DARKNESS] = 25,
		},
		combat_def = 20,
		combat_armor = 32,
		combat_armor_hardiness = 10,
		stun_immune = 0.4,
		knockback_immune = 0.4,
		combat_physresist = 40,
		healing_factor = -0.3,
		fatigue = 15,
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Dwarf" then
			local Talents = require "engine.interface.ActorStats"

			self:specialWearAdd({"wielder","max_life"}, 100)
			self:specialWearAdd({"wielder","fatigue"}, -15)

			game.logPlayer(who, "#LIGHT_BLUE#이 갑옷의 도전을 받아들일만큼, 당신이 가진 드워프의 힘이 크다는 것을 느낍니다!")
		end
	end,
}

newEntity{ base = "BASE_GREATSWORD",
	power_source = {psionic=true},
	unique = true,
	name = "Golden Three-Edged Sword 'The Truth'", image = "object/artifact/golden_3_edged_sword.png",
	unided_name = "three-edged sword",
	kr_name = "황금 세날검 '진실'", kr_unided_name = "세날검",
	desc = [[어떤 현명한 자가 '진실은 세 날 달린 검과 같다' 고 말했습니다. 그리고 가끔씩, 진실은 사람들에게 고통과 아픔을 줍니다.]],
	level_range = {27, 36},
	require = { stat = { str=18, wil=18, cun=18 }, },
	color = colors.GOLD,
	encumber = 12,
	cost = 350,
	rarity = 240,
	material_level = 3,
	moddable_tile = "special/golden_sword_right",
	moddable_tile_big = true,
	combat = {
		dam = 49,
		apr = 9,
		physcrit = 9,
		dammod = {str=1.29},
		special_on_hit = {desc="9% 확률로 목표에게 기절이나 혼란 효과 부여", fct=function(combat, who, target)
			if not rng.percent(9) then return end
			local eff = rng.table{"stun", "confusion"}
			if not target:canBe(eff) then return end
			if not target:checkHit(who:combatAttack(combat), target:combatPhysicalResist(), 15) then return end
			if eff == "stun" then target:setEffect(target.EFF_STUNNED, 3, {})
			elseif eff == "confusion" then target:setEffect(target.EFF_CONFUSED, 3, {power=75})
			end
		end},
		melee_project={[DamageType.LIGHT] = 49, [DamageType.DARKNESS] = 49},
	},
}

newEntity{ base = "BASE_MACE",
	power_source = {nature=true},
	name = "Ureslak's Femur", define_as = "URESLAK_FEMUR", image="object/artifact/club_ureslaks_femur.png",
	unided_name = "a strangely colored bone", unique = true,
	kr_name = "우레슬락의 대퇴골", kr_unided_name = "이상한 색깔의 뼈",
	desc = [[강력한 무지개빛 용의 대퇴골을 짧게 만든 것으로, 이 괴상한 곤봉은 우레슬락의 변덕스런 자연력으로 아직도 맥동하고 있습니다.]],
	level_range = {42, 50},
	require = { stat = { str=45, dex=30 }, },
	rarity = 400,
	metallic = false,
	cost = 300,
	material_level = 5,
	combat = {
		dam = 52,
		apr = 5,
		physcrit = 2.5,
		dammod = {str=1},
		special_on_hit = {desc="10% 확률로 색이 변하면서 속성과 능력치 변화", on_kill=1, fct=function(combat, who, target)
			if not rng.percent(10) then return end
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "URESLAK_FEMUR")
			if not o or not who:getInven(inven_id).worn then return end

			who:onTakeoff(o, inven_id, true)
			local b = rng.table(o.ureslak_bonuses)
			o.kr_name = "우레슬락의 "..(b.kr_name or b.name).." 대퇴골" --@ 한글 이름 추가
			o.name = "Ureslak's "..b.name.." Femur"
			o.combat.damtype = b.damtype
			o.wielder = b.wielder
			who:onWear(o, inven_id, true)
			game.logSeen(who, "#GOLD#우레슬락의 대퇴골이 어른거리면서 빛납니다!")
		end },
	},
	ureslak_bonuses = {
		{ name = "Flaming", kr_name = "불타는", damtype = DamageType.FIREBURN, wielder = {
			global_speed_add = 0.3,
			resists = { [DamageType.FIRE] = 45 },
			resists_pen = { [DamageType.FIRE] = 30 },
			inc_damage = { [DamageType.FIRE] = 30 },
		} },
		{ name = "Frozen", kr_name = "얼어붙은", damtype = DamageType.ICE, wielder = {
			combat_armor = 15,
			resists = { [DamageType.COLD] = 45 },
			resists_pen = { [DamageType.COLD] = 30 },
			inc_damage = { [DamageType.COLD] = 30 },
		} },
		{ name = "Crackling", kr_name = "파직거리는", damtype = DamageType.LIGHTNING_DAZE, wielder = {
			inc_stats = { [Stats.STAT_STR] = 6, [Stats.STAT_DEX] = 6, [Stats.STAT_CON] = 6, [Stats.STAT_CUN] = 6, [Stats.STAT_WIL] = 6, [Stats.STAT_MAG] = 6, },
			resists = { [DamageType.LIGHTNING] = 45 },
			resists_pen = { [DamageType.LIGHTNING] = 30 },
			inc_damage = { [DamageType.LIGHTNING] = 30 },
		} },
		{ name = "Venomous", kr_name = "유독성", damtype = DamageType.POISON, wielder = {
			resists = { all = 15, [DamageType.NATURE] = 45 },
			resists_pen = { [DamageType.NATURE] = 30 },
			inc_damage = { [DamageType.NATURE] = 30 },
		} },
		{ name = "Starry", kr_name = "별빛의", damtype = DamageType.DARKNESS_BLIND, wielder = {
			combat_spellresist = 15, combat_mentalresist = 15, combat_physresist = 15,
			resists = { [DamageType.DARKNESS] = 45 },
			resists_pen = { [DamageType.DARKNESS] = 30 },
			inc_damage = { [DamageType.DARKNESS] = 30 },
		} },
		{ name = "Eldritch", kr_name = "섬뜩한", damtype = DamageType.ARCANE, wielder = {
			resists = { [DamageType.ARCANE] = 45 },
			resists_pen = { [DamageType.ARCANE] = 30 },
			inc_damage = { all = 12, [DamageType.ARCANE] = 30 },
		} },
	},
}

newEntity{ base = "BASE_WARAXE",
	power_source = {psionic=true},
	unique = true, unided_name = "razor sharp war axe",
	name = "Razorblade, the Cursed Waraxe", color = colors.LIGHT_BLUE, image = "object/artifact/razorblade_the_cursed_waraxe.png",
	kr_name = "저주받은 전투도끼, '면도날'", kr_unided_name = "면도날처럼 생긴 전투도끼",
	desc = [[이 강력한 도끼는 날카로운 칼처럼 갑옷을 찢을 수도 있고, 무거운 곤봉과도 같은 충격을 줄 수도 있습니다.
이것을 쥔 사람은 천천히 미쳐간다는 소문이 있습니다. 아직까지 이 소문의 진위를 가려줄 사용자가 아무도 없었기 때문에, 소문이 진실인지는 알 수 없습니다.]],
	require = { stat = { str=42 }, },
	level_range = {40, 50},
	rarity = 250,
	material_level = 5,
	combat = {
		dam = 58,
		apr = 16,
		physcrit = 7,
		dammod = {str=1},
		damrange = 1.4,
		damtype = DamageType.PHYSICALBLEED,
	},
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 4, [Stats.STAT_DEX] = 4, },
		see_invisible = 5,
		inc_damage = { [DamageType.PHYSICAL]=10 },
	},
}

newEntity{ base = "BASE_LONGSWORD", define_as = "ART_PAIR_TWSWORD",
	power_source = {arcane=true},
	unique = true,
	name = "Sword of Potential Futures", image = "object/artifact/sword_of_potential_futures.png",
	unided_name = "under-wrought blade",
	kr_name = "잠재적 미래의 검", kr_unided_name = "미완성의 칼",
	desc = [[전설에 따르면, 이 검에는 짝이 있다고 합니다. 두 쌍둥이 검은 시간의 감시자가 갓 만들어졌을 무렵에 만들어진 것입니다. 시간의 감시자가 이 검을 들면, 훈련되지 않은 착용자가 이끌어낼 수 없었던 힘인 잠재적인 시간에 손을 댈 수 있게 됩니다.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { str=24, mag=24 }, },
	cost = 300,
	material_level = 3,
	combat = {
		dam = 28,
		apr = 10,
		physcrit = 8,
		physspeed = 0.9,
		dammod = {str=0.8,mag=0.2},
		melee_project={[DamageType.TEMPORAL] = 5},
		convert_damage = {
			[DamageType.TEMPORAL] = 30,
	},
	},
	wielder = {
		inc_damage={
			[DamageType.TEMPORAL] = 5,
		},
		combat_spellpower = 5,
		combat_spellcrit = 5,
		resist_all_on_teleport = 5,
		defense_on_teleport = 10,
		effect_reduction_on_teleport = 15,
	},
	set_list = { {"define_as","ART_PAIR_TWDAG"} },
	on_set_complete = function(self, who)
		self.combat.special_on_hit = {desc="10% 확률로 목표의 전체 속성 저항 감소", fct=function(combat, who, target)
			if not rng.percent(10) then return end
			target:setEffect(target.EFF_FLAWED_DESIGN, 3, {power=20})
		end}
		self:specialSetAdd({"wielder","inc_damage"}, {[engine.DamageType.TEMPORAL]=5, [engine.DamageType.PHYSICAL]=10,})
		game.logSeen(who, "#CRIMSON#두 칼이 다시 뭉치자, 시간의 메아리가 다시 한번 울려 퍼집니다.")
	end,
	on_set_broken = function(self, who)
		self.combat.special_on_hit = nil
		game.logPlayer(who, "#CRIMSON#두 칼이 분리되자, 시간의 완벽함이 줄어드는 것을 느꼈습니다.")
	end,
}

newEntity{ base = "BASE_KNIFE", define_as = "ART_PAIR_TWDAG",
	power_source = {arcane=true},
	unique = true,
	name = "Dagger of the Past", image = "object/artifact/dagger_of_the_past.png",
	unided_name = "rusted blade",
	kr_name = "과거의 단검", kr_unided_name = "녹슨 칼",
	desc = [[전설에 따르면, 이 검에는 짝이 있다고 합니다. 두 쌍둥이 검은 시간의 감시자가 갓 만들어졌을 무렵에 만들어진 것입니다. 시간의 감시자가 이 검을 들면, 훈련되지 않은 착용자가 이끌어낼 수 없었던 힘인 과거의 실수를 통해 배울 수 있는 능력을 얻게 됩니다.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { dex=24, mag=24 }, },
	cost = 300,
	material_level = 3,
	combat = {
		dam = 25,
		apr = 20,
		physcrit = 20,
		physspeed = 0.9,
		dammod = {dex=0.5,mag=0.5},
		melee_project={[DamageType.TEMPORAL] = 5},
		convert_damage = {
			[DamageType.TEMPORAL] = 30,
	},
	},
	wielder = {
		inc_damage={
			[DamageType.TEMPORAL] = 5,
		},
		movement_speed = 0.20,
		combat_def = 10,
		combat_spellresist = 10,
		resist_all_on_teleport = 5,
		defense_on_teleport = 10,
		effect_reduction_on_teleport = 15,
	},
	set_list = { {"define_as","ART_PAIR_TWSWORD"} },
	on_set_complete = function(self, who)
		self.combat.special_on_hit = {desc="10% 확률로 목표를 어렸을 적으로 회귀", fct=function(combat, who, target)
			if not rng.percent(10) then return end
			target:setEffect(target.EFF_TURN_BACK_THE_CLOCK, 3, {power=10})
		end}
		self:specialSetAdd({"wielder","inc_damage"}, {[engine.DamageType.TEMPORAL]=5, [engine.DamageType.PHYSICAL]=10,})
		self:specialSetAdd({"wielder","resists_pen"}, {[engine.DamageType.TEMPORAL]=15,})
	end,
	on_set_broken = function(self, who)
		self.combat.special_on_hit = nil
	end,
}

newEntity{ base = "BASE_GAUNTLETS",
	power_source = {arcane=true},
	unique = true,
	name = "Stone Gauntlets of Harkor'Zun", image = "object/artifact/harkor_zun_gauntlets.png",
	unided_name = "dark stone gauntlets",
	kr_name = "하코르'준의 암석 전투장갑", kr_unided_name = "어두운 암석 전투장갑",
	desc = [[고대에 하코르'준의 광신도가 만든 물건입니다. 이 무거운 화강암 전투장갑은, 그들이 신봉하는 어둠의 지배자의 분노로부터 착용자를 보호하기 위해 설계되었습니다.]],
	level_range = {26, 31},
	rarity = 210,
	encumber = 7,
	metallic = false,
	cost = 150,
	material_level = 3,
	wielder = {
		talent_cd_reduction={
			[Talents.T_CLINCH]=2,
		},
		fatigue = 10,
		combat_armor = 7,
		inc_damage = { [DamageType.PHYSICAL]=5, [DamageType.ACID]=10, },
		resists = {[DamageType.ACID] = 20, [DamageType.PHYSICAL] = 10, },
		resists_cap = {[DamageType.ACID] = 10, [DamageType.PHYSICAL] = 5, },
		resists_pen = {[DamageType.ACID] = 15, [DamageType.PHYSICAL] = 15, },
		combat = {
			dam = 26,
			apr = 15,
			physcrit = 5,
			dammod = {dex=0.3, str=-0.4, cun=0.3 },
			melee_project={[DamageType.ACID] = 10},
			talent_on_hit = { T_EARTHEN_MISSILES = {level=3, chance=20}, T_CORROSIVE_MIST = {level=1, chance=10} },
			damrange = 0.3,
			physspeed = 0.2,
		},
	},
}

newEntity{ base = "BASE_AMULET",
	power_source = {arcane=true, psionic=true},
	unique = true,
	name = "Unflinching Eye", color = colors.WHITE, image = "object/artifact/amulet_unflinching_eye.png",
	unided_name = "a bloodshot eye",
	kr_name = "감기지 않는 눈", kr_unided_name = "충혈된 눈",
	desc = [[어떤 자가 짙은 검정색 노끈을 이 크고 충혈된 눈알에 엮어, 목에 걸 수 있도록 만든 것입니다. 사용할지 말지는 당신의 선택입니다.]],
	level_range = {30, 40},
	rarity = 300,
	cost = 300,
	material_level = 4,
	metallic = false,
	wielder = {
		infravision = 3,
		resists = { [DamageType.LIGHT] = -25 },
		resists_cap = { [DamageType.LIGHT] = -25 },
		blind_immune = 1,
		confusion_immune = 0.5,
		esp = { horror = 1 }, esp_range = 10,
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_ARCANE_EYE, level = 2, power = 60 },
}

newEntity{ base = "BASE_CLOAK",
	power_source = {nature=true},
	unique = true,
	name = "Ureslak's Molted Scales", image = "object/artifact/ureslaks_molted_scales.png",
	unided_name = "scaley multi-hued cloak",
	kr_name = "우레슬락의 녹은 비늘", kr_unided_name = "무지개빛 비늘 망토",
	desc = [[이 망토는 커다란 파충류의 비늘로 만들어진 것으로, 무지개의 모든 색을 반사해내고 있습니다.]],
	level_range = {40, 50},
	rarity = 400,
	cost = 300,
	material_level = 5,
	wielder = {
		resists_cap = {
			[DamageType.FIRE] = 5,
			[DamageType.COLD] = 5,
			[DamageType.LIGHTNING] = 5,
			[DamageType.NATURE] = 5,
			[DamageType.DARKNESS] = 5,
			[DamageType.ARCANE] = -30,
		},
		resists = {
			[DamageType.FIRE] = 20,
			[DamageType.COLD] = 20,
			[DamageType.LIGHTNING] = 20,
			[DamageType.NATURE] = 20,
			[DamageType.DARKNESS] = 20,
			[DamageType.ARCANE] = -30,
		},
	},
}

newEntity{ base = "BASE_DIGGER",
	power_source = {technique=true},
	unique = true,
	name = "Pick of Dwarven Emperors", color = colors.GREY, image = "object/artifact/pick_of_dwarven_emperors.png",
	unided_name = "crude iron pickaxe",
	kr_name = "드워프 황제의 곡괭이", kr_unided_name = "조잡한 무쇠 곡괭이",
	desc = [[이 고대의 곡괭이는 이전 세대에서 다음 세대로 이어져 내려온 드워프의 전설입니다. 머리와 자루에는 룬이 빼곡히 새겨져 있으며, 이 룬에는 드워프의 역사가 적혀 있습니다.]],
	level_range = {40, 50},
	rarity = 290,
	cost = 150,
	material_level = 5,
	digspeed = 12,
	wielder = {
		resists_pen = { [DamageType.PHYSICAL] = 10, },
		inc_stats = { [Stats.STAT_STR] = 3, [Stats.STAT_CON] = 3, },
		combat_mentalresist = 7,
		combat_physresist = 7,
		combat_spellresist = 7,
		max_life = 50,
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Dwarf" then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"wielder","inc_stats"}, { [Stats.STAT_STR] = 5, [Stats.STAT_CON] = 5, })
			self:specialWearAdd({"wielder","inc_damage"}, { [engine.DamageType.PHYSICAL] = 10 })
			self:specialWearAdd({"wielder", "talents_types_mastery"}, { ["race/dwarf"] = 0.2 })

			game.logPlayer(who, "#LIGHT_BLUE#곡괭이를 쥐자, 조상들의 속삭임이 느껴집니다!")
		end
	end,
}

newEntity{ base = "BASE_ARROW",
	power_source = {arcane=true},
	unique = true,
	name = "Quiver of the Sun",
	unided_name = "bright quiver",
	kr_name = "태양의 화살통", kr_unided_name = "밝은 화살통",
	desc = [[놋쇠로 만들어졌으며, 빛을 쬐면 반짝거리면서 달아오르는 빨간색 룬이 많이 새겨진 이상한 화살통입니다. 이 안에 있는 화살들은 마치 햇빛처럼 뜨거운 빛을 내고 있으며, 단단하게 연마되어 있습니다.]],
	color = colors.BLUE, image = "object/artifact/quiver_of_the_sun.png",
	level_range = {20, 40},
	rarity = 300,
	cost = 100,
	material_level = 4,
	require = { stat = { dex=24 }, },
	combat = {
		capacity = 25,
		tg_type = "beam",
		travel_speed = 3,
		dam = 34,
		apr = 15, --Piercing is piercing
		physcrit = 2,
		dammod = {dex=0.7, str=0.5},
		damtype = DamageType.LITE_LIGHT,
	},
}

newEntity{ base = "BASE_ARROW",
	power_source = {psionic=true},
	unique = true,
	name = "Quiver of Domination",
	unided_name = "grey quiver",
	kr_name = "지배의 화살통", kr_unided_name = "회색 화살통",
	desc = [[이 화살통에 있는 화살에서는 강력한 정신 감응력이 발산되고 있습니다. 화살촉은 둔해 보이지만, 만져보면 강렬한 고통이 전해집니다.]],
	color = colors.GREY, image = "object/artifact/quiver_of_domination.png",
	level_range = {20, 40},
	rarity = 300,
	cost = 100,
	material_level = 4,
	require = { stat = { dex=24 }, },
	combat = {
		capacity = 20,
		dam = 24,
		apr = 8,
		physcrit = 2,
		dammod = {dex=0.6, str=0.5, wil=0.2},
		damtype = DamageType.MIND,
		special_on_crit = {desc="목표를 지배", fct=function(combat, who, target)
			if not target or target == self then return end
			if target:canBe("instakill") then
				local check = math.max(who:combatSpellpower(), who:combatMindpower(), who:combatAttack())
				target:setEffect(target.EFF_DOMINATE_ENTHRALL, 3, {src=who, apply_power=check})
			end
		end},
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {nature=true, antimagic=true},
	unique = true,
	name = "Blightstopper",
	unided_name = "vine coated shield",
	moddable_tile = "special/%s_blightstopper",
	moddable_tile_big = true,
	kr_name = "황폐차단기", kr_unided_name = "덩굴 감긴 방패",
	desc = [[이 보라툰 방패는 두꺼운 덩굴이 감겨있으며, 이 덩굴에는 하플링 장군 알마다르 리울이 불어넣은 자연의 힘이 들어있습니다. 이 하플링 장군은 장작더미의 시대에 벌어졌던 전투에서, 오크 타락자들의 마법과 질병을 막기 위해 이 방패를 사용했습니다.]],
	color = colors.LIGHT_GREEN, image = "object/artifact/blightstopper.png",
	level_range = {36, 45},
	rarity = 300,
	require = { stat = { str=35 }, },
	cost = 375,
	material_level = 5,
	special_combat = {
		dam = 52,
		block = 240,
		physcrit = 4.5,
		dammod = {str=1},
		damtype = DamageType.PHYSICAL,
		convert_damage = {
			[DamageType.NATURE] = 30,
			[DamageType.MANABURN] = 10,
		},
	},
	wielder = {
		resists={[DamageType.BLIGHT] = 35, [DamageType.NATURE] = 15},
		on_melee_hit={[DamageType.NATURE] = 15},
		combat_armor = 12,
		combat_def = 18,
		combat_def_ranged = 12,
		combat_spellresist = 24,
		talents_types_mastery = { ["wild-gift/antimagic"] = 0.2, },
		fatigue = 22,
		learn_talent = { [Talents.T_BLOCK] = 5,},
		disease_immune = 0.6,
	},
	max_power = 40, power_regen = 1,
	use_power = { name = "purge diseases and increase your resistances", kr_name = "질병 정화 및 면역력 상승",  power = 24,
	use = function(self, who)
		local target = who
		local effs = {}
		local known = false

		who:setEffect(who.EFF_PURGE_BLIGHT, 5, {power=20})

			-- Go through all spell effects
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.subtype.disease then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, 3 + math.floor(who:getWil() / 10) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				target:removeEffect(eff[2])
				known = true
			end
		end
		game.logSeen(who, "%s의 질병이 정화되었습니다!", (who.kr_name or who.name):capitalize())
		return {id=true, used=true}
	end,
	},
	on_wear = function(self, who)
		if who:attr("forbid_arcane") then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"wielder","resists"}, {[DamageType.ARCANE] = 15, [DamageType.BLIGHT] = 5})
			self:specialWearAdd({"wielder","disease_immune"}, 0.15)
			self:specialWearAdd({"wielder","poison_immune"}, 0.5)
			game.logPlayer(who, "#DARK_GREEN#자연의 힘이 당신을 보호하는 것이 느껴집니다!")
		end
	end,
}

newEntity{ base = "BASE_SHOT",
	power_source = {arcane=true},
	unique = true,
	name = "Star Shot",
	unided_name = "blazing shot",
	kr_name = "유성탄", kr_unided_name = "타오르는 탄환",
	desc = [[강렬한 열기가 발산되고 있는 강력한 탄환입니다.]],
	color = colors.RED, image = "object/artifact/star_shot.png",
	level_range = {25, 40},
	rarity = 300,
	cost = 110,
	material_level = 4,
	require = { stat = { dex=28 }, },
	combat = {
		capacity = 20,
		dam = 32,
		apr = 15,
		physcrit = 10,
		dammod = {dex=0.7, cun=0.5},
		damtype = DamageType.FIRE,
		special_on_hit = {desc="강렬한 폭발 발생", on_kill=1, fct=function(combat, who, target)
			local tg = {type="ball", range=0, radius=3, selffire=false}
			local grids = who:project(tg, target.x, target.y, engine.DamageType.FIREKNOCKBACK, {dist=3, dam=40 + who:getMag()*0.6 + who:getCun()*0.6})
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_fire", {radius=tg.radius})
		end},
	},
}

--[[ For now
newEntity{ base = "BASE_MINDSTAR",
	power_source = {psionic=true},
	unique = true,
	name = "Withered Force", define_as = "WITHERED_STAR",
	unided_name = "dark mindstar",
	level_range = {28, 38},
	color=colors.AQUAMARINE,
	rarity = 250,
	desc = [=[A hazy aura emanates from this ancient gem, coated with withering, thorny vines.]=],
	cost = 98,
	require = { stat = { wil=24 }, },
	material_level = 4,
	combat = {
		dam = 16,
		apr = 28,
		physcrit = 5,
		dammod = {wil=0.45, cun=0.25},
		damtype = DamageType.MIND,
		convert_damage = {
			[DamageType.DARKNESS] = 30,
		},
		talents_types_mastery = {
			["cursed/gloom"] = 0.2,
			["cursed/darkness"] = 0.2,
		}
	},
	ms_combat = {},
	wielder = {
		combat_mindpower = 14,
		combat_mindcrit = 7,
		inc_damage={
			[DamageType.DARKNESS] 	= 10,
			[DamageType.PHYSICAL]	= 10,
		},
		inc_stats = { [Stats.STAT_WIL] = 4,},
		hate_per_kill = 3,
	},
	max_power = 40, power_regen = 1,
	use_power = { name = "switch the weapon between an axe and a mindstar", power = 40,
		use = function(self, who)
		if self.subtype == "mindstar" then
			ms_combat = table.clone(self.combat)
			--self.name	= "Withered Axe"
			if self:isTalentActive (who.T_PSIBLADES) then
				self:forceUseTalent(who.T_PSIBLADES, {ignore_energy=true})
				game.logSeen(who, "%s rejects the inferior psionic blade!", self.name:capitalize())
			end
			self.desc	= [=[A hazy aura emanates from this dark axe, withering, thorny vines twisting around the handle.]=]
			self.subtype = "waraxe"
			self.image = self.resolvers.image_material("axe", "metal")
			self.moddable_tile = self.resolvers.moddable_tile("axe")
					self:removeAllMOs()
			--Set moddable tile here
			self.combat = nil
			self.combat = {
				talented = "axe", damrange = 1.4, physspeed = 1, sound = {"actions/melee", pitch=0.6, vol=1.2}, sound_miss = {"actions/melee", pitch=0.6, vol=1.2},
				no_offhand_penalty = true,
				dam = 34,
				apr = 8,
				physcrit = 7,
				dammod = {str=0.85, wil=0.2},
				damtype = DamageType.PHYSICAL,
				convert_damage = {
					[DamageType.DARKNESS] = 25,
					[DamageType.MIND] = 15,
				},
			}
		else
			--self.name	= "Withered Star"
			self.image = self.resolvers.image_material("mindstar", "nature")
			self.moddable_tile = self.resolvers.moddable_tile("mindstar")
					self:removeAllMOs()
			--Set moddable tile here
			self.desc	= [=[A hazy aura emanates from this ancient gem, coated with withering, thorny vines."]=]
			self.subtype = "mindstar"
			self.combat = nil
			self.combat = table.clone(ms_combat)
		end
		return {id=true, used=true}
		end
	},
}
]]

newEntity{ base = "BASE_MINDSTAR",
	power_source = {psionic=true},
	unique = true,
	name = "Nexus of the Way",
	unided_name = "brilliant green mindstar",
	level_range = {38, 50},
	color=colors.AQUAMARINE, image = "object/artifact/nexus_of_the_way.png",
	rarity = 350,
	kr_name = "'한길' 의 집합체", kr_unided_name = "눈부신 녹색 마석",
	desc = [['한길' 의 막대한 염동력이 이 원석에서 느껴집니다. 마석을 만져보면 압도적인 힘을 느낄수 있으며, 수많은 생각이 들립니다.]],
	cost = 280,
	require = { stat = { wil=48 }, },
	material_level = 5,
	combat = {
		dam = 22,
		apr = 40,
		physcrit = 5,
		dammod = {wil=0.6, cun=0.2},
		damtype = DamageType.MIND,
	},
	wielder = {
		combat_mindpower = 20,
		combat_mindcrit = 9,
		confusion_immune=0.3,
		inc_damage={
			[DamageType.MIND] 	= 20,
		},
		resists={
			[DamageType.MIND] 	= 20,
		},
		resists_pen={
			[DamageType.MIND] 	= 20,
		},
		inc_stats = { [Stats.STAT_WIL] = 6, [Stats.STAT_CUN] = 3, },
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_WAYIST, level = 1, power = 60 },
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Yeek" then
			local Talents = require "engine.interface.ActorStats"
			self:specialWearAdd({"wielder", "talents_types_mastery"}, { ["race/yeek"] = 0.2 })
			self:specialWearAdd({"wielder","combat_mindpower"}, 5)
			self:specialWearAdd({"wielder","combat_mentalresist"}, 15)
			game.logPlayer(who, "#LIGHT_BLUE#당신이 소속된 '한길' 의 힘이 느껴집니다!")
		end
		if who.descriptor and who.descriptor.race == "Halfling" then
			local Talents = require "engine.interface.ActorStats"
			self:specialWearAdd({"wielder","resists"}, {[engine.DamageType.MIND] = -25,})
			self:specialWearAdd({"wielder","combat_mentalresist"}, -20)
			game.logPlayer(who, "#RED#'한길' 의 힘이 과거의 포획자들을 거부합니다!")
		end
	end,
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {psionic=true},
	unique = true,
	name = "Amethyst of Sanctuary",
	unided_name = "deep purple gem",
	level_range = {30, 38},
	color=colors.AQUAMARINE, image = "object/artifact/amethyst_of_sanctuary.png",
	rarity = 250,
	kr_name = "성역의 자수정", kr_unided_name = "짙은 보랏빛 보석",
	desc = [[이 밝게 빛나는 보라색 보석에서는 차분하고 집중된 힘이 흘러나오고 있습니다. 보석을 손에 쥐면, 외부의 힘에서 보호받는 것을 느낄 수 있습니다.]],
	cost = 85,
	require = { stat = { wil=28 }, },
	material_level = 4,
	combat = {
		dam = 15,
		apr = 26,
		physcrit = 6,
		dammod = {wil=0.45, cun=0.22},
		damtype = DamageType.MIND,
	},
	wielder = {
		combat_mindpower = 15,
		combat_mindcrit = 8,
		combat_mentalresist = 25,
		max_psi = 20,
		talents_types_mastery = {
			["psionic/focus"] = 0.1,
			["psionic/absorption"] = 0.2,
		},
		resists={
			[DamageType.MIND] 	= 15,
		},
		inc_stats = { [Stats.STAT_WIL] = 8,},
	},
	max_power = 25, power_regen = 1,
	use_talent = { id = Talents.T_RESONANCE_FIELD, level = 3, power = 25 },
}

newEntity{ base = "BASE_STAFF", define_as = "SET_SCEPTRE_LICH",
	power_source = {arcane=true},
	unique = true,
	name = "Sceptre of the Archlich",
	flavor_name = "vilestaff",
	unided_name = "bone carved sceptre",
	level_range = {30, 38},
	color=colors.VIOLET, image = "object/artifact/sceptre_of_the_archlich.png",
	rarity = 320,
	kr_name = "고위 리치의 홀", kr_unided_name = "뼈로 만들어진 홀",
	desc = [[검은 고대의 뼈를 깎아 만든 이 홀에는 짙은 흑요석이 박혀있습니다. 그 속에서 빠져나오려 하는 어둠의 힘이 느껴집니다. 만약 리치가 이 홀을 들게 된다면...]],
	cost = 285,
	material_level = 4,

	require = { stat = { mag=40 }, },
	combat = {
		dam = 40,
		apr = 12,
		dammod = {mag=1.3},
		damtype = DamageType.DARKNESS,
	},
	wielder = {
		combat_spellpower = 28,
		combat_spellcrit = 14,
		inc_damage={
			[DamageType.DARKNESS] = 26,
		},
		talents_types_mastery = {
			["celestial/star-fury"] = 0.2,
			["spell/necrotic-minions"] = 0.2,
			["spell/advanced-necrotic-minions"] = 0.1,
		}
	},
	on_wear = function(self, who)
		if who.descriptor and who.descriptor.race == "Undead" then
			local Talents = require "engine.interface.ActorStats"
			self:specialWearAdd({"wielder", "talents_types_mastery"}, { ["spell/nightfall"] = 0.2 })
			self:specialWearAdd({"wielder","combat_spellpower"}, 12)
			self:specialWearAdd({"wielder","combat_spellresist"}, 10)
			self:specialWearAdd({"wielder","combat_mentalresist"}, 10)
			self:specialWearAdd({"wielder","max_mana"}, 50)
			self:specialWearAdd({"wielder","mana_regen"}, 0.5)
			game.logPlayer(who, "#LIGHT_BLUE#홀에 담겨있던 힘이 당신의 언데드 육체로 들어오고 있습니다!")
		end
	end,
	set_list = { {"define_as", "SET_LICH_RING"} },
	on_set_complete = function(self, who)
	end,
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {nature=true, antimagic=true},
	unique = true,
	name = "Oozing Heart",
	unided_name = "slimy mindstar",
	level_range = {27, 34},
	color=colors.GREEN, image = "object/artifact/oozing_heart.png",
	rarity = 250,
	kr_name = "진흙 심장", kr_unided_name = "찐득한 마석",
	desc = [[이 마석에서는 진한 부식성 액체가 스며나오고 있습니다. 또한 마석 주변의 마법적 힘이 사라지고 있습니다.]],
	cost = 85,
	require = { stat = { wil=36 }, },
	material_level = 4,
	combat = {
		dam = 17,
		apr = 25,
		physcrit = 7,
		dammod = {wil=0.5, cun=0.2},
		damtype = DamageType.SLIME,
	},
	wielder = {
		combat_mindpower = 12,
		combat_mindcrit = 8,
		combat_spellresist=15,
		inc_damage={
			[DamageType.NATURE] = 18,
			[DamageType.ACID] = 15,
		},
		resists={
			[DamageType.ARCANE] = 12,
			[DamageType.BLIGHT] = 12,
		},
		inc_stats = { [Stats.STAT_WIL] = 7, [Stats.STAT_CUN] = 2, },
		talents_types_mastery = { ["wild-gift/ooze"] = 0.1, ["wild-gift/slime"] = 0.1,},
	},
	max_power = 20, power_regen = 1,
	use_talent = { id = Talents.T_OOZE_SPIT, level = 2, power = 20 },
	on_wear = function(self, who)
		if who:attr("forbid_arcane") then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"combat","melee_project"}, {[DamageType.MANABURN]=30})
			game.logPlayer(who, "#DARK_GREEN#당신이 이 심장을 움켜쥐자, 그것은 반마법의 힘으로 맥동하기 시작합니다.")
		end
	end,
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {nature=true},
	unique = true,
	name = "Bloomsoul",
	unided_name = "flower covered mindstar",
	level_range = {10, 20},
	color=colors.GREEN, image = "object/artifact/bloomsoul.png",
	rarity = 180,
	kr_name = "꽃피운 영혼", kr_unided_name = "꽃으로 덮힌 마석",
	desc = [[오염되지 않은 깨끗한 꽃들로 덮힌 마석입니다. 마석을 손에 쥐면, 마음 속이 차분해지면서 상쾌해집니다.]],
	cost = 40,
	require = { stat = { wil=18 }, },
	material_level = 2,
	combat = {
		dam = 8,
		apr = 13,
		physcrit = 7,
		dammod = {wil=0.25, cun=0.1},
		damtype = DamageType.NATURE,
	},
	wielder = {
		combat_mindpower = 12,
		combat_mindcrit = 8,
		life_regen = 0.5,
		healing_factor = 0.1,
		talents_types_mastery = { ["wild-gift/fungus"] = 0.2,},
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_BLOOM_HEAL, level = 1, power = 60 },
}

newEntity{ base = "BASE_STAFF",
	power_source = {arcane=true},
	unique = true,
	name = "Gravitational Staff",
	flavor_name = "starstaff",
	unided_name = "heavy staff",
	level_range = {25, 33},
	color=colors.VIOLET, image = "object/artifact/gravitational_staff.png",
	rarity = 240,
	kr_name = "중력의 지팡이", kr_unided_name = "무거운 지팡이",
	desc = [[지팡이의 끝부분에서 시공간이 구부러지며 왜곡되고 있습니다.]],
	cost = 215,
	material_level = 3,
	require = { stat = { mag=35 }, },
	combat = {
		dam = 30,
		apr = 8,
		dammod = {mag=1.3},
		damtype = DamageType.GRAVITYPIN,
	},
	wielder = {
		combat_spellpower = 25,
		combat_spellcrit = 7,
		inc_damage={
			[DamageType.PHYSICAL] 	= 20,
			[DamageType.TEMPORAL] 	= 12,
		},
		resists={
			[DamageType.PHYSICAL] 	= 15,
		},
		talents_types_mastery = {
			["chronomancy/gravity"] = 0.2,
			["chronomancy/matter"] = 0.1,
			["spell/earth"] = 0.1,
		}
	},
	max_power = 14, power_regen = 1,
	use_talent = { id = Talents.T_GRAVITY_SPIKE, level = 3, power = 14 },
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {nature=true},
	name = "Eye of the Wyrm", define_as = "EYE_WYRM",
	unided_name = "multi-colored mindstar", unique = true,
	kr_name = "용의 눈", kr_unided_name = "무지개빛 마석",
	desc = [[이 마석의 중심부에는 검은 홍채가 박혀있고, 이내 그 홍채의 색은 무수히 많은 색깔들로 변화하기 시작합니다. 마치 뭔가를 찾는 것처럼, 홍채가 이리저리 움직이고 있습니다.]],
	color = colors.BLUE, image = "object/artifact/eye_of_the_wyrm.png",
	level_range = {30, 40},
	require = { stat = { wil=45, }, },
	rarity = 280,
	cost = 300,
	material_level = 4,
	sentient=true,
	combat = {
		dam = 16,
		apr = 24,
		physcrit = 2.5,
		dammod = {wil=0.4, cun=0.1, str=0.2},
		damtype=DamageType.PHYSICAL,
		convert_damage = {
			[DamageType.COLD] = 18,
			[DamageType.FIRE] = 18,
			[DamageType.ACID] = 18,
			[DamageType.LIGHTNING] = 18,
		},
	},
	wielder = {
		combat_mindpower = 9,
		combat_mindcrit = 7,
		inc_damage={
			[DamageType.PHYSICAL] 	= 8,
			[DamageType.FIRE] 	= 8,
			[DamageType.COLD] 	= 8,
			[DamageType.LIGHTNING] 	= 8,
			[DamageType.ACID] 	= 8,
		},
		resists={
			[DamageType.PHYSICAL] 	= 8,
			[DamageType.FIRE] 	= 8,
			[DamageType.COLD] 	= 8,
			[DamageType.ACID] 	= 8,
			[DamageType.LIGHTNING] 	= 8,
		},
		talents_types_mastery = {
			["wild-gift/sand-drake"] = 0.1,
			["wild-gift/fire-drake"] = 0.1,
			["wild-gift/cold-drake"] = 0.1,
			["wild-gift/storm-drake"] = 0.1,
			["wild-gift/venom-drake"] = 0.1,
		}
	},
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self)
		self.worn_by = nil
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.worn_by:attr("dead") then return end
		if not rng.percent(25)  then return end
		self.use_talent.id=rng.table{ "T_FIRE_BREATH", "T_ICE_BREATH", "T_LIGHTNING_BREATH", "T_SAND_BREATH", "T_CORROSIVE_BREATH" }
--		game.logSeen(self.worn_by, "#GOLD#The %s shifts colour!", self.name:capitalize())
	end,
	max_power = 30, power_regen = 1,
	--[[use_power = { name = "release a random breath", power = 40,
	use = function(self, who)
			local Talents = require "engine.interface.ActorTalents"
			local breathe = rng.table{
				{Talents.T_FIRE_BREATH},
				{Talents.T_ICE_BREATH},
				{Talents.T_LIGHTNING_BREATH},
				{Talents.T_SAND_BREATH},
			}

			who:forceUseTalent(breathe[1], {ignore_cd=true, ignore_energy=true, force_level=4, ignore_ressources=true})
			return {id=true, used=true}
		end
	},]]
	use_talent = { id = rng.table{ Talents.T_FIRE_BREATH, Talents.T_ICE_BREATH, Talents.T_LIGHTNING_BREATH, Talents.T_SAND_BREATH, Talents.T_CORROSIVE_BREATH }, level = 4, power = 30 }
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {nature=true},
	name = "Great Caller",
	unided_name = "humming mindstar", unique = true, image = "object",
	kr_name = "위대한 소환사", kr_unided_name = "웅웅거리는 마석",
	desc = [[마석에서 낮은 톤의 소리가 끊임없이 나고 있습니다. 마치 주변의 생명력이 마석 주변으로 끌려오는 것 같습니다.]],
	color = colors.GREEN,  image = "object/artifact/great_caller.png",
	level_range = {20, 32},
	require = { stat = { wil=34, }, },
	rarity = 250,
	cost = 220,
	material_level = 3,
	combat = {
		dam = 10,
		apr = 18,
		physcrit = 2.5,
		dammod = {wil=0.35, cun=0.5},
		damtype=DamageType.NATURE,
	},
	wielder = {
		combat_mindpower = 9,
		combat_mindcrit = 6,
		inc_damage={
			[DamageType.PHYSICAL] 	= 8,
			[DamageType.FIRE] 	= 8,
			[DamageType.COLD] 	= 8,
		},
		talents_types_mastery = {
			["wild-gift/summon-melee"] = 0.1,
			["wild-gift/summon-distance"] = 0.1,
			["wild-gift/summon-augmentation"] = 0.1,
			["wild-gift/summon-utility"] = 0.1,
			["wild-gift/summon-advanced"] = 0.1,
		},
		heal_on_nature_summon = 30,
		nature_summon_max = 2,
		inc_stats = { [Stats.STAT_WIL] = 5, [Stats.STAT_CUN] = 4 },
	},
	max_power = 16, power_regen = 1,
	use_talent = { id = Talents.T_RAGE, level = 4, power = 16 },
}

newEntity{ base = "BASE_HELM",
	power_source = {arcane=true},
	unique = true,
	name = "Corrupted Gaze", image = "object/artifact/corrupted_gaze.png",
	unided_name = "dark visored helm",
	kr_name = "타락한 시선", kr_unided_name = "얼굴 가리개가 달린 어두운 투구",
	desc = [[어둠의 힘을 내뿜고 있는 투구로, 투구에 달린 얼굴 가리개는 착용자의 시야를 비틀고 타락시킵니다. 이 비틀린 시야가 정신에 영향을 끼치지 못하도록, 투구를 오래 쓰는 것은 피해야할 것 같습니다.]],
	require = { stat = { mag=16 } },
	level_range = {28, 40},
	rarity = 300,
	cost = 300,
	material_level = 4,
	wielder = {
		inc_stats = { [Stats.STAT_MAG] = 5, [Stats.STAT_WIL] = 3, [Stats.STAT_CUN] = 4,},
		combat_def = 4,
		combat_armor = 8,
		fatigue = 6,
		resists = { [DamageType.BLIGHT] = 10},
		inc_damage = { [DamageType.BLIGHT] = 20},
		resists_pen = { [DamageType.BLIGHT] = 10},
		disease_immune=0.4,
		talents_types_mastery = { ["corruption/vim"] = 0.1, },
		combat_atk = 10,
		see_invisible = 12,
		see_stealth = 12,
	},
	max_power = 32, power_regen = 1,
	use_talent = { id = Talents.T_VIMSENSE, level = 3, power = 25 },
}

newEntity{ base = "BASE_KNIFE",
	power_source = {arcane=true},
	unique = true,
	name = "Umbral Razor", image = "object/artifact/dagger_silent_blade.png",
	unided_name = "shadowy dagger",
	kr_name = "그림자 면도날", kr_unided_name = "그림자 단검",
	desc = [[순수한 그림자로 만든 단검으로, 기이한 독기가 주변으로 퍼지고 있습니다.]],
	level_range = {12, 25},
	rarity = 200,
	require = { stat = { dex=32 }, },
	cost = 250,
	material_level = 2,
	combat = {
		dam = 25,
		apr = 10,
		physcrit = 9,
		dammod = {dex=0.45,str=0.45, mag=0.1},
		convert_damage = {
			[DamageType.DARKNESS] = 50,
		},
	},
	wielder = {
		inc_stealth=10,
		inc_stats = {[Stats.STAT_MAG] = 4, [Stats.STAT_CUN] = 4,},
		resists = {[DamageType.DARKNESS] = 10,},
		resists_pen = {[DamageType.DARKNESS] = 10,},
		inc_damage = {[DamageType.DARKNESS] = 5,},
	},
	max_power = 10, power_regen = 1,
	use_talent = { id = Talents.T_INVOKE_DARKNESS, level = 2, power = 8 },
}


newEntity{ base = "BASE_LEATHER_BELT",
	power_source = {technique=true},
	unique = true,
	name = "Emblem of Evasion", color = colors.GOLD,
	unided_name = "gold coated emblem", image = "object/artifact/emblem_of_evasion.png",
	kr_name = "회피의 문장", kr_unided_name = "금도금된 문장",
	desc = [[회피의 명수가 가지고 있던 것이라고 알려진 문장으로, 그 회피 기술의 상징과도 같습니다.]],
	level_range = {28, 38},
	rarity = 200,
	cost = 50,
	material_level = 4,
	wielder = {
		inc_stats = { [Stats.STAT_LCK] = 8, [Stats.STAT_DEX] = 12, [Stats.STAT_CUN] = 10,},
		slow_projectiles = 30,
		combat_def_ranged = 20,
		projectile_evasion = 15,
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_EVASION, level = 4, power = 30 },
}

newEntity{ base = "BASE_LONGBOW",
	power_source = {technique=true},
	name = "Surefire", unided_name = "high-quality bow", unique=true, image = "object/artifact/surefire.png",
	kr_name = "확실한-한발", kr_unided_name = "고품질 활",
	desc = [[신뢰할 만한 기술을 가진 자가 만든 것이라는 것을 보여주듯, 팽팽한 활시위를 가진 활입니다. 활시위를 당겨보면, 그 속에 담긴 강력한 힘을 느낄 수 있습니다.]],
	level_range = {5, 15},
	rarity = 200,
	require = { stat = { dex=18 }, },
	cost = 20,
	use_no_energy = true,
	material_level = 1,
	combat = {
		range = 9,
		physspeed = 0.75,
	},
	wielder = {
		inc_damage={ [DamageType.PHYSICAL] = 5, },
		inc_stats = { [Stats.STAT_DEX] = 3},
		combat_atk=12,
		combat_physcrit=5,
		apr = 10,
	},
	max_power = 8, power_regen = 1,
	use_talent = { id = Talents.T_STEADY_SHOT, level = 2, power = 8 },
}

newEntity{ base = "BASE_SHOT",
	power_source = {arcane=true},
	unique = true,
	name = "Frozen Shards", image = "object/artifact/frozen_shards.png",
	unided_name = "pouch of crystallized ice",
	kr_name = "얼어붙은 파편", kr_unided_name = "얼음 결정 뭉치",
	desc = [[이 검푸른 주머니에는 여러 개의 작은 얼음 구슬이 들어 있습니다. 신비한 증기가 그 주변을 감싸고 있으며, 얼음 구슬을 만져보면 뼛속까지 시려오는 차가움을 느낄 수 있습니다.]],
	color = colors.BLUE,
	level_range = {25, 40},
	rarity = 300,
	cost = 110,
	material_level = 4,
	require = { stat = { dex=28 }, },
	combat = {
		capacity = 25,
		dam = 32,
		apr = 15,
		physcrit = 10,
		dammod = {dex=0.7, cun=0.5},
		damtype = DamageType.ICE,
		special_on_hit = {desc="얼음 구름 생성",on_kill=1, fct=function(combat, who, target)
			local duration = 4
			local radius = 1
			local dam = (10 + who:getMag()/5 + who:getDex()/3)
			game.level.map:particleEmitter(target.x, target.y, radius, "iceflash", {radius=radius})
			-- Add a lasting map effect
			game.level.map:addEffect(who,
				target.x, target.y, duration,
				engine.DamageType.ICE, dam,
				radius,
				5, nil,
				{type="ice_vapour"},
				function(e)
					e.radius = e.radius
					return true
				end,
				false
			)
		end},
	},
}

newEntity{ base = "BASE_WHIP",
	power_source = {arcane=true},
	unided_name = "electrified whip",
	name = "Stormlash", color=colors.BLUE, unique = true, image = "object/artifact/stormlash.png",
	kr_name = "폭풍채찍", kr_unided_name = "전기 채찍",
	desc = [[금속 조각들이 연결된 채찍으로, 강렬한 전기가 흐르고 있습니다. 이 전기의 힘은 통제불능의, 강력하며, 폭발적인 힘입니다.]],
	require = { stat = { dex=15 }, },
	cost = 90,
	rarity = 250,
	level_range = {6, 15},
	material_level = 1,
	combat = {
		dam = 17,
		apr = 7,
		physcrit = 5,
		dammod = {dex=1},
		convert_damage = {[DamageType.LIGHTNING_DAZE] = 50,},
	},
	wielder = {
		combat_atk = 7,
	},
	max_power = 10, power_regen = 1,
	use_power = { name = "strike an enemy in range 3, releasing a burst of lightning", kr_name = "주변 3 칸 반경의 적 하나를 공격하여, 전기 폭발 발생", power = 10,
		use = function(self, who)
			local dam = 20 + who:getMag()/2 + who:getDex()/3
			local tg = {type="bolt", range=3}
			local blast = {type="ball", range=0, radius=1, selffire=false}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			local _ _, x, y = who:canProject(tg, x, y)
			local target = game.level.map(x, y, engine.Map.ACTOR)
			if not target then return end
			who:attackTarget(target, engine.DamageType.LIGHTNING, 1, true)
			local _ _, x, y = who:canProject(tg, x, y)
			game.level.map:particleEmitter(who.x, who.y, math.max(math.abs(x-who.x), math.abs(y-who.y)), "lightning", {tx=x-who.x, ty=y-who.y})
			who:project(blast, x, y, engine.DamageType.LIGHTNING, rng.avg(dam / 3, dam, 3))
			game.level.map:particleEmitter(x, y, radius, "ball_lightning", {radius=blast.radius})
			game:playSoundNear(self, "talents/lightning")
			who:logCombat(target, "#Source1# #Target3# 공격해, 전류를 흘려보냅니다!")
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_WHIP",
	power_source = {psionic=true},
	unided_name = "gemmed whip handle",
	name = "Focus Whip", color=colors.YELLOW, unique = true, image = "object/artifact/focus_whip.png",
	kr_name = "집중의 채찍", kr_unided_name = "보석 박힌 채찍 손잡이",
	desc = [[끝부분에 작은 마석이 박힌 채찍 손잡이입니다. 손잡이를 쥐고 정신을 집중하면, 의지에 따라 움직이는 반투명한 채찍이 나타납니다.]],
	require = { stat = { dex=15 }, },
	cost = 90,
	rarity = 250,
	metallic = false,
	level_range = {18, 28},
	material_level = 3,
	combat = {
		is_psionic_focus=true,
		dam = 19,
		apr = 7,
		physcrit = 5,
		dammod = {dex=0.7, wil=0.2, cun=0.1},
		wil_attack = true,
		damtype=DamageType.MIND,
	},
	wielder = {
		combat_mindpower = 10,
		combat_mindcrit = 3,
		talent_on_hit = { [Talents.T_MINDLASH] = {level=1, chance=18} },
	},
	max_power = 10, power_regen = 1,
	use_power = { name = "strike all targets in a line", kr_name = "직선 상의 모든 적을 공격", power = 10,
		use = function(self, who)
			local tg = {type="beam", range=4}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			who:project(tg, x, y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				who:attackTarget(target, engine.DamageType.MIND, 1, true)
			end)
			local _ _, x, y = who:canProject(tg, x, y)
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "matter_beam", {tx=x-who.x, ty=y-who.y})
			game:playSoundNear(self, "talents/lightning")
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_GREATSWORD",
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Latafayn",
	unided_name = "flame covered greatsword", image = "object/artifact/latafayn.png",
	level_range = {32, 40},
	color=colors.DARKRED,
	rarity = 300,
	kr_name = "라타파인", kr_unided_name = "불꽃이 타오르는 대검",
	desc = [[불꽃이 타오르는 이 거대한 대검은 황혼의 시대에 모험가 케스틴 하이핀이 훔친 것으로, 그 이전에는 원래 "붉은 프론드'랄" 이라는 악마가 가지고 있었습니다. 검으로부터 사악한 불꽃이 피어오르고 있으며, 이것의 존재 자체가 오염된 대지의 상징과도 같아보입니다.]],
	cost = 400,
	require = { stat = { str=40 }, },
	material_level = 4,
	combat = {
		dam = 68,
		apr = 5,
		physcrit = 10,
		dammod = {str=1.25},
		convert_damage={[DamageType.FIREBURN] = 50},
		lifesteal = 8, --Won't affect the burn damage, so it gets to have a bit more
	},
	wielder = {
		resists = {
			[DamageType.FIRE] = 15,
		},
		inc_damage = {
			[DamageType.FIRE] = 15,
			[DamageType.DARKNESS] = 10,
		},
		inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_CUN] = 3 },
	},
	max_power = 25, power_regen = 1,
	use_power = {name="accelerate burns, instantly inflicting 125% of all burn damage", kr_name="몸에 붙은 불을 촉진시켜, 총 화상 피해의 125% 만큼 즉시 피해 유발", power = 10, --wherein Pure copies Catalepsy
	use=function(combat, who, target)
		local tg = {type="ball", range=5, radius=1, selffire=false}
		local x, y = who:getTarget(tg)
		if not x or not y then return nil end

		local source = nil
		who:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end

			-- List all diseases, I mean, burns
			local burns = {}
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.subtype.fire and p.power and e.status == "detrimental" then
					burns[#burns+1] = {id=eff_id, params=p}
				end
			end
			-- Make them EXPLODE !!!
			for i, d in ipairs(burns) do
				target:removeEffect(d.id)
				engine.DamageType:get(engine.DamageType.FIRE).projector(who, px, py, engine.DamageType.FIRE, d.params.power * d.params.dur * 1.25)
			end
			game.level.map:particleEmitter(target.x, target.y, 1, "ball_fire", {radius=1})
		end)
		game:playSoundNear(who, "talents/fireflash")
		return {id=true, used=true}
	end},
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {psionic=true},
	unique = true,
	name = "Robe of Force", color = colors.YELLOW, image = "object/artifact/robe_of_force.png",
	unided_name = "rippling cloth robe",
	kr_name = "염동력 로브", kr_unided_name = "물결치는 로브",
	desc = [[강력한 염동력의 장막과도 같은, 얇은 로브입니다.]],
	level_range = {20, 28},
	rarity = 190,
	cost = 250,
	material_level = 2,
	wielder = {
		combat_def = 12,
		combat_armor = 8,
		inc_stats = { [Stats.STAT_CUN] = 3, [Stats.STAT_WIL] = 4, },
		combat_mindpower = 8,
		combat_mindcrit = 4,
		combat_physresist = 10,
		inc_damage={[DamageType.PHYSICAL] = 5, [DamageType.MIND] = 5,},
		resists_pen={[DamageType.PHYSICAL] = 10, [DamageType.MIND] = 10,},
		resists={[DamageType.PHYSICAL] = 12, [DamageType.ACID] = 15,},
	},
	max_power = 10, power_regen = 1,
	use_power = { name = "send out a beam of kinetic energy", kr_name = "동역학적 에너지 발사", power = 10,
		use = function(self, who)
			local dam = 15 + who:getWil()/3 + who:getCun()/3
			local tg = {type="beam", range=5}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			who:project(tg, x, y, engine.DamageType.MINDKNOCKBACK, who:mindCrit(rng.avg(0.8*dam, dam)))
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "matter_beam", {tx=x-who.x, ty=y-who.y})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {nature=true},
	unique = true,
	name = "Serpent's Glare", image = "object/artifact/serpents_glare.png",
	unided_name = "venomous gemstone",
	level_range = {1, 10},
	color=colors.GREEN,
	rarity = 180,
	kr_name = "독사의 눈", kr_unided_name = "유독한 원석",
	desc = [[맹독성 액체가 흐르는 마석입니다.]],
	cost = 40,
	require = { stat = { wil=12 }, },
	material_level = 1,
	combat = {
		dam = 7,
		apr = 15,
		physcrit = 7,
		dammod = {wil=0.30, cun=0.1},
		damtype = DamageType.NATURE,
		convert_damage={[DamageType.POISON] = 30,}
	},
	wielder = {
		combat_mindpower = 5,
		combat_mindcrit = 5,
		poison_immune = 0.5,
		resists = {
			[DamageType.NATURE] = 10,
		},
		inc_damage = {
			[DamageType.NATURE] = 10,
		}
	},
	max_power = 8, power_regen = 1,
	use_talent = { id = Talents.T_SPIT_POISON, level = 2, power = 8 },
}

--[=[ seems to generate more bugs than it's worth
newEntity{ base = "BASE_LEATHER_CAP",
	power_source = {psionic=true},
	unique = true,
	name = "The Inner Eye", image = "object/artifact/the_inner_eye.png",
	unided_name = "engraved marble eye",
	level_range = {24, 32},
	color=colors.WHITE,
	encumber = 1,
	rarity = 140,
	kr_name = "내부의 눈", kr_unided_name = "조각된 대리석 눈",
	desc = [[이 대리석 눈이 박힌 두꺼운 안대는 시야를 차단하는 대신 착용자가 주변을 감지할 수 있도록 만들어 준다고 합니다.
그 효과로부터 회복되는데 시간이 필요한 것이 좀 의심스럽습니다.]],
	cost = 200,
	material_level=3,
	wielder = {
		combat_def=3,
		esp_range=-3,
		esp_all=1,
		blind=1,
		combat_mindpower=6,
		combat_mindcrit=4,
		blind_immune=1,
		blind_sight=1, -- So we can see walls, objects, and what not nearby and not break auto-explore.
		combat_mentalresist = 12,
		resists = {[DamageType.LIGHT] = 10,},
		resists_cap = {[DamageType.LIGHT] = 10,},
		resists_pen = {all=5, [DamageType.MIND] = 10,}
	},
	on_wear = function(self, who)
		game.logPlayer(who, "#CRIMSON#Your eyesight fades!")
		who:resetCanSeeCache()
		if who.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
	end,
}
]=]

newEntity{ base = "BASE_LONGSWORD", define_as="CORPUS",
	power_source = {unknown=true, technique=true},
	unique = true,
	name = "Corpathus", image = "object/artifact/corpus.png",
	unided_name = "bound sword",
	kr_name = "코르파투스", kr_unided_name = "봉인된 검",
	desc = [[칼날 부분이 두꺼운 가죽끈으로 감겨 있는 검으로, 칼날을 따라 나있는 이빨같이 생긴 톱니가 칼날을 이등분하고 있습니다. 이 검은 가죽끈을 풀어내기 위해 온갖 노력을 했지만, 그 힘이 모자랐던 것 같습니다.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { str=40, }, },
	cost = 300,
	material_level = 4,
	combat = {
		dam = 40,
		apr = 12,
		physcrit = 4,
		dammod = {str=1,},
		melee_project={[DamageType.DRAINLIFE] = 18},
		special_on_kill = {desc="힘을 얻어 급격하게 성장", fct=function(combat, who, target)
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "CORPUS")
			if not o or not who:getInven(inven_id).worn then return end
			who:onTakeoff(o, inven_id, true)
			o.combat.physcrit = (o.combat.physcrit or 0) + 2
			o.wielder.combat_critical_power = (o.wielder.combat_critical_power or 0) + 4
			who:onWear(o, inven_id, true)
			if not rng.percent(o.combat.physcrit*0.8) or o.combat.physcrit < 30 then return end
			o.summon(o, who)
		end},
		special_on_crit = {desc="힘을 얻어 성장", on_kill=1, fct=function(combat, who, target)
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "CORPUS")
			if not o or not who:getInven(inven_id).worn then return end
			who:onTakeoff(o, inven_id, true)
			o.combat.physcrit = (o.combat.physcrit or 0) + 1
			o.wielder.combat_critical_power = (o.wielder.combat_critical_power or 0) + 2
			who:onWear(o, inven_id, true)
			if not rng.percent(o.combat.physcrit*0.8) or o.combat.physcrit < 30 then return end
			o.summon(o, who)
		end},
	},
	summon=function(o, who)
		o.cut=nil
		o.combat.physcrit=6
		o.wielder.combat_critical_power = 0
		game.logSeen(who, "코르파투스가 폭발하며, 끔찍하게 생긴 덩어리가 풀려납니다!")
		local x, y = util.findFreeGrid(who.x, who.y, 5, true, {[engine.Map.ACTOR]=true})
			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				type = "horror", subtype = "eldritch",
				display = "h",
				name = "Vilespawn", color=colors.GREEN,
				image="npc/horror_eldritch_oozing_horror.png",
				kr_name = "역겨운 덩어리",
				desc = "코르파투스가 폭발하면서 나온, 부패한 슬라임 덩어리입니다.",
				body = { INVEN = 10, MAINHAND=1, OFFHAND=1, },
				rank = 2,
				life_rating = 8, exp_worth = 0,
				life_regen=0,
				max_vim=200,
				max_life = resolvers.rngavg(50,90),
				infravision = 20,
				autolevel = "dexmage",
				ai = "summoned", ai_real = "tactical", ai_state = { talent_in=2, ally_compassion=0},
				stats = { str=15, dex=18, mag=18, wil=15, con=10, cun=18 },
				level_range = {10, nil}, exp_worth = 0,
				silent_levelup = true,
				combat_armor = 0, combat_def = 24,
				combat = { dam=resolvers.rngavg(10,13), atk=15, apr=15, dammod={mag=0.5, dex=0.5}, damtype=engine.DamageType.BLIGHT, },

				resists = { [engine.DamageType.BLIGHT] = 100, [engine.DamageType.NATURE] = -100, },

				on_melee_hit = {[engine.DamageType.DRAINLIFE]=resolvers.mbonus(10, 30)},
				melee_project = {[engine.DamageType.DRAINLIFE]=resolvers.mbonus(10, 30)},

				resolvers.talents{
					[who.T_DRAIN]={base=1, every=7, max = 10},
					[who.T_SPIT_BLIGHT]={base=1, every=6, max = 9},
					[who.T_VIRULENT_DISEASE]={base=1, every=9, max = 7},
					[who.T_BLOOD_FURY]={base=1, every=8, max = 6},
				},
				resolvers.sustains_at_birth(),
				faction = who.faction,
			}

			m:resolve()

			game.zone:addEntity(game.level, m, "actor", x, y)
	end,
	wielder = {
		inc_damage={[DamageType.BLIGHT] = 5,},
		combat_critical_power = 0,
		cut_immune=-0.25,
		max_vim=20,
	},

}

newEntity{ base = "BASE_LONGSWORD",
	power_source = {unknown=true, psionic=true},
	unique = true,
	name = "Anmalice", image = "object/artifact/anima.png", define_as = "ANIMA",
	unided_name = "twisted blade",
	kr_name = "악의", kr_unided_name = "뒤틀린 칼날",
	desc = [[칼날의 손잡이에 달린 눈이, 당신의 영혼과 정신을 꿰뚫어보는 것만 같습니다. 손잡이에서는 촉수가 뻗어나와, 당신의 손을 붙잡고 떨어지지 않습니다.]],
	level_range = {30, 40},
	rarity = 250,
	require = { stat = { str=32, wil=20, }, },
	cost = 300,
	material_level = 4,
	combat = {
		dam = 47,
		apr = 20,
		physcrit = 7,
		dammod = {str=1,wil=0.1},
		damage_convert = {[DamageType.MIND]=20,},
		special_on_hit = {desc="다양한 정신적 상태효과로 대상을 고문", fct=function(combat, who, target)
			if not who:checkHit(who:combatMindpower(), target:combatMentalResist()*0.9) then return end
			target:setEffect(target.EFF_WEAKENED_MIND, 2, {power=0, save=20})
			if not rng.percent(40) then return end
			local eff = rng.table{"stun", "malign", "agony", "confusion", "silence",}
			if not target:canBe(eff) then return end
			if not who:checkHit(who:combatMindpower(), target:combatMentalResist()) then return end
			if eff == "stun" then target:setEffect(target.EFF_MADNESS_STUNNED, 3, {mindResistChange=-25})
			elseif eff == "malign" then target:setEffect(target.EFF_MALIGNED, 3, {resistAllChange=10})
			elseif eff == "agony" then target:setEffect(target.EFF_AGONY, 5, { src=who, damage=40, mindpower=40, range=10, minPercent=10, duration=5})
			elseif eff == "confusion" then target:setEffect(target.EFF_CONFUSED, 3, {power=60})
			elseif eff == "silence" then target:setEffect(target.EFF_SILENCED, 3, {})
			end
		end},
		special_on_kill = {desc="정신내성 손실 감소", fct=function(combat, who, target)
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "ANIMA")
			if not o or not who:getInven(inven_id).worn then return end
			if o.wielder.combat_mentalresist >= 0 then return end
			o.skipfunct=1
			who:onTakeoff(o, inven_id, true)
			o.wielder.combat_mentalresist = (o.wielder.combat_mentalresist or 0) + 2
			who:onWear(o, inven_id, true)
			o.skipfunct=nil
		end},
	},
	wielder = {
		combat_mindpower=9,
		combat_mentalresist=-30,
		inc_damage={
			[DamageType.MIND] = 8,
		},
	},
	sentient=true,
	act = function(self)
		self:useEnergy()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by=nil return end
		if self.worn_by:attr("dead") then return end
		local who = self.worn_by
			local blast = {type="ball", range=0, radius=2, selffire=false}
			who:project(blast, who.x, who.y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				if not rng.percent(20) then return end
				target:setEffect(target.EFF_WEAKENED_MIND, 2, {power=0, save=5})
				who:logCombat(target, "'악의'가 그 정신을 꿰뚫는 눈으로 #Target3# 쳐다봅니다!")
			end)
	end,
	on_takeoff = function(self, who)
		if self.skipfunct then return end
		self.worn_by=nil
		who:removeParticles(self.particle)
		if self.wielder.combat_mentalresist == 0 then
			game.logPlayer(who, "#CRIMSON#촉수가 만족하면서 팔에서 풀려납니다.")
		else
			game.logPlayer(who, "#CRIMSON#팔에서 촉수를 강제로 떼어내자, 머리 속에 끔찍한 형상들이 떠오르기 시작합니다!")
			who:setEffect(who.EFF_WEAKENED_MIND, 15, {power=0, save=25})
			who:setEffect(who.EFF_AGONY, 5, { src=who, damage=15, mindpower=40, range=10, minPercent=10, duration=5})
		end
		self.wielder.combat_mentalresist = -30
	end,
	on_wear = function(self, who)
		if self.skipfunct then return end
		self.particle = who:addParticles(engine.Particles.new("gloom", 1))
		self.worn_by = who
		game.logPlayer(who, "#CRIMSON#검을 쥐자, 촉수가 손잡이에서 나와 팔을 감싸기 시작했습니다. 검의 의지가 당신의 정신을 침범합니다!")
	end,
}

newEntity{ base = "BASE_LONGSWORD", define_as="MORRIGOR",
	power_source = {arcane=true, unknown=true},
	unique = true, sentient = true,
	name = "Morrigor", image = "object/artifact/morrigor.png",
	kr_name = "모리고르",
	unided_name = "jagged, segmented, sword",
	kr_unided_name = "톱니 모양으로, 갈라진, 검",
	desc = [[무겁고, 길다란 검으로, 마법의 힘을 뿜어내고 있으며, 손잡이를 쥐면 얼음을 쥔 듯한 한기가, 이 검에 의해 살해된 모든 적들의 영혼이 느껴진다. 일치단결하여, '그들' 은 새로운 일행을 요구한다.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { mag=40, }, },
	cost = 300,
	material_level = 4,
	combat = {
		dam = 50,
		apr = 12,
		physcrit = 7,
		dammod = {str=0.6, mag=0.6},
		special_on_hit = {desc="추가적인 마법속성과 암흑속성 피해", fct=function(combat, who, target)
			local tg = {type="ball", range=1, radius=0, selffire=false}
			who:project(tg, target.x, target.y, engine.DamageType.ARCANE, who:getMag()*0.5)
			who:project(tg, target.x, target.y, engine.DamageType.DARKNESS, who:getMag()*0.5)
		end},
		special_on_kill = {desc="희생자의 영혼을 삼켜, 새로운 힘을 획득", fct=function(combat, who, target)
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "MORRIGOR")
			if o.use_talent then return end
			local got_talent = false
			local tids = {}
			for tid, _ in pairs(target.talents) do
				local t = target:getTalentFromId(tid)
				if t.mode == "activated" and not t.uber and not t.on_pre_use and not t.no_npc_use and not t.hide and not t.is_nature and not t.type[1]:find("/other") and not t.type[1]:find("horror") and not t.type[1]:find("race/") and not t.type[1]:find("inscriptions/") and t.id ~= who.T_HIDE_IN_PLAIN_SIGHT then
					tids[#tids+1] = tid
					got_talent = true
				end
			end
			if got_talent == true then
				local get_talent = rng.table(tids)
				local t = target:getTalentFromId(get_talent)
				o.use_talent = {}
				o.use_talent.id = t.id
				o.use_talent.power = (who:getTalentCooldown(t) or 5)
				o.use_talent.level = 3
				o.power = 1
				o.max_power = (who:getTalentCooldown(t) or 5)
				o.power_regen = 1
			end
	end},
	},
	wielder = {
		combat_spellpower=24,
		combat_spellcrit=12,
		learn_talent = { [Talents.T_SOUL_PURGE] = 1, },
	},
}

newEntity{ base = "BASE_WHIP", define_as = "HYDRA_BITE",
	slot_forbid = "OFFHAND",
	offslot = false,
	twohanded=true,
	power_source = {technique=true, nature=true},
	unique = true,
	name = "Hydra's Bite", color = colors.LIGHT_RED, image = "object/artifact/hydras_bite.png",
	unided_name = "triple headed flail",
	kr_name = "히드라의 공격", kr_unided_name = "머리 셋 달린 도리깨",
	desc = [[이 머리 셋 달린 스트라라이트 도리깨는 히드라의 힘을 담아 공격합니다. 한번 후려칠 때마다, 주변의 모두를 공격할 수 있습니다.]],
	level_range = {32, 40},
	rarity = 250,
	require = { stat = { str=40 }, },
	cost = 650,
	material_level = 4,
	running = 0, --For the on hit
	combat = {
		dam = 56,
		apr = 7,
		physcrit = 14,
		dammod = {str=1.1},
		talent_on_hit = { [Talents.T_LIGHTNING_BREATH_HYDRA] = {level=1, chance=10}, [Talents.T_ACID_BREATH] = {level=1, chance=10}, [Talents.T_POISON_BREATH] = {level=1, chance=10} },
		--convert_damage = {[DamageType.NATURE]=25,[DamageType.ACID]=25,[DamageType.LIGHTNING]=25},
		special_on_hit = {desc="인접한 두 적을 동시에 공격",on_kill=1, fct=function(combat, who, target)
				local o, item, inven_id = who:findInAllInventoriesBy("define_as", "HYDRA_BITE")
				if not o or not who:getInven(inven_id).worn then return end
				local tgts = {}
				local twohits=1
				for _, c in pairs(util.adjacentCoords(who.x, who.y)) do
				local targ = game.level.map(c[1], c[2], engine.Map.ACTOR)
				if targ and targ ~= target and who:reactionToward(target) < 0 then tgts[#tgts+1] = targ end
				end
				if #tgts == 0 then return end
					local target1 = rng.table(tgts)
					local target2 = rng.table(tgts)
					local tries = 0
				while target1 == target2 and tries < 100 do
					local target2 = rng.table(tgts)
					tries = tries + 1
				end
				if o.running == 1 then return end
				o.running = 1
				if tries >= 100 or #tgts==1 then twohits=nil end
				if twohits then
					who:logCombat(target1, "#Source#의 머리 셋 달린 도리깨가 %s #Target3# 후려칩니다!",who:canSee(target2) and ("%s"):format((target2.kr_name or target2.name):capitalize():addJosa("와")) or "")
				else
					who:logCombat(target1, "#Source#의 머리 셋 달린 도리깨가 #Target3# 후려칩니다!")
				end
				who:attackTarget(target1, engine.DamageType.PHYSICAL, 0.4,  true)
				if twohits then who:attackTarget(target2, engine.DamageType.PHYSICAL, 0.4,  true) end
				o.running=0
		end},
	},
	wielder = {
		inc_damage={[DamageType.NATURE]=12, [DamageType.ACID]=12, [DamageType.LIGHTNING]=12,},

	},
}

newEntity{ base = "BASE_GAUNTLETS",
	power_source = {technique=true, antimagic=true},
	define_as = "GAUNTLETS_SPELLHUNT",
	unique = true,
	name = "Spellhunt Remnants", color = colors.GREY, image = "object/artifact/spellhunt_remnants.png",
	unided_name = "rusted voratun gauntlets",
	kr_name = "마법사냥의 유물", kr_unided_name = "녹슨 보라툰 전투장갑",
	desc = [[한때는 빛나는 보라툰 전투장갑이었지만, 이제는 엄청나게 녹슬었습니다. 원래는 마법사냥에 사용되던 것으로, 마법이 깃든 아티팩트를 부숴 그것들이 세상에 끼친 영향을 치유하는 용도로 주로 사용되었습니다.]],
	level_range = {1, 25}, --Relevant at all levels, though of course mat level 1 limits it to early game.
	rarity = 450, -- But rare to make it not ALWAYS appear.
	cost = 1000,
	material_level = 1,
	wielder = {
		combat_mindpower=4,
		combat_mindcrit=1,
		combat_spellresist=4,
		combat_def=1,
		combat_armor=2,
		combat = {
			dam = 12,
			apr = 4,
			physcrit = 3,
			physspeed = 0.2,
			dammod = {dex=0.4, str=-0.6, cun=0.4,},
			damrange = 0.3,
			melee_project={[DamageType.RANDOM_SILENCE] = 10},
			talent_on_hit = { [Talents.T_DESTROY_MAGIC] = {level=1, chance=100} },
		},
	},
	power_up= function(self, who, level)
		local Stats = require "engine.interface.ActorStats"
		local Talents = require "engine.interface.ActorTalents"
		local DamageType = require "engine.DamageType"
		local _, _, inven_id = who:findInAllInventoriesByObject(self)
		who:onTakeoff(self, inven_id, true)
		self.wielder=nil
		if level==2 then -- LEVEL 2
		self.desc = [[한때는 빛나는 보라툰 전투장갑이었지만, 이제는 상당히 녹슬었습니다. 원래는 마법사냥에 사용되던 것으로, 마법이 깃든 아티팩트를 부숴 그것들이 세상에 끼친 영향을 치유하는 용도로 주로 사용되었습니다]]
		self.wielder={
			combat_mindpower=6,
			combat_mindcrit=2,
			combat_spellresist=6,
			combat_def=2,
			combat_armor=3,
			combat = {
				dam = 17,
				apr = 8,
				physcrit = 6,
				physspeed = 0.2,
				dammod = {dex=0.4, str=-0.6, cun=0.4,},
				damrange = 0.3,
				melee_project={[DamageType.RANDOM_SILENCE] = 12},
				talent_on_hit = { [Talents.T_DESTROY_MAGIC] = {level=2, chance=100} },
			},
		}
		elseif  level==3 then -- LEVEL 3
		self.desc = [[한때는 빛나는 보라툰 전투장갑이었지만, 이제는 조금 손상되었습니다. 원래는 마법사냥에 사용되던 것으로, 마법이 깃든 아티팩트를 부숴 그것들이 세상에 끼친 영향을 치유하는 용도로 주로 사용되었습니다.]]
		self.wielder={
			combat_mindpower=8,
			combat_mindcrit=3,
			combat_spellresist=8,
			combat_def=3,
			combat_armor=4,
			combat = {
				dam = 22,
				apr = 12,
				physcrit = 8,
				physspeed = 0.2,
				dammod = {dex=0.4, str=-0.6, cun=0.4,},
				damrange = 0.3,
				melee_project={[DamageType.RANDOM_SILENCE] = 15, [DamageType.ITEM_ANTIMAGIC_MANABURN] = 20,},
				talent_on_hit = { [Talents.T_DESTROY_MAGIC] = {level=3, chance=100}, [Talents.T_MANA_CLASH] = {level=1, chance=5} },
			},
		}
		elseif  level==4 then -- LEVEL 4
		self.desc = [[보라툰 전투장갑으로, 착용하면 빛이 납니다. 원래는 마법사냥에 사용되던 것으로, 마법이 깃든 아티팩트를 부숴 그것들이 세상에 끼친 영향을 치유하는 용도로 주로 사용되었습니다]]
		self.wielder={
			combat_mindpower=10,
			combat_mindcrit=4,
			combat_spellresist=10,
			combat_def=4,
			combat_armor=5,
			combat = {
				dam = 27,
				apr = 15,
				physcrit = 10,
				physspeed = 0.2,
				dammod = {dex=0.4, str=-0.6, cun=0.4,},
				damrange = 0.3,
				melee_project={[DamageType.RANDOM_SILENCE] = 17, [DamageType.ITEM_ANTIMAGIC_MANABURN] = 35,},
				talent_on_hit = { [Talents.T_DESTROY_MAGIC] = {level=4, chance=100}, [Talents.T_MANA_CLASH] = {level=2, chance=10} },
			},
		}
		elseif  level==5 then -- LEVEL 5
		self.desc = [[보라툰 전투장갑으로, 착용하면 이 세상의 빛이라고는 할 수 없을 정도로 밝게 빛납니다. 원래는 마법사냥에 사용되던 것으로, 마법이 깃든 아티팩트를 부숴 그것들이 세상에 끼친 영향을 치유하는 용도로 주로 사용되었습니다. 당신은 이 고대의 임무를 완수한 것에 자부심을 가집니다.]]
		self.wielder={
			combat_mindpower=12,
			combat_mindcrit=5,
			combat_spellresist=15,
			combat_def=6,
			combat_armor=8,
			lite=1,
			combat = {
				dam = 33,
				apr = 18,
				physcrit = 12,
				physspeed = 0.2,
				dammod = {dex=0.4, str=-0.6, cun=0.4,},
				damrange = 0.3,
				melee_project={[DamageType.RANDOM_SILENCE] = 20, [DamageType.ITEM_ANTIMAGIC_MANABURN] = 50,},
				talent_on_hit = { [Talents.T_DESTROY_MAGIC] = {level=5, chance=100}, [Talents.T_MANA_CLASH] = {level=3, chance=15}, [Talents.T_AURA_OF_SILENCE] = {level=1, chance=10} },
			},
		}
		self.use_power.name = "destroy magic in a radius 5 cone"
		self.use_power.kr_name = "5 칸 이내 원뿔영역에 있는 마법 파괴"
		self.use_power.power = 100
		self.use_power.use= function(self,who)
			local tg = {type="cone", range=0, radius=5}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			who:project(tg, x, y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				target:setEffect(target.EFF_SPELL_DISRUPTION, 10, {src=who, power = 50, max = 75, apply_power=who:combatMindpower()})
				for i = 1, 2 do
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
					end
				end
				if target.undead or target.construct then
					who:project({type="hit"}, target.x, target.y, engine.DamageType.ARCANE,100+who:combatMindpower())
					if target:canBe("stun") then target:setEffect(target.EFF_STUNNED, 10, {apply_power=who:combatMindpower()}) end
					game.logSeen(who, "%s에게 생명을 불어넣은 마법이, 장갑의 힘에 의해 방해받습니다!", (who.kr_name or who.name):capitalize())
				end
			end, nil, {type="slime"})
			game:playSoundNear(who, "talents/breath")
			return {id=true, used=true}
		end
		end

		who:onWear(self, inven_id, true)
	end,
	max_power = 150, power_regen = 1,
	use_power = { name = "destroy an arcane item (of a higher tier than the gauntlets)", kr_name = "(전투장갑보다 높은 단계의) 마법적 아티팩트 파괴", power = 1, use = function(self, who, obj_inven, obj_item)
		local d = who:showInventory("어느 물건을 부숩니까?", who:getInven("INVEN"), function(o) return o.unique and o.power_source and o.power_source.arcane and o.power_source.arcane and o.power_source.arcane == true and o.material_level and o.material_level > self.material_level end, function(o, item, inven)
			if o.material_level <= self.material_level then return end
			self.material_level=o.material_level
			game.logPlayer(who, "당신이 %s 부수자, 빛이 발생하여 장갑 속으로 흡수됩니다!", o:getName{do_color=true}:addJosa("를"))

			if not o then return end
			who:removeObject(who:getInven("INVEN"), item)
			who:sortInven(who:getInven("INVEN"))

			self.power_up(self, who, self.material_level)

			who.changed=true
		end)
	end },
}

newEntity{ base = "BASE_LONGBOW",
	power_source = {arcane=true},
	name = "Merkul's Second Eye", unided_name = "sleek stringed bow", unique=true, image = "object/artifact/merkuls_second_eye.png",
	kr_name = "메르쿨의 두 번째 눈", kr_unided_name = "매끈한 활시위가 걸린 활",
	desc = [[이 활은 악명 높은 드워프 첩자가 사용했던 도구로 알려져 있습니다. 소문에 따르면, 이것은 그 적의 시야를 공유할 수 있게 만들어 준다고 합니다. 이 활에서 발사된 화살에 맞은 적은 그 숨이 붙어있는 동안, 자신도 모르게 그 흔들림 없는 시야를 통해 그들의 비밀을 알려주게 됩니다.]], 
	level_range = {20, 38},
	rarity = 250,
	require = { stat = { dex=24 }, },
	cost = 200,
	material_level = 3,
	combat = {
		range = 9,
		physspeed = 0.8,
		travel_speed = 4,
		talent_on_hit = { [Talents.T_ARCANE_EYE] = {level=4, chance=100} },
	},
	wielder = {
		lite = 2,
		ranged_project = {[DamageType.ARCANE] = 25},
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {nature=true},
	unique = true,
	name = "Summertide",
	unided_name = "shining gold shield", image = "object/artifact/summertide.png",
	level_range = {38, 50},
	color=colors.GOLD,
	rarity = 350,
	kr_name = "밀려오는 여름", kr_unided_name = "빛나는 황금 방패",
	desc = [[중심부에서 밝은 빛이 빛나고 있는 방패입니다. 방패를 들어보면, 정신이 맑아지는 것을 느낄 수 있습니다.]],
	cost = 280,
	require = { stat = { wil=28, str=20, }, },
	material_level = 5,
	special_combat = {
		dam = 52,
		block = 260,
		physcrit = 4.5,
		dammod = {str=1},
		damtype = DamageType.LIGHT,
		special_on_hit = {desc="빛의 기운 방출", on_kill=1, fct=function(combat, who, target)
			local tg = {type="ball", range=0, radius=1, selffire=false}
			local grids = who:project(tg, target.x, target.y, engine.DamageType.LITE_LIGHT, 30 + who:getWil()*0.5)
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_light", {radius=tg.radius})
		end},
		melee_project = {[DamageType.ITEM_LIGHT_BLIND]=30},
	},
	wielder = {
		combat_armor = 15,
		combat_def = 17,
		combat_def_ranged = 17,
		fatigue = 12,
		combat_mindpower = 8,
		combat_mentalresist=18,
		blind_immune=1,
		confusion_immune=0.25,
		lite=3,
		max_psi=20,
		inc_damage={
			[DamageType.MIND] 	= 15,
			[DamageType.LIGHT] 	= 15,
			[DamageType.FIRE] 	= 10,
		},
		resists={
			[DamageType.LIGHT] 		= 20,
			[DamageType.DARKNESS] 	= 15,
			[DamageType.MIND] 		= 12,
			[DamageType.FIRE] 		= 10,
		},
		resists_pen={
			[DamageType.LIGHT] 	= 10,
			[DamageType.MIND] 	= 10,
			[DamageType.FIRE] 	= 10,
		},
		learn_talent = { [Talents.T_BLOCK] = 5, },
		inc_stats = { [Stats.STAT_WIL] = 5, [Stats.STAT_CUN] = 3, },
	},
	max_power = 30, power_regen = 1,
	use_power = { name = "send out a beam of light", kr_name = "빛줄기 발사", power = 12,
		use = function(self, who)
			local dam = 20 + who:getWil()/3 + who:getCun()/3
			local tg = {type="beam", range=7}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			
			who:project(tg, x, y, engine.DamageType.LITE_LIGHT, who:mindCrit(rng.avg(0.8*dam, dam)))
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "light_beam", {tx=x-who.x, ty=y-who.y})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_LEATHER_BOOT", 
	power_source = {psionic=true},
	unique = true,
	name = "Wanderer's Rest", image = "object/artifact/wanderers_rest.png",--Thanks Grayswandir! (just for the name this time!)
	unided_name = "weightless boots",
	kr_name = "방랑자의 휴식처", kr_unided_name = "가벼운 신발",
	desc = [[거의 무게가 느껴지지 않는 신발입니다. 신발을 신어보면, 굉장히 무거운 짐도 손쉽게 들 수 있을 것 같은 느낌이 듭니다.]],
	encumber=0,
	color = colors.YELLOW,
	level_range = {17, 28},
	rarity = 200,
	cost = 100,
	material_level = 3,
	wielder = {
		combat_def = 4,
		fatigue = -10,
		mindpower=4,
		inc_stats = { [Stats.STAT_DEX] = 3, },
		movement_speed=0.10,
		pin_immune=1,
		resists={
			[DamageType.PHYSICAL] = 5,
		},
	},
	max_power = 20, power_regen = 1,
	use_talent = { id = Talents.T_TELEKINETIC_LEAP, level = 3, power = 20 },
}

newEntity{ base = "BASE_CLOTH_ARMOR", --Thanks Grayswandir!
	power_source = {arcane=true},
	unique = true,
	name = "Silk Current", color = colors.BLUE, image = "object/artifact/silk_current.png",
	unided_name = "flowing robe",
	kr_name = "비단 해류", kr_unided_name = "흐르는 로브",
	desc = [[보이지 않는 조류가 이는 것처럼, 스스로 흔들거리고 물결치는 짙은 푸른색 로브입니다.]],
	level_range = {1, 15},
	rarity = 220,
	cost = 250,
	material_level = 1,
	wielder = {
		combat_def = 12,
		combat_spellpower = 4,
		
		inc_damage={[DamageType.COLD] = 10},
		resists={[DamageType.COLD] = 15},
		resists_pen={[DamageType.COLD] = 8},
		on_melee_hit={[DamageType.COLD] = 10,},
		
		movement_speed=0.15,
		talents_types_mastery = {
 			["spell/water"] = 0.1,
 		},
	},
}

newEntity{ base = "BASE_WHIP", --Thanks Grayswandir!
	power_source = {arcane=true},
	unided_name = "bone-link chain",
	name = "Skeletal Claw", color=colors.GREEN, unique = true, image = "object/artifact/skeletal_claw.png",
	kr_name = "뼈 발톱", kr_unided_name = "뼈가 이어진 사슬",
	desc = [[이 채찍은 인간의 척추로 만들어진 것 같습니다. 한쪽 끝에는 손잡이가 달려있고, 다른 한쪽에는 날카롭게 갈린 발톱이 달려있습니다.]],
	require = { stat = { dex=14 }, },
	cost = 150,
	rarity = 325,
	level_range = {40, 50},
	metallic = false,
	material_level = 5,
	combat = {
		dam = 55,
		apr = 8,
		physcrit = 9,
		dammod = {dex=1},
		melee_project={[DamageType.BLEED] = 30},
		burst_on_crit = {
			[DamageType.BLEED] = 50,
		},
		talent_on_hit = { [Talents.T_BONE_GRAB] = {level=3, chance=10}, [Talents.T_BONE_SPEAR] = {level=4, chance=20} },
		
	},
	wielder = {
		combat_def = 12,
		combat_spellpower = 4,
		combat_physspeed = 0.1,
		talents_types_mastery = { ["corruption/bone"] = 0.25, },
	},
	max_power = 20, power_regen = 1,
	use_talent = { id = Talents.T_BONE_NOVA, level = 4, power = 20 },
	talent_on_spell = { {chance=10, talent=Talents.T_BONE_SPEAR, level=4} },
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {psionic=true},
	unique = true,
	name = "Core of the Forge", image = "object/artifact/core_of_the_forge.png",
	unided_name = "fiery mindstar",
	level_range = {38, 50},
	color=colors.RED,
	rarity = 350,
	kr_name = "대장간의 심장", kr_unided_name = "불같은 마석",
	desc = [[이 불타는 뜨거운 마석은 주기적으로 고동치며, 부딪힐 때마다 뜨거운 폭발이 발생합니다.]],
	cost = 280,
	require = { stat = { wil=40 }, },
	material_level = 5,
	combat = {
		dam = 24,
		apr = 40,
		physcrit = 5,
		dammod = {wil=0.6, cun=0.2},
		damtype = DamageType.DREAMFORGE,
	},
	wielder = {
		combat_mindpower = 15,
		combat_mindcrit = 8,
		combat_atk=10,
		combat_dam=10,
		inc_damage={
			[DamageType.MIND] 		= 10,
			[DamageType.PHYSICAL] 	= 10,
			[DamageType.FIRE] 		= 10,
		},
		resists={
			[DamageType.MIND] 		= 5,
			[DamageType.PHYSICAL] 	= 5,
			[DamageType.FIRE] 		= 15,
		},
		resists_pen={
			[DamageType.MIND] 		= 10,
			[DamageType.PHYSICAL] 	= 10,
		},
		inc_stats = { [Stats.STAT_WIL] = 6, [Stats.STAT_CUN] = 3, },
		talents_types_mastery = {
			["psionic/dream-forge"] = 0.2,
			["psionic/dream-smith"] = 0.2,
		},
		melee_project={[DamageType.DREAMFORGE] = 30,},
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_FORGE_BELLOWS, level = 3, power = 24 },
}

newEntity{ base = "BASE_LEATHER_BOOT", --Thanks Grayswandir!
	power_source = {arcane=true},
	unique = true,
	name = "Aetherwalk", image = "object/artifact/aether_walk.png",
	unided_name = "ethereal boots",
	kr_name = "천상의 걸음", kr_unided_name = "에테르 재질의 신발",
	desc = [[성긴 보라빛 기운이, 이 검고 투명한 신발 주변을 감싸고 있습니다.]],
	color = colors.PURPLE,
	level_range = {30, 40},
	rarity = 200,
	cost = 100,
	material_level = 4,
	wielder = {
		combat_def = 6,
		fatigue = 1,
		spellpower=5,
		inc_stats = { [Stats.STAT_MAG] = 8, [Stats.STAT_CUN] = 8,},
		resists={
			[DamageType.ARCANE] = 12,
		},
		resists_cap={
			[DamageType.ARCANE] = 5,
		},
	},
	max_power = 24, power_regen = 1,
	use_power = { name = "phase door in range 6, radius 2", kr_name = "근거리 순간이동 (최대 6 칸, 오차 반경 2 칸)", power = 24,
		use = function(self, who)
			local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=6, radius=2, requires_knowledge=false}
			local x, y = who:getTarget(tg)
			if not x then return nil end
			-- Target code does not restrict the target coordinates to the range, it lets the project function do it
			-- but we cant ...
			local _ _, x, y = who:canProject(tg, x, y)

			-- Check LOS
			local rad = 2
			game.level.map:particleEmitter(who.x, who.y, 1, "teleport")
			who:teleportRandom(x, y, rad)
			game.level.map:particleEmitter(who.x, who.y, 1, "teleport")
			
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_GREATSWORD", -- Thanks Alex!
	power_source = {arcane=true},
	unique = true,
	name = "Colaryem",
	unided_name = "floating sword", image = "object/artifact/colaryem.png",
	level_range = {16, 36},
	color=colors.BLUE,
	rarity = 300,
	kr_name = "콜라리엠", kr_unided_name = "떠있는 검",
	desc = [[터무니없이 길고 폭은 자신의 몸통만큼이나 넓은 이상한 검입니다. 하지만 그 크기와는 모순적으로, 무게가 단순히 '가벼운 정도' 가 아니라 '쥐면 날아 다닐 수 있을 듯한' 정도입니다. 이 검을 제대로 휘두르려면 아주 힘이 강하거나, 아주 덩치가 커야 할 것 같습니다.]],
	cost = 400,
	require = { stat = { str=10 }, },
	sentient=true,
	material_level = 3,
	special_desc = function(self) return "공격 속도가 힘과 신체 크기에 비례하여 빨라집니다." end,
	combat = {
		dam = 48,
		apr = 12,
		physcrit = 11,
		dammod = {str=1.3},
		physspeed=1.8,
	},
	wielder = {
		resists = { [DamageType.LIGHTNING] = 7 },
		inc_damage = { [DamageType.LIGHTNING] = 7, },
		movement_speed = 0.1,
		inc_stats = { [Stats.STAT_DEX] = 7 },
		max_encumber = 50,
		fatigue = -12,
		avoid_pressure_traps = 1,
	},
	act = function(self)
		self:useEnergy()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by=nil return end
		if self.worn_by:attr("dead") then return end
		
		local size = self.worn_by.size_category-3
		local str = self.worn_by:getStr()
		self.combat.physspeed=util.bound(1.8-(str-10)*0.02-size*0.1, 0.80, 1.8)
	end,
	on_wear = function(self, who)
		self.worn_by = who
		
		local size = self.worn_by.size_category-3
		local str = self.worn_by:getStr()
		self.combat.physspeed=util.bound(1.8-(str-10)*0.02-size*0.1, 0.80, 1.8)
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
		self.combat.physspeed=2
	end,
}

newEntity{ base = "BASE_ARROW", --Thanks Grayswandir!
	power_source = {arcane=true},
	unique = true,
	name = "Void Quiver",
	unided_name = "ethereal quiver",
	kr_name = "공허의 화살통", kr_unided_name = "에테르 재질의 화살통",
	desc = [[진한 검은색 화살통으로, 안에서 화살이 끝없이 나옵니다. 그 표면에는 빛나는 흰색 작은 점들이 박혀 있습니다.]],
	color = colors.BLUE, image = "object/artifact/void_quiver.png",
	level_range = {35, 50},
	rarity = 300,
	cost = 100,
	material_level = 5,
	infinite=true,
	require = { stat = { dex=32 }, },
	combat = {
		capacity = 0,
		dam = 45,
		apr = 30, --No armor can stop the void
		physcrit = 6,
		dammod = {dex=0.7, str=0.5, mag=0.1,},
		damtype = DamageType.VOID,
		talent_on_hit = { [Talents.T_QUANTUM_SPIKE] = {level=1, chance=10}, [Talents.T_TEMPORAL_CLONE] = {level=1, chance=5} },
	},
}

newEntity{ base = "BASE_ARROW", --Thanks Grayswandir!
	power_source = {nature=true},
	unique = true,
	name = "Hornet Stingers", image = "object/artifact/hornet_stingers.png",
	unided_name = "sting tipped arrows",
	kr_name = "말벌의 독침", kr_unided_name = "화살촉에 독침이 박힌 화살",
	desc = [[이 화살의 촉에서는 지독한 독액이 흐르고 있습니다.]],
	color = colors.BLUE,
	level_range = {15, 25},
	rarity = 240,
	cost = 100,
	material_level = 2,
	require = { stat = { dex=18 }, },
	combat = {
		capacity = 20,
		dam = 18,
		apr = 10,
		physcrit = 5,
		dammod = {dex=0.7, str=0.5},
		ranged_project={
			[DamageType.CRIPPLING_POISON] = 45,
		},
	},
}

newEntity{ base = "BASE_LITE", --Thanks Frumple!
	power_source = {psionic=true},
	unique = true,
	name = "Umbraphage", image="object/artifact/umbraphage.png",
	unided_name = "deep black lantern",
	level_range = {20, 30},
	color=colors.BLACK,
	rarity = 240,
	kr_name = "어둠을 먹는 자", kr_unided_name = "짙은 검정색 랜턴",
	desc = [[창백한 빛을 내는 흰색 수정이 들어있는 랜턴으로, 주변의 어둠을 흡수하고 있습니다. 이 수정이 빛을 발하면, 모든 곳이 빛나고, 어둠은 완전히 사라집니다.]],
	cost = 320,
	material_level=3,
	sentient=true,
	charge = 0,
	special_desc = function(self) return "조명 반경 내의 모든 어둠을 흡수합니다." end,
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		
		local who=self.worn_by --Make sure you can actually act!
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.worn_by:attr("dead") then return end
		
		
		who:project({type="ball", range=0, radius=self.wielder.lite}, who.x, who.y, function(px, py) -- The main event!
			local is_lit = game.level.map.lites(px, py)
			if is_lit then return end
			
			if not self.max_charge then
			
				self.charge = self.charge + 1
				
				if self.charge == 200 then
					self.max_charge=true
					game.logPlayer(who, "어둠을 먹는 자가 완전히 충전되었습니다!")
				end
			
			end
		end)
		who:project({type="ball", range=0, radius=self.wielder.lite}, who.x, who.y, engine.DamageType.LITE, 100) -- Light the space!
		if (5 + math.floor(self.charge/20)) > self.wielder.lite and self.wielder.lite < 10 then
			local p = self.power
			who:onTakeoff(self, who.INVEN_LITE, true)
			self.wielder.lite = math.min(10, 5+math.floor(self.charge/20))
			who:onWear(self, who.INVEN_LITE, true)
			self.power = p
		end
	end,
	wielder = {
		lite = 5,
		combat_mindpower=10,
		combat_mentalresist=10,
		
		inc_damage = {[DamageType.LIGHT]=15, [DamageType.DARKNESS]=15},
		resists = {[DamageType.DARKNESS]=20},
		resists_pen = {[DamageType.DARKNESS]=10},
		damage_affinity={
			[DamageType.DARKNESS] = 20,
		},
		talents_types_mastery = {
			["cursed/shadows"] = 0.2,
		}
	},
	max_power = 10, power_regen = 1,
	use_power = { name = "release the absorbed darkness", kr_name = "흡수된 어둠 방출", power = 10,
		use = function(self, who)
			if self.max_charge then self.charge=300 end -- Power boost if you fully charged :)
			local dam = (15 + who:combatMindpower()) * 4+math.floor(self.charge/50) -- Damage is based on charge
			local tg = {type="cone", range=0, radius=self.wielder.lite} -- Radius of Cone is based on lite radius of the artifact
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			
			who:project(tg, x, y, engine.DamageType.DARKNESS, who:mindCrit(dam)) -- FIRE!
			who:project(tg, x, y, engine.DamageType.RANDOM_BLIND, self.wielder.lite*10) -- FIRE!
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "breath_dark", {radius=tg.radius, tx=x-who.x, ty=y-who.y})
			self.max_charge=nil -- Reset charge.
			self.charge=0
			
			local p = self.power
			who:onTakeoff(self, who.INVEN_LITE, true)
			self.wielder.lite = 5
			who:onWear(self, who.INVEN_LITE, true)
			self.power = p
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_LITE", --Thanks Grayswandir!
	power_source = {arcane=true},
	unique = true,
	name = "Spectral Cage", image="object/artifact/spectral_cage.png",
	unided_name = "ethereal blue lantern",
	level_range = {20, 30},
	color=colors.BLUE,
	rarity = 240,
	kr_name = "유령의 감옥", kr_unided_name = "에테르 재질의 푸른 랜턴",
	desc = [[고대의 풍화된 제등으로, 창백한 푸른 빛을 내고 있습니다. 제등을 만져보면, 얼음 같이 차가운 느낌을 받을 수 있습니다.]],
	cost = 320,
	material_level=3,
	wielder = {
		lite = 5,
		combat_spellpower=10,
		
		inc_damage = {[DamageType.COLD]=15},
		resists = {[DamageType.COLD]=20},
		resists_pen = {[DamageType.COLD]=10},
		
		talent_cd_reduction = {
			[Talents.T_CHILL_OF_THE_TOMB] = 2,
		},
	},
	max_power = 20, power_regen = 1,
	use_power = { name = "release a will o' the wisp", kr_name = "윌 오 위습 생성", power = 20,
		use = function(self, who)
			local x, y = util.findFreeGrid(who.x, who.y, 5, true, {[engine.Map.ACTOR]=true})
			local NPC = require "mod.class.NPC"
			local Talents = require "engine.interface.ActorTalents"
			local m = NPC.new{
				name = "will o' the wisp",
				kr_name = "윌 오 위습",
				type = "undead", subtype = "ghost",
				blood_color = colors.GREY,
				display = "G", color=colors.WHITE,
				combat = { dam=1, atk=1, apr=1 },
				autolevel = "warriormage",
				ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, },
				dont_pass_target = true,
				movement_speed = 2,
				stats = { str=14, dex=18, mag=20, con=12 },
				rank = 2,
				size_category = 1,
				infravision = 10,
				can_pass = {pass_wall=70},
				resists = {all = 35, [engine.DamageType.LIGHT] = -70, [engine.DamageType.COLD] = 65, [engine.DamageType.DARKNESS] = 65},
				no_breath = 1,
				stone_immune = 1,
				confusion_immune = 1,
				fear_immune = 1,
				teleport_immune = 0.5,
				disease_immune = 1,
				poison_immune = 1,
				stun_immune = 1,
				blind_immune = 1,
				cut_immune = 1,
				see_invisible = 80,
				undead = 1,
				will_o_wisp_dam = 110 + who:getMag() * 2.5,
				resolvers.talents{[Talents.T_WILL_O__THE_WISP_EXPLODE] = 1,},
				
				faction = who.faction,
				summoner = who, summoner_gain_exp=true,
				summon_time = 20,
			}

			m:resolve()
			game.zone:addEntity(game.level, m, "actor", x, y)
			m.remove_from_party_on_death = true,
			game.party:addMember(m, {
				control=false,
				type="summon",
				title="Summon", kr_title="소환수",
				orders = {target=true, leash=true, anchor=true, talents=true},
			})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {nature = true, antimagic=true},
	unique=true, rarity=240,
	type = "charm", subtype="totem",
	name = "The Guardian's Totem", image = "object/artifact/the_guardians_totem.png",
	unided_name = "cracked stone totem",
	color = colors.GREEN,
	level_range = {40, 50},
	kr_name = "수호자의 토템", kr_unided_name = "금이 간 암석 토템",
	desc = [[무수히 많은 틈이 생긴 고대의 암석 토템으로, 그 틈에서 짙은 점액이 스며나오고 있습니다. 하지만 그럼에도 불구하고, 이 토템에서 강력한 힘이 느껴집니다.]],
	cost = 320,
	material_level = 5,
	wielder = {
		resists={[DamageType.BLIGHT] = 20, [DamageType.ARCANE] = 20},
		on_melee_hit={[DamageType.SLIME] = 18},
		combat_spellresist = 20,
		talents_types_mastery = { ["wild-gift/antimagic"] = 0.1, ["wild-gift/fungus"] = 0.1},
		inc_stats = {[Stats.STAT_WIL] = 10,},
		combat_mindpower=8,
	},
		max_power = 35, power_regen = 1,
	use_power = { name = "call an antimagic pillar, but silence yourself", kr_name = "반마법의 기둥 소환 (대신 사용자는 침묵 상태가 됨)", power = 35,
		use = function(self, who)
			local x, y = util.findFreeGrid(who.x, who.y, 5, true, {[engine.Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "소환할 공간이 없습니다!")
				return
			end
			local Talents = require "engine.interface.ActorTalents"
			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				resolvers.nice_tile{image="invis.png", add_mos = {{image="terrain/darkgreen_moonstone_01.png", display_h=2, display_y=-1}}},
				name = "Stone Guardian",
				type = "totem", subtype = "antimagic",
				kr_name = "암석 수호자",
				desc = "이 거대한 암석 기둥에서는 끈적한 점액이 흘러내리고 있습니다. 이를 통해 자연의 힘도 같이 흘러나오고 있으며, 주변의 모든 마법을 없애버립니다...",
				rank = 3,
				blood_color = colors.GREEN,
				display = "T", color=colors.GREEN,
				life_rating=18,
				combat_dam = 40,
				combat = {
					dam=resolvers.rngavg(50,60),
					atk=resolvers.rngavg(50,75), apr=25,
					dammod={wil=1.2}, physcrit = 10,
					damtype=engine.DamageType.SLIME,
				},
				level_range = {1, nil}, exp_worth = 0,
				silent_levelup = true,
				combat_armor=50,
				combat_armor_hardiness=70,
				autolevel = "wildcaster",
				ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, },
				never_move=1,
				stats = { str=14, dex=18, mag=10, con=12, wil=20, cun=20, },
				size_category = 5,
				blind=1,
				esp_all=1,
				resists={all = 15, [engine.DamageType.BLIGHT] = 40, [engine.DamageType.ARCANE] = 40, [engine.DamageType.NATURE] = 70},
				no_breath = 1,
				cant_be_moved = 1,
				stone_immune = 1,
				confusion_immune = 1,
				fear_immune = 1,
				teleport_immune = 1,
				disease_immune = 1,
				poison_immune = 1,
				stun_immune = 1,
				blind_immune = 1,
				cut_immune = 1,
				knockback_resist=1,
				combat_mentalresist=50,
				combat_spellresist=100,
				on_act = function(self) self:project({type="ball", range=0, radius=5, friendlyfire=false}, self.x, self.y, engine.DamageType.SILENCE, {dur=2, power_check=self:combatMindpower()}) end,
				resolvers.talents{
					[Talents.T_RESOLVE]={base=3, every=6},
					[Talents.T_MANA_CLASH]={base=3, every=5},
					[Talents.T_STUN]={base=3, every=4},
					[Talents.T_OOZE_SPIT]={base=5, every=4},
					[Talents.T_TENTACLE_GRAB]={base=1, every=6,},
				},
				
				faction = who.faction,
				summoner = who, summoner_gain_exp=true,
				summon_time=15,
			}

			m:resolve()
			game.zone:addEntity(game.level, m, "actor", x, y)
			m.remove_from_party_on_death = true,
			game.party:addMember(m, {
				control=false,
				type="summon",
				title="Summon", kr_title="소환수",
				orders = {target=true, leash=true, anchor=true, talents=true},
			})
			who:setEffect(who.EFF_SILENCED, 5, {})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_CLOAK",
	power_source = {psionic=true},
	unique = true,
	name = "Cloth of Dreams", image = "object/artifact/cloth_of_dreams.png",
	unided_name = "tattered cloak",
	kr_name = "꿈의 의복", kr_unided_name = "누더기 망토",
	desc = [[다른 세계의 직물로 짠 듯한 망토로, 만져보면 졸음이 오면서도 완전한 각성 상태가 동시에 느껴집니다.]],
	level_range = {30, 40},
	rarity = 240,
	cost = 200,
	material_level = 4,
	wielder = {
		combat_def = 10,
		combat_mindpower = 6,
		combat_physresist = 10,
		combat_mentalresist = 10,
		combat_spellresist = 10,
		inc_stats = { [Stats.STAT_CUN] = 6, [Stats.STAT_WIL] = 5, },
		resists = { [DamageType.MIND] = 15 },
		lucid_dreamer=1,
		sleep=1,
		talents_types_mastery = { ["psionic/dreaming"] = 0.1, ["psionic/slumber"] = 0.1,},
	},
	max_power = 25, power_regen = 1,
	use_talent = { id = Talents.T_SLUMBER, level = 3, power = 10 },
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {arcane=true},
	unique=true, rarity=240,
	type = "charm", subtype="wand",
	name = "Void Shard", image = "object/artifact/void_shard.png",
	unided_name = "strange jagged shape",
	color = colors.GREY,
	level_range = {40, 50},
	kr_name = "공허의 파편", kr_unided_name = "기묘하게 생긴 날카로운 조각",
	desc = [[날카로운 조각으로, 공간에 뚫린 구멍같이 생겼습니다. 단단하고, 가볍습니다.]],
	cost = 320,
	material_level = 5,
	wielder = {
		resists={[DamageType.DARKNESS] = 10, [DamageType.TEMPORAL] = 10},
		inc_damage={[DamageType.DARKNESS] = 12, [DamageType.TEMPORAL] = 12},
		on_melee_hit={[DamageType.VOID] = 16},
		inc_stats = {[Stats.STAT_MAG] = 8,},
		combat_spellpower=10,
	},
	max_power = 40, power_regen = 1,
	use_power = { name = "release a burst of void energy", kr_name = "공허의 힘을 모아 발사", power = 20,
		use = function(self, who)
			local tg = {type="ball", range=5, radius=2}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			who:project(tg, x, y, engine.DamageType.VOID, 200 + who:getMag() * 2)
			game.level.map:particleEmitter(x, y, tg.radius, "shadow_flash", {radius=tg.radius, tx=x, ty=y})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_SHIELD", --Thanks SageAcrin!
	power_source = {nature=true},
	unided_name = "thick coral plate",
	name = "Coral Spray", unique=true, image = "object/artifact/coral_spray.png",
	kr_name = "산호 물보라", kr_unided_name = "두꺼운 산호 판",
	desc = [[대양에서 캐낸, 뾰족한 산호 덩어리입니다.]],
	require = { stat = { str=16 }, },
	level_range = {1, 15},
	rarity = 200,
	cost = 60,
	material_level = 1,
	moddable_tile = "special/%s_coral_spray",
	moddable_tile_big = true,
	metallic = false,
	special_combat = {
		dam = 18,
		block = 48,
		physcrit = 2,
		dammod = {str=1.4},
		damrange = 1.4,
		melee_project = { [DamageType.COLD] = 10, },
	},
	wielder = {
		combat_armor = 8,
		combat_def = 8,
		fatigue = 12,
		resists = {
			[DamageType.COLD] = 15,
			[DamageType.FIRE] = 10,
		},
		learn_talent = { [Talents.T_BLOCK] = 2, },
		max_air = 20,
	},
	on_block = {desc = "이 방패로 공격을 막으면, 가끔씩 싸늘한 물줄기를 공격자에게 뿜어냅니다.", fct = function(self, who, target, type, dam, eff)
		if rng.percent(30) then
			if not target or target:attr("dead") or not target.x or not target.y then return end

			local burst = {type="cone", range=0, radius=4, force_target=target, selffire=false,}
		
			who:project(burst, target.x, target.y, engine.DamageType.ICE, 30)
			game.level.map:particleEmitter(who.x, who.y, burst.radius, "breath_cold", {radius=burst.radius, tx=target.x-who.x, ty=target.y-who.y})
			who:logCombat(target, "#Source#의 방패에서 싸늘한 물줄기가 #Target#에게로 뿜어져 나옵니다!")
		end
	end,},
}


newEntity{ base = "BASE_AMULET", --Thanks Grayswandir!
	power_source = {psionic=true},
	unique = true,
	name = "Shard of Insanity", color = colors.DARK_GREY, image = "object/artifact/shard_of_insanity.png",
	unided_name = "cracked black amulet",
	kr_name = "광기의 파편", kr_unided_name = "금이 간 검은 부적",
	desc = [[검은 돌로 만들어졌지만 금이 간 부적으로, 그 틈에서 짙은 빨간색 빛이 새어나오고 있습니다. 부적을 만져보면, 마음 속으로 누군가 속삭이는 소리가 들립니다.]],
	level_range = {20, 32},
	rarity = 290,
	cost = 500,
	material_level = 3,
	wielder = {
		combat_mindpower = 8,
		combat_mentalresist = 35,
		confusion_immune=-1,
		inc_damage={
			[DamageType.MIND] 	= 25,
		},
		resists={
			[DamageType.MIND] 	= -10,
		},
		resists_pen={
			[DamageType.MIND] 	= 20,
		},
		on_melee_hit={[DamageType.RANDOM_CONFUSION] = 5},
		melee_project={[DamageType.RANDOM_CONFUSION] = 5},
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_INNER_DEMONS, level = 4, power = 30 },
}


newEntity{ base = "BASE_SHOT", --Thanks Grayswandir!
	power_source = {psionic=true},
	unique = true,
	name = "Pouch of the Subconscious", image = "object/artifact/pouch_of_the_subconscious.png",
	unided_name = "familiar pouch",
	kr_name = "잠재의식의 탄환 주머니", kr_unided_name = "친숙한 주머니",
	desc = [[이 이상한 탄환 주머니를 사용하면, 끊임없이 싸우고자 하는 충동이 일어나기 시작합니다.]],
	color = colors.RED,
	level_range = {25, 40},
	rarity = 300,
	cost = 110,
	material_level = 4,
	require = { stat = { dex=28 }, },
	combat = {
		capacity = 20,
		dam = 38,
		apr = 15,
		physcrit = 10,
		dammod = {dex=0.7, cun=0.5, wil=0.1},
		ranged_project={
			[DamageType.MIND] = 25,
			[DamageType.MINDSLOW] = 30,
		},
		talent_on_hit = { [Talents.T_RELOAD] = {level=1, chance=50} },
	},
}

newEntity{ base = "BASE_SHOT", --Thanks Grayswandir!
	power_source = {nature=true},
	unique = true,
	name = "Wind Worn Shot", image = "object/artifact/wind_worn_shot.png",
	unided_name = "perfectly smooth shot",
	kr_name = "바람에 닳은 탄환", kr_unided_name = "아주 부드러운 탄환",
	desc = [[완연한 흰색을 띄고 있는 구체들로, 강한 바람에 오랫동안 노출되어 닳아버린 것 같습니다.]],
	color = colors.RED,
	level_range = {25, 40},
	rarity = 300,
	cost = 110,
	material_level = 4,
	require = { stat = { dex=28 }, },
	combat = {
		capacity = 25,
		dam = 39,
		apr = 15,
		physcrit = 10,
		travel_speed = 1,
		dammod = {dex=0.7, cun=0.5},
		talent_on_hit = { [Talents.T_TORNADO] = {level=2, chance=10} },
		special_on_hit = {desc="35% 확률로 두번째 대상을 감전", on_kill=1, fct=function(combat, who, target)
			if not rng.percent(35) then return end
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
			local tg = {type="beam", range=5, friendlyfire=false, x=target.x, y=target.y}
			if #tgts <= 0 then return end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)
			local dam = 30 + (who:combatMindpower())

			who:project(tg, a.x, a.y, engine.DamageType.LIGHTNING, rng.avg(1, dam, 3))
			game.level.map:particleEmitter(x, y, math.max(math.abs(a.x-x), math.abs(a.y-y)), "lightning", {tx=a.x-x, ty=a.y-y})
			game:playSoundNear(who, "talents/lightning")
		end},
	},
}

newEntity{ base = "BASE_GREATMAUL",
	power_source = {nature=true, antimagic=true},
	name = "Spellcrusher", color = colors.GREEN, image = "object/artifact/spellcrusher.png",
	unided_name = "vine coated hammer", unique = true,
	kr_name = "마법분쇄기", kr_unided_name = "덩굴 감긴 망치",
	desc = [[커다란 강철 대형망치로, 두꺼운 덩굴이 손잡이 부분에 감겨 있습니다.]],
	level_range = {10, 20},
	rarity = 300,
	require = { stat = { str=20 }, },
	cost = 650,
	material_level = 2,
	combat = {
		dam = 32,
		apr = 4,
		physcrit = 4,
		dammod = {str=1.2},
		melee_project={[DamageType.NATURE] = 20},
		special_on_hit = {desc="50% 확률로 마법 보호막 분쇄", fct=function(combat, who, target)
			if not rng.percent(50) then return end
			if not target then return end

			-- List all diseases, I mean, burns, I mean, shields.
			local shields = {}
			for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
				if e.subtype.shield and p.power and e.type == "magical" then
					shields[#shields+1] = {id=eff_id, params=p}
				end
			end
			local is_shield = false
			-- Make them EXPLODE !!!, I mean, remove them.
			for i, d in ipairs(shields) do
				target:removeEffect(d.id)
				is_shield=true
			end
			
			if target:attr("disruption_shield") then
				target:forceUseTalent(target.T_DISRUPTION_SHIELD, {ignore_energy=true})
				is_shield = true
			end
			if is_shield == true then
				game.logSeen(target, "%s의 마법 보호막이 부서졌습니다!", (target.kr_name or target.name):capitalize())
			end
		end},
	},
	wielder = {
		inc_damage= {[DamageType.NATURE] = 25},
		inc_stats = {[Stats.STAT_CON] = 6,},
		combat_spellresist=15,
	},
	on_wear = function(self, who)
		if who:attr("forbid_arcane") then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"combat","melee_project"}, {[DamageType.MANABURN]=20})
			self:specialWearAdd({"wielder","resists"}, {[DamageType.ARCANE] = 10, [DamageType.BLIGHT] = 10})
			game.logPlayer(who, "#DARK_GREEN#몸안에서부터 엄청난 힘이 솟아오르기 시작합니다!!")
		end
	end,
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {psionic=true},
	unique=true, rarity=240,
	type = "charm", subtype="torque",
	name = "Telekinetic Core", image = "object/artifact/telekinetic_core.png",
	unided_name = "heavy torque",
	color = colors.BLUE,
	level_range = {5, 20},
	kr_name = "염력의 중심", kr_unided_name = "무거운 주술고리",
	desc = [[무거운 주술고리로, 주변의 물질을 끌어당기는 힘을 가지고 있습니다.]],
	cost = 320,
	material_level = 2,
	wielder = {
		resists={[DamageType.PHYSICAL] = 5,},
		inc_damage={[DamageType.PHYSICAL] = 6,},
		combat_physresist = 12,
		inc_stats = {[Stats.STAT_WIL] = 5,},
		combat_mindpower=3,
		combat_dam=3,
	},
	max_power = 35, power_regen = 1,
	use_talent = { id = Talents.T_PSIONIC_PULL, level = 3, power = 18 },
}

newEntity{ base = "BASE_GREATSWORD", --Thanks Grayswandir!
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Spectral Blade", image = "object/artifact/spectral_blade.png",
	unided_name = "immaterial sword",
	level_range = {10, 20},
	color=colors.GRAY,
	rarity = 300,
	encumber = 0.1,
	kr_name = "유령의 칼날", kr_unided_name = "비물질 검",
	desc = [[이 검은 무게가 없으며, 거의 투명하여 눈에 잘 보이지 않습니다.]],
	cost = 400,
	require = { stat = { str=24, }, },
	metallic = false,
	material_level = 2,
	combat = {
		dam = 24,
		physspeed=0.9,
		apr = 25,
		physcrit = 3,
		dammod = {str=1.2},
		melee_project={[DamageType.ARCANE] = 10,},
		burst_on_crit = {
			[DamageType.ARCANE_SILENCE] = 30,
		},
	},
	wielder = {
		blind_fight = 1,
		see_invisible=10,
		combat_spellpower = 5,
		mana_regen = 0.5,
	},
}

newEntity{ base = "BASE_GLOVES", --Thanks SageAcrin /AND/ Edge2054!
	power_source = {technique=true, arcane=true},
	unique = true,
	name = "Crystle's Astral Bindings", --Yes, CRYSTLE. It's a name.
	unided_name = "crystalline gloves", image = "object/artifact/crystles_astral_bindings.png",
	kr_name = "크리스틸의 별빛 붕대", kr_unided_name = "수정같이 맑은 장갑",
	desc = [[잊혀진 아노리실이 가지고 있던 것으로, 이 다른 세계에서 온 것 같은 붕대 표면에는 수많은 별이 반사되어 보입니다.]],
	level_range = {8, 20},
	rarity = 225,
	cost = 340,
	material_level = 2,
	wielder = {
		inc_stats = { [Stats.STAT_MAG] = 3 },
		combat_spellpower = 2,
		combat_spellcrit = 3,
		spellsurge_on_crit = 4,
		resists={[DamageType.DARKNESS] = 8, [DamageType.TEMPORAL] = 8},
		inc_damage={[DamageType.DARKNESS] = 8, [DamageType.TEMPORAL] = 8},
		resists_pen={[DamageType.DARKNESS] = 10, [DamageType.TEMPORAL] = 10},
		negative_regen=0.2,
		negative_regen_ref_mod=0.2,
		combat = {
			dam = 13,
			apr = 3,
			physcrit = 6,
			dammod = {dex=0.4, str=-0.6, cun=0.4, mag=0.2 },
			convert_damage = {[DamageType.VOID] = 100,},
			talent_on_hit = { [Talents.T_SHADOW_SIMULACRUM] = {level=1, chance=15}, [Talents.T_MIND_BLAST] = {level=1, chance=10}, [Talents.T_TURN_BACK_THE_CLOCK] = {level=1, chance=10} },
		},
	},
	talent_on_spell = { {chance=10, talent=Talents.T_DUST_TO_DUST, level=2} },
}

newEntity{ base = "BASE_GEM", --Thanks SageAcrin and Graziel!
	power_source = {arcane=true},
	unique = true,
	unided_name = "cracked golem eye",
	name = "Prothotipe's Prismatic Eye", subtype = "multi-hued",
	color = colors.WHITE, image = "object/artifact/prothotipes_prismatic_eye.png",
	level_range = {18, 30},
	kr_name = "프로소티페의 무지개빛 눈", kr_unided_name = "부서진 골렘 눈",
	desc = [[부서진지 오래되어, 그 색이 희미해진 원석입니다. 한때는 골렘의 눈으로 사용되던 것 같습니다.]],
	rarity = 240,
	cost = 200,
	identified = false,
	material_level = 3,
	wielder = {
		inc_stats = {[Stats.STAT_MAG] = 5, [Stats.STAT_CON] = 5, },
		inc_damage = {[DamageType.FIRE] = 10, [DamageType.COLD] = 10, [DamageType.LIGHTNING] = 10,  },
		talents_types_mastery = {
			["golem/arcane"] = 0.2,
		},
		talent_on_spell = { {chance=10, talent=Talents.T_GOLEM_BEAM, level=2} },

	},
	imbue_powers = {
		inc_stats = {[Stats.STAT_MAG] = 5, [Stats.STAT_CON] = 5, },
		inc_damage = {[DamageType.FIRE] = 10, [DamageType.COLD] = 10, [DamageType.LIGHTNING] = 10,  },
		talents_types_mastery = {
			["golem/arcane"] = 0.2,
		},
		talent_on_spell = { {chance=10, talent=Talents.T_GOLEM_BEAM, level=2} },
	},
	--special_desc = function(self) return "Casts lasers on spellcast when worn or imbued." end,

}

newEntity{ base = "BASE_MASSIVE_ARMOR", --Thanks SageAcrin!
	power_source = {psionic=true},
	unique = true,
	name = "Plate of the Blackened Mind", image = "object/artifact/plate_of_the_blackened_mind.png",
	unided_name = "solid black breastplate",
	kr_name = "더럽혀진 정신의 판갑", kr_unided_name = "단단한 검은 흉갑",
	desc = [[이 짙은 검정빛 갑옷은 주변의 빛을 모두 흡수하고 있습니다. 그 속에는 근원적인 어두운 힘이 잠들어 있으며, 아직도 의식이 남아있습니다. 판갑을 건드리면, 정신 속으로 어둠이 기어들어오는 것이 느껴집니다.]],
	color = colors.BLACK,
	level_range = {40, 50},
	rarity = 390,
	require = { stat = { str=48 }, },
	cost = 800,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 6, [Stats.STAT_CUN] = 4, [Stats.STAT_CON] = 3,},
		resists = {
			[DamageType.ACID] = 15,
			[DamageType.LIGHT] = 15,
			[DamageType.MIND] = 25,
			[DamageType.BLIGHT] = 20,
			[DamageType.DARKNESS] = 20,
		},
		combat_def = 15,
		combat_armor = 40,
		confusion_immune = 1,
		fear_immune = 1,
		combat_mentalresist = 25,
		combat_physresist = 15,
		combat_mindpower=10,
		lite = -2,
		infravision=4,
		fatigue = 17,
		talents_types_mastery = {
			["cursed/gloom"] = 0.2,
		},
		on_melee_hit={[DamageType.ITEM_MIND_GLOOM] = 20}, --Thanks Edge2054!
	},
	max_power = 25, power_regen = 1,
	use_talent = { id = Talents.T_DOMINATE, level = 2, power = 15 },
}

newEntity{ base = "BASE_TOOL_MISC", --Sorta Thanks Donkatsu!
	power_source = {nature = true},
	unique=true, rarity=220,
	type = "charm", subtype="totem",
	name = "Tree of Life", image = "object/artifact/tree_of_life.png",
	unided_name = "tree shaped totem",
	color = colors.GREEN,
	level_range = {40, 50},
	kr_name = "생명의 나무", kr_unided_name = "나무 모양의 토템",
	desc = [[이 작은 나무 모양의 토템에는 강력한 치유의 힘이 주입되어 있습니다.]],
	cost = 320,
	material_level = 4,
	special_desc = function(self) return "주변의 모든 생명체가 턴 당 생명력을 5 회복합니다." end,
	sentient=true,
	use_no_energy = true,
	wielder = {
		resists={[DamageType.BLIGHT] = 20, [DamageType.NATURE] = 20},
		inc_damage={[DamageType.NATURE] = 20},
		talents_types_mastery = { ["wild-gift/call"] = 0.1, ["wild-gift/harmony"] = 0.1, },
		inc_stats = {[Stats.STAT_WIL] = 7, [Stats.STAT_CON] = 6,},
		combat_mindpower=7,
		healing_factor=0.25,
	},
	on_takeoff = function(self, who)
		self.worn_by=nil
		who:removeParticles(self.particle)
	end,
	on_wear = function(self, who)
		self.worn_by=who
		if core.shader.active(4) then
			self.particle = who:addParticles(engine.Particles.new("shader_ring_rotating", 1, {rotation=0, radius=4}, {type="flames", aam=0.5, zoom=3, npow=4, time_factor=4000, color1={0.2,0.7,0,1}, color2={0,1,0.3,1}, hide_center=0}))
		else
			self.particle = who:addParticles(engine.Particles.new("ultrashield", 1, {rm=0, rM=0, gm=180, gM=220, bm=10, bM=80, am=80, aM=150, radius=2, density=30, life=14, instop=17}))
		end
		game.logPlayer(who, "#CRIMSON#%s 착용하자, 강력한 치유의 힘이 주변을 감쌉니다.", self:getName():capitalize():addJosa("를"))
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by=nil return end
		if self.worn_by:attr("dead") then return end
		local who = self.worn_by
		local blast = {type="ball", range=0, radius=2, selffire=true}
		who:project(blast, who.x, who.y, engine.DamageType.HEALING_NATURE, 5)
	end,
	max_power = 15, power_regen = 1,
	use_power = { name = "take root increasing health, armor, and armor hardiness but rooting you in place", kr_name = "뿌리를 내려 그 자리에 속박되는 대신 생명력과 방어도, 방어 효율을 증가", power = 10,
		use = function(self, who)
			who:setEffect(who.EFF_TREE_OF_LIFE, 4, {})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_RING",
	power_source = {technique=true, nature=true},
	name = "Ring of Growth", unique=true, image = "object/artifact/ring_of_growth.png",
	kr_name = "성장의 반지", kr_unided_name = "덩굴이 둘러진 반지",
	desc = [[작은 나무 반지로, 하나의 녹색 줄기가 감겨있습니다. 가는 나뭇잎이 그 속에서 피어오르고 있습니다.]],
	unided_name = "vine encircled ring",
	level_range = {6, 20},
	rarity = 250,
	cost = 500,
	material_level = 2,
	wielder = {
		combat_physresist = 8,
		inc_stats = {[Stats.STAT_WIL] = 4, [Stats.STAT_STR] = 4,},
		inc_damage={ [DamageType.PHYSICAL] = 8, [DamageType.NATURE] = 8,},
		resists={[DamageType.NATURE] = 10,},
		life_regen=0.15,
		healing_factor=0.2,
	},
}

newEntity{ base = "BASE_CLOAK",
	power_source = {arcane=true},
	unique = true,
	name = "Wrap of Stone", image = "object/artifact/wrap_of_stone.png",
	unided_name = "solid stone cloak",
	kr_name = "암석 덮개", kr_unided_name = "단단한 암석 망토",
	desc = [[이 두꺼운 망토는 놀라울 정도로 단단하면서도, 쉽게 구부러지고 흔들거립니다.]],
	level_range = {8, 20},
	rarity = 400,
	cost = 250,
	material_level = 2,
	wielder = {
		combat_spellpower=6,
		combat_armor=10,
		combat_armor_hardiness=15,
		talents_types_mastery = {
			["spell/earth"] = 0.2,
			["spell/stone"] = 0.1,
		},
		inc_damage={ [DamageType.PHYSICAL] = 5,},
		resists={ [DamageType.PHYSICAL] = 5,},
	},
	max_power = 60, power_regen = 1,
	use_talent = { id = Talents.T_STONE_WALL, level = 1, power = 60 },
}

newEntity{ base = "BASE_LIGHT_ARMOR", --Thanks SageAcrin!
	power_source = {arcane=true},
	unided_name = "black leather armor",
	name = "Death's Embrace", unique=true, image = "object/artifact/deaths_embrace.png",
	kr_name = "죽음의 포옹", kr_unided_name = "검은 가죽 갑옷",
	desc = [[이 짙은 검은 가죽 갑옷은 두꺼운 비단으로 감싸져 있으며, 건드려보면 얼음같이 차갑다는 것을 알 수 있습니다.]],
	level_range = {40, 50},
	rarity = 250,
	cost = 300,
	material_level=5,
	wielder = {
		combat_spellpower = 10,
		combat_critical_power = 20,
		combat_def = 18,
		combat_armor = 18,
		combat_armor_hardiness=15,
		inc_stats = { 
			[Stats.STAT_MAG] = 5, 
			[Stats.STAT_CUN] = 5, 
			[Stats.STAT_DEX] = 5, 
		},
		healing_factor=-0.15,
		on_melee_hit = {[DamageType.DARKNESS]=15, [DamageType.COLD]=15},
		inc_stealth=10,
 		inc_damage={
			[DamageType.DARKNESS] = 20,
			[DamageType.COLD] = 20,
 		},
 		resists={
			[DamageType.TEMPORAL] = 30,
			[DamageType.DARKNESS] = 30,
			[DamageType.COLD] = 30,
 		},
 		talents_types_mastery = {
 			["spell/phantasm"] = 0.1,
 			["spell/shades"] = 0.1,
			["cunning/stealth"] = 0.1,
 		},
	},
	max_power = 50, power_regen = 1,
	use_power = { name = "turn yourself invisible for 10 turns", kr_name = "10 턴 동안 투명화", power = 50,
		use = function(self, who)
			who:setEffect(who.EFF_INVISIBILITY, 10, {power=10+who:getCun()/6+who:getMag()/6, penalty=0.5, regen=true})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_LIGHT_ARMOR", --Thanks SageAcrin!
	power_source = {nature=true, antimagic=true},
	unided_name = "gauzy green armor",
	name = "Breath of Eyal", unique=true, image = "object/artifact/breath_of_eyal.png",
	kr_name = "에이알의 숨결", kr_unided_name = "얇은 녹색 갑옷",
	desc = [[이 가벼운 갑옷은 무수히 많은 새싹을 엮어 만든 것으로, 그 새싹들은 지금도 성장하고 있습니다. 손으로 들어보면 아주 가볍지만, 실제로 착용하면 어깨에 세상의 무게가 느껴집니다.]],
	level_range = {40, 50},
	rarity = 250,
	cost = 300,
	material_level=5,
	wielder = {
		combat_spellresist = 20,
		combat_mindpower = 10,
		combat_def = 10,
		combat_armor = 10,
		fatigue = 20,
		resists = {
			[DamageType.ACID] = 20,
			[DamageType.LIGHTNING] = 20,
			[DamageType.FIRE] = 20,
			[DamageType.COLD] = 20,
			[DamageType.LIGHT] = 20,
			[DamageType.DARKNESS] = 20,
			[DamageType.BLIGHT] = 20,
			[DamageType.TEMPORAL] = 20,
			[DamageType.NATURE] = 20,
			[DamageType.ARCANE] = 15,
		},
	},
	on_wear = function(self, who)
		if who:attr("forbid_arcane") then
			local Stats = require "engine.interface.ActorStats"
			local DamageType = require "engine.DamageType"

			self:specialWearAdd({"wielder","resists"}, {all = 10})
			game.logPlayer(who, "#DARK_GREEN#당신 뒤에 있는, 세계의 무게가 느껴집니다!")
		end
	end,
}

newEntity{ base = "BASE_TOOL_MISC", --Thanks Alex!
	power_source = {arcane=true},
	unique = true,
	name = "Eternity's Counter", color = colors.WHITE,
	unided_name = "crystalline hourglass", image="object/artifact/eternities_counter.png",
	kr_name = "영원의 시계", kr_unided_name = "수정 모래시계",
	desc = [[모래 대신에 셀 수 없이 많은 작은 보석들이 채워진, 마치 다른 세상에서 온 것 같은 수정 모래시계입니다. 보석이 흐르면, 주변의 시간이 변화하는 것을 느낄 수 있습니다.]],
	level_range = {30, 40},
	rarity = 300,
	cost = 200,
	material_level = 4,
	direction=1,
	finished=false,
	sentient=true,
	metallic = false,
	special_desc = function(self) return "모래의 위치에 따라서, 공격적이거나 방어적인 혜택을 제공합니다." end,
	wielder = {
		inc_damage = { [DamageType.TEMPORAL]= 15},
		resists = { [DamageType.TEMPORAL] = 15, all = 0, },
		movement_speed=0,
		combat_physspeed=0,
		combat_spellspeed=0,
		combat_mindspeed=0,
		flat_damage_armor = {all=0},
	},
	max_power = 20, power_regen = 1,
	use_power = { name = "flip the hourglass", kr_name = "모래시계 뒤집기", power = 20,
		use = function(self, who)
			self.direction = self.direction * -1
			self.finished = false
			who:onTakeoff(self, who.INVEN_TOOL, true)
			self.wielder.inc_damage.all = 0
			self.wielder.flat_damage_armor.all = 0
			who:onWear(self, who.INVEN_TOOL, true)
			game.logPlayer(who, "#GOLD#모래가 반대방향으로 천천히 떨어지기 시작합니다.")
		end
	},
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self)
		self.worn_by = nil
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by=nil return end
		if self.worn_by:attr("dead") then return end
		local who = self.worn_by
		local direction=self.direction
		if self.finished == true then return end
		who:onTakeoff(self, who.INVEN_TOOL, true)
		
		self.wielder.resists.all = self.wielder.resists.all + direction * 3
		self.wielder.movement_speed = self.wielder.movement_speed + direction * 0.04
		self.wielder.combat_physspeed = self.wielder.combat_physspeed - direction * 0.03
		self.wielder.combat_spellspeed = self.wielder.combat_spellspeed - direction * 0.03
		self.wielder.combat_mindspeed = self.wielder.combat_mindspeed - direction * 0.03
		
		if self.wielder.resists.all <= -10 then 
			self.wielder.inc_damage.all = 10
			game.logPlayer(who, "#GOLD#마지막 모래알이 떨어지자, 몸에서 힘이 느껴집니다.")
			self.finished=true
		end
		if self.wielder.resists.all >= 10 then 
			self.wielder.flat_damage_armor.all = 10
			game.logPlayer(who, "#GOLD#마지막 모래알이 떨어지자, 조금 더 안전해지는 것을 느꼈습니다.")
			self.finished=true
		end
		
		who:onWear(self, who.INVEN_TOOL, true)
	end,
}

newEntity{ base = "BASE_WIZARD_HAT", --Thanks SageAcrin!
	power_source = {psionic=true, arcane=true},
	unique = true,
	name = "Malslek the Accursed's Hat",
	unided_name = "black charred hat",
	kr_name = "저주받은 말슬렉의 모자", kr_unided_name = "검게 탄 모자",
	desc = [[황혼의 시대에 다른 차원의 존재와 거래하는 법을 알고 있었던, 강력한 마법사 말슬렉이 가지고 있던 검은 모자입니다. 그는 주로 여러 강력한 악마들과 거래를 했었는데, 어느날 악마 중 하나가 지루함을 느껴 그를 배신하고 그의 힘을 훔쳐갔습니다. 이에 분노한 말슬렉은 자신의 탑에 불을 질러, 그 악마를 죽이려 했습니다. 이 불탄 모자는 그 폐허에 유일하게 남아있던 것입니다.]],
	color = colors.BLUE, image = "object/artifact/malslek_the_accursed_hat.png",
	level_range = {30, 40},
	rarity = 300,
	cost = 100,
	material_level = 4,
	wielder = {
		combat_def = 2,
		combat_mentalresist = -10,
		healing_factor=-0.1,
		combat_mindpower = 15,
		combat_spellpower = 10,
		combat_mindcrit=10,
		hate_on_crit = 2,
		hate_per_kill = 2,
		max_hate = 20,
		resists = { [DamageType.FIRE] = 20 },
		talents_types_mastery = {
			["cursed/punishments"]=0.2,
		},
		melee_project={[DamageType.RANDOM_GLOOM] = 30},
		inc_damage={
			[DamageType.DARKNESS] 	= 10,
			[DamageType.PHYSICAL]	= 10,
		},
	},
	talent_on_spell = { {chance=10, talent=Talents.T_AGONY, level=2} },
	talent_on_mind  = { {chance=10, talent=Talents.T_HATEFUL_WHISPER, level=2} },
}

newEntity{ base = "BASE_TOOL_MISC", --And finally, Thank you, Darkgod, for making such a wonderful game!
	power_source = {technique=true},
	unique=true, rarity=240,
	name = "Fortune's Eye", image = "object/artifact/fortunes_eye.png",
	unided_name = "golden telescope",
	color = colors.GOLD,
	level_range = {28, 40},
	kr_name = "행운의 눈", kr_unided_name = "황금 망원경",
	desc = [[이 잘 만들어진 망원경은, 탐험가이자 모험가인 케스틴 하이핀이 가지고 있던 것입니다. 그는 이 도구를 사용하여 마즈'에이알의 보물들을 찾아 여행을 다녔고, 죽기 전까지 그는 놀랄만큼 막대한 보물을 모았다고 합니다. 그는 자주 이 망원경을 행운의 상징으로 여겼고, 이것 덕분에 그 어떤 위험한 상황에서도 탈출할 수 있었다고 생각했습니다. 그는 도둑맞은 검에 대한 복수를 하러 온 악마에게 죽음을 맞았다고 알려져 있습니다.

그의 마지막 유언은 다음과 같습니다. "이제 끝을 맞이할 때가 온 것 같군. 하지만, 아직도 세상에는 찾아야할 것들이 너무나 많다네."]],
	cost = 350,
	material_level = 4,
	wielder = {		
		inc_stats = {[Stats.STAT_LCK] = 10, [Stats.STAT_CUN] = 5,},
		combat_atk=12,
		combat_apr=12,
		combat_physresist = 10,
		combat_spellresist = 10,
		combat_mentalresist = 10,
		combat_def = 12,
		see_invisible = 12,
		see_stealth = 12,
	},
	max_power = 35, power_regen = 1,
	use_talent = { id = Talents.T_TRACK, level = 2, power = 18 },
}

newEntity{ base = "BASE_LEATHER_CAP",
	power_source = {nature=true},
	unique = true,
	name = "Eye of the Forest",
	unided_name = "overgrown leather cap", image = "object/artifact/eye_of_the_forest.png",
	level_range = {24, 32},
	color=colors.GREEN,
	encumber = 2,
	rarity = 200,
	kr_name = "숲의 눈", kr_unided_name = "우거진 가죽 모자",
	desc = [[이 가죽 모자는 앞쪽의 눈 구멍 부위만 제외하고는 두꺼운 이끼로 우거져 있습니다. 눈 주변에는 짙은 녹색 슬라임이 눈동자처럼 천천히 움직이고 있습니다.]],
	cost = 200,
	material_level=3,
	wielder = {
		combat_def=8,
		inc_stats = { [Stats.STAT_WIL] = 8, [Stats.STAT_CUN] = 6, },
		blind_immune=1,
		combat_mentalresist = 12,
		see_invisible = 15,
		see_stealth = 15,
		inc_damage={
			[DamageType.NATURE] = 20,
		},
		infravision=2,
		resists_pen={
			[DamageType.NATURE] = 15,
		},
		talents_types_mastery = { ["wild-gift/moss"] = 0.1,},
	},
	max_power = 35, power_regen = 1,
	use_talent = { id = Talents.T_EARTH_S_EYES, level = 2, power = 35 },
}

newEntity{ base = "BASE_MINDSTAR",
	power_source = {antimagic=true},
	unique = true,
	name = "Eyal's Will",
	unided_name = "pale green mindstar",
	level_range = {38, 50},
	color=colors.AQUAMARINE, image = "object/artifact/eyals_will.png",
	rarity = 380,
	kr_name = "에이알의 의지", kr_unided_name = "창백한 녹색 마석",
	desc = [[이 부드러운 녹색 수정의 중심부에는 밝은 녹색 슬라임이 흘러다니고 있습니다. 작은 물방울이 가끔씩 그 표면에 맺히고, 그 물방울이 떨어진 대지에서는 풀잎 다발이 빠르게 자라나기 시작합니다.]],
	cost = 280,
	require = { stat = { wil=48 }, },
	material_level = 5,
	combat = {
		dam = 22,
		apr = 40,
		physcrit = 5,
		dammod = {wil=0.6, cun=0.2},
		damtype = DamageType.NATURE,
	},
	wielder = {
		combat_mindpower = 20,
		combat_mindcrit = 9,
		resists={[DamageType.BLIGHT] = 25, [DamageType.NATURE] = 15},
		inc_damage={
			[DamageType.NATURE] = 20,
			[DamageType.ACID] = 10,
		},
		resists_pen={
			[DamageType.NATURE] = 20,
			[DamageType.ACID] = 10,
		},
		inc_stats = { [Stats.STAT_WIL] = 10, [Stats.STAT_CUN] = 5, },
		learn_talent = {[Talents.T_OOZE_SPIT] = 3},
		talents_types_mastery = { ["wild-gift/mindstar-mastery"] = 0.1,},
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_SLIME_WAVE, level = 3, power = 30 },
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {nature=true},
	unique = true,
	name = "Evermoss Robe", color = colors.DARK_GREEN, image = "object/artifact/evermoss_robe.png",
	unided_name = "fuzzy green robe",
	kr_name = "늘푸른이끼 로브", kr_unided_name = "보송보송한 녹색 로브",
	desc = [[짙은 녹색 이끼를 단단히 묶어 만든 두꺼운 로브로, 만져보면 시원함이 느껴집니다. 이 로브에는 착용자를 더 활기차게 만들어주는 힘이 있다고 합니다.]],
	level_range = {30, 42},
	rarity = 200,
	cost = 350,
	material_level = 4,
	wielder = {
		combat_def=12,
		inc_stats = { [Stats.STAT_WIL] = 5, },
		combat_mindpower = 12,
		combat_mindcrit = 5,
		combat_physresist = 15,
		life_regen=0.2,
		healing_factor=0.15,
		inc_damage={[DamageType.NATURE] = 30,},
		resists={[DamageType.NATURE] = 25},
		resists_pen={[DamageType.NATURE] = 10},
		on_melee_hit={[DamageType.SLIME] = 35},
		talents_types_mastery = { ["wild-gift/moss"] = 0.1,},
	},
}

newEntity{ base = "BASE_SLING",
	power_source = {arcane=true},
	unique = true,
	name = "Nithan's Force", image = "object/artifact/sling_eldoral_last_resort.png",
	unided_name = "massive sling",
	kr_name = "닛탄의 힘", kr_unided_name = "묵직한 투석구",
	desc = [[벽돌로 만들어진 벽도 뚫어버릴 수 있었다는, 한 강력한 전사가 사용했던 투석구입니다. 지금 보니, 그의 강력했던 힘은 어떤 마법적 도움을 받아왔던 것 같습니다...]],
	level_range = {35, 50},
	rarity = 220,
	require = { stat = { dex=32 }, },
	cost = 350,
	material_level = 5,
	combat = {
		range = 10,
		physspeed = 0.7,
	},
	wielder = {
		pin_immune = 0.3,
		knockback_immune = 0.3,
		inc_stats = { [Stats.STAT_STR] = 10, [Stats.STAT_CON] = 5,},
		inc_damage={ [DamageType.PHYSICAL] = 35},
		resists_pen={[DamageType.PHYSICAL] = 15},
		resists={[DamageType.PHYSICAL] = 10},
	},
	max_power = 25, power_regen = 1,
	use_talent = { id = Talents.T_DIG, level = 3, power = 25 },
}

newEntity{ base = "BASE_ARROW",
	power_source = {technique=true},
	unique = true,
	name = "The Titan's Quiver", image = "object/artifact/the_titans_quiver.png",
	unided_name = "gigantic ceramic arrows",
	kr_name = "거인의 화살통", kr_unided_name = "거대한 세라믹 화살이 담긴 통",
	desc = [[이 거대한 화살들은 끝이 매우 날카롭게 갈려 있으며, 절대 부러지지 않을 것 같아보입니다. 마치 화살이라기보다는, 거대한 가시 같습니다.]],
	color = colors.GREY,
	level_range = {35, 50},
	rarity = 300,
	cost = 150,
	material_level = 5,
	require = { stat = { dex=20, str=30 }, },
	combat = {
		capacity = 18,
		dam = 62,
		apr = 20,
		physcrit = 8,
		dammod = {dex=0.5, str=0.7},
		special_on_crit = {desc="대상을 근처의 벽에 박아 강제로 속박", fct=function(combat, who, target)
			if not target or target == self then return end
			if target:checkHit(who:combatPhysicalpower()*1.25, target:combatPhysicalResist(), 0, 95, 15) and target:canBe("knockback") then
				game.logSeen(target, "%s 밀려나 속박되었습니다!", (target.kr_name or target.name):capitalize():addJosa("가"))
				target:knockback(who.x, who.y, 10)
				target:setEffect(target.EFF_PINNED, 5, {}) --ignores pinning resistance, too strong!
			end
		end},
	},
}

newEntity{ base = "BASE_RING",
	power_source = {technique=true, psionic=true},
	name = "Inertial Twine", unique=true, image = "object/artifact/inertial_twine.png",
	kr_name = "휘감긴 관성", kr_unided_name = "얽힌 철제 반지",
	desc = [[두 개의 나선으로 이루어진 반지로, 반지 자체에 관성의 힘이 작용하고 있습니다. 반지를 착용하면 반지의 능력이 몸 전체로 퍼지는 것을 느낄 수 있습니다.]],
	unided_name = "entwined iron ring",
	level_range = {17, 28},
	rarity = 250,
	cost = 300,
	material_level = 3,
	wielder = {
		combat_physresist = 12,
		inc_stats = {[Stats.STAT_WIL] = 8, [Stats.STAT_STR] = 4,},
		inc_damage={ [DamageType.PHYSICAL] = 5,},
		resists={[DamageType.PHYSICAL] = 5,},
		knockback_immune=1,
		combat_armor = 5,
	},
}

newEntity{ base = "BASE_LONGSWORD",
	power_source = {nature=true, technique=true},
	unique = true,
	name = "Everpyre Blade",
	unided_name = "flaming wooden blade", image = "object/artifact/everpyre_blade.png",
	moddable_tile = "special/%s_everpyre_blade",
	moddable_tile_big = true,
	level_range = {28, 38},
	color=colors.RED,
	rarity = 300,
	metallic = false,
	kr_name = "늘타오르는 검", kr_unided_name = "타오르는 목재 검",
	desc = [[이 화려한 검은 영원히 불타오른다고 알려진 나무를 깎아 만들어졌습니다. 칼자루 부분은 보석으로 만들어져, 상당히 높은 지위에 있던 자의 소유물이었음을 짐작할 수 있습니다. 검에서 나오는 불꽃은 착용자의 의지에 따라 구부릴 수 있습니다.]],
	cost = 400,
	require = { stat = { str=40 }, },
	material_level = 4,
	combat = {
		dam = 38,
		apr = 10,
		physcrit = 18,
		dammod = {str=1},
		convert_damage={[DamageType.FIRE] = 50,},
	},
	wielder = {
		resists = {
			[DamageType.FIRE] = 15,
			[DamageType.NATURE] = 10,
		},
		inc_damage = {
			[DamageType.FIRE] = 20,
		},
		resists_pen = {
			[DamageType.FIRE] = 15,
		},
		inc_stats = { [Stats.STAT_STR] = 7, [Stats.STAT_WIL] = 7 },
	},
	max_power = 25, power_regen = 1,
	use_talent = { id = Talents.T_FIRE_BREATH, level = 2, power = 25 },
}

newEntity{ base = "BASE_STAFF",
	power_source = {arcane=true},
	image = "object/artifact/eclipse.png",
	unided_name = "dark, radiant staff",
	flavor_name = "starstaff",
	name = "Eclipse", unique=true,
	kr_name = "일월식", kr_unided_name = "검은, 빛을 내뿜는 지팡이",
	desc = [[긴 마법지팡이로, 끝부분에 칠흑같이 새까만 구체가 달려 있습니다. 구체는 새까맣지만, 강렬한 빛을 내뿜고 있습니다.]],
	require = { stat = { mag=32 }, },
	level_range = {10, 20},
	rarity = 200,
	cost = 60,
	material_level = 2,
	modes = {"darkness", "light", "physical", "temporal"},
	combat = {
		is_greater = true,
		dam = 18,
		apr = 4,
		physcrit = 3.5,
		dammod = {mag=1.1},
		damtype = DamageType.DARKNESS,
	},
	wielder = {
		combat_spellpower = 12,
		combat_spellcrit = 8,
		inc_damage={
			[DamageType.LIGHT] = 15,
			[DamageType.DARKNESS] = 15,
			[DamageType.PHYSICAL] = 15,
			[DamageType.TEMPORAL] = 15,
		},
		positive_regen_ref_mod=0.1,
		negative_regen_ref_mod=0.1,
		positive_regen=0.1,
		negative_regen=0.1,
		talent_cd_reduction = {
			[Talents.T_TWILIGHT] = 1,
			[Talents.T_SEARING_LIGHT] = 1,
			[Talents.T_MOONLIGHT_RAY] = 1,
		},
		learn_talent = {[Talents.T_COMMAND_STAFF] = 1},
	},
}

newEntity{ base = "BASE_BATTLEAXE",
	power_source = {technique=true},
	unique = true,
	unided_name = "gore stained battleaxe",
	name = "Eksatin's Ultimatum", color = colors.GREY, image = "object/artifact/eskatins_ultimatum.png",
	kr_name = "엑사틴의 최후통첩", kr_unided_nmae = "피에 젖은 대형도끼",
	desc = [[이 피에 젖은 전투도끼는 가학증이 있던 악명 높은 왕이 사용하던 것으로, 그는 모든 처형을 스스로의 손으로 직접 내렸다고 합니다. 그는 그가 잘라낸 자들의 목을 소중하게 관리하였으며, 이를 금고에 넣어 보관했습니다. 그의 왕위는 결국 타도당했고, 그의 머리는 금고의 중앙을 장식하여 그의 잔인성에 대한 증거로 남겨졌습니다.]],
	require = { stat = { str=50 }, },
	level_range = {39, 46},
	rarity = 300,
	material_level = 4,
	combat = {
		dam = 63,
		apr = 25,
		physcrit = 25,
		dammod = {str=1.3},
		special_on_crit = {desc="약해진 적을 참수", fct=function(combat, who, target)
			if not target or target == self then return end
			if target:checkHit(who:combatPhysicalpower(), target:combatPhysicalResist(), 0, 95, 15) and target:canBe("instakill") and target.life > 0 and ((target.life < target.max_life * 0.25 and target.rank < 3.5) or target.life < target.max_life * 0.10) then
				target:die(who)
				game.logSeen(target, "#RED#%s#GOLD# 참수되었습니다!#LAST#", (target.kr_name or target.name):capitalize():addJosa("는"))
			end
		end},
	},
	wielder = {
		combat_critical_power = 25,
	},
}

newEntity{ base = "BASE_CLOAK",
	power_source = {arcane=true},
	unique = true,
	name = "Radiance", image = "object/artifact/radiance.png",
	unided_name = "a sparkling, golden cloak",
	kr_name = "광휘", kr_unided_name = "빛나는, 금색 망토",
	desc = [[이 아주 깨끗한 금색 망토는 어디선가 불어오는 마법의 바람으로 펄럭이고 있습니다. 망토 안쪽은 순백색이면서도, 바깥쪽에서는 눈부신 빛이 빛나고 있습니다.]],
	level_range = {45, 50},
	color = colors.GOLD,
	rarity = 500,
	cost = 300,
	material_level = 5,
	wielder = {
		combat_def = 15,
		combat_spellpower = 8,
		inc_stats = { 
			[Stats.STAT_MAG] = 8, 
			[Stats.STAT_CUN] = 6, 
			[Stats.STAT_DEX] = 10, 
		},
		inc_damage = { [DamageType.LIGHT]= 15 },
		resists_cap = { [DamageType.LIGHT] = 10, },
		resists = { [DamageType.LIGHT] = 20, [DamageType.DARKNESS] = 20, },
		talents_types_mastery = {
			["celestial/light"] = 0.2,
			["celestial/sun"] = 0.2,
			["spell/phantasm"] = 0.2,
			["celestial/radiance"] = 0.2, 
		},
		on_melee_hit={[DamageType.LIGHT_BLIND] = 30},
	},
	max_power = 40, power_regen = 1,
	use_talent = { id = Talents.T_BARRIER, level = 3, power = 40 },
}

newEntity{ base = "BASE_HEAVY_BOOTS",
	power_source = {technique=true},
	unique = true,
	name = "Unbreakable Greaves", image = "object/artifact/unbreakable_greaves.png",
	unided_name = "huge stony boots",
	kr_name = "부서지지 않는 정강이받이", kr_unided_name = "거대한 석재 신발",
	desc = [[이 거대한 신발은 바위를 깎아 만든 것으로 보입니다. 비록 풍화되고 금이 갔지만, 이 신발에는 모든 공격을 튕겨내는 힘을 가지고 있습니다.]],
	color = colors.DARK_GRAY,
	level_range = {40, 50},
	rarity = 250,
	cost = 200,
	material_level = 5,
	wielder = {
		combat_armor = 20,
		combat_def = 8,
		fatigue = 12,
		combat_dam = 10,
		inc_stats = { 
			[Stats.STAT_STR] = 20, 
			[Stats.STAT_CON] = 10, 
			[Stats.STAT_DEX] = -6, 
		},
		knockback_immune=1,
		combat_armor_hardiness = 20,
		inc_damage = { [DamageType.PHYSICAL] = 15 },
		resists = { [DamageType.PHYSICAL] = 15,  [DamageType.ACID] = 15,},
	},
}

newEntity{ base = "BASE_LIGHT_ARMOR",
	power_source = {arcane=true},
	unique = true, sentient=true,
	name = "The Untouchable", color = colors.BLUE, image = "object/artifact/the_untouchable.png",
	unided_name = "tough leather coat",
	kr_name = "무적", kr_unided_name = "거친 가죽 조끼",
	desc = [[이 튼튼한 조끼는 많은 시골 전설의 소재가 되어왔습니다.
누군가는 이 조끼가 모험심 강한 마법사가 도적이 되면서 만들었으며, 마법폭발이 일어나 잊혀지게 된 옷이라고 합니다.
그리고, 때때로 이것을 입고 (내기에 걸지 않아놓고 이기는 내기에 걸었다고 우기는) 클레임을 시도하는 자가 있었다고 합니다.
클레임에는 실패했지만 언제나 살아가는 그 모습을 보고, 모든 도박사들이 그 조끼를 '무적' 이라고 부르게 되었다고 합니다.]],
	level_range = {20, 30},
	rarity = 200,
	cost = 350,
	require = { stat = { str=16 }, },
	material_level = 3,
	wearer_hp = 100,
	wielder = {
		combat_def=14,
		combat_armor=12,
		combat_apr=10,
		inc_stats = { [Stats.STAT_CUN] = 8, },
	},
	on_wear = function(self, who)
		self.worn_by = who
		self.wearer_hp = who.life / who.max_life
	end,
	on_takeoff = function(self)
		self.worn_by = nil
	end,
	special_desc = function(self) return "한번에 최대 생명력의 20%가 넘는 피해를 받으면 보호막이 펼쳐집니다. 이 보호막은 생성시 받은 피해량의 130% 만큼 피해를 보호해줍니다." end,
	act = function(self)
		self:useEnergy()	
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.worn_by:attr("dead") then return end
		local hp_diff = (self.wearer_hp - self.worn_by.life/self.worn_by.max_life)
		
		if hp_diff >= 0.2 and not self.worn_by:hasEffect(self.worn_by.EFF_DAMAGE_SHIELD) then
			self.worn_by:setEffect(self.worn_by.EFF_DAMAGE_SHIELD, 4, {power = (hp_diff * self.worn_by.max_life)*1.3})
			game.logPlayer(self.worn_by, "#LIGHT_BLUE#가죽 조끼에서 보호막이 펼쳐집니다!")
		end		
		
		self.wearer_hp = self.worn_by.life/self.worn_by.max_life
	end,
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {nature = true},
	unique=true, rarity=240, image = "object/artifact/honeywood_chalice.png",
	type = "charm", subtype="totem",
	name = "Honeywood Chalice",
	unided_name = "sap filled cup",
	color = colors.BROWN,
	level_range = {30, 40},
	kr_name = "벌꿀나무 성배", kr_unided_name = "수액이 가득한 잔",
	desc = [[이 나무로 만들어진 잔은 끊임없이 수액과 같은 물질이 채워지고 있습니다. 그 맛은 매우 좋으며, 마실 때마다 의식이 고양되는 느낌이 듭니다.]],
	cost = 320,
	material_level = 4,
	wielder = {
		combat_physresist = 10,
		inc_stats = {[Stats.STAT_STR] = 5,},
		inc_damage={[DamageType.PHYSICAL] = 5,},
		resists={[DamageType.NATURE] = 10,},
		life_regen=0.15,
		healing_factor=0.1,
		
		learn_talent = {[Talents.T_BATTLE_TRANCE] = 1},
	},
}

newEntity{ base = "BASE_CLOTH_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "The Calm", color = colors.GREEN, image = "object/artifact/the_calm.png",
	unided_name = "ornate green robe",
	kr_name = "고요", kr_unided_name = "화려한 녹색 로브",
	desc = [[이 녹색 로브에는 구름과 소용돌이치는 바람의 형상이 수놓아져 있습니다. 원 소유자인 강력한 마법사 프로칼라는 그의 위대한 선행들과, 필요할 때마다 그가 보여준 강력한 능력으로 인해 많은 존경을 받았었습니다.]],
	level_range = {30, 40},
	rarity = 250,
	cost = 500,
	material_level = 4,
	special_desc = function(self) return "'전격' 과 '전격 연계' 마법이 24% 확률로 상대를 혼절시키고, '뇌우' 마법은 12% 확률로 상대를 혼절시킵니다." end,
	wielder = {
		combat_spellpower = 20,
		inc_damage = {[DamageType.LIGHTNING]=25},
		combat_def = 15,
		inc_stats = { [Stats.STAT_MAG] = 10, [Stats.STAT_WIL] = 8, [Stats.STAT_CUN] = 6,},
		resists={[DamageType.LIGHTNING] = 20},
		resists_pen = { [DamageType.LIGHTNING] = 15 },
		slow_projectiles = 15,
		movement_speed = 0.1,
		lightning_daze_tempest=24,
	},
}

newEntity{ base = "BASE_LEATHER_CAP",
	power_source = {psionic=true},
	unique = true,
	name = "Omniscience", image = "object/artifact/omniscience.png",
	unided_name = "very plain leather cap",
	level_range = {40, 50},
	color=colors.WHITE,
	encumber = 1,
	rarity = 300,
	kr_name = "전지적 시점", kr_unided_name = "매우 평범한 가죽 모자",
	desc = [[이 흰 모자는 평범하고 단조롭지만, 그 표면에 빛을 반사시켜보면 멀리 떨어진 장소들의 영상이 비춰집니다."]],
	cost = 200,
	material_level=5,
	wielder = {
		combat_def=7,
		combat_mindpower=20,
		combat_mindcrit=9,
		combat_mentalresist = 25,
		infravision=5,
		confusion_immune=0.4,
		resists = {[DamageType.MIND] = 15,},
		resists_cap = {[DamageType.MIND] = 10,},
		resists_pen = {[DamageType.MIND] = 10,},
		max_psi=50,
		psi_on_crit=6,
	},
	max_power = 30, power_regen = 1,
	use_power = { name = "reveal the surrounding area", kr_name = "주변 영역 살펴보기", power = 30,
		use = function(self, who)
			who:magicMap(20)
			game.logSeen(who, "%s 지형을 탐지했습니다!", (who.kr_name or who.name):capitalize():addJosa("가"))
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_AMULET",
	power_source = {nature=true},
	unique = true,
	name = "Earthen Beads", color = colors.BROWN, image = "object/artifact/earthen_beads.png",
	unided_name = "strung clay beads",
	kr_name = "대지의 염주", kr_unided_name = "진흙 염주 목걸이",
	desc = [[이것은 단단한 진흙 염주가 꿰어진 고대의 목걸이로, 그 세월에 의해 색이 바래고 금이 간 상태입니다. 황혼의 시대에, 자연의 추종자들이 자연과의 일체감을 높이기 위해 사용했다고 합니다.]],
	level_range = {10, 20},
	rarity = 200,
	cost = 100,
	material_level = 2,
	metallic = false,
	special_desc = function(self) return "'명상' 기술의 효율이 20% 상승합니다." end,
	wielder = {
		combat_mindpower = 5,
		enhance_meditate=0.2,
		inc_stats = { [Stats.STAT_WIL] = 4,},
		life_regen=0.2,
		damage_affinity={
			[DamageType.NATURE] = 15,
		},
	},
	max_power = 40, power_regen = 1,
	use_talent = { id = Talents.T_NATURE_TOUCH, level = 2, power = 40 },
}

newEntity{ base = "BASE_GAUNTLETS",
	power_source = {arcane=true, nature=true}, --Perhaps it is of Dwarven make :)
	unique = true,
	name = "Hand of the World-Shaper", color = colors.BROWN, image = "object/artifact/hand_of_the_worldshaper.png",
	unided_name = "otherworldly stone gauntlets",
	kr_name = "대지를 다루는 손", kr_unided_name = "이계의 돌장갑",
	desc = [[이 무거운 돌로 만들어진 전투장갑은 그 움직임에 따라 발 아래의 대지를 변형하고 움직일 수 있게 만들어줍니다.]],
	level_range = {40, 50},
	rarity = 300,
	cost = 800,
	material_level = 5,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 6, [Stats.STAT_MAG] = 6 },
		inc_damage = { [DamageType.PHYSICAL] = 12 },
		resists = { [DamageType.PHYSICAL] = 10 },
		resists_pen = { [DamageType.PHYSICAL] = 15 },
		combat_spellpower=10,
		combat_spellcrit = 10,
		combat_armor = 12,
		talents_types_mastery = {
			["spell/earth"] = 0.1,
			["spell/stone"] = 0.2,
			["wild-gift/sand-drake"] = 0.1,
		},
		combat = {
			dam = 38,
			apr = 10,
			physcrit = 7,
			physspeed = 0.2,
			dammod = {dex=0.4, str=-0.6, cun=0.4, mag=0.1 },
			talent_on_hit = { T_EARTHEN_MISSILES = {level=5, chance=15},},
			damrange = 0.3,
			burst_on_hit = {
			[DamageType.GRAVITY] = 50,
			},
			burst_on_crit = {
			[DamageType.GRAVITYPIN] = 30,
			},
		},
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_EARTHQUAKE, level = 4, power = 30 },
}

newEntity{ base = "BASE_CLOAK",
	power_source = {psionic=true},
	unique = true,
	name = "Guise of the Hated", image = "object/artifact/guise_of_the_hated.png",
	unided_name = "gloomy black cloak",
	kr_name = "혐오받는 자의 가면", kr_unided_name = "우울한 검은 망토",
	desc = [[달은 잊어, 반짝이는 하늘도,
	따뜻하게 맞이하는 태양의 광채도.
	빛줄기는 결코 안에 닿지 않고,
	심장은 이제 숨기를 바랄뿐]],
	level_range = {40, 50},
	color = colors.BLACK,
	rarity = 370,
	cost = 300,
	material_level = 5,
	wielder = {
		combat_def = 14,
		combat_mindpower = 8,
		combat_mindcrit = 4,
		combat_physcrit = 4,
		inc_stealth=12,
		combat_mentalresist = 10,
		hate_per_kill = 5,
		hate_per_crit = 5,
		inc_stats = { 
			[Stats.STAT_WIL] = 8, 
			[Stats.STAT_CUN] = 6, 
			[Stats.STAT_DEX] = 4, 
		},
		inc_damage = { all = 4 },
		resists = {[DamageType.DARKNESS] = 10, [DamageType.MIND] = 10,},
		talents_types_mastery = {
			["cursed/gloom"] = 0.2,
			["cursed/darkness"] = 0.2,
		},
		on_melee_hit={[DamageType.MIND] = 30},
	},
	max_power = 18, power_regen = 1,
	use_talent = { id = Talents.T_CREEPING_DARKNESS, level = 4, power = 18 },
}

newEntity{ base = "BASE_KNIFE", --Thanks FearCatalyst/FlarePusher!
	power_source = {arcane=true},
	unique = true,
	name = "Spelldrinker", image = "object/artifact/spelldrinker.png",
	unided_name = "eerie black dagger",
	kr_name = "주문흡혈기", kr_unided_name = "으스스한 검은 단검",
	desc = [[셀 수 없이 많은 마법사들이 더 강력한 힘을 원하는 자들에게 배신당해, 이 날카로운 칼날에 찔려 쓰러졌습니다.
	그렇게 손에서 손을 거쳐, 이 칼날은 그 스스로 '갈증' 을 느끼게 되었습니다.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { dex=30 }, },
	cost = 300,
	material_level = 3,
	combat = {
		dam = 27,
		apr = 8,
		physcrit = 9,
		dammod = {str=0.45, dex=0.55, mag=0.05},
		talent_on_hit = { T_DISPERSE_MAGIC = {level=1, chance=15},},
		special_on_hit = {desc="대상으로부터 마나를 50 강탈", fct=function(combat, who, target)
			local manadrain = util.bound(target:getMana(), 0, 50)
			target:incMana(-manadrain)
			who:incMana(manadrain)
			local tg = {type="ball", range=10, radius=0, selffire=false}
			who:project(tg, target.x, target.y, engine.DamageType.ARCANE, manadrain)
		end},
	},
	wielder = {
		inc_stats = {[Stats.STAT_MAG] = 6, [Stats.STAT_CUN] = 6,},
		combat_spellresist=12,
		resists={
			[DamageType.ARCANE] = 12,
		},
	},
}

newEntity{ base = "BASE_AMULET",
	power_source = {arcane=true},
	unique = true,
	name = "Frost Lord's Chain",
	unided_name = "ice coated chain", image = "object/artifact/frost_lords_chain.png",
	kr_name = "서리 군주의 사슬", kr_unided_name = "얼음으로 덮여진 사슬",
	desc = [[이상하고 위압적인 기운이 뿜어져 나오는 서리가 뒤덮힌, 금속으로 이어진 비현실적으로 차가운 사슬 목걸이입니다.]],
	color = colors.LIGHT_RED,
	level_range = {40, 50},
	rarity = 220,
	cost = 350,
	material_level = 5,
	special_desc = function(self) return "냉기속성 피해를 줄 때 마다 20% 확률로 상대를 빙결시킵니다." end,
	wielder = {
		combat_spellpower=12,
		inc_damage={
			[DamageType.COLD] = 12,
		},
		resists={
			[DamageType.COLD] = 25,
		},
		stun_immune = 0.3,
		on_melee_hit = {[DamageType.COLD]=10},
		cold_freezes = 20,
		iceblock_pierce=20,
		learn_talent = {[Talents.T_SHIV_LORD] = 2},
	},
}

newEntity{ base = "BASE_LONGSWORD", --Thanks BadBadger?
	power_source = {arcane=true},
	unique = true,
	name = "Twilight's Edge", image = "object/artifact/twilights_edge.png",
	unided_name = "shining long sword",
	level_range = {32, 42},
	color=colors.GREY,
	rarity = 250,
	kr_name = "석양의 가장자리", kr_unided_name = "빛나는 장검",
	desc = [[이 검의 칼날은 보라툰과 스트라라이트의 합성 물질로 벼려진 듯 합니다. 그 결과 빛과 어둠이 서로 맞물려 소용돌이치는 문양을 띄고 있습니다.]],
	cost = 800,
	require = { stat = { str=35,}, },
	material_level = 4,
	combat = {
		dam = 47,
		apr = 7,
		physcrit = 12,
		dammod = {str=1},
		special_on_crit = {desc="빛과 어둠의 폭발을 만들어 주위의 모두에게 (마법 능력치에 비례하는) 피해를 줌", on_kill=1, fct=function(combat, who, target)
			local tg = {type="ball", range=10, radius=2, selffire=false}
			who:project(tg, target.x, target.y, engine.DamageType.LIGHT, 40 + who:getMag()*0.6)
			who:project(tg, target.x, target.y, engine.DamageType.DARKNESS, 40 + who:getMag()*0.6)
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "shadow_flash", {radius=tg.radius})
		end},
	},
	wielder = {
		lite = 1,
		combat_spellpower = 12,
		combat_spellcrit = 4,
		inc_damage={
			[DamageType.DARKNESS] = 18,
			[DamageType.LIGHT] = 18,
		},
		inc_stats = { [Stats.STAT_MAG] = 4, [Stats.STAT_STR] = 4, [Stats.STAT_CUN] = 4, },
	},
}

newEntity{ base = "BASE_RING",
	power_source = {psionic=true},
	name = "Mnemonic", unique=true, image = "object/artifact/mnemonic.png",
	kr_name = "기억", kr_unided_name = "익숙한 반지",
	desc = [[이 반지를 끼고 있는 한, 자신이 누구인지를 절대 잊지 않게 될 것입니다.]],
	unided_name = "familiar ring",
	level_range = {40, 50},
	rarity = 250,
	cost = 300,
	material_level = 5,
	special_desc = function(self) return "정신 기술을 사용할 때마다, 10% 확률로 최대 3 개의 자연의 권능이나 초능력 혹은 저주 계열 기술의 남은 지연시간을 3 턴 줄여줍니다." end,
	wielder = {
		combat_mentalresist = 20,
		combat_mindpower = 12,
		inc_stats = {[Stats.STAT_WIL] = 8,},
		resists={[DamageType.MIND] = 25,},
		confusion_immune=0.4,
		talents_types_mastery = {
			["psionic/mentalism"]=0.2,
		},
		psi_regen=0.5,	
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_MENTAL_SHIELDING, level = 2, power = 30 },
	talent_on_mind = { {chance=10, talent=Talents.T_MENTAL_REFRESH, level=1}},
}

newEntity{ base = "BASE_LONGSWORD",
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Acera",
	unided_name = "corroded sword", image = "object/artifact/acera.png",
	level_range = {25, 35},
	color=colors.GREEN,
	rarity = 300,
	kr_name = "아세라", kr_unided_name = "부식된 검",
	desc = [[이 뒤틀린 더러운 검의 셀수없이 많은 작은 구멍들에서 산성액이 흘러 떨어지고 있습니다.]],
	cost = 400,
	require = { stat = { str=40 }, },
	material_level = 3,
	combat = {
		dam = 33,
		apr = 4,
		physcrit = 10,
		dammod = {str=1},
		burst_on_crit = {
			[DamageType.ACID_CORRODE] = 40,
		},
		melee_project={[DamageType.ACID] = 12},
	},
	wielder = {
		inc_damage={ [DamageType.ACID] = 15,},
		resists={[DamageType.ACID] = 15,},
		resists_pen={[DamageType.PHYSICAL] = 10,}, --Burns right through your pathetic physical resists
		combat_physcrit = 10,
		combat_spellcrit = 10,
	},
	max_power = 30, power_regen = 1,
	use_talent = { id = Talents.T_CORROSIVE_WORM, level = 4, power = 30 },
}

newEntity{ base = "BASE_GREATSWORD",
	power_source = {technique=true},
	define_as = "DOUBLESWORD",
	name = "Borosk's Hate", unique=true, image="object/artifact/borosks_hate.png",
	unided_name = "double-bladed sword", color=colors.GREY,
	kr_name = "보로스크의 증오", kr_unided_name = "이중날 검",
	desc = [[이 인상깊은 검에는 커다란 칼날 두 개가 평행하게 달려있습니다. 두 날의 균형이 놀라울만큼 잘 맞춰져 있습니다.]],
	require = { stat = { str=35 }, },
	level_range = {40, 50},
	rarity = 240,
	cost = 280,
	material_level = 5,
	running=false,
	combat = {
		dam = 60,
		apr = 22,
		physcrit = 10,
		dammod = {str=1.2},
		special_on_hit = {desc="25% 확률로 상대를 한번 더 공격.", fct=function(combat, who, target)
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "DOUBLESWORD")
			if not o or not who:getInven(inven_id).worn then return end
			if o.running == true then return end
			if not rng.percent(25) then return end
			o.running=true
			who:attackTarget(target, engine.DamageType.PHYSICAL, 1,  true)
			o.running=false
		end},
	},
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 10, [Stats.STAT_DEX] = 5, [Stats.STAT_CON] = 15 },
		talents_types_mastery = {
			["technique/2hweapon-cripple"] = 0.2,
		},
	},
}

newEntity{ base = "BASE_LONGSWORD",
	power_source = {technique=true, psionic=true}, define_as = "BUTCHER",
	name = "Butcher", unique=true, image="object/artifact/butcher.png",
	unided_name = "blood drenched shortsword", color=colors.CRIMSON,
	kr_name = "도살자", kr_unided_name = "피에 젖은 단검",
	desc = [["저주 때문인지, 미쳐버렸기 때문인지, 엄청나게 권태로웠기 때문인지는 알 수 없으나, 하플링 도살업자였던 칼렙은 어느날 소 대신 동족을 먹어보기로 마음 먹었습니다. 그렇게 시작된 그의 잔치는 끝날 줄을 몰랐고, 그가 어디로 사라졌는지 아무도 알지 못합니다. 오직 이 칼만이 피에 젖은 받침대에 단단히 박힌 채로 남아있었는데, 그 아래에는 "재밌었다, 기회가 되면 또 해봐야겠어." 라는 말이 새겨져 있었습니다.]],
	require = { stat = { str=40 }, },
	level_range = {36, 48},
	rarity = 250,
	cost = 300,
	material_level = 5,
	sentient=true,
	running=false,
	special_desc = function(self) return ("생명력이 20%% 아래로 떨어지면 '광란' 상태가 됩니다 (공유되는 지연 시간 30 턴).") end,
	combat = {
		dam = 48,
		apr = 12,
		physcrit = 10,
		dammod = {str=1},
		special_on_hit = {desc="생명력이 낮아 즉사시킬 수 있는 적을 재공격하여, 삼키기 시도.", fct=function(combat, who, target)
			local Talents = require "engine.interface.ActorTalents"
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "BUTCHER")
			if not o or not who:getInven(inven_id).worn then return end
			if target.life / target.max_life > 0.15 or o.running==true then return end
			local Talents = require "engine.interface.ActorTalents"
			o.running=true
			if target:canBe("instakill") then
				who:forceUseTalent(Talents.T_SWALLOW, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=4, ignore_ressources=true})
			end
			o.running=false
		end},
		special_on_kill = {desc="'광란' 상태로 돌입 (공유되는 지연 시간 30 턴).", fct=function(combat, who, target)
			local Talents = require "engine.interface.ActorTalents"
			local o, item, inven_id = who:findInAllInventoriesBy("define_as", "BUTCHER")
			if not o or not who:getInven(inven_id).worn then return end
			if o.power < o.max_power then return end
			who:forceUseTalent(Talents.T_RAMPAGE, {ignore_cd=true, ignore_energy=true, force_level=2, ignore_ressources=true})
			o.power = 0
		end},
	},
	wielder = {
		inc_stats = { [Stats.STAT_CUN] = 7, [Stats.STAT_STR] = 10, [Stats.STAT_WIL] = 10, },
		talents_types_mastery = {
			["cursed/rampage"] = 0.2,
			["cursed/slaughter"] = 0.2,
		},
		combat_atk = 18,
	},
	max_power = 30, power_regen = 1,
	use_power = { name = "", power = 30, hidden = true, use = function(self, who) return end},
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self)
		self.worn_by = nil
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		if not self.worn_by then return end
		local who=self.worn_by
		if game.level and not game.level:hasEntity(who) and not who.player then self.worn_by = nil return end
		if who.life/who.max_life < 0.2 and self.power == self.max_power then
			local Talents = require "engine.interface.ActorTalents"
			who:forceUseTalent(Talents.T_RAMPAGE, {ignore_cd=true, ignore_energy=true, force_level=2, ignore_ressources=true})
			self.power=0
		end
	end,
}

newEntity{ base = "BASE_CLOAK",
	power_source = {arcane=true},
	unique = true,
	name = "Ethereal Embrace", image = "object/artifact/ethereal_embrace.png",
	unided_name = "wispy purple cloak",
	kr_name = "천상의 포옹", kr_unided_name = "성긴 보라빛 망토",
	desc = [[이 망토에서는 빛이 어른거리며, 우주의 깊이와 에테르의 심장을 표현하듯 물결치고 있습니다.]],
	level_range = {30, 40},
	rarity = 400,
	cost = 250,
	material_level = 4,
	special_desc = function(self) return ("피해 보호막의 지속시간이 +1 턴 증가하고, 성능이 15% 증가합니다.") end,
	wielder = {
		combat_spellcrit = 6,
		combat_def = 10,
		inc_stats = { 
			[Stats.STAT_MAG] = 8, 
		},
		talents_types_mastery = {
			["spell/arcane"] = 0.2,
			["spell/nightfall"] = 0.2,
			["spell/aether"] = 0.1,
		},
		spellsurge_on_crit = 5,
		inc_damage={ [DamageType.ARCANE] = 15, [DamageType.DARKNESS] = 15, },
		resists={ [DamageType.ARCANE] = 12, [DamageType.DARKNESS] = 12,},
		shield_factor=15,
		shield_dur=1,
	},
	max_power = 28, power_regen = 1,
	use_talent = { id = Talents.T_AETHER_BREACH, level = 2, power = 28 },
}

newEntity{ base = "BASE_HEAVY_BOOTS",
	power_source = {psionic=true},
	unique = true,
	name = "Boots of the Hunter", image = "object/artifact/boots_of_the_hunter.png",
	unided_name = "well-worn boots",
	kr_name = "사냥꾼의 신발", kr_unided_name = "잘 길들여진 신발",
	desc = [[두꺼운 진흙이 신발 전체를 한 겹 감싸고 있는, 금이 간 신발입니다. 이전에 신발을 가지고 있던 자가 누구인지는 알 수 없지만, 엄청나게 많이 사용했었다는 것만은 분명합니다.]],
	color = colors.BLACK,
	level_range = {30, 40},
	rarity = 240,
	cost = 280,
	material_level = 4,
	use_no_energy = true,
	wielder = {
		combat_armor = 12,
		combat_def = 2,
		combat_dam = 12,
		combat_apr = 15,
		fatigue = 8,
		combat_mentalresist = 10,
		combat_spellresist = 10,
		max_life = 80,
		stun_immune=0.4,
		talents_types_mastery = {
			["cursed/predator"] = 0.2,
			["cursed/endless-hunt"] = 0.2,
			["cunning/trapping"] = 0.2,
		},
	},
	max_power = 32, power_regen = 1,
	use_power = { name = "boost movement speed by 300% for 4 turns (does not use a turn)", kr_name = "4 턴 동안 이동 속도 300% 증가 (사용하는데에는 턴이 소모되지 않음)", power = 32,
	use = function(self, who)
		game:onTickEnd(function() who:setEffect(who.EFF_HUNTER_SPEED, 5, {power=300}) end)
		return {id=true, used=true}
	end
	},
}

newEntity{ base = "BASE_GLOVES",
	power_source = {nature=true},
	unique = true,
	name = "Sludgegrip", color = colors.GREEN, image = "object/artifact/sludgegrip.png",
	unided_name = "slimy gloves",
	kr_name = "진창의 손", kr_unided_name = "슬라임 장갑",
	desc = [[이 장갑은 두꺼운 녹색 액체로 코팅되어 있습니다.]],
	level_range = {1, 10},
	rarity = 190,
	cost = 70,
	material_level = 1,
	wielder = {
		inc_stats = { [Stats.STAT_WIL] = 4, [Stats.STAT_CUN] = 4,},
		resists = { [DamageType.NATURE]= 10, },
		inc_damage = { [DamageType.NATURE]= 5, },
		combat_mindpower=2,
		poison_immune=0.2,
		talents_types_mastery = {
			["wild-gift/slime"] = 0.2,
		},		
		combat = {
			dam = 6,
			apr = 7,
			physcrit = 4,
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
			talent_on_hit = { T_SLIME_SPIT = {level=1, chance=35} },
			convert_damage = { [DamageType.ITEM_NATURE_SLOW] = 40,},
		},
	},
}

newEntity{ base = "BASE_RING", define_as = "SET_LICH_RING",
	power_source = {arcane=true},
	unique = true,
	name = "Ring of the Archlich", image = "object/artifact/ring_of_the_archlich.png",
	unided_name = "dusty, cracked ring",
	kr_name = "고위 리치의 반지", kr_unided_name = "잿빛의 갈라진 반지",
	desc = [[이 반지는 압도적이지만 반지에 구속된 힘으로 가득 차있습니다. 이 힘은 갉아먹을 생명을 찾기 위해 그 금속의 감옥 속에서 몸부림치고 있습니다. 소유자만이 그 힘으로부터 안전할 뿐입니다.
	아마도 이 반지는, 가까운 시간 내에 당신이 취할 타인의 죽음을 느끼고 있는걸지도 모릅니다.]],
	color = colors.DARK_GREY,
	level_range = {30, 40},
	cost = 170,
	rarity = 280,
	material_level = 4,
	wielder = {
		max_soul = 3,
		combat_spellpower=8,
		combat_spellresist=8,
		inc_damage={[DamageType.DARKNESS] = 10, [DamageType.COLD] = 10, },
		poison_immune=0.25,
		cut_immune=0.25,
		resists={ [DamageType.COLD] = 10, [DamageType.DARKNESS] = 10,},
	},
	max_power = 40, power_regen = 1,
	set_list = { {"define_as", "SET_SCEPTRE_LICH"} },
	on_set_complete = function(self, who)
		game.logPlayer(who, "#DARK_GREY#반지에서 사령의 힘이 폭발적으로 방출됩니다!")
		self:specialSetAdd({"wielder","combat_spellpower"}, 10)
		self.use_talent = { id = "T_IMPENDING_DOOM", level = 2, power = 40 }
		self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.DARKNESS] = 14 })
		self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.DARKNESS] = 5 })
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#DARK_GREY#반지의 힘이 사라집니다.")
		self.use_talent = nil
	end,
}

newEntity{ base = "BASE_TOOL_MISC",
	power_source = {arcane = true},
	unique=true, rarity=240,
	type = "charm", subtype="wand",
	name = "Lightbringer's Wand", image = "object/artifact/lightbringers_rod.png",
	unided_name = "bright wand",
	color = colors.GOLD,
	level_range = {20, 30},
	kr_name = "빛을 부르는 자의 장대", kr_unided_name = "밝은 마법봉",
	desc = [[이 황금이 끝에 달린 마법봉은 비현실적인 광채로 빛나고 있습니다.]],
	cost = 320,
	material_level = 3,
	wielder = {
		resists={[DamageType.DARKNESS] = 12, [DamageType.LIGHT] = 12},
		inc_damage={[DamageType.LIGHT] = 10},
		on_melee_hit={[DamageType.LIGHT] = 18},
		combat_spellresist = 15,
		lite=2,
	},
		max_power = 35, power_regen = 1,
	use_power = { name = "summon a shining orb", kr_name = "빛나는 오브 소환", power = 35,
		use = function(self, who)
			local tg = {type="bolt", nowarning=true, range=5, nolock=true}
			local tx, ty, target = who:getTarget(tg)
			if not tx or not ty then return nil end
			local _ _, _, _, tx, ty = who:canProject(tg, tx, ty)
			target = game.level.map(tx, ty, engine.Map.ACTOR)
			if target == who then target = nil end
			local x, y = util.findFreeGrid(tx, ty, 5, true, {[engine.Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "소환할 공간이 부족합니다!")
				return
			end
			local Talents = require "engine.interface.ActorTalents"
			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/undead_ghost_will_o__the_wisp.png", display_h=1, display_y=0}}},
				name = "Lightbringer",
				type = "orb", subtype = "light",
				kr_name = "빛을 부르는 자",
				desc = "빛나는 오브.",
				rank = 1,
				blood_color = colors.YELLOW,
				display = "T", color=colors.YELLOW,
				life_rating=10,
				combat = {
					dam=resolvers.rngavg(50,60),
					atk=resolvers.rngavg(50,75), apr=25,
					dammod={mag=1}, physcrit = 10,
					damtype=engine.DamageType.LIGHT,
				},
				level_range = {1, nil}, exp_worth = 0,
				silent_levelup = true,
				combat_armor=30,
				combat_armor_hardiness=30,
				autolevel = "caster",
				ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, },
				never_move=1,
				stats = { str=14, dex=18, mag=20, con=12, wil=20, cun=20, },
				size_category = 2,
				lite=10,
				blind=1,
				esp_all=1,
				resists={[engine.DamageType.LIGHT] = 100, [engine.DamageType.DARKNESS] = 100},
				no_breath = 1,
				cant_be_moved = 1,
				stone_immune = 1,
				confusion_immune = 1,
				fear_immune = 1,
				teleport_immune = 1,
				disease_immune = 1,
				poison_immune = 1,
				stun_immune = 1,
				blind_immune = 1,
				cut_immune = 1,
				knockback_resist=1,
				combat_physresist=50,
				combat_spellresist=100,
				on_act = function(self) self:project({type="ball", range=0, radius=5, friendlyfire=false}, self.x, self.y, engine.DamageType.LITE_LIGHT, self:getMag()) end,
				
				faction = who.faction,
				summoner = who, summoner_gain_exp=true,
				summon_time=15,
			}

			m:resolve()
			game.zone:addEntity(game.level, m, "actor", x, y)
			m.remove_from_party_on_death = true,
			game.party:addMember(m, {
				control=false,
				type="summon",
				title="Summon", kr_title="소환수",
				orders = {target=true, leash=true, anchor=true, talents=true},
			})
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {arcane=true},
	unique = true,
	unided_name = "handled hole in space",
	name = "Temporal Rift", image = "object/artifact/temporal_rift.png",
	moddable_tile = "special/%s_temporal_rift",
	moddable_tile_big = true,
	kr_name = "시간의 균열", kr_unided_name = "손잡이달린 공간의 구멍",
	desc = [[어떤 미친 시공제어사가 이 시공간의 구멍에다가 손잡이를 단 것으로 보입니다. 그 결과 독특한 방식으로 작동되긴 하지만, 매우 효과적인 방패가 되었습니다.]],
	color = colors.LIGHT_GREY,
	rarity = 300,
	metallic = false,
	level_range = {35, 45},
	require = { stat = { str=40 }, },
	cost = 400,
	material_level = 5,
	special_combat = {
		dam = 50,
		block = 325,
		physcrit = 4.5,
		dammod = {str=1, mag=0.2},
		damtype = DamageType.TEMPORAL,
		talent_on_hit = { [Talents.T_TURN_BACK_THE_CLOCK] = {level=3, chance=25} },
	},
	wielder = {
		combat_armor = 4,
		combat_def = 8,
		combat_def_ranged = 10,
		fatigue = 0,
		combat_spellpower=12,
		combat_spellresist = 20,
		resists = {[DamageType.TEMPORAL] = 30},
		learn_talent = { [Talents.T_BLOCK] = 5, },
		flat_damage_armor = {all=20},
		slow_projectiles = 50,
	},
}

newEntity{ base = "BASE_ARROW",
	power_source = {technique=true},
	unique = true,
	name = "Arkul's Siege Arrows", image = "object/artifact/arkuls_seige_arrows.png",
	unided_name = "gigantic spiral arrows",
	kr_name = "아르쿨의 공성용 화살", kr_unided_name = "거대한 나선형 화살",
	desc = [[이 거대한 이중 나선형 화살은 일반적인 전투보다는 성채를 무너뜨리는 용도에 더 적합하게 만들어진 것 같습니다. 대부분의 적들은 순식간에 박살날 것이 분명합니다.]],
	color = colors.GREY,
	level_range = {42, 50},
	rarity = 400,
	cost = 400,
	material_level = 5,
	require = { stat = { dex=20, str=30 }, },
	special_desc = function(self) return "충격파가 발생하여 대상에게 가해진 피해량의 25% 만큼이 그 주변 1 칸 반경의 다른 이들에게도 가해집니다." end,
	combat = {
		capacity = 14,
		dam = 68,
		apr = 100,
		physcrit = 10,
		dammod = {dex=0.5, str=0.7},
		siege_impact=0.25,		
	},
}

newEntity{ base = "BASE_LONGSWORD", --For whatever artists draws this: it's a rapier.
	power_source = {technique=true},
	unique = true,
	name = "Punae's Blade",
	unided_name = "thin blade", image = "object/artifact/punaes_blade.png",
	level_range = {28, 38},
	color=colors.GREY,
	rarity = 300,
	kr_name = "푸내의 칼", kr_unided_name = "얇은 칼",
	desc = [[아주 얇은 검으로, 공기를 가르고 빠르게 움직일 수 있도록 만들어졌습니다.]],
	cost = 400,
	require = { stat = { str=30 }, },
	material_level = 4,
	combat = {
		dam = 46,
		apr = 4,
		physcrit = 10,
		dammod = {str=1},
	},
	wielder = {
		evasion=10,
		combat_physcrit = 10,
		combat_physspeed = 0.1,
	},
}

newEntity{ base = "BASE_CLOTH_ARMOR", --Thanks SageAcrin!
	power_source = {psionic=true},
	unique = true,
	name = "Crimson Robe", color = colors.RED, image = "object/artifact/crimson_robe.png",
	unided_name = "blood-stained robe",
	kr_name = "핏빛 로브", kr_unided_name = "피로 얼룩진 로브",
	desc = [[이 로브는 한때 많은 초능력 기술을 창시했던, 강력한 초능력자인 염동력자 칼리스터가 입던 것입니다. 그의 아내가 살해당한 후, 칼리스터는 그의 증오심을 원동력으로 삼는 새롭고 불온한 기술을 만들어 아내의 살해자를 찾는데 몰두했습니다. 범인이 스스로를 고문하여 죽음에 이르도록 만든 이후, 칼리스터는 그저 대지를 떠돌아다니면서 눈에 띄는 모든 것들을 자살하도록 만들었습니다. (그는 이것이 세상의 모든 공포로부터 그들을 자유롭게 해주는 유일한 길이라고 생각했습니다) 그러던 어느 날, 그는 갑자기 사라졌습니다. 이 피에 젖은 로브가 그가 남긴 유일한 것이었습니다.]],
	level_range = {40, 50},
	rarity = 230,
	cost = 350,
	material_level = 5,
	special_desc = function(self) return "독존 한계량이 (보유시) 20% 향상됩니다. 독존 한계량이 향상되면, 이 로브를 입고있는 동안 전체 속도도 15% 빨라집니다." end,
	wielder = {
		combat_def=12,
		inc_stats = { [Stats.STAT_WIL] = 10, [Stats.STAT_CUN] = 10, },
		combat_mindpower = 20,
		combat_mindcrit = 9,
		psi_regen=0.2,
		psi_on_crit = 4,
		hate_on_crit = 4, 
		hate_per_kill = 2,
		resists_pen={all = 20},
		on_melee_hit={[DamageType.MIND] = 35, [DamageType.RANDOM_GLOOM] = 10},
		melee_project={[DamageType.MIND] = 35, [DamageType.RANDOM_GLOOM] = 10},
		talents_types_mastery = { ["psionic/solipsism"] = 0.1, ["psionic/focus"] = 0.2, ["cursed/slaughter"] = 0.2, ["cursed/punishments"] = 0.2,},
	},
	on_wear = function(self, who)
		if who:attr("solipsism_threshold") then
			self:specialWearAdd({"wielder","solipsism_threshold"}, 0.2)
			self:specialWearAdd({"wielder","global_speed_add"}, 0.15)
			game.logPlayer(who, "#RED#당신은 로브에서 나온 기운에 갖혀 자신이 누구인지를 잊었습니다.")
		end
	end,
	talent_on_mind  = { {chance=8, talent=Talents.T_HATEFUL_WHISPER, level=2}, {chance=8, talent=Talents.T_AGONY, level=2}  },
}

newEntity{ base = "BASE_RING", --Thanks Alex!
	power_source = {arcane=true},
	name = "Exiler", unique=true, image = "object/artifact/exiler.png",
	kr_name = "추방자", kr_unided_name = "표식 반지",
	desc = [[솔리쓰라고 알려진 시공 제어사는 에이알 전역에 걸쳐 유명합니다. 그는 항상 홀로 있는 적과 일대일로 대결했다고 합니다.
만약 상대방이 혼자가 아니게 된 경우, 그는 즉석에서 일대일의 상황을 만들었습니다.]],
	unided_name = "insignia ring",
	level_range = {40, 50},
	rarity = 250,
	cost = 300,
	material_level = 5,
	wielder = {
		combat_spellpower = 10,
		paradox_reduce_fails = 20,
		talent_cd_reduction={
			[Talents.T_TIME_SKIP]=1,
		},
		inc_damage={ [DamageType.TEMPORAL] = 15, [DamageType.PHYSICAL] = 10, },
		resists={ [DamageType.TEMPORAL] = 15,},
		melee_project={ [DamageType.TEMPORAL] = 15,},
		talents_types_mastery = {
 			["chronomancy/timetravel"] = 0.2,
 		},
	},
	talent_on_spell = { {chance=10, talent="T_RETHREAD", level = 2} },
	max_power = 32, power_regen = 1,
	use_power = { name = "deal temporal damage to summons, and if they survive, remove them from time", kr_name = "소환수에게 시간 속성 피해를 주고, 살아남은 소환수는 시간에서 제거함", power = 32,
		use = function(self, who)
			local Talents = require "engine.interface.ActorTalents"
			local tg = {type="ball", range=5, radius=2}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			who:project(tg, x, y, function(px, py) 
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end
			if target.summoner then
			who:forceUseTalent(Talents.T_TIME_SKIP, {ignore_cd=true, ignore_energy=true, force_target=target, force_level=2, ignore_ressources=true})
			end
			end)
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {arcane=true},
	unique = true,
	name = "Piercing Gaze", image = "object/artifact/piercing_gaze.png",
	moddable_tile = "special/%s_piercing_gaze",
	moddable_tile_big = true,
	unided_name = "stone-eyed shield",
	kr_name = "날카로운 응시", kr_unided_name = "석안 방패",
	desc = [[이 거대한 방패에는 돌로 만들어진 눈이 박혀 있습니다.]],
	color = colors.BROWN,
	level_range = {30, 40},
	rarity = 270,
	--require = { stat = { str=28 }, },
	cost = 400,
	material_level = 4,
	metallic = false,
	special_combat = {
		dam = 40,
		block = 180,
		physcrit = 5,
		dammod = {str=1},
	},
	wielder = {
		combat_armor = 25,
		combat_def = 5,
		combat_def_ranged = 10,
		fatigue = 12,
		learn_talent = { [Talents.T_BLOCK] = 4, },
		resists = { [DamageType.PHYSICAL] = 10, [DamageType.ACID] = 10, [DamageType.LIGHTNING] = 10, [DamageType.FIRE] = 10,},
	},
	on_block = {desc = "막기 성공시, 30% 확률로 공격자를 석화시킵니다.", fct = function(self, who, src, type, dam, eff)
		if rng.percent(30) then
			if not src then return end
			game.logSeen(src, "석안이 %s 응시하여 그 자리에서 얼어붙게 만들었습니다!", (src.kr_name or src.name):capitalize():addJosa("를"))
			if src:canBe("stun") and src:canBe("stone") and src:canBe("instakill") then
				src:setEffect(who.EFF_STONED, 5, {})
			end
		end
	end,}
}

-- No longer hits your own projectiles
-- Hopefully fixed LUA errors with DamageType require
-- Significant rescaling.  Base damage cut by 50%, crit by 5%.  The reason these hilariously bad numbers happened was derping and not accounting for the awesomeness of the 100% dex scaling.  APR is still extremely high.
-- Proc chance is now 100% up from 25%.  No matter how I test this--even at 100% and 500% global action speed--it is often a pain in the ass to get procs just to test.  This is supposed to be one of the main features of the item. 
newEntity{ base = "BASE_KNIFE", --Shibari's #1
	power_source = {nature=true},
	unique = true,
	name = "Shantiz the Stormblade",
	unided_name = "thin stormy blade", image = "object/artifact/shantiz_the_stromblade.png",
	level_range = {18, 33},
	material_level = 3,
	rarity = 300,
	kr_name = "폭풍검 샨티즈", kr_unided_name = "얇은 폭풍의 칼",
	desc = [[이 초현실적인 단검은 격렬하고 위험한 폭풍으로 둘러싸여 있습니다.]],
	cost = 400,
	color=colors.BLUE,
	require = { stat = { dex=30}},
	combat = {
		dam = 15,
		apr = 20,
		physcrit = 10,
		dammod = {dex=1},
		special_on_hit = {desc="뇌전이 발사되어 10 칸 반경 이내의 발사체를 파괴. 파괴된 발사체 주위 5 칸 반경의 적들에게 피해를 주고 기절시킴.", on_kill=1, fct=function(combat, who, target)
			local grids = core.fov.circle_grids(who.x, who.y, 10, true)
			for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
				local i = 0
				local p = game.level.map(x, y, engine.Map.PROJECTILE+i)
				while p do
					local DamageType = require "engine.DamageType" -- I don't entirely follow why this is necessary
					if p.src and (p.src == who) then return end -- Keep Arcane Blade procs from hitting them since the projectile is still on top of them.
					if p.name then 
						game.logPlayer(who, "#GREEN#뇌전이 " .. (p.kr_name or p.name) .. "에게 발사되었습니다!")
					else
						game.logPlayer(who, "#GREEN#샨티즈가 발사체를 파괴하였습니다!")
					end
					
					p:terminate(x, y)
					game.level:removeEntity(p, true)
					p.dead = true
					game.level.map:particleEmitter(x, y, 5, "ball_lightning_beam", {radius=5, tx=x, ty=y})
				   
					local tg = {type="ball", radius=5, selffire=false}
					local dam = 4*who:getDex() -- no more crit or base damage.  no real reason, just like it better.

					who:project(tg, x, y, DamageType.LIGHTNING, dam)
				   
					who:project(tg, x, y, function(tx, ty)
							local target = game.level.map(tx, ty, engine.Map.ACTOR)
							if not target or target == who then return end
							target:setEffect(target.EFF_DAZED, 3, {apply_power=who:combatAttack()})
					end)
   
					i = i + 1
					p = game.level.map(x, y, engine.Map.PROJECTILE+i)
				end end end    
			return          
			end
		},
	},
	wielder = {
		inc_stats = { [Stats.STAT_DEX] = 20 },
		slow_projectiles = 40, 
		quick_weapon_swap = 1, 
	},
}

newEntity{ base = "BASE_KNIFE",
	power_source = {technique=true},
	unique = true,
	name = "Swordbreaker", image = "object/artifact/swordbreaker.png",
	unided_name = "hooked blade",
	kr_name = "무기파괴자", kr_unided_name = "갈고리 칼",
	desc = [[양질의 튼튼한 보라툰으로 만든 단검으로, 칼날 부분이 톱니 모양 갈고리처럼 생겼습니다. 이 단순한 모양은 믿기 힘들 정도로 굉장한 효과를 보여, 이 갈고리에 의해 많은 칼날들이 부숴졌고 많은 전사 지망자들의 발걸음을 먹어치웠습니다.]],
	level_range = {20, 30},
	rarity = 250,
	require = { stat = { dex=10, cun=10 }, },
	cost = 300,
	material_level = 3,
	special_desc = function(self) return "방패와 비슷한 막기 기술을 사용할 수 있고, 적을 무장해제 시킬 수도 있습니다." end,
	combat = {
		dam = 25,
		apr = 20,
		physcrit = 15,
		physspeed = 0.9,
		dammod = {dex=0.5,cun=0.5},
		special_on_crit = {desc="적의 무기 부수기.", fct=function(combat, who, target)
			target:setEffect(target.EFF_SUNDER_ARMS, 5, {power=5+(who:combatPhysicalpower()*0.33), apply_power=who:combatPhysicalpower()})
		end},
	},
	wielder = {
		combat_def = 15,
		disarm_immune=0.5,
		combat_physresist = 15,
		inc_stats = { 
			[Stats.STAT_DEX] = 8, 
			[Stats.STAT_CUN] = 8, 
		},
		combat_armor_hardiness = 20,
		learn_talent = { [Talents.T_DAGGER_BLOCK] = 1, },
	},
}

newEntity{ base = "BASE_SHIELD",
	power_source = {arcane=true},
	unique = true,
	name = "Shieldsmaiden", image = "object/artifact/shieldmaiden.png",
	unided_name = "icy shield",
	moddable_tile = "special/%s_shieldmaiden",
	moddable_tile_big = true,
	kr_name = "쉴드메이든", kr_unided_name = "차가운 방패",
	desc = [[신화에 따르면, 마즈'에이알 북쪽 황무지에 있는 한 부족의 여전사들을 '쉴드메이든' 이라는 이름으로 불렀다고 합니다. 그녀들의 전투 역량과 아름다움은 수많은 이들을 매혹시켜 구혼자로 만들었으나, 그 어떤 사랑도 이루어지지 못했다고 합니다. 그 결과 '쉴드메이든의 심장은 그녀의 방패와 같아, 차갑고 꺾이지 않는다' 는 이야기가 퍼지기 시작되었다고 합니다.]],
	color = colors.BLUE,
	level_range = {36, 48},
	rarity = 270,
	require = { stat = { str=28 }, },
	cost = 400,
	material_level = 5,
	metallic = false,
	special_desc = function(self) return "10 턴 마다 한번의 공격을 완전히 막아내는 기술이 부여되어 있습니다." end,
	special_combat = {
		dam = 48,
		block = 150,
		physcrit = 8,
		dammod = {str=1},
		damtype = DamageType.ICE,
		talent_on_hit = { [Talents.T_ICE_SHARDS] = {level=3, chance=15} },
	},
	wielder = {
		combat_armor = 20,
		combat_def = 5,
		combat_def_ranged = 12,
		fatigue = 10,
		learn_talent = { [Talents.T_BLOCK] = 4, [Talents.T_SHIELDSMAIDEN_AURA] = 1,  },
		resists = { [DamageType.COLD] = 25, [DamageType.FIRE] = 25,},
	},
}

-- Thanks to Naghyal's Beholder code for the basic socket skeleton
newEntity{ base = "BASE_GREATMAUL",
	power_source = {arcane=true},
	unique = true,
	color = colors.BLUE,
	name = "Tirakai's Maul", image = "object/artifact/tirakais_maul.png",
	kr_name = "티라카이의 대형망치",
	desc = [[이 거대한 망치는 기묘하게 자라난 수정조각이 두껍게 뭉쳐져 만들어졌습니다. 망치의 측면을 보면 비어있는 홈을 발견할 수 있는데, 딱 보석 하나가 들어갈 정도의 홈인 것 같습니다.]],
	gemDesc = "없음", -- Defined by the elemental properties and used by special_desc
	special_desc = function(self)
	-- You'll want to color this and such
		if not self.Gem then return ("No gem") end
		return ("%s : %s"):format((self.Gem.kr_name or self.Gem.name):capitalize(), self.gemDesc or ("이 보석의 속성을 설명해 주세요!"))
	end,	
	cost = 1000,
	material_level = 2, -- Changes to gem material level on socket
	level_range = {1, 30},
	rarity = 280,
	combat = {
		dam = 32,
		apr = 6,
		physcrit = 8,
		damrange=1.3,
		dammod = {str=1.2, mag=0.1},
	},
	max_power = 10, power_regen = 1,
	use_power = { name = "imbue the hammer with a gem of your choice", kr_name = "망치에 원하는 보석 박기", power = 10,
		use = function(self, who)
			local DamageType = require "engine.DamageType"
			local Stats = require "engine.interface.ActorStats"
			local d
			d = who:showInventory("어느 보석을 사용합니까?", who:getInven("INVEN"), function(gem) return gem.type == "gem" and gem.imbue_powers and gem.material_level end, function(gem, gem_item)
				local name_old=self.name
				local old_hotkey
				for i, v in pairs(who.hotkey) do
					if v[2]==name_old then
						old_hotkey=i
					end
				end
				
				-- Recycle the old gem
				local old_gem=self.Gem
				if gem then
					local gem = who:removeObject(who:getInven("INVEN"), gem_item)
					if old_gem then
						who:addObject(who:getInven("INVEN"), old_gem)
						game.logPlayer(who, "당신은 %s 뽑아 냈습니다.", old_gem:getName{do_colour=true, no_count=true}:addJosa("을"))
					end
					who:sortInven()

					local _, _, inven_id = who:findInAllInventoriesByObject(self)
					who:onTakeoff(self, inven_id)
	
					self.Gem = gem
					self.gemDesc = "뭔가 잘못되었습니다"
					
					self.sentient = false
					self.act = mod.class.Object.act
					
					self.talent_on_spell = nil
					
					self.material_level=gem.material_level
					local scalingFactor = self.material_level 
					
					self.combat = {
						dam = 8 + (12 * scalingFactor),
						apr = (3 * scalingFactor),
						physcrit = 4 + (2 * scalingFactor),
						dammod = {str=1.2, mag=0.1},
						damrange = 1.3,
					}
							
					self.wielder = {
						inc_stats = {[Stats.STAT_MAG] = (2 * scalingFactor), [Stats.STAT_CUN] = (2 * scalingFactor), [Stats.STAT_DEX] = (2 * scalingFactor),},
					}


					-- Each element merges its effect into the combat/wielder tables (or anything else) after the base stats are scaled
					-- You can modify damage and such here too but you should probably make static tables instead of merging
					if gem.subtype =="black" then -- Acid
						self.combat.damtype = DamageType.ACID
						table.mergeAdd(self.wielder, {inc_damage = { [DamageType.ACID] = 4 * scalingFactor} }, true)
						
						self.combat.burst_on_crit = {[DamageType.ACID_DISARM] = 12 * scalingFactor,}
						self.gemDesc = "산성"
					end
					if gem.subtype =="blue" then  -- Lightning
						self.combat.damtype = DamageType.LIGHTNING
						table.mergeAdd(self.wielder, {
							inc_damage = { [DamageType.LIGHTNING] = 4 * scalingFactor} 
						
							}, true)
						self.combat.burst_on_crit = {[DamageType.LIGHTNING_DAZE] = 12 * scalingFactor,}
						self.gemDesc = "전기"
					end
					if gem.subtype =="green" then  -- Nature
						self.combat.damtype = DamageType.NATURE
						table.mergeAdd(self.wielder, {
							inc_damage = { [DamageType.NATURE] = 4 * scalingFactor} 
							
							}, true)
						self.combat.burst_on_crit = {[DamageType.SPYDRIC_POISON] = 12 * scalingFactor,}
						self.gemDesc = "자연"
					end
					if gem.subtype =="red" then  -- Fire					
						self.combat.damtype = DamageType.FIRE
						table.mergeAdd(self.wielder, {
							inc_damage = { [DamageType.FIRE] = 4 * scalingFactor}, 
						}, true)
						self.combat.burst_on_crit = {[DamageType.FLAMESHOCK] = 12 * scalingFactor,}
						self.gemDesc = "화염"
					end
					if gem.subtype =="violet" then -- Arcane
						self.combat.damtype = DamageType.ARCANE
						table.mergeAdd(self.wielder, {
							inc_damage = { [DamageType.ARCANE] = 4 * scalingFactor} 
							
						}, true)
						self.combat.burst_on_crit = {[DamageType.ARCANE_SILENCE] = 12 * scalingFactor,}
						self.gemDesc = "마법"
					end
					if gem.subtype =="white" then  -- Cold
						self.combat.damtype = DamageType.COLD
						table.mergeAdd(self.wielder, {
							inc_damage = { [DamageType.COLD] = 4 * scalingFactor} 
							
						}, true)
						self.combat.burst_on_crit = {[DamageType.ICE] = 12 * scalingFactor,}
						self.gemDesc = "냉기"
					end
					if gem.subtype =="yellow" then -- Light
						self.combat.damtype = DamageType.LIGHT
						table.mergeAdd(self.wielder, {
							inc_damage = { [DamageType.LIGHT] = 4 * scalingFactor} 
							
						}, true)	
						self.combat.burst_on_crit = {[DamageType.LIGHT_BLIND] = 12 * scalingFactor,}
						self.gemDesc = "빛"
					end
					if gem.subtype == "multi-hued"  then -- Some but not all artifacts, if you want to do artifact specific effects make conditionals by name, don't use this
						table.mergeAdd(self.combat, {convert_damage = {[DamageType.COLD] = 25, [DamageType.FIRE] = 25, [DamageType.LIGHTNING] = 25, [DamageType.ARCANE] = 25,} }, true)
						table.mergeAdd(self.wielder, {
							inc_damage = { all = 2 * scalingFactor},
							resists_pen = { all = 2 * scalingFactor},
							}, true)	
							self.gemDesc = "고유"							
					end
					if gem.subtype == "demonic"  then -- Goedalath Rock
						self.combat.damtype = DamageType.SHADOWFLAME
						table.mergeAdd(self.wielder, {
							inc_damage = { [DamageType.FIRE] = 3 * scalingFactor, [DamageType.DARKNESS] = 3 * scalingFactor,},
							resists_pen = { all = 2 * scalingFactor},
							}, true)	
							self.gemDesc = "악마"							
					end
					game.logPlayer(who, "당신은 %s에 %s 박아 넣었습니다.", self:getName{do_colour=true, no_count=true}, gem:getName{do_colour=true, no_count=true}:addJosa("를"))

					--self.name = (gem.name .. " of Divinity")
					
					table.mergeAdd(self.wielder, gem.imbue_powers, true)
					
					if gem.talent_on_spell then
						self.talent_on_spell = self.talent_on_spell or {}
						table.append(self.talent_on_spell, gem.talent_on_spell)
					end

					who:onWear(self, inven_id)
				end
				for i, v in pairs(who.hotkey) do
					if v[2]==name_old then
						v[2]=self.name
					end
					if v[2]==self.name and old_hotkey and i~=old_hotkey then
						who.hotkey[i] = nil
					end
				end
				d.used_talent=true
				game:unregisterDialog(d)
				return true
			end)
			return {id=true, used=true}
		end
	},
	on_wear = function(self, who)

		return true
	end,
	wielder = {
	-- Stats only from gems
	},
}

newEntity{ base = "BASE_GLOVES", define_as = "SET_GLOVE_DESTROYER",
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Fist of the Destroyer", color = colors.RED, image = "object/artifact/fist_of_the_destroyer.png",
	unided_name = "vile gauntlets",
	kr_name = "파괴자의 주먹", kr_unided_name = "불결한 전투장갑",
	desc = [[이 짐승 가죽 장갑은 밝혀지지 않은 힘으로 인해 달아오르고 있습니다.]],
	level_range = {40, 50},
	rarity = 300,
	cost = 800,
	material_level = 5,
	special_desc = function(self)
		local num=4
		if self.set_complete then
			num=6
		end
		return ("현재 원기의 %d%% 만큼 모든 공격력 증가 \n현재 증가량 : %d%%"):format(num, num*0.01*(game.player:getVim() or 0)) 
	end,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 9, [Stats.STAT_MAG] = 9, [Stats.STAT_CUN] = 3, },
		demonblood_dam=0.04,
		max_vim = 25,
		combat_def = 8,
		stun_immune = 0.2,
		talents_types_mastery = { ["corruption/shadowflame"] = 0.2, ["corruption/vim"] = 0.2,},
		combat = {
			dam = 35,
			apr = 15,
			physcrit = 10,
			physspeed = 0,
			dammod = {dex=0.4, str=-0.6, cun=0.4, mag=0.2,},
			damrange = 0.3,
			talent_on_hit = { T_DRAIN = {level=2, chance=8}, T_SOUL_ROT = {level=3, chance=12}, T_BLOOD_GRASP = {level=3, chance=10}},
		},
	},
	max_power = 12, power_regen = 1,
	use_talent = { id = Talents.T_DARKFIRE, level = 5, power = 12 },
	set_list = { {"define_as", "SET_ARMOR_MASOCHISM"} },
	on_set_complete = function(self, who)
		game.logPlayer(who, "#STEEL_BLUE#주먹과 짓이긴 옷이 불길하게 달아오릅니다!")
		self:specialSetAdd({"wielder","demonblood_dam"}, 0.02)
		self:specialSetAdd({"wielder","inc_damage"}, { [engine.DamageType.FIRE] = 15, [engine.DamageType.DARKNESS] = 15, all = 5 })
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#STEEL_BLUE#불길한 달아오름이 사그라듭니다.")
	end,
}

newEntity{ base = "BASE_LIGHT_ARMOR", define_as = "SET_ARMOR_MASOCHISM",
	power_source = {arcane=true, technique=true},
	unique = true,
	name = "Masochism", color = colors.RED, image = "object/artifact/masochism.png",
	unided_name = "mangled clothing",
	kr_name = "피학대 도착증", kr_unided_name = "짓이긴 옷",
	desc = [[도둑맞은 살점,
	도둑맞은 고통.
	모두 다 포기하면,
	다시금 살아나네.]],
	level_range = {40, 50},
	rarity = 300,
	cost = 800,
	material_level = 5,
	special_desc = function(self)
		local num=7
		if self.set_complete then
			num=10
		end
		return ("현재 원기의 %d%% 만큼 착용자가 받는 모든 피해를 줄여줍니다 (최대 감소량은 피해의 50%%). 피해 감소량의 5%% 만큼 원기가 사용됩니다. \n현재 감소량 : %d"):format(num, num*0.01*(game.player:getVim() or 0)) 
	end,
	wielder = {
		inc_stats = {[Stats.STAT_MAG] = 9, [Stats.STAT_CUN] = 3, },
		combat_spellpower = 10,
		demonblood_def=0.07,
		max_vim = 25,
		disease_immune = 1,
		combat_physresist = 10,
		combat_mentalresist = 10,
		combat_spellresist = 10,
		on_melee_hit={[DamageType.DRAIN_VIM] = 25},
		melee_project={[DamageType.DRAIN_VIM] = 25},
		talents_types_mastery = { ["corruption/sanguisuge"] = 0.2, ["corruption/blood"] = 0.2,},
	},
	max_power = 12, power_regen = 1,
	use_talent = { id = Talents.T_BLOOD_GRASP, level = 5, power = 12 },
	set_list = { {"define_as", "SET_GLOVE_DESTROYER"} },
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","demonblood_def"}, 0.03)
		self:specialSetAdd({"wielder","resists"}, { [engine.DamageType.FIRE] = 15, [engine.DamageType.DARKNESS] = 15, all = 5 })
	end,
	on_set_broken = function(self, who)
	end,
}

newEntity{ base = "BASE_GREATMAUL",
	power_source = {technique=true},
	unique = true,
	name = "Obliterator", color = colors.UMBER, image = "object/artifact/obliterator.png",
	unided_name = "titanic maul",
	kr_name = "소멸자", kr_unided_name = "타이탄의 대형망치",
	desc = [[엄청나게 큰 망치로, 한번 휘두르는 것만으로도 뼈를 부수고 작게 조각낸 후 먼지로 만들어버릴 수 있을 정도로 파괴적입니다.]],
	level_range = {23, 30},
	rarity = 270,
	require = { stat = { str=40 }, },
	cost = 250,
	material_level = 3,
	combat = {
		dam = 48,
		apr = 10,
		physcrit = 0,
		dammod = {str=1.2},
		crushing_blow=1,

	},
	wielder = {
		combat_critical_power = 10,
		inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_CON] = 5, },
	},
}

newEntity{ base = "BASE_HELM",
	power_source = {technique=true},
	unique = true,
	name = "Yaldan Baoth", image = "object/artifact/yaldan_baoth.png",
	unided_name = "obscuring helm",
	kr_name = "얄단 바오쓰", kr_unided_name = "잘 보이지 않는 투구",
	desc = [[중세 시대를 연상시키는 금색 투구로, 얄단의 벨루카와 관련된 물품입니다. 왕국민들의 오만에 의해 에이알 세계에서 사라졌다고 전해지는, 신화 속 도시 얄단의 왕 벨루카. 일족의 유일한 생존자가 된 그는, 남은 일생을 사람들에게 어둠과 맞서는 방법을 가르치면서 세계의 초창기를 방랑하는데 사용했습니다. 그의 유언은 "어둠을 두려워 말라" 였고, 이 투구는 그의 가르침을 계승받은 자들에게 이어져 내려왔습니다.]], 
	level_range = {28, 39,},
	rarity = 240,
	cost = 700,
	material_level = 4,
	wielder = {
		combat_armor = 6,
		fatigue = 4,
		resist_unseen = 25,
		sight = -2,
		inc_stats = { [Stats.STAT_WIL] = 10, [Stats.STAT_CON] = 7, },
		inc_damage={
			[DamageType.LIGHT] = 10,
		},
		resists={
			[DamageType.LIGHT] = 10,
			[DamageType.DARKNESS] = 15,
		},
		resists_cap={
			[DamageType.DARKNESS] = 10,
		},
		blind_fight = 1,
	},
}

newEntity{ base = "BASE_GREATSWORD",
	power_source = {technique=true, arcane=true},
	name = "Champion's Will", unique=true, image = "object/artifact/champions_will.png",
	unided_name = "blindingly bright sword", color=colors.YELLOW,
	kr_name = "투사의 의지", kr_unided_name = "눈이 멀 정도로 환한 장검",
	desc = [[이 인상깊게 생긴 장검의 손잡이에는 태양의 금장이 조각되어 있습니다. 그 칼날에 새겨진 일련의 룬들은, 오직 육체와 정신에 모두 정통한 자만이 이 검을 효과적으로 다룰 수 있다는 것을 단언하고 있습니다.]],
	require = { stat = { str=35 }, },
	level_range = {40, 50},
	rarity = 240,
	cost = 280,
	material_level = 5,
	special_desc = function(self) return "태양 광선의 공격력이 15% 상승합니다." end,
	combat = {
		dam = 67,
		apr = 22,
		physcrit = 12,
		dammod = {str=1.15, con = 0.2},
		special_on_hit = {desc="폭발적인 빛으로 전방 3 칸 반경에 주문력 만큼의 피해 발생.", on_kill=1, fct=function(combat, who, target)
			who.turn_procs.champion_will = (who.turn_procs.champion_will or 0) + 1
			local tg = {type="cone", range=10, radius=3, force_target=target, selffire=false}
			local grids = who:project(tg, target.x, target.y, engine.DamageType.LIGHT, who:combatSpellpower() / (who.turn_procs.champion_will))
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "light_cone", {radius=tg.radius, tx=target.x-who.x, ty=target.y-who.y})
			who.turn_procs.champion_will = (who.turn_procs.champion_will or 0) + 1
		end},
	},
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 12, [Stats.STAT_MAG] = 6, [Stats.STAT_CON] = 7},
		talents_types_mastery = {
			["celestial/crusader"] = 0.2,
			["celestial/sun"] = 0.2,
			["celestial/radiance"] = 0.1,
		},
		talent_cd_reduction= {
			[Talents.T_ABSORPTION_STRIKE] = 1,
			[Talents.T_SUN_BEAM] = 1,
			[Talents.T_FLASH_OF_THE_BLADE] = 1,
		},
		amplify_sun_beam = 15,
	},
	max_power = 30, power_regen = 1,
	use_power = { name = "strike with your weapon as 100% light damage, up to 4 spaces away, healing for 50% of the damage dealt", kr_name = "무기로 100% 빛 속성 피해를 주는 공격 시도 (사정거리 4 칸), 피해량의 50% 만큼 생명력 회복", power = 30,
		use = function(self, who)
			local tg = {type="beam", range=4}
			local x, y = who:getTarget(tg)
			if not x or not y then return nil end
			local _ _, x, y = who:canProject(tg, x, y)
			who:attr("lifesteal", 50)
			who:project(tg, x, y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				who:attackTarget(target, engine.DamageType.LIGHT, 1, true)
			end)
			who:attr("lifesteal", -50)
			game.level.map:particleEmitter(who.x, who.y, tg.radius, "light_beam", {tx=x-who.x, ty=y-who.y})
			game:playSoundNear(self, "talents/lightning")
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_MASSIVE_ARMOR",
	power_source = {technique=true},
	unique = true,
	name = "Tarrasca", image = "object/artifact/terrasca.png",
	unided_name = "absurdly large armor",
	kr_name = "타라스카", kr_unided_name = "터무니없이 큰 갑옷",
	desc = [[이 판갑은 그 거대한 크기와 위압적인 무게를 자랑합니다. 이것은 한 이름없는 병사의 것으로 알려져 있습니다. 그는 그의 마을로 가는 다리로 이어진 길을 오크 침략자 무리에 대항하여 막아낸 수호자였습니다. 오크들은 그를 쓰러뜨리는 것에 실패한 이후 되돌아갔습니다. 그러나 그 자리에서 그는 극도의 피로로 쓰러져 죽음을 맞이했습니다. 마지막까지 남아있는 갑옷만이 그의 삶을 증명하고 있습니다.]],
	color = colors.RED,
	level_range = {30, 40},
	rarity = 320,
	require = { stat = { str=52 }, },
	cost = 500,
	material_level = 4,
	special_desc = function(self) return ("실질적인 이동 속도 (전체속도*이동속도) 가 100%% 보다 느리다면, 착용자가 받는 모든 피해를 느려진 속도만큼 감소시켜 줍니다. (최대 감소량 70%%)\n현재 저항력 : %d%%"):format(100*(1-(util.bound(game.player.global_speed * game.player.movement_speed, 0.3, 1)))) end,
	wielder = {
		inc_stats = { [Stats.STAT_CON] = 15, },
		combat_armor = 50,
		combat_armor_hardiness = 15,
		knockback_immune = 1,
		combat_physresist = 45,
		fatigue = 35,
		speed_resist=1,
	},
	max_power = 25, power_regen = 1,
	use_power = { name = "slow all units within 5 spaces (including yourself) by 40%", kr_name = "(자신을 포함한) 5 칸 반경의 모두를 40% 만큼 감속", power = 25,
		use = function(self, who)
			who:project({type="ball", range=0, radius=5}, who.x, who.y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				target:setEffect(target.EFF_SLOW_MOVE, 3, {power=0.4, no_ct_effect=true, })
			end)
			game.logSeen(who, "%s 모든 것이 조금 느려질 필요가 있다고 생각했습니다.", (who.kr_name or who.name):capitalize():addJosa("는"))
			return {id=true, used=true}
		end
	},
}

newEntity{ base = "BASE_LEATHER_CAP",
	power_source = {unknown=true},
	unique = true,
	name = "The Face of Fear",
	unided_name = "bone mask", image = "object/artifact/the_face_of_fear.png",
	level_range = {24, 32},
	color=colors.GREEN,
	moddable_tile = "special/the_face_of_fear",
	moddable_tile_big = true,
	encumber = 2,
	rarity = 200,
	kr_name = "두려움의 얼굴", kr_unided_name = "뼈 가면",
	desc = [[이 가면은 존재하지 말았어야 할 기형적이고 왜곡된 생명체의 두개골을 조각해서 만든 것입니다. 이 가면을 통해서 밖을 보면 전율이 느껴지고, 그 움푹한 눈 구멍이 거꾸로 당신을 응시하는 느낌을 받게 됩니다.]],
	cost = 200,
	material_level=3,
	wielder = {
		combat_def=8,
		fear_immune = 0.6,
		inc_stats = { [Stats.STAT_WIL] = 8, [Stats.STAT_CUN] = 6, },
		combat_mindpower = 16,
		talents_types_mastery = { ["cursed/fears"] = 0.2,},
	},
	max_power = 45, power_regen = 1,
	use_talent = { id = Talents.T_INSTILL_FEAR, level = 2, power = 18 },
}

newEntity{ base = "BASE_LEATHER_BOOT",
	power_source = {arcane=true},
	unided_name = "flame coated sandals",
	name = "Cinderfeet", unique=true, image = "object/artifact/cinderfeet.png",
	kr_name = "재 투성이 발", kr_unided_name = "불 붙은 샌달",
	desc = [[카임이라 불리는 고대의 요술사에 대한, 경고성 이야기가 하나 전승되고 있습니다. 그는 스스로를 시험하기 위해, 매일 가혹한 악마의 황무지인 괴달라스를 산책하는 것을 좋아했다고 합니다. 그는 악마가 그를 찾는 표식으로 사용할지도 모르기 때문에, 돌아올 때 아무 것도 가져오지 않기 위해 주의를 했었습니다. 하지만 어느 날 불행하게도, 그의 샌달에 공포의 영역의 재와 검댕이 잔뜩 묻어버렸습니다. 결국 악마의 불길이 바깥으로 이어진 그의 발자국을 쫒아와, 그의 섬뜩한 운명의 결말을 그렸습니다.]],
	require = { stat = { dex=10 }, },
	level_range = {28, 38},
	material_level = 4,
	rarity = 195,
	cost = 40,
	sentient=true,
	oldx=0,
	oldy=0,
	wielder = {
		lite = 2,
		combat_armor = 5,
		combat_def = 3,
		fatigue = 6,
		inc_damage = {
			[DamageType.FIRE] = 18,
		},
		resists = {
			[DamageType.COLD] = 20,
		},
		inc_stats = { [Stats.STAT_MAG] = 4, [Stats.STAT_CUN] = 4, },
	},
	special_desc = function(self) return "화염이 당신 뒤를 쫒아오면서, 주문력에 비례한 피해를 줍니다." end,
	on_wear = function(self, who)
		self.worn_by = who
		self.oldx=who.x
		self.oldy=who.y
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		
		local who=self.worn_by --Make sure you can actually act!
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.worn_by:attr("dead") then return end
		if self.oldx ~= who.x or self.oldy ~= who.y then
			local DamageType = require "engine.DamageType"
			local duration = 6
			local radius = 0
			local dam = who:combatSpellpower()
			-- Add a lasting map effect
			game.level.map:addEffect(who,
				who.x, who.y, duration,
				DamageType.FIRE, dam,
				radius,
				5, nil,
				{type="inferno"},
				function(e)
					e.radius = e.radius 
					return true
				end,
				false
			)
		end
		self.oldx=who.x
		self.oldy=who.y
		return
	end
}

newEntity{ base = "BASE_MASSIVE_ARMOR",
	power_source = {arcane=true},
	unique = true,
	name = "Cuirass of the Dark Lord", image = "object/artifact/dg_casual_outfit.png",
	unided_name = "black, spiked armor",
	moddable_tile = "special/dgs_clothes",
	moddable_tile_big = true,
	kr_name = "암흑 군주의 흉갑", kr_unided_name = "징박힌 검은 갑옷",
	desc = [[오랫동안 잊혀진 악당이 입던 이 갑옷은 수천의 무고한 생명체의 피에서 추출한 힘이 부여되어 있습니다. 암흑 군주가 늙고 약해져 고독하게 죽을 때, 그의 영토는 허물어지고 그의 신하들은 사라졌습니다. 결국 마지막으로 다시 한번 신선한 피를 맛본 이 철판만이 남았습니다.]],
	color = colors.RED,
	level_range = {40, 50},
	rarity = 320,
	require = { stat = { str=52 }, },
	cost = 500,
	material_level = 5,
	sentient=true,
	blood_charge=0,
	blood_dur=0,
	wielder = {
		inc_stats = { [Stats.STAT_STR] = 10,  [Stats.STAT_CON] = 10, },
		combat_armor = 40,
		combat_dam=10,
		combat_physresist = 15,
		fatigue = 25,
		life_regen=0,
		on_melee_hit={[DamageType.PHYSICAL] = 30},
		resists={[DamageType.PHYSICAL] = 20},
	},
	max_power = 25, power_regen = 1,
	use_power = { name = "drain blood from all units within 5 spaces, causing them to bleed for 120 physical damage over 4 turns. For every unit (up to 10) drained, the armor's stats increase, but decrease over 10 turns until back to normal", kr_name = "5 칸 반경의 모두에게서 피를 흡수하여, 4 턴 동안 물리 속성 피해를 120 만큼 받는 출혈 상태를 일으킴. 피를 흡수한 생명의 수에 비례하여 (최대 10명까지) 일시적으로 갑옷의 능력이 상승 (10 턴 후 원상복구됨).", power = 25,
		use = function(self, who)
			self.blood_charge = 0
			who:project({type="ball", range=0, radius=5, selffire=false}, who.x, who.y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end
				self.blood_charge = self.blood_charge + 1
				target:setEffect(target.EFF_CUT, 4, {power=30, no_ct_effect=true, src = who})
			end)
			if self.blood_charge > 10 then self.blood_charge = 10 end
			self.blood_dur = 10
			game.logSeen(who, "피에 젖자, %s 매우 기뻐합니다!", (self.kr_name or self.name):capitalize():addJosa("가"))
			return {id=true, used=true}
		end
	},
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
	end,
	special_desc = function(self)
		return ("채워진 피의 양 : " .. (self.blood_charge or 0))
	end,
	act = function(self)
		self:useEnergy()
		self:regenPower()
		
		local who=self.worn_by --Make sure you can actually act!
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		local boost = self.blood_charge
		local dur = self.blood_dur
		local storepower=self.power
		local _, _, inven_id = who:findInAllInventoriesByObject(self)
		who:onTakeoff(self, inven_id, true)

		local DamageType = require "engine.DamageType"
		
		self.wielder = {
			inc_stats = { [who.STAT_STR] = math.ceil(10 + boost * dur/5),  [who.STAT_CON] = math.ceil(10 + boost * dur/5), },
			combat_armor = math.ceil(30 + boost * dur * 0.4),
			combat_dam = math.ceil(10 + boost/5 * dur),
			combat_physresist = math.ceil(15 + boost/5 * dur),
			fatigue = math.ceil(25 - boost/5 * dur),
			life_regen= math.ceil(boost/2 * dur),
			on_melee_hit={[DamageType.PHYSICAL] = math.ceil(30 + boost * dur * 0.8)},
			resists={[DamageType.PHYSICAL] = math.ceil(20 + boost/5 * dur)},
		}
		who:onWear(self, inven_id, true)
		self.power = storepower
		if self.blood_dur > 0 then
			self.blood_dur = self.blood_dur - 1
			if self.blood_dur <= 0 then self.blood_charge = 0 end
		end
		return
	end
}

--[=[
newEntity{
	unique = true,
	type = "jewelry", subtype="ankh",
	unided_name = "glowing ankh",
	name = "Anchoring Ankh",
	desc = [[As you lift the ankh you feel stable. The world around you feels stable.]],
	level_range = {15, 50},
	rarity = 400,
	display = "*", color=colors.YELLOW, image = "object/fireopal.png",
	encumber = 2,

	carrier = {

	},
}
]=]
