extends SpellBase

const Fish = preload("res://scenes/projectiles/fish.tscn")

func cast(player: CharacterBody2D, _enemies: Array[Node]):
	spawn_projectile(player, Fish.instantiate())
	# TODO: status effects
	# var idx = SpellBook.Spells.FISH
	# var status = player.status
	# status.visible = true
