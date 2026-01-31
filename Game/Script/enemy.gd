extends BaseCharacter

@onready var line_2d: Line2D = $Line2D
@onready var sfx_jump: AudioStreamPlayer2D = $SfxJump # Pastikan node ini ada di scene Enemy

var player : BaseCharacter
var playerDirection: Vector2
var playerAngle: float

func _ready() -> void:
	# Menggunakan find_child agar lebih fleksibel mencari Player di root
	player = get_tree().root.find_child("Player", true, false)
	
func _process(_delta: float) -> void:
	if not player: return
	
	playerDirection = player.global_position - global_position
	playerDirection = playerDirection.normalized()
	
	if showDebugVisual:
		line_2d.points[1] = playerDirection * 40
	else:
		line_2d.points[1] = Vector2.ZERO
		
	# Logika sudut untuk menentukan animasi
	var dir_for_angle = playerDirection
	dir_for_angle.y = -dir_for_angle.y
	playerAngle = rad_to_deg(dir_for_angle.angle())
	if playerAngle < 0:
		playerAngle += 360

func GetDirectionName() -> String:
	facingDirection = "Up"
	if playerAngle > 135 && playerAngle <= 225:
		facingDirection = "Left"
	elif playerAngle > 225 && playerAngle <= 315:
		facingDirection = "Down"
	elif playerAngle > 315 || playerAngle <= 45:
		facingDirection = "Right"
	return facingDirection

# FUNGSI AUDIO UNTUK DIPANGGIL STATE
func play_jump_sfx():
	if sfx_jump:
		sfx_jump.pitch_scale = randf_range(0.9, 1.2) # Biar suara tiap lompatan beda dikit
		sfx_jump.play()
