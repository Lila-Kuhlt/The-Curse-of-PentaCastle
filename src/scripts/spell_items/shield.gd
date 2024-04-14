extends SpellItemBase

func _init():
	spell = SpellBook.Spells.SHIELD
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.RARE
	title = "Shield"
	desc = "Half damage for 10s"
	cast = [0, 1, 2, 3, 4, 0]
	duration = 10.0
