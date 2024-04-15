extends Node2D

const door = preload("res://scenes/door.tscn")

const main_room = preload("res://scenes/rooms/room_debug.tscn")
const rooms = [
	preload("res://scenes/rooms/room1.tscn"),
	preload("res://scenes/rooms/room2.tscn"),
	preload("res://scenes/rooms/room3.tscn"),
	preload("res://scenes/rooms/room-illuminati.tscn"),
	preload("res://scenes/rooms/room-wheel.tscn"),
]

var room_idx: int = -1
var room: Node2D

const Spell = SpellBook.Spells
const spell_order = [
	Spell.SPEED,
	Spell.FISH,
	Spell.SLOWDOWN,
	Spell.PUSH_BACK,
	Spell.MAGIC_BOOST,
	Spell.STRIKE,
	Spell.SHIELD,
	Spell.LIGHTNING,
	Spell.RAIN_OF_BLOOD,
]
var next_spell_idx := 0

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
		await room.tree_exited
	room = scene.instantiate()
	add_child(room)
	check_room_cleared()
	$Player.position = room.find_child("PlayerMarker").position

func _ready():
	load_room(main_room)

func check_room_cleared():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var chests = get_tree().get_nodes_in_group("chests")
	if enemies.all(func(enemy): return enemy.life <= 0) and chests.all(func(chest): return not chest.active):
		room.room_cleared()

func get_next_spell() -> Spell:
	if next_spell_idx == -1:
		return Spell.PLACEHOLDER
	var spell = spell_order[next_spell_idx]
	next_spell_idx += 1
	return spell
