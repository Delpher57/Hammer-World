extends Node2D


export var num_enemies = 3

#array de enemigos
var Enemy = preload("res://enemy/enemy.tscn")
var enemies = []

#jugador
onready var player = $player

func _ready():
	var last_pos = $enemy_start_pos.position
	for i in range(0,num_enemies):
		var enemy = Enemy.instance()
		add_child(enemy)
		enemy.position = last_pos
		last_pos.x += 127 + 10 #tamaño + margen
		enemies.append(enemy)


func randomize_bubble():
	var last_pos = $enemy_start_pos.position
	for i in range(0,20):
		var num = randi() % 12 + 1
		$bubble.set_number(num)
		yield(get_tree().create_timer(0.05), "timeout")


func move_enemies():
	var last_pos = $enemy_start_pos.position
	for i in enemies:
		$Tween.interpolate_property(i, "position",
				i.position, last_pos, 1,
				Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
		last_pos.x += 127 + 10 #tamaño + margen
		


#inicia un turno luego de seleccionar una carta
func turno(carta):
	player.attack(carta.puntos)
	yield(get_tree().create_timer(0.2), "timeout")
	var enemy_roll = enemies[0].attack()
	yield(get_tree().create_timer(0.5), "timeout")
	$bubble.appear()
	randomize_bubble()
	yield(get_tree().create_timer(1.1), "timeout")
	var diferencia = carta.puntos - enemy_roll
	$bubble.set_number(abs(diferencia))
	yield(get_tree().create_timer(0.7), "timeout")
	
	#gana el enemigo
	if diferencia < 0:
		$AnimationPlayer.play("player")
		yield(get_tree().create_timer(0.3), "timeout")
		player.damage(abs(diferencia))
		yield(get_tree().create_timer(0.1), "timeout")
		enemies[0].end_attack()
		
	#gana el jugador
	elif diferencia > 0:
		$AnimationPlayer.play("enemy")
		yield(get_tree().create_timer(0.3), "timeout")
		enemies[0].damage(abs(diferencia))
		if enemies[0].vida <= 0:
			enemies[0].die()
			yield(get_tree().create_timer(0.5), "timeout")
			enemies.pop_front()
			move_enemies()
			yield(get_tree().create_timer(0.1), "timeout")
			player.end_attack()
	
	if enemies[0].vida > 0 and player.vida > 0:
		yield(get_tree().create_timer(0.1), "timeout")
		player.end_attack()
		enemies[0].end_attack()
		$bubble.disapear()
	
	



