extends SpellItemBase

func _init():
	spell = SpellBook.Spells.ULTIMATE
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.ULTRA
	title = "Ultimate"
	desc = "Passive: Kills all enemies, but you take 30 damage. Only reusable every 50 seconds."
	cast = [0, 2, 4, 1, 3, 0]
	duration = 50
	sprite = preload("res://assets/spell_items/ultimate.png")
