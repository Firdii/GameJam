extends CanvasLayer

@onready var notification_label = %NotificationLabel
@onready var mask_rect = $MarginContainer/HBoxContainer/MaskTextureRect 

# Pastiin path file PNG mask baru lu bener!
var mask_evolved_png = preload("res://Assets/Characters/mask-4044.png") 

func _ready():
	# Double check biar beneran ilang pas awal
	notification_label.modulate.a = 0
	
	# DAFTARIN KE GROUP (Paling penting biar bisa dipanggil Boss)
	add_to_group("PlayerUI")

func show_mask_notification():
	# 1. Ganti PNG Mask
	mask_rect.texture = mask_evolved_png
	
	# 2. Munculin Teks (Fade In) pake Tween
	var tween = create_tween()
	tween.tween_property(notification_label, "modulate:a", 1.0, 1.0)
	
	# 3. Efek kedip di Mask (Warna Gold)
	var tween_mask = create_tween()
	# Lu bisa ganti Color.GOLD jadi Color(1, 1, 0) kalau mau manual
	tween_mask.tween_property(mask_rect, "modulate", Color.GOLD, 0.2)
	tween_mask.tween_property(mask_rect, "modulate", Color.WHITE, 0.5)
	
	# 4. Tunggu 3 detik terus ilangin lagi
	await get_tree().create_timer(3.0).timeout
	var tween_out = create_tween()
	tween_out.tween_property(notification_label, "modulate:a", 0.0, 1.0)
