extends KinematicBody2D

export var speed: float = 20
var direction: Vector2 = Vector2(0, 1)  # Direção para baixo

 
func _physics_process(_delta):
	# Movimentação para baixo
	var velocity = direction * speed
	velocity = move_and_slide(velocity)
