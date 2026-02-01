extends State

const SPEED = 120
const ACCELERATE = 5


var footstep_timer : float = 0.0
@export var footstep_delay : float = 0.25 

func UpdatePhysics(delta: float):
	super.UpdatePhysics(delta)
	
	character.velocity = character.velocity.lerp(character.inputDirection * SPEED, ACCELERATE * delta)
	character.move_and_slide()
	
	if character.velocity.length() > 10:
		footstep_timer -= delta
		if footstep_timer <= 0:
			character.play_footstep()
			footstep_timer = footstep_delay 
	else:
		footstep_timer = 0 
	
func Update():
	character.UpdateAnimation()
	if character.inputDirection == Vector2.ZERO:
		parentStateMachine.SwitchTo("Idle")
		return
	
	if Input.is_action_just_pressed("Attack"):
		parentStateMachine.SwitchTo("Attack")
