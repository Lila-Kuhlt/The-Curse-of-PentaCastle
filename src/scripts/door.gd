extends Area2D

func disable():
	$CollisionShape2D.disabled = true
	modulate *= 0.5

func enable():
	if $CollisionShape2D.disabled:
		$CollisionShape2D.disabled = false
		modulate *= 2

func _on_body_entered(_body):
	SfxAudio.play_sfx(SfxAudio.Sound.PORTAL)
	var player = _body as Player
	player.heal(player.HEAL_ON_ROOM_CHANGE)
	var score = get_parent().score
	var world = get_tree().get_first_node_in_group("world")
	world.add_score(score)
	world.new_room()
