extends SpellItemBase

func _init():
	spell = SpellBook.Spells.FIREBALL
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.ULTRA
	title = "Fireball"
	desc = "Attack Spell: A ball of fire charging straight forwards."
	cast = [1, 2, 0, 3, 4]
	duration = 0.0
	sprite = preload("res://assets/spell_items/fireball.png")
