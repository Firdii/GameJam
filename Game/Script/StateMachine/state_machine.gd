extends Node
class_name StateMachine
var currentState: State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
func _ready() -> void:
	
	for child in get_children():
		var childState = child as State
		childState.parentStateMachine = self
		childState.character = get_parent()
		childState.Ready()
		
	currentState = get_child(0)
	currentState.Enter()

func _physics_process(delta: float) -> void:
	currentState.UpdatePhysics(delta)
	
func _process(_delta: float) -> void:
	currentState.Update()

func SwitchTo(targetState: String):
	var nextStateNode = get_node(targetState)
	
	if !nextStateNode:
		print("Can not find the target state node")
		return
		
	currentState.Exit()
	currentState = nextStateNode
	currentState.Enter()
	
