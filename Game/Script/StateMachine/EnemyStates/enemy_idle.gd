extends State

var playerDetectionRadius = 100
@onready var polygon_2d: Polygon2D = $"../../Polygon2D"


func Enter():
	super.Enter()
	
	if character.showDebugVisual:
		CreatePolygonCircle()
	else:
		polygon_2d.polygon = PackedVector2Array()

func Exit():
	super.Enter()
	if character.showDebugVisual:
		polygon_2d.polygon = PackedVector2Array()
	

func Update():
	super.Update()
	character.UpdateAnimation()
	
	if character.global_position.distance_to(character.player.global_position) <= playerDetectionRadius:
		parentStateMachine.SwitchTo("Move")
		

func CreatePolygonCircle():
	var points = PackedVector2Array()
	
	for i in 36:
		var angle = deg_to_rad( i * 10)
		var pointVector2D = Vector2( cos(angle), sin(angle))
		pointVector2D *= playerDetectionRadius
		points.append(pointVector2D)
		
	polygon_2d.polygon = points
