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
	for i in range(0,20):
		var num = randi() % 12 + 1
		$bubble.set_number(num)
		yield(get_tree().create_timer(0.05), "timeout")



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
