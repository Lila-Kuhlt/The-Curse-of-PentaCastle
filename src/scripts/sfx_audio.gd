extends AudioStreamPlayer

enum Sound {
	CHEST,
	DRAW,
	DRAW_INVALID,
	DRAW_SHORT,
	HIT,
	STEP_DROP,
	STEP,
	UNICORN_CHARGE,
	PUSH_BACK,
	STOEHN,
	PORTAL,
	FISH
}

const SoundDict = {
	Sound.CHEST: preload("res://assets/sfx/chest.mp3"),
	Sound.DRAW: preload("res://assets/sfx/draw.mp3"),
	Sound.DRAW_INVALID: preload("res://assets/sfx/draw_invalid_spell.mp3"),
	Sound.DRAW_SHORT: preload("res://assets/sfx/draw_short.mp3"),
	Sound.HIT: preload("res://assets/sfx/hit.mp3"),
	Sound.STEP_DROP: preload("res://assets/sfx/step_drop.mp3"),
	Sound.STEP: preload("res://assets/sfx/step_light.mp3"),
	Sound.UNICORN_CHARGE: preload("res://assets/sfx/unicorn_charge.mp3"),
	Sound.PUSH_BACK: preload("res://assets/sfx/wind_spell.mp3"),
	Sound.STOEHN: preload("res://assets/sfx/stoehn.mp3"),
	Sound.PORTAL: preload("res://assets/sfx/portal.wav"),
	Sound.FISH: preload("res://assets/sfx/fish_attack.wav")
}

func _ready():
	max_polyphony = 6

func play_sfx(sound: Sound):
	stream = SoundDict.get(sound)
	play()
