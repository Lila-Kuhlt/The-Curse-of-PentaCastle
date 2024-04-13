extends SpellItemBase

func _ready():
	spell_id = 0
	title = "Speed"
	desc = "20% increase in speed and jump for 10 seconds"
	cast = "0140"
	set_title()
	set_sprite('speed.png')

