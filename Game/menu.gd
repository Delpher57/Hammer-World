extends Node2D



func _on_TextureButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://cards/CardManager.tscn")
