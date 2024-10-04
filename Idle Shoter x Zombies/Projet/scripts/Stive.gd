extends KinematicBody2D

var speed = 200  # Velocidade de movimento do jogador
var Weapon = preload("res://Scenes/Weapon01.tscn")  # Carrega a cena da Arma

onready var weapon = Weapon.instance()

func _ready():
	# Posiciona o jogador na parte inferior da tela
	position.y = get_viewport_rect().size.y - 20  # 50 pixels acima da borda inferior
	position.x = get_viewport_rect().size.x - 90
	# Adiciona a arma como filho do jogador
	add_child(weapon)
	weapon.position = Vector2(-8, -20)  # Ajuste a posição da arma em relação ao jogador
	add_to_group("player")

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	
	# Movimento horizontal
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	# Normaliza e aplica a velocidade
	velocity = velocity.normalized() * speed
	
	# Move o jogador
	move_and_slide(velocity)
	
	# Mantém a arma na posição correta em relação ao jogador
	weapon.global_position = global_position + Vector2(-10, -18)

# Função para trocar de arma (pode ser expandida mais tarde)
func change_weapon(new_weapon):
	remove_child(weapon)
	weapon = new_weapon.instance()
	add_child(weapon)
	weapon.position = Vector2(-10, -20)

# Função para atualizar a arma (pode ser usada para melhorias)
func upgrade_weapon(new_fire_rate, new_damage):
	weapon.set_fire_rate(new_fire_rate)
	weapon.set_damage(new_damage)
