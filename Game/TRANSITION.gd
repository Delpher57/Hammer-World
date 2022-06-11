extends Node

onready var animation = $AnimationPlayer

signal transition_finished(anim_name)

func fade_in():
	animation.play("fade-in")

func fade_out():
	animation.play("fade-out")



func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("transition_finished",anim_name)
