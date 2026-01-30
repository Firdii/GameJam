extends ParallaxBackground

# Kecepatan gerak dasar
@export var scroll_speed : float = 30.0

func _process(delta):
	# Menggerakkan offset secara konstan ke kiri
	scroll_offset.x -= scroll_speed * delta
