extends Area2D

var skewTween : Tween
var skewTweenBack : Tween 

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_back: Sprite2D = $Sprite2D_Back

func _ready() -> void:
	var startSkew = deg_to_rad(randf_range(-10, -10))
	var endSkew = -startSkew
	
	skewTween = get_tree().create_tween().set_loops()
	skewTween.tween_property(sprite_2d, "skew", endSkew, 1.5).from(startSkew)
	skewTween.tween_property(sprite_2d, "skew", startSkew, 1.5).from(endSkew)

	var startSkewBack = endSkew * 0.5
	var end 
