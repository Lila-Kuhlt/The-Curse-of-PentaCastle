extends SpellBase

const BASE_DAMAGE := 2.0

var timer: Timer

func cast(player: Player, enemies: Array[Node]):
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(_time_out.bind(player, enemies))
	player.add_child(timer)
	timer.start()

func _time_out(player: Player, enemies: Array[Node]):
	for enemy in enemies:
		if enemy != null:
			enemy.take_damage(BASE_DAMAGE * player.damage_multiplier)

func uncast(_player: Player, _enemies: Array[Node]):
	timer.queue_free()
