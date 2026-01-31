extends "res://Game/Script/StateMachine/State.gd"


func Enter(_msg := {}):
	character.isDead = true
	print("Player mati, memutar animasi die...")
	
	character.UpdateAnimation()
	
	character.velocity = Vector2.ZERO
	
	_handle_death()

func _handle_death():
	await get_tree().create_timer(2.0).timeout
	
	get_tree().reload_current_scene()
	
