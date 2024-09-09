extends CharacterBody2D

const SPEED = 800
signal fish_captured

# Bubble should move upwards
func _ready():
	$AnimatedSprite2D.play("bubble")
	velocity = Vector2.ZERO
	velocity.y = -SPEED  # Set the bubble to move upwards

func _process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collider = collision_info.get_collider()
		if (collider is money_fish 
		and $AnimatedSprite2D.animation == "bubble"):
			collision_layer = 3
			collision_mask = 1
			$AnimatedSprite2D.play("fish_captured")
			collider.in_bubble = true
		elif (collider is rock):
			$AnimatedSprite2D.play("pop")

func _on_animated_sprite_2d_animation_finished() -> void:
	if ($AnimatedSprite2D.animation == "pop"):
		queue_free()
