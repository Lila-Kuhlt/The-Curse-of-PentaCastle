extends Enemy

@export var SHOOT_COOLDOWN := 5.0

const Fire = preload("res://scenes/projectiles/firelike.tscn")

var cooldown := SHOOT_COOLDOWN

func _physics_process(delta: float):
	var collider = $ViewRay.get_collider()
	if collider == player and cooldown <= 0:
		var fire = Fire.instantiate()
		if not is_facing_right:
			fire.direction *= -1
			fire.flip()
		fire.position = position
		get_parent().add_child(fire)
		cooldown = SHOOT_COOLDOWN

	if cooldown > 0:
		cooldown -= delta

	super._physics_process(delta)
