extends SpellBase

const PROJECTILE = preload("res://scenes/projectiles/fish.tscn")

func cast(player: CharacterBody2D, _enemies: Array[Node]):
	var projectile = PROJECTILE.instantiate()
	spawn_projectile(player, projectile)
	var status = player.status
	status.visible = true
