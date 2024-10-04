extends Area2D

# Variáveis do projétil
var speed = 200  # Velocidade do projétil
var direction = Vector2.ZERO  # Direção do movimento

# Função chamada quando o projétil é instanciado
func _ready():
	set_physics_process(true)  # Ativa o processamento de física

# Função para atualizar a posição do projétil a cada quadro de física
func _physics_process(delta):
	if direction != Vector2.ZERO:
		position += direction * speed * delta  # Move o projétil na direção
