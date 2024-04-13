class_name SpellItemBase extends Node2D

var cast := '6'
var title := "PLACEHOLDER"
var desc := "PLACEHOLDER"
var spell: SpellBook.Spells = SpellBook.Spells.PLACEHOLDER

@onready var sprite := $Sprite
@onready var title_label: Label = $Title

func _ready():
	set_title()

func set_sprite(_spell: SpellBook.Spells):
	sprite.texture = SpellBook.get_spell_item_sprite(_spell)

func set_title():
	title_label.text = title
