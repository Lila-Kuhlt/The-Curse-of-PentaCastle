extends Area2D

func disable():
	$CollisionShape2D.disabled = true
	modulate *= 0.5

func enable():
	$CollisionShape2D.disabled = false
	modulate *= 2

func _on_body_entered(_body):
	var score = get_parent().score
	var world = get_tree().get_first_node_in_group("world")
	world.add_score(score)
	world.new_room()
