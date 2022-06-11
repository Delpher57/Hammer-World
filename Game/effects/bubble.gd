extends Node2D


func set_number(num):
	$Node2D/Label.text = str(num)

func appear():
	$AnimationPlayer.play("appear")

func disapear():
	$AnimationPlayer.play("disapear")
