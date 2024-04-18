extends Enemy

const VIEW_DISTANCE := 70.0
const MIN_DISTANCE_TO_PLAYER := 40.0
const IDLE_COOLDOWN_MIN := 4.0
const IDLE_COOLDOWN_MAX := 8.0
const HIDE_COOLDOWN_MIN := 1
const HIDE_COOLDOWN_MAX := 3
const PRE_ATTACK_COOLDOWN := 1.0
const ATTACK_COOLDOWN := 2

enum BookwormMode { IDLE, PRE_ATTACK, ATTACK, HIDING }

var mode: BookwormMode = BookwormMode.IDLE
var mode_cooldown := 3.0
var attack_target := Vector2(0, 0)

@onready var shape: CollisionShape2D = $PhysicsCollider
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var map: TileMap = get_parent().find_child('Map')

const Spear = preload("res://scenes/projectiles/spear.tscn")

func _ready() -> void:
	super._ready()

func goto_pre_attack_mode():
	mode = BookwormMode.PRE_ATTACK
	mode_cooldown = PRE_ATTACK_COOLDOWN

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
	var tpos := find_teleport_pos()
	if tpos.x != INF:
		position = tpos
	mode = BookwormMode.IDLE
	shape.disabled = false
	mode_cooldown = randf_range(IDLE_COOLDOWN_MIN, IDLE_COOLDOWN_MAX)
	anim.queue('idle')

func find_teleport_pos() -> Vector2:
	var coords: Array[Vector2i] = []
	for coord in map.get_used_cells(0):
		if map.map_to_local(coord).distance_to(player.position) <= MIN_DISTANCE_TO_PLAYER:
			continue
		var cell = map.get_cell_tile_data(0, coord)
		if cell == null or cell.get_collision_polygons_count(0) == 0: continue
		coord = map.get_neighbor_cell(coord, TileSet.CELL_NEIGHBOR_TOP_SIDE)
		var top_tile := map.get_cell_tile_data(0, coord)
		if top_tile != null and top_tile.get_collision_polygons_count(0): continue
		if map.get_cell_tile_data(1, coord) != null: continue # spawn blocker
		coords.append(coord)
	if not coords: return Vector2(INF, INF)
	var coord := coords[randi_range(0, coords.size() - 1)]
	return map.map_to_local(coord)

func _physics_process(delta: float) -> void:
	if not stunned:
		match mode:
			BookwormMode.IDLE:
				if player.position.distance_to(position) < VIEW_DISTANCE:
					goto_pre_attack_mode()
				else:
					mode_cooldown -= delta
					if mode_cooldown < 0:
						goto_hide_mode()
			BookwormMode.HIDING:
				if mode_cooldown <= 0:
					goto_idle_mode()
				else: mode_cooldown -= delta
			BookwormMode.PRE_ATTACK:
				if mode_cooldown <= 0:
					goto_attack_mode()
				else: mode_cooldown -= delta
			BookwormMode.ATTACK:
				mode_cooldown -= delta
				if mode_cooldown < 0:
					goto_hide_mode()
		if mode != BookwormMode.HIDING:
			super._physics_process(delta)
		is_facing_right = position.x < player.position.x
	else:
		if mode != BookwormMode.HIDING:
			super._physics_process(delta)
