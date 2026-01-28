extends State

func Update():
	super.Update()
	character.UpdateAnimation()
	
	if character.inputDirection.length() > 0:
		parentStateMachine.SwitchTo("Run")
		
	if Input.is_action_just_pressed("Attack"):
		parentStateMachine.SwitchTo("Attack")
