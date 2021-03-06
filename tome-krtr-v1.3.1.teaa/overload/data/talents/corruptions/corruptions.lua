-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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

-- Corruptions
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/sanguisuge", name = "sanguisuge", description = "생명의 힘을 통해, 어둠의 힘을 키웁니다." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/torment", name = "torment", generic = true, description = "모든 도구를 이용하여, 적들을 고문합니다." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/vim", name = "vim", description = "희생자들이 지닌 생명의 근원에 손을 뻗칩니다." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/bone", name = "bone", description = "해골과 뼈의 힘을 사용합니다." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/hexes", name = "hexes", generic = true, description = "매혹술을 걸어, 적들의 행동을 방해하고 무력화시킵니다." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/curses", name = "curses", generic = true, description = "저주를 걸어, 적들의 행동을 방해하고 무력화시킵니다." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/vile-life", name = "vile life", generic = true, description = "불결한 욕망에 따라, 생명의 힘을 조작합니다." } 
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/plague", name = "plague", description = "적들에게 질병을 퍼뜨립니다." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/scourge", name = "scourge", description = "세상에 고통과 파괴를 가져옵니다." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/reaving-combat", name = "reaving combat", description = "어둠의 마법을 사용해 근접 전투력을 높입니다." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/blood", name = "blood", description = "피의 힘을 사용합니다. 자신의 것이든, 남의 것이든..." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/blight", name = "blight", description = "적들을 오염시키고 부패하게 만듭니다." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="corruption/shadowflame", name = "Shadowflame", description = "악마들이 사용하는 어둠의 불꽃을 사용합니다." }

-- Generic requires for corruptions based on talent level
corrs_req1 = {
	stat = { mag=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
corrs_req2 = {
	stat = { mag=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
corrs_req3 = {
	stat = { mag=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
corrs_req4 = {
	stat = { mag=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
corrs_req5 = {
	stat = { mag=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}
str_corrs_req1 = {
	stat = { str=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
str_corrs_req2 = {
	stat = { str=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
str_corrs_req3 = {
	stat = { str=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
str_corrs_req4 = {
	stat = { str=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
str_corrs_req5 = {
	stat = { str=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}

corrs_req_high1 = {
	stat = { mag=function(level) return 22 + (level-1) * 2 end },
	level = function(level) return 10 + (level-1)  end,
}
corrs_req_high2 = {
	stat = { mag=function(level) return 30 + (level-1) * 2 end },
	level = function(level) return 14 + (level-1)  end,
}
corrs_req_high3 = {
	stat = { mag=function(level) return 38 + (level-1) * 2 end },
	level = function(level) return 18 + (level-1)  end,
}
corrs_req_high4 = {
	stat = { mag=function(level) return 46 + (level-1) * 2 end },
	level = function(level) return 22 + (level-1)  end,
}
corrs_req_high5 = {
	stat = { mag=function(level) return 54 + (level-1) * 2 end },
	level = function(level) return 26 + (level-1)  end,
}

load("/data/talents/corruptions/sanguisuge.lua")
load("/data/talents/corruptions/scourge.lua")
load("/data/talents/corruptions/plague.lua")
load("/data/talents/corruptions/reaving-combat.lua")
load("/data/talents/corruptions/bone.lua")
load("/data/talents/corruptions/curses.lua")
load("/data/talents/corruptions/hexes.lua")
load("/data/talents/corruptions/blood.lua")
load("/data/talents/corruptions/blight.lua")
load("/data/talents/corruptions/shadowflame.lua")
load("/data/talents/corruptions/vim.lua")
load("/data/talents/corruptions/torment.lua")
load("/data/talents/corruptions/vile-life.lua")
