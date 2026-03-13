extends Area2D

@onready var top_detector: Area2D = $TopDetector
var is_dead = false

func _ready():
	body_entered.connect(_on_body_entered)
	top_detector.body_entered.connect(_on_top_detector_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	if body.is_in_group("Player"):
		get_tree().reload_current_scene()

func _on_top_detector_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	if body.is_in_group("Player"):
		is_dead = true
		queue_free()
		if body.has_method("bounce"):
			body.bounce()
