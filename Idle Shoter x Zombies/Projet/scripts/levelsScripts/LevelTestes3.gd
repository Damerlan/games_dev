extends Node2D

# Controle de turnos
var current_turn = 1 # Turno inicial
var zombies_per_turn = 5 # Zumbis por turno
var boss_spawned = false # Flag do boss

var zombies_spawned = 0 # Zumbis spawnados no turno atual
var zombies_killed = 0 # Zumbis mortos no turno atual

# Referências aos timers
onready var ZombieSpawnTimer = $ZombieSpawnTimer
onready var TurnIntervalTimer = $TurnIntervalTimer

# Carregue as cenas de zumbis no início do script
var EnemyBase = preload("res://Scenes/Enemy.tscn")
var ZombieTank = preload("res://Scenes/Golias.tscn")
var ZombieFast = preload("res://Scenes/Flash.tscn")
var ZombieBoss = preload("res://Scenes/jake.tscn")


# Outras variáveis do jogo
onready var score_label = $ScoreLabel
onready var zombi_label = $ZombiConunt
onready var zombi_label2 = $ZombiConunt2

func _ready():
	ZombieSpawnTimer.connect("timeout", self, "_on_ZombieSpawnTimer_timeout")
	start_new_turn()

func _process(_delta):
	score_label.text = "Gold: " + str(Global.coins)
	zombi_label.text = "Kills: " + str(Global.zombies_killed)

# Timer para intervalo entre turnos
func _on_TurnIntervalTimer_timeout():
	TurnIntervalTimer.stop()
	start_new_turn()

func _on_ZombieSpawnTimer_timeout():
	if zombies_spawned < zombies_per_turn:
		spawn_zombie()
		zombies_spawned += 1
	else:
		ZombieSpawnTimer.stop()

# Função chamada quando um zumbi é morto
func on_zombie_killed():
	zombies_killed += 1
	Global.increment_global_zombie_kill()
	zombi_label2.text =  "Zumbi morto: " +  str(zombies_killed) + "/" +  str(zombies_per_turn)
	if zombies_killed >= zombies_per_turn:
		end_turn()

# Inicia um novo turno
func start_new_turn():
	zombi_label2.text =  "Iniciando o turno: " +  str(current_turn)  
	zombies_spawned = 0
	zombies_killed = 0
	ZombieSpawnTimer.start()

# Função chamada no final de cada turno para ajustar a dificuldade
func end_turn():
	zombi_label2.text = "Turno " + str(current_turn) + " completo."
	# Atualiza o turno
	current_turn += 1
	# Dobra a quantidade de zumbis por turno (ou ajusta conforme a necessidade)
	zombies_per_turn = int(zombies_per_turn * 2)
	# Reseta o flag do boss para permitir o spawn no próximo turno
	boss_spawned = false
	# Ajusta o timer para o intervalo entre turnos
	ZombieSpawnTimer.stop()
	TurnIntervalTimer.start(5)

# Função para definir a chance de spawn de cada tipo de zumbi
func get_zombie_type(turn):
	var chance = randf() * 100 # Gera um número aleatório entre 0 e 100
	if turn == 1:
		return EnemyBase # Primeiro turno só spawna ZombieBase
	elif chance < 60: # 60% de chance de spawnar ZombieBase
		return EnemyBase
	elif chance < 85: # 25% de chance de spawnar ZombieFast
		return ZombieFast
	else: # 15% de chance de spawnar ZombieTank
		return ZombieTank

# Função para criar o boss
func spawn_boss():
	var boss = ZombieBoss.instance()

	# Atualiza o HP, escala e velocidade do boss com base no turno
	var turn_factor = current_turn
	var helt_factor = 500 + (100 * current_turn)
	boss.health = helt_factor # Aumenta o HP em 100 por turno

	# Ajusta a escala do boss com base no turno, com limite máximo de 8x
	var scale_factor = 1 + (turn_factor * 0.5) # Aumenta 0.5x por turno
	#boss.scale = Vector2(min(scale_factor, 8), min(scale_factor, 8)) # Limita a escala máxima para 8x
	boss.scale_factor = min(scale_factor, 8)

	# Ajusta a velocidade do boss com base no turno
	boss.moveSpeed = 1 + (turn_factor * 0.5) # Aumenta a velocidade em 20 por turno

	# Posiciona o boss aleatoriamente no topo da tela
	boss.position = Vector2(rand_range(0, get_viewport_rect().size.x), 0)
	add_child(boss)

	# Debug: imprime os valores atualizados
	print("Spawnando o BOSS com HP: ", boss.health, ", Escala: ", boss.scale, ", Velocidade: ", boss.moveSpeed)

	# Conecta o sinal de morte do boss
	boss.connect("zombie_died", self, "on_zombie_killed")

# Função para spawnar zumbis
func spawn_zombie():
	# Checa se estamos no último zumbi para spawnar o boss
	if zombies_spawned == zombies_per_turn - 1 and not boss_spawned:
		spawn_boss()
		boss_spawned = true
	else:
		# Pega o tipo de zumbi baseado no turno atual
		var zombie_type = get_zombie_type(current_turn)
		var zombie = zombie_type.instance()
		
		# Posiciona o zumbi aleatoriamente no topo da tela
		var viewport_size = get_viewport_rect().size
		zombie.position = Vector2(rand_range(0, viewport_size.x), 0)
		add_child(zombie)
		
		print("Spawnando zumbi ", zombies_spawned + 1, " de ", zombies_per_turn)
		# Conecta o sinal de morte do zumbi à função on_zombie_killed
		zombie.connect("zombie_died", self, "on_zombie_killed")
