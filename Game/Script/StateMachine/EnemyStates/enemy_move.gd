extends State

@onready var navigation_agent_2d: NavigationAgent2D = $"../../NavigationAgent2D"

var direction : Vector2
var speed : float
const SPEED_MAX = 50
const SPEED_MIN = 25


var jump_timer : float = 0.0
@export var jump_interval : float = 0.6
@export var attack_range : float = 10.0 

func Update():
	super.Update()
	character.UpdateAnimation()
	speed = randf_range(SPEED_MIN, SPEED_MAX)
	
	if character.player:
		navigation_agent_2d.target_position = character.player.global_position
		
		
		var dist = character.global_position.distance_to(character.player.global_position)
		if dist <= attack_range:
			parentStateMachine.SwitchTo("Attack") 

func UpdatePhysics(delta: float):
	super.UpdatePhysics(delta)
	if not navigation_agent_2d: return
	
	direction = character.global_position.direction_to(navigation_agent_2d.get_next_path_position())
	
	if navigation_agent_2d.is_target_reached() == false:
		character.velocity = character.velocity.lerp(direction * speed, delta)
		character.move_and_slide()
		
		
		jump_timer -= delta
		if jump_timer <= 0:
			character.play_jump_sfx()
			jump_timer = jump_interval
	else:
		jump_timer = 0
