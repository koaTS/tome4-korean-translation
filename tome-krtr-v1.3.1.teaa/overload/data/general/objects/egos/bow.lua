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

local Talents = require("engine.interface.ActorTalents")
local Stats = require("engine.interface.ActorStats")
local DamageType = require "engine.DamageType"

load("/data/general/objects/egos/ranged.lua")

-- Now matches the sling with a different stat
newEntity{
	power_source = {technique=true},
	name = " of dexterity (#STATBONUS#)", suffix=true, instant_resolve=true,
	kr_name = "민첩(#STATBONUS#)의 ",
	keywords = {dex=true},
	level_range = {20, 50},
	rarity = 7,
	cost = 7,
	wielder = {
		resists_pen={ [DamageType.PHYSICAL] = resolvers.mbonus_material(15, 10), },
		inc_stats = { [Stats.STAT_DEX] = resolvers.mbonus_material(6, 2) },
	},
}

newEntity{
	power_source = {technique=true},
	name = "thaloren ", prefix=true, instant_resolve=true,
	kr_name = "탈로레 ",
	keywords = {thaloren=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 24,
	cost = 40,
	wielder = {
		talent_cd_reduction={
			[Talents.T_STEADY_SHOT]=1,
			[Talents.T_PINNING_SHOT]=1,
			[Talents.T_VOLLEY_OF_ARROWS]=2,
		},
		inc_damage={ [DamageType.PHYSICAL] = resolvers.mbonus_material(14, 8), },
	},
}

newEntity{
	power_source = {arcane=true},
	name = "keeper's ", prefix=true, instant_resolve=true,
	kr_name ="관리자의 ",
	keywords = {keepers=true},
	level_range = {30, 50},
	greater_ego = 1,
	rarity = 24,
	cost = 40,
	wielder = {
		talent_cd_reduction={
			[Talents.T_ARROW_STITCHING]=1,
		},
		inc_damage={ 
			[DamageType.PHYSICAL] = resolvers.mbonus_material(14, 8),
			[DamageType.TEMPORAL] = resolvers.mbonus_material(14, 8),
		},
		resists_pen = {
			[DamageType.PHYSICAL] = resolvers.mbonus_material(10, 5),
			[DamageType.TEMPORAL] = resolvers.mbonus_material(10, 5),
		},
	},
}