extends Node2D

var activa = false

func set_number(num):
	$Node2D/Label.text = str(num)

func appear():
	$AnimationPlayer.play("appear")
	activa = true

func disapear():
	$AnimationPlayer.play("disapear")
	activa = false
