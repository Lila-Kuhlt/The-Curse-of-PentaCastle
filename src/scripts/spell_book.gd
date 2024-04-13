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
