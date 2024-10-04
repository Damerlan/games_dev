extends KinematicBody2D

var targets = []  # Lista para armazenar os corpos que entram na área
var current_target = null  # Alvo atual dos projéteis

func _ready():
	pass



func _on_Area2D_body_entered(body):
	#print(body.name, " entrou na Zona de Tiro = on_Area2D_body")
	$Label.text = "To atirando no " + body.name
	
	if body.has_method("get_position"):
		targets.append(body)
		print("Novo objeto entrou na área: ", body.name)
		# Se não houver um alvo atual, selecione este como o alvo
		if current_target == null:
			select_target()

# Função para selecionar um alvo
func select_target():
	if targets.size() > 0:
		# Exemplo: Seleciona o alvo mais próximo da área
		current_target = targets[0]
		for target in targets:
			if (target.position - position).length() < (current_target.position - position).length():
				current_target = target
		print("Novo alvo selecionado: ", current_target.name)
	else:
		print("Nenhum alvo disponível")

# Pega a posição do corpo que foi monitorado
func _process(_delta):
	if current_target != null:
		print("Perseguindo alvo: ", current_target.position)
		
		_dispara(current_target.position)

		# Aqui você pode adicionar lógica para mover o projétil em direção ao `current_target.position`


func _dispara(target):
	var projectile = preload("res://Scenes/bullet1.tscn").instance()
	projectile.set_target(current_target)  # Define o alvo como o inimigo atual
	add_child(projectile)  # Adiciona o projétil à cena


func _on_Area2D_body_exited(body):
	current_target = null
	
