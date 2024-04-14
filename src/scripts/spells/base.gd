class_name SpellBase extends Node2D

func cast(_player: Player, _enemies: Array[Node]):
	pass

func uncast(_player: Player, _enemies: Array[Node]):
	pass

func spawn_projectile(player: Player, projectile: Node2D):
	if  player.sprite.flip_h:
		projectile.direction = Vector2(-1, 0)
		projectile.rotation = PI
	else:
		projectile.direction = Vector2(1, 0)
		projectile.rotation = 0

	projectile.position = player.position
	player.get_parent().add_child(projectile)
