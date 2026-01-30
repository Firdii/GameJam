extends State

@onready var sfx_hurt = $"../../SfxHurt"

func Enter():
	super.Enter()
	character.UpdateAnimation()
	
	if sfx_hurt:
		# CEK APAKAH INI HIT TERAKHIR (Darah musuh habis)
		# Gunakan currentHealth sesuai yang ada di base_character.gd
		if character.currentHealth <= 0:
			# Efek Suara Slow-Mo pas mati (Pitch diturunin drastis)
			sfx_hurt.pitch_scale = 0.5 
			sfx_hurt.play()
			
			# Efek Dramatis: Game melambat sebentar
			Engine.time_scale = 0.5
			await get_tree().create_timer(0.1, true, false, true).timeout # Timer biar ga kena pengaruh timescale
			Engine.time_scale = 1.0
		else:
			# Suara Hurt Biasa (Randomized Pitch)
			sfx_hurt.pitch_scale = randf_range(0.8, 1.2)
			sfx_hurt.play()

func Update():
	super.Update()
	
	# Balik ke Idle kalau animasi hurt sudah selesai
	if character.animated_sprite_2d.frame_progress == 1:
		parentStateMachine.SwitchTo("Idle")
