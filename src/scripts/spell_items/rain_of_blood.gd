extends SpellItemBase

func _init():
	spell = SpellBook.Spells.RAIN_OF_BLOOD
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.RARE
	title = "Rain of Blood"
	desc = "Passive: All enemies obtain constant damage over 7 seconds"
	cast = [2, 3, 0]
	duration = 7.0
	sprite = preload("res://assets/spell_items/rain_of_blood.png")
