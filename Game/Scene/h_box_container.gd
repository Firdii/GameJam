extends HBoxContainer

func _ready() -> void:
	await get_tree().process_frame
	var player = get_tree().root.find_child("Player", true, false)
	if player:
		if not player.health_changed.is_connected(update_hearts):
			player.health_changed.connect(update_hearts)
		update_hearts(player.currentHealth, player.maxHealth)

func update_hearts(current: int, _max: int):
	var all_nodes = get_children() 
	
	var heart_nodes = []
	
	for node in all_nodes:
		if not node is TextureRect:
			heart_nodes.append(node)
	
	for i in range(heart_nodes.size()):
		var sprite = heart_nodes[i].find_child("Sprite2D", true)
		if sprite:
			var heart_value = (i + 1) * 2
			
			if current >= heart_value:
				sprite.frame = 0 
			elif current == heart_value - 1:
				sprite.frame = 1 
			else:
				sprite.frame = 2 
