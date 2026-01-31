extends Node2D

func _ready() -> void:
	# Cek jika Player datang dari Region 2
	if Global.spawn_position != Vector2.ZERO:
		$Level/Player.global_position = Global.spawn_position
		Global.spawn_position = Vector2.ZERO

func _on_exit_to_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		
		Global.spawn_position = Vector2(580, 42) 
		get_tree().change_scene_to_file("res://Game/Region2.tscn")
