extends State

func Enter():
	super.Enter()
	character.UpdateAnimation()
	character.animated_sprite_2d.offset.y -= 10
	
func Update():
	super.Update()
	if character.animated_sprite_2d.frame_progress == 1:
		character.queue_free()
