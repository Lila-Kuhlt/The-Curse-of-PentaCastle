extends Area2D

func disable():
	$CollisionShape2D.disabled = true
	modulate *= 0.5

func enable():
	$CollisionShape2D.disabled = false
	modulate *= 2

func _on_body_entered(_body):
	get_tree().get_first_node_in_group("world").new_room()
