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
		var cast = spell_item.cast
		if (check_combo(combo, cast)):
			return spell_item.spell
	return Spells.PLACEHOLDER

func check_combo(combo: String, cast: String) -> bool:
	if (combo.length() != cast.length()): return false

	var cast_cylic = _is_cylic(cast)
	if (cast_cylic):
		if (_is_cylic(combo)):
			cast = _remove_last_char(cast)
			combo = _remove_last_char(combo)
		else:
			return false

	var last_cast_idx = -1
	var cast_idx = -1
	var idx_diff = -1
	for number in combo:
		cast_idx = cast.find(number)
		if (cast_idx == -1): return false

		idx_diff = abs(last_cast_idx - cast_idx)
		if (last_cast_idx == -1):
			last_cast_idx = cast_idx
			continue
		elif (idx_diff != 1 and idx_diff != cast.length() - 1): return false
		last_cast_idx = cast_idx
	return true

func _is_cylic(text: String):
	return text[0] == text[text.length() - 1]

func _remove_last_char(text: String):
	return text.erase(text.length() - 1, 1)
