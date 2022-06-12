extends Node2D


export var num_enemies = 3
export var enemy_dificulty = 0

#array de enemigos
var Enemy = preload("res://enemy/enemy.tscn")
var enemies = []

#jugador
onready var player = $player

#cuando no hay nadie más vivo
signal end_of_game(type) #type es "win" o "lose"

func _ready():
	var last_pos = $enemy_start_pos.position
	for i in range(0,num_enemies):
		var enemy = Enemy.instance()
		add_child(enemy)
		enemy.position = last_pos
		enemy.dificultad = enemy_dificulty
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
	if enemies.size() > 0:
		for i in enemies:
			if i != null:
				$Tween.interpolate_property(i, "position",
						i.position, last_pos, 1,
						Tween.TRANS_EXPO, Tween.EASE_OUT)
				$Tween.start()
				last_pos.x += 127 + 10 #tamaño + margen
		


#inicia un turno luego de seleccionar una carta
func turno(carta):
	
	player.attack(carta.puntos)
	yield(get_tree().create_timer(0.2), "timeout")
	var enemy_roll
	if enemies.size() != 0: enemy_roll = enemies[0].attack()
	else: enemy_roll = 0
	yield(get_tree().create_timer(0.5), "timeout")
	$bubble.appear()
	randomize_bubble()
	yield(get_tree().create_timer(1.1), "timeout")
	var diferencia = carta.puntos - enemy_roll
	#bonus de carta real
	if carta.nombre == "real" and (player.vida/player.full_vida) < 0.25:
		diferencia+=1
	$bubble.set_number(abs(diferencia))
	yield(get_tree().create_timer(0.7), "timeout")
	
	#le quitamos todo el daño a la carta curativa
	if carta.nombre == "curativo" and diferencia > 0:
		diferencia = 0
	
	if carta.healing != 0:
		player.curar(carta.healing)
	
	#carta atomica, 30% de prob de lastimarse
	if carta.nombre == "atomico":
		randomize()
		var porcentage = rand_range(0,100)
		if porcentage < 30:
			player.damage(3)
	
	
	#gana el enemigo
	if diferencia < 0:
		$AnimationPlayer.play("player")
		yield(get_tree().create_timer(0.3), "timeout")
		player.damage(abs(diferencia))
		yield(get_tree().create_timer(0.1), "timeout")
		
		
	#gana el jugador
	elif diferencia > 0 and enemies.size() != 0:
		$AnimationPlayer.play("enemy")
		yield(get_tree().create_timer(0.3), "timeout")
		enemies[0].damage(abs(diferencia))
		if enemies[0].vida <= 0:
			enemies[0].die()
			yield(get_tree().create_timer(0.5), "timeout")
			enemies.pop_front()
			move_enemies()
			yield(get_tree().create_timer(0.1), "timeout")
			
	#manejamos el daño multiple
	if carta.fulldamage != 0:
		var primera_vez = true
		var deads = []
		var index = 0
		for i in enemies:
			if !primera_vez:
				i.damage(carta.fulldamage)
				if i.vida <= 0:
					deads.append([i,index])
			primera_vez = false
		for i in deads:
			enemies.pop_at(i[1])
			i[0].die()
			yield(get_tree().create_timer(0.5), "timeout")
			move_enemies()
			yield(get_tree().create_timer(0.1), "timeout")
	
	
	yield(get_tree().create_timer(0.1), "timeout")
	if player.vida > 0: player.end_attack()
	if enemies.size() > 0:
		if enemies[0].vida > 0: enemies[0].end_attack()
	
	if enemies.size() == 0:
		emit_signal("end_of_game","win")
	if player.vida <= 0:
		emit_signal("end_of_game","lose")
	
	$bubble.disapear()
	
	



