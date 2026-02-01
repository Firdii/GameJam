extends BaseCharacter

# --- SETUP UI & EVOLUSI MASK ---
# Gue pake % (Unique Name) biar lu gak pusing sama path CanvasLayer/Margin/HBox/Anjing
@onready var notification_label = %NotificationLabel
@onready var mask_rect = $CanvasLayer/MarginContainer/HeartContainer/MaskTextureRect

# Ganti path ini sesuai lokasi file PNG mask baru lu
var mask_evolved_png = preload("res://Assets/Characters/mask-4044.png")

# --- SETUP AUDIO ---
@onready var sfx_run: AudioStreamPlayer2D = $SfxRun
var sfx_grass_collection = [preload("res://Assets/Sounds/Step_grass_1_(1).mp3.wav"), preload("res://Assets/Sounds/Step_grass_2_(1).mp3.wav")]
var sfx_stone_collection = [preload("res://Assets/Sounds/Step_stone_1_(1).mp3.wav"), preload("res://Assets/Sounds/Step_stone_2_(1).mp3.wav")]
var current_surface: String = "grass"

func _ready() -> void:
	# 1. Pastiin notifikasi ilang pas awal
	if notification_label:
		notification_label.modulate.a = 0
	
	# 2. Daftarin player ke grup "Player" (PENTING BUAT BOSS)
	add_to_group("Player")

func _process(_delta: float) -> void:
	inputDirection = Input.get_vector("Left", "Right", "Up", "Down")

# --- LOGIKA EVOLUSI (Panggil fungsi ini di script Boss) ---
func evolution_event():
	# Cek dulu nodenya ada gak, biar gak error merah
	if notification_label == null or mask_rect == null:
		print("ERROR: Node UI nggak ketemu! Pastiin udah 'Access as Unique Name'")
		return
		
	# 1. Ganti PNG Mask
	mask_rect.texture = mask_evolved_png
	
	# 2. Munculin Teks Notifikasi (Fade In)
	var tween = create_tween()
	tween.tween_property(notification_label, "modulate:a", 1.0, 1.0)
	
	# 3. Efek visual di Mask (Cyan)
	var tween_m = create_tween()
	tween_m.tween_property(mask_rect, "modulate", Color.CYAN, 0.2)
	tween_m.tween_property(mask_rect, "modulate", Color.WHITE, 0.6)
	
	# 4. Tunggu 4 detik, terus ilangin teksnya
	await get_tree().create_timer(4.0).timeout
	var tween_out = create_tween()
	tween_out.tween_property(notification_label, "modulate:a", 0.0, 1.0)

# --- FUNGSI FOOTSTEP ---
func play_footstep():
	var selected_stream = sfx_stone_collection.pick_random() if current_surface == "stone" else sfx_grass_collection.pick_random()
	if sfx_run:
		sfx_run.stream = selected_stream
		sfx_run.pitch_scale = randf_range(0.8, 1.2)
		sfx_run.play()

func _on_surface_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("StoneRegion"): current_surface = "stone"

func _on_surface_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("StoneRegion"): current_surface = "grass"
