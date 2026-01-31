extends Node2D

@export var grass_scene: PackedScene  # Masukkan file grass.tscn di sini
@export var amount: int = 50          # Jumlah rumput yang mau dispawn

@onready var area_visual = $ReferenceRect

func _ready():
	# Sembunyikan kotak visual saat game mulai (kalau lupa dicentang editor only)
	if area_visual:
		area_visual.visible = false
	
	spawn_grass()

func spawn_grass():
	if not grass_scene:
		print("ERROR: Lupa masukin file grass.tscn ke Inspector!")
		return

	# Ambil ukuran kotak dari ReferenceRect
	var area_pos = area_visual.position
	var area_size = area_visual.size

	for i in range(amount):
		# 1. Buat instance rumput
		var grass = grass_scene.instantiate()
		
		# 2. Tentukan posisi acak di dalam kotak
		var random_x = randf_range(0, area_size.x)
		var random_y = randf_range(0, area_size.y)
		
		# 3. Atur posisi (relatif terhadap kotak spawner)
		grass.position = Vector2(area_pos.x + random_x, area_pos.y + random_y)
		
		# 4. Masukkan ke scene
		add_child(grass)
