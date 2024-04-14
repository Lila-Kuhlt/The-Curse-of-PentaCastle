extends SpellItemBase

func _init():
	spell = SpellBook.Spells.FISH
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.RARE
	title = "Fish"
	desc = "Enemy gets 4 damage and effect wet"
	cast = [3, 0, 1, 4]
	duration = 30.0
