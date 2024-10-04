extends Area2D

export var speed = 200
export var damage = 100

func _ready():
	#print("Bullet created at position: ", global_position)
	pass

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	#print("Bullet exited screen")
	queue_free()


func _on_Bullet01_body_entered(body):
	# Verifica se o objeto colidido é um zumbi e se pode receber dano
	if body.is_in_group("zombies") and body.has_method("take_damage"):
		body.take_damage(damage)  # Aplica o dano
		
		# Parar o movimento do projetil
		$CollisionShape2D.set_deferred("disabled", true)  # Desativar colisão
		speed = Vector2(0, 0)  # Parar o movimento definindo a velocidade para zero
		
		# Mudar para a animação de destruição e esperar a animação acabar antes de destruir o projetil
		$anim.play("destroi")  # Toca a animação de explosão
		$anim.connect("animation_finished", self, "_on_destroi_finished")  # Conecta o sinal de finalização da animação

# Função chamada quando a animação de destruição terminar
func _on_destroi_finished():
	queue_free()  # Remove o projetil da cena
