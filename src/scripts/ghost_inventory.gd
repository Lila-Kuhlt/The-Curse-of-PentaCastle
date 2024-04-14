class_name GhostInventory

extends Node2D

const TARGET := Vector2(-10.0, -5.0)
const CHAIN_GAP := Vector2(-15.0, 0.0)

const ghost_type = preload("res://scripts/ghost.gd")

var flipped := false

func _update_targets():
	for i in range(get_child_count()):
		var ghost = get_child(i) as ghost_type
		var target = TARGET + i * CHAIN_GAP
		if flipped:
			target.x = -target.x
		ghost.target = target

func append(ghost: ghost_type):
	add_child(ghost)
	_update_targets()

func erase(ghost: ghost_type):
	remove_child(ghost)
	ghost.queue_free()
	_update_targets()

func flip():
	flipped = not flipped
	_update_targets()
