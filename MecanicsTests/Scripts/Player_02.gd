extends KinematicBody2D
#teste de mecanica de salto em estilo topdown

export var speed := 100
export var jump_force := 60

var direction : Vector2
var motion : Vector2

onready var tween: Tween = $tween

func _physics_process(_delta):
	if Input.is_action_pressed("jump"):
		tween.interpolate_property($shadown, "scale", $shadown.scale, $shadown.scale / 2, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		while $Sprite.position.y > -jump_force:
			$Sprite.position.y -= 5
			yield(get_tree(),"idle_frame")
		yield(get_tree().create_timer(0.15),"timeout")
		tween.interpolate_property($shadown, "scale", $shadown.scale, $shadown.scale * 2, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		while $Sprite.position.y < 0:
			$Sprite.position.y += 5
			yield(get_tree(),"idle_frame")
	
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	motion = direction.normalized() * speed
	
	move_and_slide(motion)
