extends CharacterBody2D

######################################
# Controls the subamrine's movements 
# actions
# A submarine should only collide with and do:
#		- eel —> take damage
#		- rocks —> collide regularly
######################################
class_name submarine

@onready var total_money = $CanvasLayer/total_money
var SPEED = 2000
var bubble_scene = load("res://bubble.tscn")
var curr_score = 0

func spawn_bubble():
	var bubble = bubble_scene.instantiate()
	var temp_position = position
	temp_position.y -= 30
	bubble.position = temp_position
	get_parent().add_child(bubble)
	
func display_upgrade_menu():
	$CanvasLayer/upgrade_menu.visible = true
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true
	
func undisplay_upgrade_menu():
	$CanvasLayer/upgrade_menu.visible = false
	process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().paused = false
	
func _ready():
	$AnimatedSprite2D.play("submarine_default")
	$CanvasLayer/upgrade_menu.visible = false
	
func _process(delta):
	var direction = Vector2.ZERO # (0,0d)
	$AnimatedSprite2D.rotation = 0
	
	if Input.is_action_just_pressed("display_upgrade_menu"):
		if get_tree().paused:
			undisplay_upgrade_menu()
		else:
			display_upgrade_menu()
	if get_tree().paused:
		return
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


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name.begins_with("captured_bubble"):
		curr_score += body.get_meta("FISH_VALUE")
		total_money.text = "$" + str(curr_score)
	elif body.name.begins_with("bubble"):
		body.get_node("AnimatedSprite2D").play("pop")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "damage_taken":
		$AnimatedSprite2D.play("submarine_default")
