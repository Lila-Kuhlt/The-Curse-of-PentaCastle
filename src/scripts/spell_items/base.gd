class_name SpellItemBase extends Node2D

var cast: Array[int] = [6]
var title := "PLACEHOLDER"
var desc := "PLACEHOLDER"
var duration := 0.0 # only for passive spells (in seconds)
var spell: SpellBook.Spells = SpellBook.Spells.PLACEHOLDER
var type: SpellBook.SpellType = SpellBook.SpellType.PASSIVE
var rank: SpellBook.SpellRank = SpellBook.SpellRank.COMMON
var sprite := preload("res://assets/spell_items/placeholder.png")

func _ready():
	set_title()
	set_sprite()

func set_sprite():
	$Sprite.texture = sprite

func set_title():
	$Title.text = title
