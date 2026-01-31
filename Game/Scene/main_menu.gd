extends Control



func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/Region1.tscn")


func _on_option_pressed() -> void:
	print("Option pressed")


func _on_exit_pressed() -> void:
	get_tree().quit()
