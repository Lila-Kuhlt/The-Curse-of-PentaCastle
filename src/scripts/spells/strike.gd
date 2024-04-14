extends SpellBase

var Projectile = preload("res://scenes/projectiles/strike.tscn")

func cast(player: CharacterBody2D, _enemies: Array[Node]):
	var projectile = Projectile.instantiate()
	spawn_projectile(player, projectile)
