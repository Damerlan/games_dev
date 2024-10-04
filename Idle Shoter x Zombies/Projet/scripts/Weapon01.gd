extends Node2D

export var fire_rate = 1.0
export var damage = 50
export var recoil_distance = 4.0
export var recoil_recovery_speed = 5.0

var Bullet = preload("res://Scenes/Bullet01.tscn")
onready var shoot_timer = $ShootTimer
onready var muzzle = $Muzzle
var current_target = null
var initial_rotation
var recoil_tween

func _ready():
	shoot_timer.wait_time = fire_rate
	shoot_timer.connect("timeout", self, "_on_ShootTimer_timeout")
	shoot_timer.start()
	initial_rotation = -20
	recoil_tween = Tween.new()
	add_child(recoil_tween)
	#print("Weapon initialized")

func _process(_delta):
	if current_target and is_instance_valid(current_target):
		var target_direction = (current_target.global_position - global_position).normalized()
		var angle = target_direction.angle()
		rotation = angle
		#print("Aiming at target: ", current_target.global_position)
	else:
		rotation = initial_rotation
		find_nearest_zombie()

func _on_ShootTimer_timeout():
	#print("ShootTimer timeout")
	if current_target and is_instance_valid(current_target):
		shoot()
	else:
		find_nearest_zombie()

func shoot():
	#print("Shooting at target: ", current_target)
	if current_target and is_instance_valid(current_target):
		var bullet = Bullet.instance()
		bullet.global_position = muzzle.global_position
		bullet.rotation = global_rotation
		bullet.damage = damage
		get_tree().root.add_child(bullet)
		#print("Bullet created at position: ", bullet.global_position)
		apply_recoil()
	else:
		current_target = null
		#print("Target is no longer valid")

func apply_recoil():
	var recoil_direction = -Vector2(cos(rotation), sin(rotation))
	var recoil_position = position + recoil_direction * recoil_distance
	
	recoil_tween.stop_all()
	recoil_tween.interpolate_property(self, "position", position, recoil_position, 0.05, Tween.TRANS_SINE, Tween.EASE_OUT)
	recoil_tween.interpolate_property(self, "position", recoil_position, Vector2.ZERO, 0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 10.09)
	recoil_tween.start()

func find_nearest_zombie():
	var zombies = get_tree().get_nodes_in_group("zombies")
	var nearest_distance = INF
	var nearest_zombie = null

	for zombie in zombies:
		var distance = global_position.distance_to(zombie.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_zombie = zombie

	if nearest_zombie:
		current_target = nearest_zombie
		current_target.connect("tree_exiting", self, "_on_target_died", [], CONNECT_ONESHOT)
		#print("New target acquired: ", current_target)
	else:
		pass
		#print("No zombies found")

func set_fire_rate(new_rate):
	fire_rate = new_rate
	shoot_timer.wait_time = fire_rate

func set_damage(new_damage):
	damage = new_damage

func _on_target_died():
	#print("Target died")
	current_target = null
