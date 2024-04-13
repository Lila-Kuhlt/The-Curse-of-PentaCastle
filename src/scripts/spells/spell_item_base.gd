class_name SpellItemBase extends Node2D

var cast := '6'
var title := "PLACEHOLDER"
var desc := "PLACEHOLDER"
var spell_id: int = -1

@onready var sprite := $Sprite
@onready var title_label: Label = $Title

func _ready():
	set_title()

func set_sprite(path: String):
	sprite.texture = load('res://assets/spellitems/' + path)

func set_title():
	title_label.text = title
