class_name GhostInventory

extends Node2D

const ghost_type = preload("res://scripts/ghost.gd")

func _rearrange_ghosts():
	for i in range(get_child_count()):
		var child = get_child(i) as ghost_type
		child.ghost_nr = i

func append(ghost: ghost_type):
	add_child(ghost)
	_rearrange_ghosts()

func erase(ghost: ghost_type):
	remove_child(ghost)
	ghost.queue_free()
	_rearrange_ghosts()
