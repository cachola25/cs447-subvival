extends CharacterBody2D


const SPEED = 500
var bubble_scene = load("res://bubble.tscn")

func spawn_bubble():
	var bubble = bubble_scene.instantiate()
	var temp_position = position
	temp_position.y -= 30
	bubble.position = temp_position
	get_parent().add_child(bubble)
	
func _ready():
	pass
	
func _process(delta):
	var direction = Vector2.ZERO # (0,0d)
	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_just_pressed("release_bubble"):
		spawn_bubble()
	
	if direction.length() > 1:
		direction = direction.normalized()
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = true
	elif direction.x < 0: 
		$AnimatedSprite2D.flip_h = false
	
	move_and_collide(direction * SPEED * delta)
