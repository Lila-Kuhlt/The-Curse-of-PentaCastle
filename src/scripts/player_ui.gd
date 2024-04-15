extends CanvasLayer

@onready var spellsBox = $MarginContainer/VBoxContainer/SpellsHBox
@onready var inPanel = $MarginContainer/VBoxContainer/SpellsHBox/MarginContainer
@onready var scoreLabel = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HPBar/Score

var dflt_box := StyleBoxFlat.new()
var ovrride_box := StyleBoxFlat.new()

func _update_score(score: int):
	scoreLabel.text = str(score)

func _ready() -> void:
	dflt_box.bg_color = Color(0.3, 0.3, 0.3)
	ovrride_box.bg_color = Color(0.4, 0.5, 0.4)
	dflt_box.border_color = Color(0.2, 0.15, 0.2)
	ovrride_box.border_color = Color(1.0, 0.4, 0.6)
	for box in [dflt_box, ovrride_box]:
		box.set_border_width_all(4.0)

	var world = get_tree().get_first_node_in_group("world")
	world.score_changed.connect(_update_score)

func add_spell_item_panel(spell: SpellBook.Spells):
	var panel: MarginContainer = inPanel.duplicate()
	panel.visible = true
	spellsBox.add_child(panel)
	var lst: Array[int] = []
	var spell_item = SpellBook.spell_item_scripts[spell]
	for c in spell_item.cast:
		lst.append(int(c))
	var child = panel.get_child(0)
	child.init_lines(lst)
	child.set_desc(spell_item.desc)
	child.add_theme_stylebox_override('panel', dflt_box)
	child.set_texture(spell_item.sprite)

func mark_spell_item_panel(idx: int):
	var panel: Panel = spellsBox.get_child(idx + 1).get_child(0)
	panel.remove_theme_stylebox_override('panel')
	panel.add_theme_stylebox_override('panel', ovrride_box)

func unmark_spell_item_panel(idx: int):
	var panel = spellsBox.get_child(idx + 1).get_child(0)
	panel.remove_theme_stylebox_override('panel')
	panel.add_theme_stylebox_override('panel', dflt_box)

func replace_spell_item_panel(idx: int, new_spell: SpellBook.Spells):
	var panel = spellsBox.get_child(idx + 1).get_child(0)
	var spell_item = SpellBook.spell_item_scripts[new_spell]
	panel.set_texture(spell_item.sprite)

func delete_spell_item_panel(idx: int):
	var item_panel = spellsBox.get_child(idx + 1)
	item_panel.queue_free()
