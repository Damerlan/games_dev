extends Node2D

onready var label = $Label  # Referência ao seu Label

# Função que inicia a animação
func start_animation():
	# Animação de subir
	var tween = Tween.new()
	add_child(tween)  # Adiciona o Tween à cena
	tween.interpolate_property(self, "position", position, position + Vector2(0, -50), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

	# Remove o label após a animação
	yield(tween, "tween_completed")
	queue_free()  # Remove o Label após a animação
