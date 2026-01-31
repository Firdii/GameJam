extends Node2D

# Array ini untuk menampung banyak jenis pohon sekaligus
@export var tree_scenes: Array[PackedScene] 

@export var amount: int = 15 # Jumlah pohon (jangan kebanyakan, nanti sempit)
@export var tilemap_lantai: TileMapLayer # Drag TileMapLayer ke sini
@export var custom_data_name: String = "bisa_tumbuh_rumput" # Pastikan nama label tanah sama

@onready var area_visual = $ReferenceRect

func _ready():
	# Sembunyikan kotak visual saat game jalan
	if area_visual:
		area_visual.visible = false
	
	spawn_trees()

func spawn_trees():
	# Cek error dulu biar aman
	if tree_scenes.is_empty():
		print("ERROR: Belum ada pohon yang dimasukkan ke Inspector (Tree Scenes)!")
		return
	if not tilemap_lantai:
		print("ERROR: TileMap Lantai belum dimasukkan ke Inspector!")
		return

	var area_pos = area_visual.position
	var area_size = area_visual.size
	var spawned_count = 0
	var attempts = 0
	var max_attempts = amount * 20 # Kita butuh percobaan lebih banyak karena pohon butuh ruang

	while spawned_count < amount and attempts < max_attempts:
		attempts += 1
		
		# 1. Tentukan Posisi Acak
		var rand_x = randf_range(0, area_size.x)
		var rand_y = randf_range(0, area_size.y)
		var final_pos = Vector2(area_pos.x + rand_x, area_pos.y + rand_y)
		
		# 2. Cek Apakah Ini Tanah (Bukan Air/Jurang/Pilar)?
		# Mengubah posisi pixel dunia -> koordinat grid map
		var local_pos = tilemap_lantai.to_local(global_position + final_pos)
		var map_pos = tilemap_lantai.local_to_map(local_pos)
		var tile_data = tilemap_lantai.get_cell_tile_data(map_pos)
		
		# Cek Label Custom Data (Pastikan kamu sudah buat label ini di TileSet seperti tutorial Grass)
		if tile_data and tile_data.get_custom_data(custom_data_name) == true:
			
			# 3. SPESIAL: Pilih Salah Satu Pohon Secara Acak
			var random_tree_scene = tree_scenes.pick_random()
			
			# 4. Tanam Pohonnya
			var tree = random_tree_scene.instantiate()
			tree.position = final_pos
			add_child(tree)
			
			spawned_count += 1
