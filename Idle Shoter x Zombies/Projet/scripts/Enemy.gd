extends KinematicBody2D

#Variaveis
export var moveSpeed = 20 #velocidade de Movimento
export var health = 50 # HP
export var coins_to_drop = 1 # coins por drop
export var scale_factor = 1.0  # Fator de escala do zumbi
export var damage = 10 #Dano do inimigo

var player = null
var invincibility_duration = 0.4  # Tempo do fading de hit
var knockback_distance = 10  # Distância de recuo de impacto

signal zombie_died #sinal de morte do inimigo

#Pre carregamento de cenas
var CoinScene = preload("res://Scenes/Coin.tscn") # Sena da Coin para drop
var DamageLabelScene = preload("res://Scenes/DamageLabel.tscn") # Carregue a cena do label de dano

func _ready(): #quando estanciar roda esta função
	_apply_scale()  # Aplica a escala ao iniciar ao inimigo
	
	player = get_tree().get_nodes_in_group("player")[0] # encontra o player
	
	add_to_group("zombies") # add ao grupo de zumbis inimigos
	
func _physics_process(_delta): #função de fisica
	if player: #se encontrar o player trava na posição dele como alvo
		var direction = (player.global_position - global_position).normalized()
		
		move_and_slide(direction * moveSpeed) #move o inimigo
		_update_animation_speed() # Atualiza a animação com base na nova velocidade


func die(): # função para mandar o sinal de morte
	drop_coin() # Chama a função para dropar a moeda
	emit_signal("zombie_died") # Emite o sinal de que o zumbi foi destruído
	queue_free() # Remove o zumbi da cena

func drop_coin():  # Função que dropa a moeda
	for i in range(coins_to_drop):  # Loop para instanciar a quantidade de moedas
		var coin_instance = CoinScene.instance()  # Cria uma instância da moeda
		get_parent().add_child(coin_instance)  # Adiciona a moeda na cena principal
		
		# Define a posição da moeda para o local onde o zumbi morreu
		var offset_x = randf() * 20 - 10  # Gera um deslocamento aleatório de -10 a 10
		var offset_y = randf() * 20 - 10  # Gera um deslocamento aleatório de -10 a 10
		coin_instance.position = self.position + Vector2(offset_x, offset_y)

func flash_and_knockback(): #função do flash e recuo do impacto
	var original_position = position # Pega a posição original
	var knockback_position = position - Vector2(0, 5)  # Move 5 pixels para cima no eixo Y

	if not has_node("Tween"): # Cria uma Tween se ainda não existir
		var tween = Tween.new()
		add_child(tween)

	var tween = $Tween  # Acessa a Tween

	# Anima o recuo no eixo Y
	tween.interpolate_property(self, "position", original_position, knockback_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "position", knockback_position, original_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.2)

	# Piscar em branco usando modulate
	tween.interpolate_property(self, "modulate", Color(1, 1, 1), Color(1, 1, 1, 0.5), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)

	tween.start() # Iniciar a animação

func take_damage(damage):
	health -= damage
	show_damage(damage)# Mostra o dano
	if health <= 0:
		die()
	else:
		flash_and_knockback()  # Chama a função de piscar e recuo


func _update_animation_speed(): # Função que atualiza a animação com base na velocidade
	if $animSprite:  # Verifique se o nó AnimationPlayer existe
		$animSprite.speed_scale = 100.0 / moveSpeed   # Ajusta a taxa de frames baseada na velocidade

# Função que aplica a escala ao zumbi
func _apply_scale():
	scale = Vector2(scale_factor, scale_factor)  # Aplica a escala

func show_damage(damage):
	# Cria uma instância do label de dano
	var damage_label_instance = DamageLabelScene.instance()
	get_parent().add_child(damage_label_instance)  # Adiciona na cena principal

	# Define a posição do label acima do zumbi
	damage_label_instance.position = position + Vector2(0, -10)  # Ajuste a posição vertical conforme necessário

	# Define o texto do label
	damage_label_instance.get_node("Label").text = "+" + str(damage)  # Acessa o nó do Label

	# Inicia a animação de movimento e desaparecimento
	damage_label_instance.start_animation()
