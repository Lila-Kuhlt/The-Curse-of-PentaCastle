extends Area2D

func _on_body_entered(_body):
	get_tree().get_first_node_in_group("world").new_room()
