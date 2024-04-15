extends SpellItemBase

func _init():
	spell = SpellBook.Spells.PUSH_BACK
	type = SpellBook.SpellType.ACTIVE
	rank = SpellBook.SpellRank.COMMON
	title = "PushBack"
	desc = "Attack Spell: High knockback, but no damage projectile"
	cast = [1, 3]
	duration = 0.0
	sprite = preload("res://assets/spell_items/push_back.png")
