extends Node2D

#array de 4 valores, va a tener las cartas del usuario
var mazo_cartas = []

#mazos con cartas de cada tipo
var cartas_verdes = []
var cartas_rojas = []
var cartas_azules = []
var cartas_moradas = []
var cartas_legendarias = []

#escena de la carta
var Carta = preload("res://cards/Card.tscn")

#referencias a nodos
onready var cards_node = $cards

#se encarga de rellenar los valores internos de las cartas
func inicializar_carta(nombre, textura, puntos, healing, full_damage):
	var carta = {
	"nombre": "",
	"textura": "",
	"puntos": 0, "healing": 0,
	"fulldamage": 0}
	
	carta.nombre = nombre
	carta.textura = textura
	carta.puntos = puntos
	carta.healing = healing
	carta.fulldamage = full_damage
	return carta


#inicializamos las cartas
# y las guardamos en un array con su propio tipo
func rellenar_cartas():
	#verdes
	var palito = inicializar_carta("palito",
									"res://assets/sprites/cards/palito.png",
									1,
									0,
									0)
	var pequenno = inicializar_carta("pequenno",
									"res://assets/sprites/cards/pequenno.png",
									2,
									0,
									0)
	var madera = inicializar_carta("madera",
									"res://assets/sprites/cards/madera.png",
									2,
									0,
									0)
	var piedra = inicializar_carta("piedra",
									"res://assets/sprites/cards/piedra.png",
									3,
									0,
									0)
	var carpintero = inicializar_carta("carpintero",
									"res://assets/sprites/cards/carpintero.png",
									4,
									0,
									0)

	cartas_verdes = [palito,pequenno,madera,piedra,carpintero]

	#rojos
	var batalla = inicializar_carta("batalla",
									"res://assets/sprites/cards/batalla.png",
									5,
									0,
									0)
	var guardia = inicializar_carta("guardia",
									"res://assets/sprites/cards/guardia.png",
									6,
									0,
									0)
	var atomico = inicializar_carta("atomico",
									"res://assets/sprites/cards/atomico.png",
									6,
									-4,
									0)
	var ss = inicializar_carta("ss",
									"res://assets/sprites/cards/ss.png",
									7,
									0,
									0)

	cartas_rojas = [batalla,guardia,atomico,ss]

	#azules
	var cosmico = inicializar_carta("cosmico",
									"res://assets/sprites/cards/cosmico.png",
									7,
									0,
									1)
	var real = inicializar_carta("real",
									"res://assets/sprites/cards/real.png",
									8,
									0,
									0)
	var curativo = inicializar_carta("curativo",
									"res://assets/sprites/cards/curativo.png",
									7,
									2,
									0)

	cartas_azules = [cosmico,real,curativo]

	#morados
	var chapulin = inicializar_carta("chapulin",
									"res://assets/sprites/cards/Chapulin.png",
									9,
									0,
									3)
	var dracula = inicializar_carta("dracula",
									"res://assets/sprites/cards/absorber.png",
									8,
									5,
									0)
	var thor = inicializar_carta("thor",
									"res://assets/sprites/cards/thor.png",
									9,
									0,
									5)

	cartas_moradas = [chapulin,dracula,thor]

	#legendarios
	var milagro = inicializar_carta("milagro",
									"res://assets/sprites/cards/milagro.png",
									12,
									15,
									0)
	var zeus = inicializar_carta("zeus",
									"res://assets/sprites/cards/Zeus.png",
									12,
									0,
									10)

	cartas_legendarias = [milagro,zeus]

#obtenemos una carta aleatoria
func get_carta():
	
	#probabilidades de obtener cada tipo de carta
	var prob_verde = [0,40]
	var prob_rojo = [40,65]
	var prob_azul = [65,80]
	var prob_morado = [80,95]
	var prob_leg = [95,100]
	
	randomize()
	var porcentage = rand_range(0,100)
	var carta
	
	#carta verde
	if prob_verde[0] <= porcentage and porcentage < prob_verde[1]:
		carta = cartas_verdes[randi() % cartas_verdes.size()]
	
	elif prob_rojo[0] <= porcentage and porcentage < prob_rojo[1]:
		carta = cartas_rojas[randi() % cartas_rojas.size()]
	
	elif prob_azul[0] <= porcentage and porcentage < prob_azul[1]:
		carta = cartas_azules[randi() % cartas_azules.size()]
	
	elif prob_morado[0] <= porcentage and porcentage < prob_morado[1]:
		carta = cartas_moradas[randi() % cartas_moradas.size()]
	
	else:
		carta = cartas_legendarias[randi() % cartas_legendarias.size()]
	
	return carta

func update_cards(mazo):
	#limpiamos las cartas en caso de reiniciar
	for n in cards_node.get_children():
		if n.name != "Position2D" and n.name != "mazo":
			cards_node.remove_child(n)
			n.queue_free()
	var last_position = cards_node.get_node("Position2D").global_position
	for i in mazo:
		var carta = Carta.instance()
		print(i)
		carta.card_texture = i.textura
		cards_node.add_child(carta)
		carta.global_position = last_position
		last_position.x += carta.textura.rect_size.x + 23 #ancho + espacing


func _ready():
	rellenar_cartas()
	#rellenamos el mazo con 4 cartas
	mazo_cartas = [get_carta(),get_carta(),get_carta(),get_carta()]
	update_cards(mazo_cartas)



func _on_textura_pressed():
	mazo_cartas = [get_carta(),get_carta(),get_carta(),get_carta()]
	update_cards(mazo_cartas)
