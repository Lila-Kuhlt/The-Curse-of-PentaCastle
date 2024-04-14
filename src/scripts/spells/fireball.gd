extends SpellBase

const Fireball = preload("res://scenes/projectiles/fireball.tscn")

func cast(player: Player, _enemies: Array[Node]):
	spawn_projectile(player, Fireball.instantiate())
