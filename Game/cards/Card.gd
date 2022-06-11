extends Node2D

#maneja la textura de la carta
export(String, FILE, "*.png") var card_texture = "res://assets/sprites/cards/absorber.png"


#referencias a nodos
onready var textura = $textura
onready var animator = $AnimationPlayer
onready var audio = $AudioStreamPlayer

#sonidos
var shove1 = preload("res://assets/sound/cards/cardShove1.wav")
var shove2 = preload("res://assets/sound/cards/cardShove2.wav")
var shove3 = preload("res://assets/sound/cards/cardShove3.wav")
var shove4 = preload("res://assets/sound/cards/cardShove4.wav")
var shove_sounds = [shove1,shove2,shove3,shove4]

func _ready():
	randomize()
	textura.texture_normal = load(card_texture)
	


func _on_textura_mouse_entered():
	audio.stream = shove_sounds[randi() % shove_sounds.size()]
	audio.volume_db = 0
	audio.play()
	animator.play("elevate")


func _on_textura_mouse_exited():
	audio.stream = shove_sounds[randi() % shove_sounds.size()]
	audio.volume_db = -10
	audio.play()
	animator.play("down")
