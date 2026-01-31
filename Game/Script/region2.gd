extends Node2D

func _on_exit_to_1_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		Global.spawn_position = Vector2(577, 36) 
		get_tree().change_scene_to_file("res://Game/Region1.tscn")
		
func _on_exit_to_3_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		
		Global.spawn_position = Vector2(579, 611)  
		get_tree().change_scene_to_file("res://Game/Region3.tscn")
