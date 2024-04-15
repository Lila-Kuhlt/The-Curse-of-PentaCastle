extends SpellBase

const PushbackProjectile = preload("res://scenes/projectiles/pushback.tscn")

func cast(player: Player, _enemies: Array[Node]):
	SfxAudio.play_sfx(SfxAudio.Sound.PUSH_BACK)
	spawn_projectile(player, PushbackProjectile.instantiate())
