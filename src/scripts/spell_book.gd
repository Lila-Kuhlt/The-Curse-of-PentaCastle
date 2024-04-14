extends Node

enum SpellRank {
	COMMON,
	RARE,
	ULTRA,
}

enum SpellType {
	ACTIVE,
	PASSIVE,
}

enum Spells {
	PLACEHOLDER,
	SPEED,
	SLOWDOWN,
	PUSH_BACK,
	FIREBALL,
	ULTIMATE
}

var spell_item_scripts = [
	preload("res://scripts/spell_items/base.gd"),
	preload("res://scripts/spell_items/speed.gd"),
	preload("res://scripts/spell_items/slowdown.gd"),
	preload("res://scripts/spell_items/push_back.gd"),
	preload("res://scripts/spell_items/fireball.gd"),
	preload("res://scripts/spell_items/ultimate.gd"),
]

var spell_item_sprites = [
	preload("res://assets/spell_items/placeholder.png"),
	preload("res://assets/spell_items/speed.png"),
	preload("res://assets/spell_items/slowdown.png"),
	preload("res://assets/spell_items/push_back.png"),
	preload("res://assets/spell_items/fireball.png"),
	preload("res://assets/spell_items/ultimate.png"),
]

var spell_scripts = [
	preload("res://scripts/spells/base.gd").new(),
	preload("res://scripts/spells/speed.gd").new(),
	preload("res://scripts/spells/slowdown.gd").new(),
	preload("res://scripts/spells/push_back.gd").new(),
	preload("res://scripts/spells/fireball.gd").new(),
	preload("res://scripts/spells/ultimate.gd").new(),
]

func find_spell(combo: String) -> Spells:
	for spell_item_script in spell_item_scripts:
		var spell_item = spell_item_script.new()
		if (spell_item.cast == combo):
			return spell_item.spell
	return Spells.PLACEHOLDER
