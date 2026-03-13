extends Area2D
@onready var animated_sprite_2d = $AnimatedSprite2D




func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("bounce"):
			body.bounce()
	
		animated_sprite_2d.play("DIE")


func _on_animated_sprite_2d_animation_finished():
	queue_free() # Replace with function body.


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene() # Replace with function body.
