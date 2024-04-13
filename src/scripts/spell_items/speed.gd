extends SpellItemBase

func _init():
	spell = SpellBook.Spells.SPEED
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.COMMON
	title = "Speed"
	desc = "Double speed for 10s"
	cast = "1401"
	duration = 10
