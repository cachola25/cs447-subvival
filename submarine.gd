extends CharacterBody2D

######################################
# Controls the subamrine's movements 
# actions
# A submarine should only collide with and do:
#		- eel —> take damage
#		- rocks —> collide regularly
######################################

var SPEED = 2000
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
	$AnimatedSprite2D.rotation = 0
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
		
	if direction.length() > 0:
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = false
		elif direction.x > 0:
			$AnimatedSprite2D.flip_h = true
		elif direction.x == 0:
			if $AnimatedSprite2D.flip_h:
				if direction.y < 0:
					$AnimatedSprite2D.rotation = -PI/2
				elif direction.y > 0:
					$AnimatedSprite2D.rotation = PI/2
			else:
				if direction.y < 0:
					$AnimatedSprite2D.rotation = PI/2
				elif direction.y > 0:
					$AnimatedSprite2D.rotation = -PI/2
		if direction.x != 0 and direction.y != 0:
			if direction.x < 0:
				$AnimatedSprite2D.rotation = direction.angle() - PI
			else:
				$AnimatedSprite2D.rotation = direction.angle()
	
	var collision_info = move_and_collide(direction * SPEED * delta)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider is eel:
			collider.hit_sub = true
