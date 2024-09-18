extends CharacterBody2D
######################################
# Handles how the bubble should interact
# with the other entities and environment
# A bubble should only collide with and do:
#		- money_fish —> capture fish
#		- rocks —> pop and exit from scene
# A captured_fish bubble should only collide with and do:
#		- rocks —> pop and exit from scene
######################################

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
		if (collider is Fish
		and $AnimatedSprite2D.animation == "bubble"):
			var animation = "captured_" + collider.fish_type
			collision_layer = 0b100000
			collision_mask = 0b10000
			collider.in_bubble = true
			name = "captured_bubble"
			$AnimatedSprite2D.play(animation)
			set_meta("FISH_VALUE", collider.VALUE)
			set_meta("FISH_TYPE", collider.fish_type)
		elif (collider is rock):
			$AnimatedSprite2D.play("pop")

func _on_animated_sprite_2d_animation_finished() -> void:
	if ($AnimatedSprite2D.animation == "pop"):
		queue_free()
