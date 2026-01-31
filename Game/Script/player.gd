extends BaseCharacter

# --- SETUP AUDIO ---
@onready var sfx_run: AudioStreamPlayer2D = $SfxRun

# List suara (Pastiin file .wav lu ada di folder ini ya!)
var sfx_grass_collection = [
	preload("res://Assets/Sounds/Step_grass_1_(1).mp3.wav"),
	preload("res://Assets/Sounds/Step_grass_2_(1).mp3.wav")
]

var sfx_stone_collection = [
	preload("res://Assets/Sounds/Step_stone_1_(1).mp3.wav"),
	preload("res://Assets/Sounds/Step_stone_2_(1).mp3.wav")
]

var current_surface: String = "grass"

func _ready() -> void:
	# super._ready() penting kalo di BaseCharacter ada kodingan di func _ready
	pass

func _process(_delta: float) -> void:
	# LOGIKA GERAK LU YANG LAMA (Jangan sampe ilang!)
	inputDirection = Input.get_vector("Left", "Right", "Up", "Down")

# Fungsi buat dipanggil dari state player_run.gd
func play_footstep():
	var selected_stream : AudioStream
	
	if current_surface == "stone":
		selected_stream = sfx_stone_collection.pick_random()
	else:
		selected_stream = sfx_grass_collection.pick_random()
	
	sfx_run.stream = selected_stream
	sfx_run.pitch_scale = randf_range(0.8, 1.2)
	sfx_run.play()

# --- SIGNAL DETEKSI AREA ---
func _on_surface_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("StoneRegion"):
		current_surface = "stone"

func _on_surface_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("StoneRegion"):
		current_surface = "grass"
