# Zumbi Golias
extends "res://scripts/Enemy.gd" #herdando o script do inimigo base


func _ready():
	# Atributos específicos do ZumbiTank
	health = 400  # HP
	moveSpeed = 15    # Velocidade de Movimento
	damage = 15   # Dano do tanque
	coins_to_drop = 3 # Moedas por kill
	scale_factor = 2.5  # Tamanho do zumbi
	
