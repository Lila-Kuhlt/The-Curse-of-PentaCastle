extends SpellItemBase

func _ready():
	spell = SpellBook.Spells.SPEED
	title = "Speed"
	desc = "20% increase in speed and jump for 10 seconds"
	cast = "0140"
	set_title()
	set_sprite(spell)
