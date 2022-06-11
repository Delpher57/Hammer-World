extends Node2D

func _ready():
	Transition.connect("transition_finished", self, "transition_finished")

func _on_TextureButton_pressed():
	$Tween.interpolate_property($music, "volume_db",
		-5, -50, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	Transition.fade_in()

func transition_finished(anim_name):
	if anim_name == "fade-in":
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://cards/CardManager.tscn")
