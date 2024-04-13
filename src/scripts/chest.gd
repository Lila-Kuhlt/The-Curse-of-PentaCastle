extends Area2D

@export var spell: Node2D
var is_player_entered: bool = false
var player_entered: CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_player_entered && Input.is_action_just_pressed("use"):
		use_chest()


func use_chest():
	player_entered.give_spell(spell)
	queue_free()


func _on_body_entered(body):
	is_player_entered = true
	player_entered = body


func _on_body_exited(body):
	is_player_entered = false
	player_entered = null

