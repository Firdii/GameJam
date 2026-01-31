extends Node2D

func _on_exit_to_1_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		call_deferred("pindah_ke_region_1")

func _on_exit_to_3_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		call_deferred("pindah_ke_region_3")


func pindah_ke_region_1():
	get_tree().change_scene_to_file("res://Game/Region1.tscn")

func pindah_ke_region_3():
	get_tree().change_scene_to_file("res://Game/Region3.tscn")
