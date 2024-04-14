extends SpellItemBase

func _init():
	spell = SpellBook.Spells.STRIKE
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.COMMON
	title = "Strike"
	desc = "Small attack"
	cast = [1, 4]
	duration = 0.0
