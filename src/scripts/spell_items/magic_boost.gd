extends SpellItemBase

func _init():
	spell = SpellBook.Spells.MAGIC_BOOST
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.COMMON
	title = "Macic Boost"
	desc = "Increased damage of attacks for 5s"
	cast = [2, 0, 3]
	duration = 5.0
	sprite = preload("res://assets/spell_items/magic_boost.png")
