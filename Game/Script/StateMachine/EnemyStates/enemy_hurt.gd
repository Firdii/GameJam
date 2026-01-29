extends State

func Enter():
	super.Enter()
	character.UpdateAnimation()

func Update():
	super.Update()
	
	
	if character.animated_sprite_2d.frame_progress == 1:
		parentStateMachine.SwitchTo("Idle")
