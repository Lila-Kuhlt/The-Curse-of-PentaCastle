extends SpellItemBase

func _init():
	spell = SpellBook.Spells.FIREBALL
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.ULTRA
	title = "Fireball"
	desc = "High fire damage"
	cast = [1, 2, 0, 3, 4]
	duration = 0.0
