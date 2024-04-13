class_name Enemy
extends CharacterBody2D

@export var MOVEMENT_SPEED := 10.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func do_physics(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
