extends CharacterBody2D

const SPEED = 800
signal capture_fish
# Bubble should move upwards
func _ready():
	velocity = Vector2.ZERO
	velocity.y = -SPEED  # Set the bubble to move upwards

func _process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if (collision_info.get_collider() is money_fish):
			emit_signal("capture_fish")
