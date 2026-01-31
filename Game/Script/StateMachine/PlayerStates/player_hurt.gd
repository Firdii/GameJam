extends "res://Game/Script/StateMachine/State.gd"
@export var hurt_duration : float = 0.3
var timer : float = 0.0
var hurt_tween : Tween

func Enter(_msg := {}):
	if character.has_node("AnimatedSprite2D"):
		character.UpdateAnimation()
	
	if hurt_tween:
		hurt_tween.kill()
	hurt_tween = create_tween()
	hurt_tween.tween_property(character, "modulate", Color.RED, 0.1)
	hurt_tween.tween_property(character, "modulate", Color.WHITE, 0.1)
	
	timer = hurt_duration
	print("Player terkena serangan!")

func Update(): 
	if timer > 0:
		timer -= get_process_delta_time() 
	else:
		parentStateMachine.SwitchTo("Idle")
