extends CharacterBody2D

@export var speed: float = 50
@export var move_direction: int = -1
var is_dead: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_area: Area2D = $DeathArea
@onready var ray_left: RayCast2D = $RayCastLeft
@onready var ray_right: RayCast2D = $RayCastRight

func _ready():
	death_area.body_entered.connect(_on_death_area_body_entered)
	sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	if is_dead:
		return

	velocity.x = move_direction * speed
	move_and_slide()

	sprite.flip_h = (move_direction == -1)

	if not sprite.is_playing():
		sprite.play("walk")

	# انعكاس الاتجاه بالجدار
	if move_direction == -1 and ray_left.is_colliding():
		flip_direction()
	elif move_direction == 1 and ray_right.is_colliding():
		flip_direction()

func flip_direction():
	move_direction *= -1
	velocity.x = 0

func _on_death_area_body_entered(body):
	print("DeathArea touched by:", body.name)  # Debug
	if body.is_in_group("player"):
		print("Player killed enemy!")  # Debug
		die()
		if body.has_method("bounce"):
			body.bounce()

func die():
	if is_dead:
		return
	is_dead = true
	sprite.play("die")
	$CollisionShape2D.disabled = true
	$DeathArea.monitoring = false
	velocity = Vector2.ZERO

func _on_animation_finished():
	if is_dead:
		queue_free()


