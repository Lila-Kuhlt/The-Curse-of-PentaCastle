class_name SpellItemBase extends Node2D

var cast := '6'
var title := "PLACEHOLDER"
var desc := "PLACEHOLDER"
var duration := 0.0 # only for passive spells (in seconds)
var spell: SpellBook.Spells = SpellBook.Spells.PLACEHOLDER
var type: SpellBook.SpellType = SpellBook.SpellType.PASSIVE
var rank: SpellBook.SpellRank = SpellBook.SpellRank.COMMON

@onready var sprite := $Sprite
@onready var title_label: Label = $Title

func _ready():
	set_title()
	set_sprite()

func set_sprite():
	sprite.texture = SpellBook.spell_item_sprites[spell]

func set_title():
	title_label.text = title
