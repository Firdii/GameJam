extends Node2D

const TARGET_MAP = "res://Game/Region2.tscn"

func _on_exit_zone_body_entered(body: Node2D) -> void:
	print("Sesuatu masuk ke area: ", body.name) 
	if body.name == "Player":
		print("Pindah ke Region 2!")
		get_tree().change_scene_to_file("res://Game/Region2.tscn")

func _ready() -> void:
	if Global.spawn_position != Vector2.ZERO:
		$Level/Player.global_position = Global.spawn_position
		Global.spawn_position = Vector2.ZERO
