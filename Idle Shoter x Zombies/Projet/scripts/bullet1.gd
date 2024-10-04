extends Area2D  # Ou Area2D, conforme necessário

var speed = 200  # Velocidade do projétil
var target = null  # O alvo (zumbi) que o projétil vai perseguir

# Função para definir o alvo do projétil
func set_target(new_target):
	target = new_target

# Processamento do movimento a cada frame
func _process(delta):
	if target != null:
		move_towards_target(delta)

# Função para mover o projétil em direção ao alvo
func move_towards_target(delta):
	if target != null:
		# Verifique se o alvo ainda está na cena
		if not target or not target.is_inside_tree():
			queue_free()
			return

		# Calcular a direção correta (do projétil para o alvo)
		var direction = (target.position - position).normalized()
		
		# Move o projétil na direção calculada
		position += direction * speed * delta

		# Verifica se o projétil está perto o suficiente do alvo (ajuste o valor se necessário)
		if position.distance_to(target.position) < 10:
			hit_target()

# Função para lidar com o impacto no alvo
func hit_target():
	print("Projétil atingiu o alvo!")
	queue_free()  # Remove o projétil da cena
