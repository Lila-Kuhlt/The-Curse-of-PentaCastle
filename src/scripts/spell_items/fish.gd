extends SpellItemBase

func _init():
	spell = SpellBook.Spells.FISH
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.RARE
	title = "Fish"
	desc = "Attack Spell: A fish. It is wet. It moves in wave-forms."
	cast = [3, 0, 2, 4]
	duration = 30.0
	sprite = preload("res://assets/spell_items/fish.png")
