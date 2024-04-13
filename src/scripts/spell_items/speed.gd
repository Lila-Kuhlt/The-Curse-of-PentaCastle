extends SpellItemBase

func _init():
	spell = SpellBook.Spells.SPEED
	title = "Speed"
	desc = "20% increase in speed and jump for 10 seconds"
	cast = "1401"

func _ready():
	set_title()
	set_sprite(spell)
