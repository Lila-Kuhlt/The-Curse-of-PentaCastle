extends Area2D

@export var spell: Node2D
@onready var use_label := $Use
var is_player_entered: bool = false
var player_entered: CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_player_entered && Input.is_action_just_pressed("use"):
		use_chest()


func use_chest():
	player_entered.give_spell(spell)
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
