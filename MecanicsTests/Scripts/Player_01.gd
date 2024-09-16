extends KinematicBody2D

#variaveis de movimentação do player
var velocity = Vector2.ZERO
var move_speed = 350


func _physics_process(delta):
	
	_get_imput()#pegando os inputs pressionados
	move_and_slide(velocity)#movendo o player
	_set_animation()#setando a Animação

func _get_imput():
	#Resetando Vx e Vy
	velocity = Vector2.ZERO
	
	#direção x
	var move_directio_x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = lerp(velocity.x, move_speed * move_directio_x, 0.2)
	
	var move_direction_y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	velocity.y = lerp(velocity.y, move_speed * move_direction_y, 0.2)
	
func _set_animation():
	var anim = "idle"
	
	if Input.is_action_pressed("move_down"):
		anim = "run"
	if Input.is_action_pressed("move_up"):
		anim = "run"
	elif Input.is_action_pressed("move_left"):
		anim = "run"
	elif Input.is_action_pressed("move_right"):
		anim = "run"
	
	if $animPlayer.assigned_animation != anim:
		$animPlayer.play(anim)
	
