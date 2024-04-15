extends Node2D

const ROOMS_PER_DIFFICULTY := 1

const door = preload("res://scenes/door.tscn")

const main_room = preload("res://scenes/rooms/room_debug.tscn")
const room_type := preload("res://scripts/room.gd")
const rooms := {
	room_type.difficulty.EASY: [
		preload("res://scenes/rooms/room3.tscn"),
		preload("res://scenes/rooms/room_line.tscn"),
	],
	room_type.difficulty.MEDIUM: [preload("res://scenes/rooms/room2.tscn")],
	room_type.difficulty.HARD: [
		preload("res://scenes/rooms/room1.tscn"),
		preload("res://scenes/rooms/room-illuminati.tscn"),
		preload("res://scenes/rooms/room-wheel.tscn"),
		preload("res://scenes/rooms/room_4.tscn"),
		preload("res://scenes/rooms/room-tunnel.tscn"),
	]
}

var room_scene: PackedScene
var room: Node2D

const Spell = SpellBook.Spells
var spell_order := []
var next_spell_idx := 0

var next_difficulty := room_type.difficulty.EASY
var count_until_next_difficulty := ROOMS_PER_DIFFICULTY

var score: int = 0
signal score_changed(score: int)
func add_score(val: int):
	score += val
	score_changed.emit(score)

func _update_difficulty():
	count_until_next_difficulty -= 1
	if count_until_next_difficulty == 0 and next_difficulty != room_type.difficulty.HARD:
		next_difficulty += 1
		count_until_next_difficulty = ROOMS_PER_DIFFICULTY

## Spawn a new room.
func new_room():
	var available_rooms = rooms[next_difficulty].duplicate()
	# avoid picking the same room again
	available_rooms.erase(room_scene)
	assert(available_rooms.size() > 0)
	_update_difficulty()
	load_room(available_rooms.pick_random())

func load_room(scene: PackedScene):
	if room:
		room.queue_free()
		await room.tree_exited
	room_scene = scene
	room = room_scene.instantiate()
	add_child(room)
	check_room_cleared()
	$Player.position = room.find_child("PlayerMarker").position

func _ready():
	var common := []
	var rare := []
	var ultra := []
	for spell_item in SpellBook.spell_item_scripts:
		if spell_item.spell == Spell.PLACEHOLDER:
			continue
		match spell_item.rank:
			SpellBook.SpellRank.COMMON:
				common.append(spell_item.spell)
			SpellBook.SpellRank.RARE:
				rare.append(spell_item.spell)
			SpellBook.SpellRank.ULTRA:
				ultra.append(spell_item.spell)
	common.shuffle()
	rare.shuffle()
	ultra.shuffle()
	spell_order = common + rare + ultra
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
