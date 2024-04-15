extends SpellItemBase

func _init():
	spell = SpellBook.Spells.SPEED
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.COMMON
	title = "Speed"
	desc = "Passive: Doubles your speed for 10 seconds"
	cast = [1, 4, 0, 1]
	duration = 10
	sprite = preload("res://assets/spell_items/speed.png")
