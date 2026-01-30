extends CharacterBody2D
class_name BaseCharacter

@export var maxHealth = 100
@onready var currentHealth = maxHealth:
	set(value):
		currentHealth = clampi(value, 0, maxHealth)
		if currentHealth == 0:
			isDead = true
var isDead = false
@export var attackDamage = 25


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

func GetHit(damage: int):
	if isDead:
		return
		
	StartBlink()
	currentHealth -= damage
	
	if isDead:
		state_machine.SwitchTo("Die")
	else:
		state_machine.SwitchTo("Hurt")


func UpdateBlink(newValue: float):
	animated_sprite_2d.set_instance_shader_parameter("Blink", newValue)
	
func StartBlink():
	var blink_tween = get_tree().create_tween()
	blink_tween.tween_method(UpdateBlink, 1.0, 0.0, 0.3)
