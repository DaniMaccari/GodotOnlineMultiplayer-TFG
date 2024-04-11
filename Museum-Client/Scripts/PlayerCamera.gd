# Script para el controlador de la cámara
extends Camera3D
func _process(delta):
	# Obtener la posición y rotación del jugador local
	var player = get_node("/root/Player")
	if player:
		global_transform.origin = player.global_transform.origin
		global_transform.basis = player.global_transform.basis

func set_current_player(id):
	
