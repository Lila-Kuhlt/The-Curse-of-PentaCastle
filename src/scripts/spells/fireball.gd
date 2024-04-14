extends SpellBase

const PROJECTILE = preload("res://scenes/projectiles/fireball.tscn")

func cast(player: Player, _enemies: Array[Node]):
	var projectile = PROJECTILE.instantiate()
	spawn_projectile(player, projectile)
