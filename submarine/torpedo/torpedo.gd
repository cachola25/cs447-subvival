extends CharacterBody2D

class_name torpedo

@onready var explosion_sound = preload("res://submarine/torpedo/explosion.tscn")
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
		if collision_info.get_collider() is rocks:
			get_tree().current_scene.add_child(explosion_sound.instantiate())
			queue_free()
