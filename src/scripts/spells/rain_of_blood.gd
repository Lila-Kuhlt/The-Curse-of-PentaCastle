extends SpellBase

const DAMAGE_PER_SECOND := 2.0

var timer: Timer

func cast(player: Player, enemies: Array[Node]):
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(_time_out.bind(enemies))
	player.add_child(timer)
	timer.start()

func _time_out(enemies: Array[Node]):
	for enemy in enemies:
		if enemy != null:
			enemy.take_damage(DAMAGE_PER_SECOND)

func uncast(_player: Player, _enemies: Array[Node]):
	timer.queue_free()
