extends SpellBase

var effect_count
var timer

func cast(_player: CharacterBody2D, enemies: Array[Node]):
	var spell_idx = SpellBook.Spells.RAIN_OF_BLOOD
	var spell_item_script = SpellBook.spell_item_scripts[spell_idx].new()
	var duration = spell_item_script.duration
	effect_count = duration

	timer = Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(time_out.bind(enemies))
	_player.add_child(timer)
	timer.start()

func time_out(enemies: Array[Node]):
	if effect_count <= 0: timer.queue_free()
	for enemy in enemies:
		enemy.take_damage(2.0)
	effect_count -= 1
