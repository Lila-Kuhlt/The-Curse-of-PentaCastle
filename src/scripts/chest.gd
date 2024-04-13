extends Area2D

const spell_item_scene = preload("res://scenes/spellItem.tscn")
@export var spell_item_id: int = -1
@onready var use_label := $Use
var is_player_entered: bool = false
var player_entered: CharacterBody2D

func _ready():
	var spell_item: Node2D = spell_item_scene.instantiate()
	if (spell_item_id == 0):
		print("load speed")
		spell_item.script = preload("res://scripts/spells/spellItemSpeed.gd")
	else:
		spell_item.script = preload("res://scripts/spells/spellItemBase.gd")
	spell_item.position.y -= 12
	add_child(spell_item)


func _process(_delta):
	if is_player_entered && Input.is_action_just_pressed("use"):
		use_chest()


func use_chest():
	player_entered.give_spell_item(spell_item_id)
	queue_free()


func _on_body_entered(body):
	if (body is CharacterBody2D):
		is_player_entered = true
		show_use_label()
		player_entered = body


func _on_body_exited(body):
	if (body is CharacterBody2D):
		is_player_entered = false
		hide_use_label()
		player_entered = null

func show_use_label():
	use_label.visible = true

func hide_use_label():
	use_label.visible = false
