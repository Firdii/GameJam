extends CharacterBody2D
class_name BaseCharacter

# --- SIGNAL UNTUK HEART UI ---
signal health_changed(current, max)

# --- STATS ---
@export var maxHealth = 6 
@onready var currentHealth = maxHealth:
	set(value):
		currentHealth = clampi(value, 0, maxHealth)
		health_changed.emit(currentHealth, maxHealth)
		if currentHealth <= 0:
			isDead = true

var isDead = false
@export var attackDamage = 1 

# --- MOVEMENT & UI ---
var knockBackDirection : Vector2
var inputDirection: Vector2 = Vector2.ZERO
var facingDirection: String = "Down"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : StateMachine = $StateMachine

@export var showDebugVisual = true

# Pengaman i-frame
var is_invincible : bool = false 

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
	var anim_name = state_machine.currentState.name + "_" + GetDirectionName()
	if animated_sprite_2d.sprite_frames.has_animation(anim_name):
		animated_sprite_2d.play(anim_name)

# --- FUNGSI HURT / KENA HIT ---
func GetHit(damage: int, fromPoint = Vector2.ZERO):
	# Kalau karakter lagi invincible (khusus player), dia gak bisa kena hit lagi
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
		# --- LOGIKA KHUSUS PLAYER ---
		# Hanya jalankan invincibility jika karakter masuk grup "Player"
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
	
	await get_tree().create_timer(1).timeout
	is_invincible = false
