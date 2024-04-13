extends CanvasLayer

@onready var spellsBox = $SpellsHBox

func add_spell_item_panel(spell: SpellBook.Spells):
	var new_item_panel = Panel.new()
	new_item_panel.custom_minimum_size.x = 12
	spellsBox.add_child(new_item_panel)
	var spell_sprite = Sprite2D.new()
	spell_sprite.texture = SpellBook.spell_item_sprites[spell]
	spell_sprite.position += Vector2(6, 6)
	new_item_panel.add_child(spell_sprite)

func mark_spell_item_panel(idx: int):
	var item_panel: Panel = spellsBox.get_child(idx)
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = Color(1,1,1)
	item_panel.add_theme_stylebox_override("panel", new_stylebox)

func unmark_spell_item_panel(idx: int):
	var item_panel: Panel = spellsBox.get_child(idx)
	item_panel.remove_theme_stylebox_override("panel")

func replace_spell_item_panel(idx: int, new_spell: SpellBook.Spells):
	var item_panel = spellsBox.get_child(idx)
	var spell_sprite = item_panel.get_child(0)
	_set_sprite_texture(spell_sprite, new_spell)

func delete_spell_item_panel(idx: int):
	var item_panel = spellsBox.get_child(idx)
	item_panel.queue_free()

func _set_sprite_texture(spell_sprite: Sprite2D, spell: SpellBook.Spells):
	spell_sprite.texture = SpellBook.spell_item_sprites[spell]
	spell_sprite.position += Vector2(6, 6)
