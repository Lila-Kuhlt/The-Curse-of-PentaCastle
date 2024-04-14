extends SpellItemBase

func _init():
	spell = SpellBook.Spells.LIGHTNING
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.RARE
	title = "Lightning"
	desc = "Lightning Damage"
	cast = [3, 1, 4, 0]
	duration = 0.0
