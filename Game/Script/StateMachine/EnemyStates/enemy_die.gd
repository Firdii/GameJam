extends State

@onready var sfx_hurt = $"../../SfxHurt"

func Enter():
	super.Enter()
	character.UpdateAnimation()
	character.animated_sprite_2d.offset.y -= 10
	
	# --- LOGIKA FILTER: Cuma jalan kalo yang mati itu Boss ---
	if character.is_in_group("Boss"):
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			if player.has_method("evolution_event"):
				player.evolution_event()
				print("Sistem: Boss mati, memicu evolusi mask.")
			else:
				print("DEBUG: Fungsi evolution_event kaga ada di player.gd!")
		else:
			print("DEBUG: Player kaga ketemu di group 'Player'!")
	else:
		# Kalo bukan boss (kayak slime), kodingan di atas dilewati
		print("Sistem: Musuh biasa mati, tidak ada evolusi.")
	# ----------------------------------------------------

	if sfx_hurt:
		sfx_hurt.pitch_scale = 0.8
		sfx_hurt.play()
		
		# Efek Slow-mo pas mati
		Engine.time_scale = 0.2
		await get_tree().create_timer(0.05, true, false, true).timeout 
		Engine.time_scale = 1.0
	
func Update():
	super.Update()
	# Hapus musuh dari scene kalo animasi udah beres
	if character.animated_sprite_2d.frame_progress == 1:
		character.queue_free()

func UpdatePhysics(delta: float):
	super.UpdatePhysics(delta)
	
	# Efek knockback dikit pas mati
	if character.animated_sprite_2d.frame == 0:
		character.move_and_collide(character.knockBackDirection * delta * 50)
