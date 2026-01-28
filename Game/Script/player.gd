extends BaseCharacter




func _unhandled_input(_event: InputEvent) -> void:
	inputDirection = Input.get_vector("Left", "Right", "Up", "Down")

	
	
