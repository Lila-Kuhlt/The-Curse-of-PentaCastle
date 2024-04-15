extends SpellItemBase

func _init():
	spell = SpellBook.Spells.SHIELD
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.RARE
	title = "Shield"
	desc = "Passive: Halves obtained damage for 10 seconds"
	cast = [0, 1, 2, 3, 4, 0]
	duration = 10.0
	sprite = preload("res://assets/spell_items/shield.png")
