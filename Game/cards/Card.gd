extends Node2D

#maneja la textura de la carta
export(String, FILE, "*.png") var card_texture = "res://assets/sprites/cards/absorber.png"

var pressed = false
var id = 0
var enabled = false #si se permite hacer click o no
#referencias a nodos
onready var textura = $textura
onready var animator = $AnimationPlayer
onready var audio = $AudioStreamPlayer

signal click_carta(id)

#sonidos
var shove1 = preload("res://assets/sound/cards/cardShove1.wav")
var shove2 = preload("res://assets/sound/cards/cardShove2.wav")
var shove3 = preload("res://assets/sound/cards/cardShove3.wav")
var shove4 = preload("res://assets/sound/cards/cardShove4.wav")
var shove_sounds = [shove1,shove2,shove3,shove4]

var place1 = preload("res://assets/sound/cards/cardPlace1.wav")
var place2 = preload("res://assets/sound/cards/cardPlace2.wav")
var place3 = preload("res://assets/sound/cards/cardPlace3.wav")
var place4 = preload("res://assets/sound/cards/cardPlace4.wav")
var place_sounds = [place1,place2,place3,place4]


func _ready():
	randomize()
	textura.texture_normal = load(card_texture)
	


func _on_textura_mouse_entered():
	if !pressed:
		audio.stream = shove_sounds[randi() % shove_sounds.size()]
		audio.volume_db = 0
		audio.play()
		animator.play("elevate")


func _on_textura_mouse_exited():
	if !pressed:
		audio.stream = shove_sounds[randi() % shove_sounds.size()]
		audio.volume_db = -10
		audio.play()
		animator.play("down")


func _on_textura_pressed():
	if !pressed and enabled:
		audio.stream = place_sounds[randi() % place_sounds.size()]
		audio.volume_db = 10
		audio.play()
		animator.play("play")
		pressed = true
		


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "play":
		emit_signal("click_carta",id)
	
