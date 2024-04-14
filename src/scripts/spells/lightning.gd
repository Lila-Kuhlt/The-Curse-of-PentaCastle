extends SpellBase

const Lightning = preload("res://scenes/projectiles/lightning.tscn")

func cast(player: Player, _enemies: Array[Node]):
	spawn_projectile(player, Lightning.instantiate())
