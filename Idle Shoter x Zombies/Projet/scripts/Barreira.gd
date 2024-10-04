extends Area2D

# Função chamada ao detectar a colisão
func _on_body_entered(body):
	if body.is_in_group("zombies"):
		print("Zumbi chegou na barricada!")
		# Adicione a lógica para danificar a barricada aqui
