extends SpellBase

func cast(player: CharacterBody2D, _enemies: Array[Node]):
	var Projectile = load("res://scenes/projectiles/fireball.tscn")
	var projectile = Projectile.instantiate()
	if  player.sprite.flip_h:
		projectile.direction = Vector2(-1, 0)
		projectile.rotation = PI
	else:
		projectile.direction = Vector2(1, 0)
		projectile.rotation = 0

	projectile.position = player.position
	player.get_parent().add_child(projectile)
