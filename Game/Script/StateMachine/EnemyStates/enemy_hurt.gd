extends State

@onready var sfx_hurt = $"../../SfxHurt"

func Enter():
	super.Enter()
	character.UpdateAnimation()
	
	if sfx_hurt:
		if character.currentHealth <= 0:
			sfx_hurt.pitch_scale = 0.5 
			sfx_hurt.play()
			
			Engine.time_scale = 0.5
			await get_tree().create_timer(0.1, true, false, true).timeout 
			Engine.time_scale = 1.0
		else:
			sfx_hurt.pitch_scale = randf_range(0.8, 1.2)
			sfx_hurt.play()

func Update():
	super.Update()
	if character.animated_sprite_2d.frame_progress == 1:
		parentStateMachine.SwitchTo("Idle")

func UpdatePhysics(delta: float):
	super.UpdatePhysics(delta)
	
	if character.animated_sprite_2d.frame == 0:
		character.move_and_collide(character.knockBackDirection * delta * 50)
