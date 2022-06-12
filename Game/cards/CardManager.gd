extends Node2D

export(String, FILE) var next_level = ""

#array de 4 valores, va a tener las cartas del usuario
var mazo_cartas = []
var cuenta_pedir = 0
var maximo_pedir = 5

#mazos con cartas de cada tipo
var cartas_verdes = []
var cartas_rojas = []
var cartas_azules = []
var cartas_moradas = []
var cartas_legendarias = []

#escena de la carta
var Carta = preload("res://cards/Card.tscn")
var primera_vez = true

#id para identificar cartas
var last_id = 1

var in_turno = false
#referencias a nodos
onready var cards_node = $cards
onready var tween = $Tween
onready var battle_manager = $BattleManager

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

func get_unique_card(template):
	var carta = {
	"nombre": "",
	"textura": "",
	"puntos": 0, "healing": 0,
	"fulldamage": 0}
	
	carta.nombre = template.nombre
	carta.textura = template.textura
	carta.puntos = template.puntos
	carta.healing = template.healing
	carta.fulldamage = template.fulldamage
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
									0,
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
									7)

	cartas_legendarias = [milagro,zeus]

#obtenemos un id nuevo unico para la carta
func get_id():
	var id = last_id +2
	last_id = id
	return id

#obtenemos una carta aleatoria
func get_carta():
	
	#probabilidades de obtener cada tipo de carta
	var prob_verde = [0,40]
	var prob_rojo = [40,60]
	var prob_azul = [60,85]
	var prob_morado = [85,95]
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
	
	carta = get_unique_card(carta)
	carta.id = get_id()
	return carta

func update_cards(mazo):

	
	var last_position = cards_node.get_node("Position2D").global_position
	#iteramos por todas las cartas
	var debug = []
	for i in mazo:
		debug.push_back(i.id)
		#verificamos si el nodo de esa carta ya existe, si no la creamos
		var carta = get_card_node(i.id)
		if carta == null:
			carta = Carta.instance()
			carta.card_texture = i.textura
			carta.id = i.id
			cards_node.add_child(carta)
			#que la posicion inicial sea dentro del maso
			carta.global_position = cards_node.get_node("mazo").rect_position
			carta.connect("click_carta", self, "click_carta")
		
		
		#movemos las cartas
		if primera_vez:
			carta.global_position = last_position
		else:
			$Tween.interpolate_property(carta, "global_position",
				carta.global_position, last_position, 1,
				Tween.TRANS_EXPO, Tween.EASE_OUT)
			$Tween.start()
			$sound.play()
		last_position.x += carta.textura.rect_size.x + 23 #ancho + espacing
	primera_vez = false
	print(debug)

#obtenemos el nodo de una carta
func get_card_node(id):
	for n in cards_node.get_children():
		if n.name != "Position2D" and n.name != "mazo":
			if n.id == id:
				return n
	return null

func disable_cards():
	for n in cards_node.get_children():
		if n.name != "Position2D" and n.name != "mazo":
			n.enabled = false

func enable_cards():
	for n in cards_node.get_children():
		if n.name != "Position2D" and n.name != "mazo":
			n.enabled = true

func find_card_by_id(id):
	var index = 0
	for carta in mazo_cartas:
		if carta.id == id:
			return index
		index += 1

func click_carta(id):
	if !in_turno:
		in_turno = true
		disable_cards()
		var card_index = find_card_by_id(id)
		var carta = mazo_cartas[card_index] #carta que seleccionamos
		
		battle_manager.turno(carta)
		
		yield(get_tree().create_timer(1), "timeout")
		#quitamos la carta de los nodos
		var card_node = get_card_node(id)
		if card_node != null:
			cards_node.remove_child(card_node)
			card_node.queue_free()
		
		#la sacamos del mazo y metemos una nueva
		mazo_cartas.pop_at(card_index)
		mazo_cartas.push_back(get_carta())
		update_cards(mazo_cartas)
		yield(get_tree().create_timer(1.5), "timeout")
		enable_cards()
		in_turno = false

func end_of_game(type):
	if type == "win":
		$noice.noice(next_level)
	elif type == "lose":
		$noice.noice("res://menu.tscn")

func _ready():
	Transition.fade_out()
	rellenar_cartas()
	#rellenamos el mazo con 4 cartas
	mazo_cartas = [get_carta(),get_carta(),get_carta(),get_carta()]
	update_cards(mazo_cartas)
	enable_cards()
	
	battle_manager.connect("end_of_game", self, "end_of_game")



#pedir carta
func _on_textura_pressed():
	if cuenta_pedir <= maximo_pedir and !in_turno:
		randomize()
		var id = mazo_cartas[randi() % mazo_cartas.size()].id
		var card_index = find_card_by_id(id)
		var card_node = get_card_node(id)
		if card_node != null:
			cards_node.remove_child(card_node)
			card_node.queue_free()
		
		#la sacamos del mazo y metemos una nueva
		mazo_cartas.pop_at(card_index)
		mazo_cartas.push_back(get_carta())
		cuenta_pedir += 1
		
		
		update_cards(mazo_cartas)
		enable_cards()
