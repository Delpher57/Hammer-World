extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	hide()

func noice(scene):
	show()
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().change_scene(scene)
