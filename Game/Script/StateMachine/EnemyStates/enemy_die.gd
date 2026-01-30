extends State

# Ambil referensi ke node suara yang sama
@onready var sfx_hurt = $"../../SfxHurt"

func Enter():
	super.Enter()
	character.UpdateAnimation()
	character.animated_sprite_2d.offset.y -= 10
	
	# --- LOGIKA SUARA MATI DRAMATIS ---
	if sfx_hurt:
		# Kita bikin suaranya jadi berat/slowmo
		sfx_hurt.pitch_scale = 0.8
		sfx_hurt.play()
		
		# Efek Tambahan: Bikin game freeze bentar biar tebasannya kerasa kuat
		Engine.time_scale = 0.2
		# Pakai true di parameter terakhir biar timernya gak ikut kena slowmo
		await get_tree().create_timer(0.05, true, false, true).timeout 
		Engine.time_scale = 1.0
	
func Update():
	super.Update()
	# Tunggu animasi mati kelar baru hapus musuhnya
	if character.animated_sprite_2d.frame_progress == 1:
		character.queue_free()
