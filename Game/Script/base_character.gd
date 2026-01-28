extends CharacterBody2D
class_name BaseCharacter

var inputDirection: Vector2 = Vector2.ZERO
var facingDirection: String = "Down"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var animationToPlay: String
@onready var state_machine : StateMachine = $StateMachine

@export var showDebugVisual = true

func GetDirectionName() -> String:
	if inputDirection == Vector2.ZERO:
		return facingDirection
	

	if abs(inputDirection.x) >= abs(inputDirection.y):
		
		if inputDirection.x > 0:
			facingDirection = "Right"
		else:
			facingDirection = "Left"
	else:
		
		if inputDirection.y > 0:
			facingDirection = "Down" 
		else:
			facingDirection = "Up"

	return facingDirection
	
	
func UpdateAnimation():
	animated_sprite_2d.play(state_machine.currentState.name + "_" + GetDirectionName())
