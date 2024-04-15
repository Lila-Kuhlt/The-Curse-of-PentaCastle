extends Label

const SPEED: float = 70.0
const ALPHA_COOLDOWN := 1.2
var alpha_cooldown := 0.0

func start(score: int) -> void:
	position = Vector2(0, 0)
	text = '+' + str(score)
	visible = true
	alpha_cooldown = ALPHA_COOLDOWN
	modulate.a = 1.0

func _process(delta: float) -> void:
	if visible:
		position.y += delta * SPEED
		alpha_cooldown -= delta
		if alpha_cooldown <= 0.0:
			visible = false
			return
		modulate.a = min(alpha_cooldown, 1.0)
