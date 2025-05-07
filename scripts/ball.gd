class_name Ball extends CharacterBody2D

signal tile_collided(global_pos: Vector2, normal: Vector2, layer: TileMapLayer)

@export var move_speed: float = 500.0

func _ready() -> void:
	velocity = Vector2(0.0, move_speed)
	pass

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if  collision != null:
		var remainder: Vector2 = collision.get_remainder()
		remainder = remainder.bounce(collision.get_normal())
		move_and_collide(remainder)
		var collider: = collision.get_collider() as TileMapLayer
		if collider is TileMapLayer:
			tile_collided.emit(collision.get_position(), collision.get_normal(), collider)
		velocity = velocity.bounce(collision.get_normal())
		var self_tangent_velocity: Vector2 = velocity.slide(collision.get_normal())
		var collider_tangent_velocity: Vector2 = collision.get_collider_velocity().slide(collision.get_normal())
		if self_tangent_velocity.dot(collider_tangent_velocity) <= 0:
			velocity += collision.get_collider_velocity().slide(collision.get_normal())
		velocity = velocity.normalized() * move_speed
