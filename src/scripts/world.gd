extends Node2D

const door = preload("res://scenes/door.tscn")

const main_room = preload("res://scenes/rooms/room_main.tscn")
const rooms = [
	preload("res://scenes/rooms/room1.tscn"),
	preload("res://scenes/rooms/room2.tscn"),
	preload("res://scenes/rooms/room3.tscn"),
]

var room_idx: int = -1
var room: Node2D

const Spells = SpellBook.Spells

## Spawn a new room.
func new_room():
	var available_rooms = rooms.duplicate()
	# avoid picking the same room again
	if room_idx >= 0:
		available_rooms.remove_at(room_idx)
	load_room(available_rooms.pick_random())

func load_room(scene: PackedScene):
	if room:
		room.queue_free()
	room = scene.instantiate()
	add_child(room)
	$Player.position = room.find_child("PlayerMarker").position

func _ready():
	load_room(main_room)

func check_enemies():
	if get_tree().get_nodes_in_group("enemies").is_empty():
		room.all_enemies_dead()

func get_next_spell() -> Spells:
	# TODO
	return Spells.ULTIMATE
