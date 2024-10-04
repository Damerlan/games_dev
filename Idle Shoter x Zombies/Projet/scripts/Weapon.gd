extends Node2D  # Ou o nó base que você está usando

# Função para disparar projétil
func fire(target_position: Vector2):
	print("Disparando projétil em direção ao alvo!")
	
	var projectile = preload("res://Scenes/bullet.tscn").instance()

	# Adiciona o projétil à cena de forma deferida
	call_deferred("add_child", projectile)
	
	projectile.global_position = global_position  # Define posição de origem do tiro
	projectile.direction = (target_position - global_position).normalized()  # Define a direção do projétil
