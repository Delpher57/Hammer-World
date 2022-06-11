extends Node2D


export var vida = 20


func attack(tirada):
	$bubble.set_number(tirada)
	$bubble.appear()

func end_attack():
	$bubble.disapear()
