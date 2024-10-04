extends Node2D

onready var timer = $CoinDurationTimer #Controle da vida da moeda

onready var sprite_coin = $coin
onready var sprite_sombra = $Shadow
onready var tween = $Tween # Tween para controlar a animação do salto

# Variáveis para controlar a flutuação
var float_amplitude = 5 # Altura da flutuação
var float_speed = 2 # Velocidade da flutuação
var initial_y_position = 0



func _ready():
	add_to_group("coins")
	initial_y_position = sprite_coin.position.y
	# Iniciar o salto ao drop
	start_bounce()
	# Iniciar o efeito de flutuação
	#start_floating()
	#$CoinDurationTimer.start()
	timer.start()


func _on_CoinDurationTimer_timeout():
	Global.coins += 1
	queue_free()
	
	# Função para criar o efeito de salto ao dropar
func start_bounce():
	# Altura inicial do salto e a "gravidade" (quanto ela cai)
	var bounce_height = 50
	var bounce_duration = 0.4

	# Subir a moeda simulando o salto
	tween.interpolate_property(
		sprite_coin, "position:y",
		sprite_coin.position.y, sprite_coin.position.y - bounce_height,
		bounce_duration, Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	
	# Quicar para baixo após o salto
	tween.interpolate_property(
		sprite_coin, "position:y",
		sprite_coin.position.y - bounce_height, initial_y_position,
		bounce_duration, Tween.TRANS_BOUNCE, Tween.EASE_IN
	)

	tween.start()

# Função para o efeito de flutuação após o salto
func start_floating():
	# Atualizar a posição da moeda para flutuar
	set_process(true) # Ativa o _process()

# Função chamada em cada frame para criar a flutuação
func _process(_delta):
	var float_offset = sin(OS.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude
	sprite_coin.position.y = initial_y_position + float_offset
