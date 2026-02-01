extends State

func Enter():
	super.Enter()
	
	character.UpdateAnimation()
	
	if character.player and character.player.has_method("GetHit"):
		character.player.GetHit(character.attackDamage, character.global_position)

	var anim_sprite = character.get_node("AnimatedSprite2D")
	if not anim_sprite.animation_finished.is_connected(_on_attack_finished):
		anim_sprite.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)

func _on_attack_finished():
	if parentStateMachine.currentState == self:
		parentStateMachine.SwitchTo("Move")
