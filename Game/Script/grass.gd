extends Area2D

var skewTween : Tween
var scaleTween : Tween
var startScale : Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_back: Sprite2D = $Sprite2D_Back

func _ready() -> void:
	# 1. PENTING: Simpan ukuran asli rumput saat game mulai
	startScale = sprite_2d.scale
	
	# 2. Setup Animasi Goyang (Skew) Kiri-Kanan (Looping)
	var startSkew = deg_to_rad(randf_range(-10, 10))
	var endSkew = -startSkew
	
	skewTween = get_tree().create_tween().set_loops()
	skewTween.tween_property(sprite_2d, "skew", endSkew, 1.5).from(startSkew)
	skewTween.tween_property(sprite_2d, "skew", startSkew, 1.5).from(endSkew)
	skewTween.set_ease(Tween.EASE_IN_OUT)
	
	# Logic untuk bayangan belakang (jika ada)
	if sprite_2d_back:
		var skewTweenBack = get_tree().create_tween().set_loops()
		skewTweenBack.tween_property(sprite_2d_back, "skew", endSkew, 1.5).from(startSkew)
		skewTweenBack.tween_property(sprite_2d_back, "skew", startSkew, 1.5).from(endSkew)
		skewTweenBack.set_ease(Tween.EASE_IN_OUT)

func _on_body_entered(_body: Node2D) -> void:
	# SAAT DIINJAK: Rumput jadi gepeng (X melebar, Y memendek)
	var squash_scale = Vector2(startScale.x * 1.3, startScale.y * 0.7)
	CreateNewScaleTween(squash_scale, 0.2) # Animasi cepat (0.2 detik)

func _on_body_exited(_body: Node2D) -> void:
	# SAAT PERGI: Rumput balik ke ukuran normal
	CreateNewScaleTween(startScale, 0.5) # Animasi membal (0.5 detik)

# --- INI FUNGSI YANG TADI HILANG (PENYEBAB ERROR) ---
func CreateNewScaleTween(target_scale: Vector2, duration: float) -> void:
	# Hapus tween lama biar animasi gak tabrakan
	if scaleTween:
		scaleTween.kill()
	
	scaleTween = get_tree().create_tween()
	
	# Animasi Scale dengan efek 'Elastic' biar kenyal
	scaleTween.tween_property(sprite_2d, "scale", target_scale, duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	# Animasikan juga bayangannya
	if sprite_2d_back:
		scaleTween.parallel().tween_property(sprite_2d_back, "scale", target_scale, duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
