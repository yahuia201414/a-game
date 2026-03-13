
extends Area2D

# يتم استدعاؤه عندما يدخل جسم منطقة السلم
func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.on_ladder = true

# يتم استدعاؤه عندما يخرج جسم من منطقة السلم
func _on_body_exited(body):
	if body.is_in_group("Player"):
		body.on_ladder = false
