class_name SpellSpeed extends Node

var speed_diff = 0.0

func cast(player: CharacterBody2D):
	speed_diff = player.MAX_SPEED
	player.MAX_SPEED *= 2
	speed_diff = player.MAX_SPEED - speed_diff

func uncast(player: CharacterBody2D):
	player.MAX_SPEED -= speed_diff
