extends Node2D


var full_vida = 20
var vida

func _ready():
	vida = full_vida


func attack(tirada):
	$bubble.set_number(tirada)
	$bubble.appear()

func end_attack():
	$bubble.disapear()


func damage(damage):
	vida -= damage
	var porcentage = (float(vida)/float(full_vida))*100.0
	$lifebar.value = porcentage
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("damage")

func curar(puntos):
	vida += puntos
	if vida > full_vida:
		vida = full_vida
	var porcentage = (float(vida)/float(full_vida))*100.0
	$lifebar.value = porcentage
	$AnimationPlayer.play("curar")
	$vida.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "damage":
		$AnimationPlayer.play("idle")
