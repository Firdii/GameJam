extends CanvasLayer

@onready var notification_label = %NotificationLabel
@onready var mask_rect = $MarginContainer/HBoxContainer/MaskTextureRect 


var mask_evolved_png = preload("res://Assets/Characters/mask-4044.png") 

func _ready():
	notification_label.modulate.a = 0
	
	add_to_group("PlayerUI")

func show_mask_notification():
	mask_rect.texture = mask_evolved_png
	
	var tween = create_tween()
	tween.tween_property(notification_label, "modulate:a", 1.0, 1.0)
	
	var tween_mask = create_tween()
	tween_mask.tween_property(mask_rect, "modulate", Color.GOLD, 0.2)
	tween_mask.tween_property(mask_rect, "modulate", Color.WHITE, 0.5)
	
	await get_tree().create_timer(3.0).timeout
	var tween_out = create_tween()
	tween_out.tween_property(notification_label, "modulate:a", 0.0, 1.0)
