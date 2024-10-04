extends KinematicBody2D

# Variáveis de controle
export var speed: float = 20
var direction: Vector2 = Vector2(0, 1)  # Direção para baixo

func _physics_process(_delta):
	# Movimentação para baixo
	var velocity = direction * speed
	velocity = move_and_slide(velocity)

	# Verifica se o zumbi está colidindo com alguma parede (barricada)
	if is_on_wall():
		attack_barricade()

# Função de ataque à barricada
func attack_barricade():
	speed = 0  # Zumbi para de se mover
	print("Zumbi atacando a barricada!")
	# Aqui você pode adicionar lógica para reduzir a vida da barricada



#	if collision:
#		if collision.collider.is_in_group("Barreira"):
#			attack_barricade()


