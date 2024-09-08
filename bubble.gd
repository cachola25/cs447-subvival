extends CharacterBody2D

const SPEED = 800

# Bubble should move upwards
func _ready():
	velocity = Vector2.ZERO
	velocity.y = -SPEED  # Set the bubble to move upwards

func _process(delta):
	#position += velocity * delta  # Move the bubble upwards
	var collision_info = move_and_collide(velocity * delta)
