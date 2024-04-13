extends Control

@onready var spellsBox = $SpellsHBox
var item_panels: Array[SpellBook.Spells] = []

func add_spell_item_panel(spell: SpellBook.Spells):
	print("lol")
	item_panels.append(spell)
	var new_item_panel = Panel.new()
	new_item_panel.custom_minimum_size.x = 12
	spellsBox.add_child(new_item_panel)
	var spell_sprite = Sprite2D.new()
	spell_sprite.texture = SpellBook.get_spell_item_sprite(spell)
	spell_sprite.position += Vector2(6, 6)
	new_item_panel.add_child(spell_sprite)

func replace_spell_item_panel(spell: SpellBook.Spells):
	pass
