extends Area2D



func _on_body_entered(body):
	if body.is_in_group("player"):   # لازم تضيف اللاعب لجروب "player"
		body.bounce()
 
 # Replace with function body.
