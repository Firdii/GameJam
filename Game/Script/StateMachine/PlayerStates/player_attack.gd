extends State

var is_attacking = false
var combo_count = 1 
var max_combo = 2
var next_attack_pressed = false 

@onready var attack_hit_box: Area2D = $"../../AttackHitBox"

# --- REFERENSI SFX ---
# Pastikan nama node di scene player sama persis dengan nama ini
@onready var sfx_slash_1 = $"../../SfxSlash1"
@onready var sfx_slash_2 = $"../../SfxSlash2"

var attackCollisionShape : CollisionShape2D

func Enter():
	super.Enter()
	is_attacking = true
	
	# --- LOGIKA PLAY SUARA BERDASARKAN COMBO ---
	# Kita play suara tepat saat animasi dimulai di fungsi Enter
	if combo_count == 1:
		if sfx_slash_1:
			sfx_slash_1.pitch_scale = randf_range(0.9, 1.1) # Variasi dikit biar keren
			sfx_slash_1.play()
	elif combo_count == 2:
		if sfx_slash_2:
			sfx_slash_2.pitch_scale = randf_range(0.9, 1.1)
			sfx_slash_2.play()
	
	# Mainkan animasi sesuai hit combo dan arah hadap karakter
	var anim_name = "Attack" + str(combo_count) + "_" + character.GetDirectionName()
	character.animated_sprite_2d.play(anim_name)
	
	var facingDirection = character.GetDirectionName()
	var shape_name = "CollisionShape2D_" + facingDirection
	attackCollisionShape = attack_hit_box.get_node_or_null(shape_name)
	
	if attackCollisionShape:
		attackCollisionShape.disabled = true 
	else:
		print("WARNING: Tidak menemukan " + shape_name + " di dalam AttackHitBox!")

	next_attack_pressed = false
	
	# Connect signal kalau belum terhubung biar gak numpuk
	if not character.animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		character.animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func Update():
	# Cek input buat lanjutin combo
	if Input.is_action_just_pressed("Attack"):
		next_attack_pressed = true
		
	if attackCollisionShape:
		if character.animated_sprite_2d.frame == 2:
			attackCollisionShape.disabled = false
		elif character.animated_sprite_2d.frame == 5:
			attackCollisionShape.disabled = true

func _on_animation_finished():
	if next_attack_pressed and combo_count < max_combo:
		combo_count += 1
		Enter() 
	else:
		finish_attack()

func finish_attack():
	combo_count = 1
	is_attacking = false
	
	if attackCollisionShape:
		attackCollisionShape.disabled = true
	
	if character.animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		character.animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)
	
	if character.inputDirection != Vector2.ZERO:
		parentStateMachine.SwitchTo("Run")
	else:
		parentStateMachine.SwitchTo("Idle")

func Exit():
	super.Exit()
	if attackCollisionShape:
		attackCollisionShape.disabled = true
		
	if character.animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		character.animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)

func Ready():
	if attack_hit_box:
		for child in attack_hit_box.get_children():
			if child is CollisionShape2D:
				child.disabled = true

func _on_attack_hit_box_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("GetHit"):
		area.get_parent().GetHit(character.attackDamage, character.global_position)
