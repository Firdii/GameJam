extends State

const SPEED = 120
const ACCELERATE = 5

func UpdatePhysics(delta: float):
	super.UpdatePhysics(delta)
	
	character.velocity = character.velocity.lerp(character.inputDirection * SPEED, ACCELERATE * delta)
	character.move_and_slide()
	
func Update():
	
	character.UpdateAnimation()
	if character.inputDirection == Vector2.ZERO:
		parentStateMachine.SwitchTo("Idle")
		return
	
	if Input.is_action_just_pressed("Attack"):
		parentStateMachine.SwitchTo("Attack")
