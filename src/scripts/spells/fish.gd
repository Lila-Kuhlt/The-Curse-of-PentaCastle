extends SpellBase

var Projectile = preload("res://scenes/projectiles/fish.tscn")

func cast(player: CharacterBody2D, _enemies: Array[Node]):
	var projectile = Projectile.instantiate()
	spawn_projectile(player, projectile)
	# TODO: status effects
	# var idx = SpellBook.Spells.FISH
	# var status = player.status
	# status.visible = true
