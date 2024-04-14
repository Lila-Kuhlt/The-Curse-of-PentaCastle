extends SpellItemBase

func _init():
	spell = SpellBook.Spells.FISH
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.RARE
	title = "Fish"
	desc = "Medium fish attack"
	cast = [3, 0, 2, 4]
	duration = 30.0