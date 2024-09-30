extends CharacterBody2D

class_name submarine

const TOTAL_MONEY_FISH = 5
const UPGRADES_LIST = ["o2", "armor", "health", "luck"]

@onready var total_money = $CanvasLayer/total_money
@onready var oxygen_bar = $CanvasLayer/oxygen_bar
@onready var popup = preload("res://menu_scenes/popup_message/popup_message.tscn")
var ARMOR = 0
var SPEED = 10000
var LUCK = 0
var bubble_scene = load("res://submarine/bubble/bubble.tscn")
var torpedo_scene = load("res://submarine/torpedo/torpedo.tscn")
var discovered_fish = {} # This is a dict but will be used as a set
var defeated_enemy_fish = {}
var acceleration = 9000 
var friction = 0.9
var elapsed = 0.5
var gravity = Vector2(0,10)
var previous_direction = Vector2.ZERO
var previous_rotation = -100
var started_boss_fight = false
var displayed_popup = false

var nuxMode = false;

signal discovered_new
signal killed_new
signal start_boss_fight

func spawn_bubble():
	var bubble = bubble_scene.instantiate()
	var temp_position = position
	temp_position.y -= 30
	bubble.position = temp_position
	get_parent().add_child(bubble)
	oxygen_bar.value -= oxygen_bar.BUBBLE_COST
	
func display_final_compendium():
	if $CanvasLayer/enemy_fish_compendium.can_display:
		return true
	if discovered_fish.size() != TOTAL_MONEY_FISH:
		return false
	for upgrade in $CanvasLayer/upgrade_menu.get_children():
		if upgrade.name in UPGRADES_LIST:
			var progress_bar = upgrade.name+"_upgrade_progress"
			var progress_bar_node = upgrade.get_node(progress_bar)
			if not (progress_bar_node.value >= progress_bar_node.max_value):
				return false
	$CanvasLayer/enemy_fish_compendium.can_display = true
	return true
	
		
func display_user_menu():
	$CanvasLayer/fish_compendium.visible = true
	$CanvasLayer/upgrade_menu.visible = true
	$CanvasLayer/enemy_fish_compendium.visible = display_final_compendium()
	$CanvasLayer/upgrade_menu/torpedo.visible = display_final_compendium()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true
	
func undisplay_user_menu():
	$CanvasLayer/fish_compendium.visible = false
	$CanvasLayer/upgrade_menu.visible = false
	$CanvasLayer/enemy_fish_compendium.visible = false
	process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().paused = false
	if not displayed_popup and display_final_compendium():
		display_unlock_message()
		displayed_popup = true
	
func _ready():
	$AnimatedSprite2D.play("submarine_default")
	$CanvasLayer/upgrade_menu.visible = false
	$CanvasLayer/fish_compendium.visible = false
	$CanvasLayer/enemy_fish_compendium.visible = false
	$CanvasLayer/total_torpedos.visible = false
	
	
func is_submarine_destroyed():
	return $CanvasLayer/health_bar.value <= $CanvasLayer/health_bar.min_value
	
func apply_movement_rotation(direction: Vector2, delta):
	var target_rotation = 0
	if direction.length() > 0:
		target_rotation = direction.angle()
		target_rotation = wrapf(target_rotation, -PI, PI)
		var angle_difference = target_rotation - $AnimatedSprite2D.rotation
		angle_difference = wrapf(angle_difference + PI, 0, 2 * PI) - PI
		target_rotation = $AnimatedSprite2D.rotation + angle_difference
	else:
		target_rotation = $AnimatedSprite2D.rotation
	var rotation_speed = 5 * delta
	$AnimatedSprite2D.rotation = lerp($AnimatedSprite2D.rotation, target_rotation, rotation_speed)
	$AnimatedSprite2D.rotation = wrapf($AnimatedSprite2D.rotation, -PI, PI)
	if $AnimatedSprite2D.rotation > PI / 2 or $AnimatedSprite2D.rotation < -PI / 2:
			$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false
		
func display_unlock_message():
	var popup_instance = popup.instantiate()
	var viewport_size = get_viewport().get_visible_rect().size
	popup_instance.position = (viewport_size - popup_instance.size) / 2
	popup_instance.position = position + Vector2(0, -100)
	get_parent().add_child(popup_instance)
	
func get_total_torpedos():
	var total = int($CanvasLayer/total_torpedos/num_torpedos.text)
	return total
	
func update_total_torpedos(update_val):
	var total = get_total_torpedos()
	$CanvasLayer/total_torpedos/num_torpedos.text = str(total + update_val)
	
func check_if_boss_fight():
	if started_boss_fight:
		return
	if defeated_enemy_fish.size() != 3:
		return
	started_boss_fight = true
	emit_signal("start_boss_fight")
func _process(delta):
	if is_submarine_destroyed():
		var death_scene = load("res://menu_scenes/death_screen/death_screen.tscn").instantiate()
		get_tree().root.get_child(0).queue_free()
		get_tree().root.add_child(death_scene)
		
	var direction = Vector2.ZERO # (0,0d)
	if elapsed > 1:
		elapsed = 1
	if Input.is_action_just_pressed("display_user_menu"):
		if get_tree().paused:
			undisplay_user_menu()
		else:
			display_user_menu()
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
		#UNCOMMENT THIS TO TURN ON BUBBLE LIMITS
		if oxygen_bar.value >= oxygen_bar.BUBBLE_COST:
			spawn_bubble()
		#spawn_bubble()
	
	if direction.length() > 1:
		direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		velocity += direction * acceleration * delta
		velocity = velocity.limit_length(SPEED)
		if not $moving_sound.playing:
				$moving_sound.play()
	else:
		velocity += gravity
		if $moving_sound.playing:
			$moving_sound.stop()
		
	velocity *= friction
	
	apply_movement_rotation(direction, delta)
	if Input.is_action_just_pressed("fire_torpedo"):
		if get_total_torpedos() >= 1:
			fire_torpedo()
	check_if_boss_fight()
	
	if display_final_compendium():
		$CanvasLayer/total_torpedos.visible = true
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collider = collision_info.get_collider()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name.begins_with("captured_bubble"):
		var fish_type = body.get_meta("FISH_TYPE")
		if not fish_type in discovered_fish:
			discovered_fish[fish_type] = true
			body.get_node("new_fish_captured").play()
			set_meta("discovered_new_fish_type", fish_type)
			emit_signal("discovered_new")
			
		var curr_money = int(total_money.text.substr(1))
		curr_money += body.get_meta("FISH_VALUE")
		total_money.text = "$" + str(curr_money)
		body.get_node("AnimatedSprite2D").play("pop")
	elif body.name.begins_with("bubble"):
		body.get_node("AnimatedSprite2D").play("pop")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "damage_taken":
		$AnimatedSprite2D.play("submarine_default")
		
func fire_torpedo():
	var torpedo = torpedo_scene.instantiate()
	torpedo.position = position
	get_parent().add_child(torpedo)
	update_total_torpedos(-1)
	

func _on_nux_mode_button_button_down() -> void:
	nuxMode = !nuxMode

	if nuxMode:
		pass
