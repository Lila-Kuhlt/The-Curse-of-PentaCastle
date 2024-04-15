extends Enemy

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

func _on_hit_collider_body_entered(body):
	hit_player(body)
