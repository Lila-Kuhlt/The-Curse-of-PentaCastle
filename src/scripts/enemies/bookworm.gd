extends Enemy

const VIEW_DISTANCE := 70.0
const IDLE_COOLDOWN := 100.0
const HIDE_COOLDOWN_MIN := 1
const HIDE_COOLDOWN_MAX := 3
const ATTACK_COOLDOWN := 2

enum BookwormMode { IDLE, ATTACK, HIDING }

var mode: BookwormMode = BookwormMode.IDLE
var mode_cooldown := 0.0
var attack_target := Vector2(0, 0)

@onready var player = get_tree().get_first_node_in_group('player')
@onready var shape: CollisionShape2D = $PhysicsCollider
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var map: TileMap = get_tree().current_scene.find_child('Map')
@onready var Spear = preload("res://scenes/projectiles/spearlike.tscn")

func _ready() -> void:
	super._ready()

func goto_attack_mode():
	mode = BookwormMode.ATTACK
	attack_target = player.position
	mode_cooldown = ATTACK_COOLDOWN
	anim.queue('attack')
	var spear := Spear.instantiate()
	var local_target := to_local(attack_target)
	spear.look_at(local_target)
	add_child(spear)

func goto_hide_mode():
	mode = BookwormMode.HIDING
	shape.disabled = true
	mode_cooldown = randi_range(HIDE_COOLDOWN_MIN, HIDE_COOLDOWN_MAX)
	anim.queue('hide')

func goto_idle_mode():
	position = find_teleport_pos()
	mode = BookwormMode.IDLE
	shape.disabled = false
	mode_cooldown = IDLE_COOLDOWN
	anim.queue('idle')

func find_teleport_pos() -> Vector2:
	var coords: Array[Vector2i] = []
	for coord in map.get_used_cells(0):
		var cell = map.get_cell_tile_data(0, coord)
		if cell == null or cell.get_collision_polygons_count(0) == 0: continue
		coord = map.get_neighbor_cell(coord, TileSet.CELL_NEIGHBOR_TOP_SIDE)
		var top_tile := map.get_cell_tile_data(0, coord)
		if top_tile != null and top_tile.get_collision_polygons_count(0): continue
		coords.append(coord)
	var coord := coords[randi_range(0, coords.size() - 1)]
	return map.map_to_local(coord)

func _physics_process(delta: float) -> void:
	match mode:
		BookwormMode.IDLE:
			if player.position.distance_to(position) < VIEW_DISTANCE:
				goto_attack_mode()
			else:
				mode_cooldown -= delta
				if mode_cooldown < 0:
					goto_hide_mode()
		BookwormMode.HIDING:
			if mode_cooldown <= 0:
				goto_idle_mode()
			else: mode_cooldown -= delta
		BookwormMode.ATTACK:
			mode_cooldown -= delta
			if mode_cooldown < 0:
				goto_hide_mode()
	if mode != BookwormMode.HIDING:
		super._physics_process(delta)
	sprite.flip_h = position.x < player.position.x
