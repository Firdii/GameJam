extends CharacterBody2D
class_name BaseCharacter

# --- SIGNAL UNTUK HEART UI ---
signal health_changed(current, max)

# --- STATS ---
@export var maxHealth: int = 6 
@onready var currentHealth: int = maxHealth:
	set(value):
		currentHealth = clampi(value, 0, maxHealth)
		health_changed.emit(currentHealth, maxHealth)
		if currentHealth <= 0:
			isDead = true

var isDead: bool = false
@export var attackDamage: int = 1 

# --- MOVEMENT & UI ---
var knockBackDirection : Vector2
var inputDirection: Vector2 = Vector2.ZERO
var facingDirection: String = "Down"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine

@export var showDebugVisual: bool = true
var is_invincible: bool = false 

func _physics_process(_delta):
	UpdateAnimation()

func GetDirectionName() -> String:
	if inputDirection == Vector2.ZERO:
		return facingDirection
	
	if abs(inputDirection.x) >= abs(inputDirection.y):
		if inputDirection.x > 0:
			facingDirection = "Right"
		else:
			facingDirection = "Left"
	else:
		if inputDirection.y > 0:
			facingDirection = "Down" 
		else:
			facingDirection = "Up"

	return facingDirection
	
func UpdateAnimation():
	var direction = GetDirectionName()
	var state_name = state_machine.currentState.name
	var anim_name = state_name + "_" + direction
	
	# 1. Reset ke nol dulu biar gak numpuk geserannya
	animated_sprite_2d.offset = Vector2.ZERO
	
	# 2. EKSEKUSI GESER MANUAL (Tuning di sini!)
	if state_name == "Run":
		if direction == "Down":
			# Fix teleport kiri
			animated_sprite_2d.offset = Vector2(8, 2) 
		elif direction == "Up":
			# Fix teleport kanan (Kita tarik ke kiri pake -4)
			animated_sprite_2d.offset = Vector2(-12, -12)
		elif direction == "Left":
			animated_sprite_2d.offset = Vector2(0, 0)
		elif direction == "Right":
			animated_sprite_2d.offset = Vector2(0, 0)
	
	elif state_name == "Idle":
		# Kalau Idle melenceng juga, tuning di sini:
		if direction == "Down":
			animated_sprite_2d.offset = Vector2(0, 0)
		else:
			animated_sprite_2d.offset = Vector2(0, 0)

	# 3. Jalankan animasinya
	if animated_sprite_2d.sprite_frames.has_animation(anim_name):
		animated_sprite_2d.play(anim_name)

# --- FUNGSI HURT / KENA HIT ---
func GetHit(damage: int, fromPoint = Vector2.ZERO):
	if isDead or is_invincible:
		return
		
	StartBlink()
	currentHealth -= damage
	knockBackDirection = (global_position - fromPoint).normalized()
	
	if has_node("SfxHurt"):
		get_node("SfxHurt").play()

	if isDead:
		state_machine.SwitchTo("Die")
	else:
		if is_in_group("Player"):
			start_invincibility()
		
		state_machine.SwitchTo("Hurt")

# --- EFEK VISUAL & I-FRAMES ---
func UpdateBlink(newValue: float):
	animated_sprite_2d.set_instance_shader_parameter("Blink", newValue)
	
func StartBlink():
	var blink_tween = get_tree().create_tween()
	blink_tween.tween_method(UpdateBlink, 1.0, 0.0, 0.3)

func start_invincibility():
	is_invincible = true
	var tween = get_tree().create_tween().set_loops(3)
	tween.tween_property(animated_sprite_2d, "modulate:a", 0.5, 0.1)
	tween.tween_property(animated_sprite_2d, "modulate:a", 1.0, 0.1)
	
	await get_tree().create_timer(1.0).timeout
	is_invincible = false
