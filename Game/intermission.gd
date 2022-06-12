extends Node2D

export(String, FILE) var next_level = ""

func _ready():
	$Tween.interpolate_property($AudioStreamPlayer, "volume_db",
		-50, -5, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	Transition.connect("transition_finished", self, "transition_finished")
	Transition.fade_out()
	yield(get_tree().create_timer(rand_range(5,10)), "timeout")
	Transition.fade_in()
	$Tween.interpolate_property($AudioStreamPlayer, "volume_db",
		-5, -50, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func transition_finished(anim_name):
	if anim_name == "fade-in":
		# warning-ignore:return_value_discarded
		get_tree().change_scene(next_level)
