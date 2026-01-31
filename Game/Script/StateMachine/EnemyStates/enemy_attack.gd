extends State

func Enter():
	super.Enter()
	# 1. Mainin animasi sesuai arah (Attack_Up, dll)
	character.UpdateAnimation()
	
	# 2. Kasih damage (Slime: 0.5 Heart, Boss: 1 Heart)
	if character.player and character.player.has_method("GetHit"):
		character.player.GetHit(character.attackDamage, character.global_position)

	# 3. Tunggu animasinya kelar baru boleh pindah state
	var anim_sprite = character.get_node("AnimatedSprite2D")
	if not anim_sprite.animation_finished.is_connected(_on_attack_finished):
		anim_sprite.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)

func _on_attack_finished():
	# Kalau sudah beres mukul, balik ngejar player
	if parentStateMachine.currentState == self:
		parentStateMachine.SwitchTo("Move")
