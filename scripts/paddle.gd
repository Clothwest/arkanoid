class_name Paddle extends CharacterBody2D

@export var move_speed: float = 500.0

var direction: float = 0.0

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")
	velocity.x = move_speed * direction
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision != null:
		var collider: = collision.get_collider()
		if collider is Ball:
			pass
