extends Node

enum SpellRank {
	COMMON,
	RARE,
	ULTRA
}

enum SpellType {
	ACTIVE,
	PASSIVE
}

enum Spells {
	PLACEHOLDER,
	SPEED
}

var spell_item_scripts = [
	preload("res://scripts/spell_items/base.gd"),
	preload("res://scripts/spell_items/speed.gd")
]

var spell_item_sprites = [
	preload("res://assets/spell_items/placeholder.png"),
	preload("res://assets/spell_items/speed.png")
]

var _spell_scripts = [
	preload("res://scripts/spells/base.gd").new(),
	preload("res://scripts/spells/speed.gd").new()
]

func cast(spell: Spells, inventory_idx: int, player: CharacterBody2D):
	player.ui.mark_spell_item_panel(inventory_idx)
	var spell_script = _spell_scripts[spell]
	spell_script.cast(player)
	var spell_item_script = get_spell_item_script(spell).new()
	if (spell_item_script.type == SpellType.PASSIVE):
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = spell_item_script.duration
		timer.one_shot = true
		timer.timeout.connect(_uncast.bind(spell, inventory_idx, player))
		timer.start()

func _uncast(spell: Spells, inventory_idx: int, player: CharacterBody2D):
	player.ui.unmark_spell_item_panel(inventory_idx)
	var spell_script = _spell_scripts[spell]
	spell_script.uncast(player)

func get_spell_item_script(spell: Spells):
	return spell_item_scripts[spell]

func get_spell_item_sprite(spell: Spells):
	return spell_item_sprites[spell]

func find_spell(combo: String) -> Spells:
	for spell_item_script in spell_item_scripts:
		var spell_item = spell_item_script.new()
		if (spell_item.cast == combo):
			return spell_item.spell
	return -1
