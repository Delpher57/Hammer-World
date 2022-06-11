extends Node2D



var full_vida = 20
var vida
var dificultad = 0 #valor minimo que puede sacar en una tirada

#texturas de la cara
var pics = []




func roll_attack():
	randomize()
	var roll = int(round(rand_range(1+ dificultad/2,7 + dificultad))) 
	return roll

func _ready():
	vida = full_vida
	
	var path = "res://assets/sprites/enemigos/caras/"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			#break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
		#if !file_name.ends_with(".import"):
			pics.append(load(path + "/" + file_name))
	dir.list_dir_end()
	
	$cara.texture = pics[randi() % pics.size()]
	
	yield(get_tree().create_timer(rand_range(0,1)), "timeout")
	$AnimationPlayer.play("idle")
	$lifebar.value = 100

func attack():
	var tirada = roll_attack()
	$bubble.set_number(tirada)
	$bubble.appear()
	return tirada

func end_attack():
	$bubble.disapear()

func damage(damage):
	vida -= damage
	var porcentage = (float(vida)/float(full_vida))*100.0
	$lifebar.value = porcentage
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("damage")
	

func die():
	$AnimationPlayer.play("die")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "damage":
		$AnimationPlayer.play("idle")
