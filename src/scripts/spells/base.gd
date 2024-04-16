class_name SpellBase extends Node2D

func cast(_player: Player, _enemies: Array[Node]):
	pass

func uncast(_player: Player, _enemies: Array[Node]):
	pass

func spawn_projectile(player: Player, projectile: Projectile):
	if player.sprite.flip_h:
		projectile.flip()
		projectile.direction *= -1
	projectile.position = player.position + Vector2(0, 4)

	player.get_parent().room.add_child(projectile)
