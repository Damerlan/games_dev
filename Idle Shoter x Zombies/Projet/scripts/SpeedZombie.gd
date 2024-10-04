# Zumbi Flash
extends "res://scripts/Enemy.gd" #herdando o script do inimigo base


func _ready():
	# atributos específicos do ZumbiFlash
	health = 70  # HP
	moveSpeed = 90    # Velocidade de Movimento
	damage = 5   # Dano do tanque
	coins_to_drop = 2 # Moedas por kill
	scale_factor = 1.1  # Tamanho do zumbi
