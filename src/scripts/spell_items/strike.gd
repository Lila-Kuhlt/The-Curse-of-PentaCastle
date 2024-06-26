extends SpellItemBase

func _init():
	spell = SpellBook.Spells.STRIKE
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.COMMON
	title = "Strike"
	desc = "Attack Spell: Summon a rotating dagger projectile"
	cast = [1, 4]
	duration = 0.0
	sprite = preload("res://assets/spell_items/strike.png")
