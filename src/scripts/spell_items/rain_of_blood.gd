extends SpellItemBase

func _init():
	spell = SpellBook.Spells.RAIN_OF_BLOOD
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.RARE
	title = "Rain of Blood"
	desc = "Enemy gets 2 damage 7s long"
	cast = [2, 3, 0]
	duration = 7.0
