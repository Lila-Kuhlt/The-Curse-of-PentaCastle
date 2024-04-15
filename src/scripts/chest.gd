extends Area2D

@onready var use_label := $Use
@export var spell: SpellBook.Spells = SpellBook.Spells.PLACEHOLDER
const spell_item_scene = preload("res://scenes/spell_item.tscn")

var is_player_entered: bool = false
var player_entered: CharacterBody2D
var desc: String
var active := true

@onready var world: Node2D = get_tree().get_first_node_in_group("world")
@onready var desc_node: RichTextLabel = get_tree().get_first_node_in_group('spell-description-label')

func _ready():
	var spell_item: Node2D = spell_item_scene.instantiate()
	spell_item.set_script(SpellBook.spell_item_script_types[spell])
	spell_item.position.y -= 12
	add_child(spell_item)
	desc = spell_item.desc


func _process(_delta):
	if is_player_entered && Input.is_action_just_pressed("use"):
		use_chest()


func use_chest():
	active = false
	player_entered.give_spell_item(spell)
	world.check_room_cleared()
	SfxAudio.play_sfx(SfxAudio.Sound.CHEST)
	queue_free()


func _on_body_entered(body):
	if (body is CharacterBody2D):
		is_player_entered = true
		show_use_label()
		player_entered = body
		desc_node.clear()
		desc_node.add_text(desc)


func _on_body_exited(body):
	if (body is CharacterBody2D):
		is_player_entered = false
		hide_use_label()
		player_entered = null
		desc_node.clear()

func show_use_label():
	use_label.visible = true

func hide_use_label():
	use_label.visible = false
