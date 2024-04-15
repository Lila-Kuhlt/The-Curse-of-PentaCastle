extends SpellBase

var Pushback_Projectile = preload("res://scenes/projectiles/pushback.tscn")

func cast(player: Player, _enemies: Array[Node]):
	SfxAudio.play_sfx(SfxAudio.Sound.PUSH_BACK)
	var projectile = Pushback_Projectile.instantiate()
	spawn_projectile(player, projectile)
