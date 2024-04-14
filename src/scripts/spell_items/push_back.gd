extends SpellItemBase

func _init():
	spell = SpellBook.Spells.PUSH_BACK
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.COMMON
	title = "PushBack"
	desc = "Knockbacks enemies"
	cast = "15"
	duration = 0.0
