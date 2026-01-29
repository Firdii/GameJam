extends BaseCharacter

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	
	inputDirection = Input.get_vector("Left", "Right", "Up", "Down")
