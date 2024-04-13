extends SpellItemBase

func _init():
	spell = SpellBook.Spells.SLOWDOWN
	type = SpellBook.SpellType.PASSIVE
	rank = SpellBook.SpellRank.RARE
	title = "Slowdown"
	desc = "Enemy slowdown for 5s"
	cast = "24132"
	duration = 5
