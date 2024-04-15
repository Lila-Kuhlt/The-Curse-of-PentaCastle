extends SpellBase

const Fish = preload("res://scenes/projectiles/fish.tscn")

func cast(player: CharacterBody2D, _enemies: Array[Node]):
	spawn_projectile(player, Fish.instantiate())
	SfxAudio.play_sfx(SfxAudio.Sound.FISH)

