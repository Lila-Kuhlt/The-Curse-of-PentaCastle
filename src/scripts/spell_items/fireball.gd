extends SpellItemBase

func _init():
	spell = SpellBook.Spells.FIREBALL
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.COMMON
	title = "Fireball"
	desc = "Damages near enemies"
	cast = "12034"
	duration = 0.0
