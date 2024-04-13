extends SpellItemBase

func _init():
	spell = SpellBook.Spells.SPEED
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.COMMON
	title = "Speed"
	desc = "20% increase in speed and jump for 10 seconds"
	cast = "1401"
	duration = 10
