extends Node

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
