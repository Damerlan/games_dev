extends KinematicBody2D

export var moveSpeed = 10
export var health = 100
export var scale_factor = 1.0  # Fator de escala do zumbi
export var damage = 10 #Dano do inimigo
#export var pontos = 1
var player = null
var invincibility_duration = 0.4  # Tempo que o zumbi fica piscando
var knockback_distance = 10  # Distância de recuo

signal zombie_died

# Referência à cena da moeda
var CoinScene = preload("res://Scenes/Coin.tscn")

func _ready():
	_apply_scale()  # Aplica a escala ao iniciar ao inimigo
	player = get_tree().get_nodes_in_group("player")[0]
	add_to_group("zombies")
	#print("Zombie created at position: ", global_position)

# Função que aplica a escala ao zumbi
func _apply_scale():
	scale = Vector2(scale_factor, scale_factor)  # Aplica a escala
	
func _physics_process(_delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		move_and_slide(direction * moveSpeed)

func take_damage(damage):
	health -= damage
	if health <= 0:
		die()
	else:
		flash_and_knockback()  # Chama a função de piscar e recuo

func flash_and_knockback():
	# Pega a posição original
	var original_position = position
	var knockback_position = position - Vector2(0, 5)  # Move 10 pixels para cima no eixo Y

	# Cria uma Tween se ainda não existir
	if not has_node("Tween"):
		var tween = Tween.new()
		add_child(tween)
	
	var tween = $Tween  # Acessa a Tween

	# Anima o recuo no eixo Y
	tween.interpolate_property(self, "position", original_position, knockback_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "position", knockback_position, original_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.2)

	# Piscar em branco usando modulate
	tween.interpolate_property(self, "modulate", Color(1, 1, 1), Color(1, 1, 1, 0.5), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)

	# Iniciar a animação
	tween.start()


func die():
	drop_coin() # Chama a função para dropar a moeda
	# Emite o sinal de que o zumbi foi destruído
	emit_signal("zombie_died")
	queue_free() # Remove o zumbi da cena
	#print("Zombie died at position: ", global_position)
	#Global.zombie_kiled += 1 #acrescenta contagem de zumbis
	#Global.zombies_killed_int += 1 #acrescenta contagem de zumbis

# Função para dropar a moeda no chão
func drop_coin():
	var coin_instance = CoinScene.instance() # Cria uma instância da moeda
	get_parent().add_child(coin_instance) # Adiciona a moeda na cena principal
	
	# Define a posição da moeda para o local onde o zumbi morreu
	coin_instance.position = self.position
	print("Moeda dropada no chão na posição: ", coin_instance.position)
