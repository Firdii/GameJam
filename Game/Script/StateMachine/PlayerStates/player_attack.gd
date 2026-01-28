extends State


var is_attacking = false

func Enter():
	super.Enter()
	is_attacking = true
	# Mulai animasi attack
	character.UpdateAnimation() 
	
	
	character.animated_sprite_2d.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)

func _on_animation_finished():
	
	if character.inputDirection != Vector2.ZERO:
		parentStateMachine.SwitchTo("Run")
	else:
		parentStateMachine.SwitchTo("Idle")

func Exit():
	super.Exit()
	
	if character.animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		character.animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)
