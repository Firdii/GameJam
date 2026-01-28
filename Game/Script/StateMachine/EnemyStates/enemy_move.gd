extends State

@onready var navigation_agent_2d: NavigationAgent2D = $"../../NavigationAgent2D"

var direction : Vector2
var speed : float
const SPEED_MAX = 50
const SPEED_MIN = 25

func Update():
	super.Update()
	character.UpdateAnimation()
	speed =randf_range(SPEED_MIN, SPEED_MAX)
	navigation_agent_2d.target_position = character.player.global_position


func UpdatePhysics(delta: float):
	super.UpdatePhysics(delta)
	direction = character.global_position.direction_to(navigation_agent_2d.get_next_path_position())
	
	if navigation_agent_2d.is_target_reached() == false:
		character.velocity = character.velocity.lerp(direction * speed, delta)
		character.move_and_slide()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if parentStateMachine.currentState == self && navigation_agent_2d.is_target_reached() == false:
		character.velocity += safe_velocity * get_physics_process_delta_time()
