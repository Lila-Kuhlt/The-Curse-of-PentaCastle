extends SpellItemBase

func _init():
	spell = SpellBook.Spells.SLOWDOWN
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.RARE
	title = "Slowdown"
	desc = "Passive: All enemies slow down for 5s"
	cast = [2, 4, 1, 3, 2]
	duration = 5
	sprite = preload("res://assets/spell_items/slowdown.png")
