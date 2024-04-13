extends CanvasLayer

@onready var spellsBox = $SpellsHBox

func add_spell_item_panel(spell: SpellBook.Spells):
	var new_item_panel = Panel.new()
	new_item_panel.custom_minimum_size.x = 12
	spellsBox.add_child(new_item_panel)
	var spell_sprite = Sprite2D.new()
	spell_sprite.texture = SpellBook.get_spell_item_sprite(spell)
	spell_sprite.position += Vector2(6, 6)
	new_item_panel.add_child(spell_sprite)

func replace_spell_item_panel(idx: int, new_spell: SpellBook.Spells):
	var item_panel = spellsBox.get_child(idx)
	var spell_sprite = item_panel.get_child(0)
	_set_sprite_texture(spell_sprite, new_spell)

func delete_spell_item_panel(idx: int):
	var item_panel = spellsBox.get_child(idx)
	item_panel.queue_free()

func _set_sprite_texture(spell_sprite: Sprite2D, spell: SpellBook.Spells):
	spell_sprite.texture = SpellBook.get_spell_item_sprite(spell)
	spell_sprite.position += Vector2(6, 6)
