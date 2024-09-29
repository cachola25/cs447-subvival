extends CharacterBody2D

class_name torpedo
var SPEED = 1400.0

func _ready():
	$AnimatedSprite2D.play("firing")
	var submarine_scene = get_parent().get_node("submarine")
	var submarine_animation = submarine_scene.get_node("AnimatedSprite2D")
	var direction = Vector2(cos(submarine_animation.rotation),sin(submarine_animation.rotation))
	$AnimatedSprite2D.rotation = submarine_animation.rotation
	if not submarine_animation.flip_h:
		$AnimatedSprite2D.flip_h = true
		SPEED = -SPEED
	$torpedo_launch.play()
	velocity = direction * SPEED
	
func _process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		print(collision_info.get_collider())
