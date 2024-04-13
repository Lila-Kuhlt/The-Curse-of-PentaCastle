extends Node2D

const cast := '6'
const title := "PLACEHOLDER"
const desc := "PLACEHOLDER"
const spell: Node2D = null

@onready var sprite := $Sprite
@onready var title_label: Label = $Title

func _ready():
	title_label.text = title

func set_sprite(path: String):
	sprite.texture = load(path)
