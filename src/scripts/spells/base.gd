class_name SpellBase extends Node2D

func cast(_player: Player, _enemies: Array[Node]):
	pass

func uncast(_player: Player, _enemies: Array[Node]):
	pass

func spawn_projectile(player: Player, projectile: Projectile):
	var flip: bool = player.sprite.flip_h
	projectile.set_flipped(flip)
	projectile.direction = Vector2(1,0) * (-1 if flip else 1)

	projectile.position = player.position
	player.get_parent().add_child(projectile)
