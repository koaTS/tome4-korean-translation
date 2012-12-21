﻿-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012 Nicolas Casalini
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

uberTalent{
	name = "Spectral Shield",
	kr_display_name = "스펙트럼 방어막",
	mode = "passive",
	require = { special={desc="Block talent, have cast at least 100 spells and a block value over 200.", fct=function(self)
		return self:knowTalent(self.T_BLOCK) and self:getTalentFromId(self.T_BLOCK).getBlockValue(self) >= 200 and self.talent_kind_log and self.talent_kind_log.spell and self.talent_kind_log.spell >= 100
	end} },
	on_learn = function(self, t)
		self:attr("spectral_shield", 1)
	end,
	on_unlearn = function(self, t)
		self:attr("spectral_shield", -1)
	end,
	info = function(self, t)
		return ([[Infusing your shield with raw magic your Block can now block any damage type.]])
		:format()
	end,
}

uberTalent{
	name = "Aether Permeation",
	kr_display_name = "에테르 방출",
	mode = "passive",
	require = { special={desc="At least 25% arcane damage reduction and having been exposed to the void of space.", fct=function(self)
		return (game.state.birth.ignore_prodigies_special_reqs or self:attr("planetary_orbit")) and self:combatGetResist(DamageType.ARCANE) >= 25
	end} },
	on_learn = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "force_use_resist", DamageType.ARCANE)
		self:talentTemporaryValue(ret, "force_use_resist_percent", 50)
		return ret
	end,
	on_unlearn = function(self, t)
	end,
	info = function(self, t)
		return ([[Create a thin layer of aether all around you. Any attack passing through will check arcane resistance instead of the incomming damage resistance.
		In effect all your resistances are equal to 50%% of your arcane resistance.]])
		:format()
	end,
}

uberTalent{
	name = "Mystical Cunning", image = "talents/vulnerability_poison.png",
	kr_display_name = "신비한 교활함",
	mode = "passive",
	require = { special={desc="Know either traps or poisons.", fct=function(self)
		return self:knowTalent(self.T_VILE_POISONS) or self:knowTalent(self.T_TRAP_MASTERY)
	end} },
	on_learn = function(self, t)
		self:attr("combat_spellresist", 20)
		self:learnTalent(self.T_VULNERABILITY_POISON, true, nil, {no_unlearn=true})
		self:learnTalent(self.T_GRAVITIC_TRAP, true, nil, {no_unlearn=true})
	end,
	on_unlearn = function(self, t)
		self:attr("combat_spellresist", -20)
	end,
	info = function(self, t)
		return ([[Your study of arcane forces has let you develop new traps and poisons (depending on which you know when learning this prodigy).
		You can learn:
		- Vulnerability Poison: reduces all resistances and deals arcane damage
		- Gravitic Trap: each turn all foes in a radius 5 around it are pulled in and take temporal damage
		You also permanently gain 20 spell save.]])
		:format()
	end,
}

uberTalent{
	name = "Arcane Might",
	kr_display_name = "마법적 완력",
	mode = "passive",
	info = function(self, t)
		return ([[You have learnt to harness your latent arcane powers, channeling them through your weapon.
		Treats all weapons has having an additional 50%% magic modifier.]])
		:format()
	end,
}

uberTalent{
	name = "Temporal Form",
	kr_display_name = "시간의 모습",
	cooldown = 30,
	require = { special={desc="Cast over 1000 spells and visited an out-of-time zone", fct=function(self) return
		self.talent_kind_log and self.talent_kind_log.spell and self.talent_kind_log.spell >= 1000 and (game.state.birth.ignore_prodigies_special_reqs or self:attr("temporal_touched"))
	end} },
	no_energy = true,
	is_spell = true,
	requires_target = true,
	range = 10,
	tactical = { BUFF = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_TEMPORAL_FORM, 10, {})
		return true
	end,
	info = function(self, t)
		return ([[You can wrap temporal threads around you, assuming the form of a telugoroth for 10 turns.
		While in this form you gain pinning, bleeding, blindness and stun immunity, 30%% temporal resistance, your temporal damage bonus is set to your current highest damage bonus + 30%%, all damage you deal becomes temporal and 20%% temporal resistance penetration.
		You also are able to cast two anomalies: Anomaly Rearrange and Anomaly Temporal Storm.
		Transforming in this form will increase your paradox by 600 and revert it back at the end of the effect.]])
		:format()
	end,
}

uberTalent{
	name = "Blighted Summoning",
	kr_display_name = "황폐화된 소환술",
	mode = "passive",
	on_learn = function(self, t)
		if self.alchemy_golem then 
			self.alchemy_golem:learnTalent(self.alchemy_golem.T_CORRUPTED_STRENGTH, true, 1)
			self.alchemy_golem:learnTalentType("corruption/reaving-combat", true)
		end
	end,
	require = { special={desc="Have summoned at least 100 creatures affected by this talent (alchemist golem count as 100).", fct=function(self)
		return self:attr("summoned_times") and self:attr("summoned_times") >= 100
	end} },
	info = function(self, t)
		return ([[You infuse blighted energies in all your summons, giving them all a new talent:
		- War Hound: Curse of Defenselessness
		- Jelly: Vimsense
		- Minotaur: Life Tap
		- Golem: Bone Spear
		- Ritch: Drain
		- Hydra: Blood Spray
		- Rimebark: Poison Storm
		- Fire Drake: Darkfire
		- Turtle: Curse of Impotence
		- Spider: Corrosive Worm
		- Skeletons: Bone Grab
		- Ghouls: Blood Lock
		- Vampires / Liches: Darkfire
		- Ghosts / Wights: Blood Boil
		- Alchemy Golems: Corrupted Strength and the Reaving Combat tree
		- Shadows: Empathic Hex
		- Thought-Forms: Flame of Urh'Rok
		- Treants: Corrosive Worm
		- Yeek Wayists: Dark Portal
		- Ghoul Rot ghoul: Rend
		- Bloated Oozes: Bone Shield
		- Mucus Oozes: Virulent Disease
		- Other race or object-based summons might be affected too
		]]):format()
	end,
}

uberTalent{
	name = "Revisionist History",
	kr_display_name = "수정주의적 역사",
	cooldown = 40,
	no_energy = true,
	is_spell = true,
	no_npc_use = true,
	require = { special={desc="Have time-travelled at least once", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or (self:attr("time_travel_times") and self:attr("time_travel_times") >= 1) end} },
	action = function(self, t)
		if game._chronoworlds and game._chronoworlds.revisionist_history then
			self:hasEffect(self.EFF_REVISIONIST_HISTORY).back_in_time = true
			self:removeEffect(self.EFF_REVISIONIST_HISTORY)
			return nil -- the effect removal starts the cooldown
		end

		if checkTimeline(self) == true then return end

		game:onTickEnd(function()
			game:chronoClone("revisionist_history")
			self:setEffect(self.EFF_REVISIONIST_HISTORY, 9, {})
		end)
		return nil -- We do not start the cooldown!
	end,
	info = function(self, t)
		return ([[You can now control the near-past, upon using this prodigy you gain a temporal effect for 10 turns.
		While his effect holds you can use the prodigy again to rewrite history.
		This prodigy splits the timeline. Attempting to use another spell that also splits the timeline while this effect is active will be unsuccessful.]])
		:format()
	end,
}