extends enemy_fish

class_name octopus

var SPEED = 800
var DAMAGE_DEALT = 90
var ocean_scene

signal hit_sub
signal despawned
signal hit_by_torpedo

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

enum State {
	CIRCLING,
	ATTACKING,
	RETURNING
}

var state = State.CIRCLING
var phase_timer = 0.0
var circling_duration = 5.0
var attacking_duration = 2.5
var circling_center = Vector2.ZERO
var circling_center_follow_speed = 2.0
var angle = 0.0
var circle_radius = 1000.0
var angular_speed = 2

var returning_duration = 1.5
func start(_transform, submarine_position, _SPEED, _DAMAGE_DEALT):
	global_transform = _transform
	SPEED = _SPEED
	DAMAGE_DEALT = _DAMAGE_DEALT
	ocean_scene = get_parent()
	enemy_fish_type = "octopus"
	state = State.CIRCLING
	phase_timer = 0.0
	angle = (global_position - submarine_position).angle()
	circling_center = submarine_position

func _physics_process(delta):
	if not ocean_scene:
		return
	var submarine_position = ocean_scene.get_meta("SUBMARINE_POSITION")
	circling_center = circling_center.lerp(submarine_position, circling_center_follow_speed * delta)
	phase_timer += delta
	
	if state == State.CIRCLING:
		if phase_timer >= circling_duration:
			state = State.ATTACKING
			phase_timer = 0.0
		else:
			angle += angular_speed * delta
			var offset = Vector2(cos(angle),sin(angle)) * circle_radius
			global_position = circling_center + offset
			look_at(submarine_position)
	elif state == State.ATTACKING:
		if phase_timer >= attacking_duration:
			state = State.RETURNING
			phase_timer = 0.0
		else:
			var direction = (submarine_position - global_position).normalized()
			velocity = direction * SPEED
			position += velocity * delta
			rotation = velocity.angle()
	elif state == State.RETURNING:
		var direction = (global_position - circling_center).normalized()
		var target_position = circling_center + (direction * circle_radius)
		var to_target = target_position - global_position
		var distance_to_target = to_target.length()
		
		if distance_to_target > 1:
			var move_distance = min(distance_to_target, SPEED  * delta)
			var move_direction = to_target.normalized()
			position += move_direction * move_distance
			rotation = move_direction.angle()
		else:
			state = State.CIRCLING
			phase_timer = 0.0
			angle = (global_position - circling_center).angle()
			

func _on_body_entered(body: Node2D) -> void:
	if body is submarine:
		body.get_node("AnimatedSprite2D").play("damage_taken")
		body.get_node("CanvasLayer/health_bar").value -= (DAMAGE_DEALT - body.ARMOR)
	elif body is torpedo:
		if state == State.ATTACKING:
			$octopus_health_bar.value -= $octopus_health_bar.step
		body.queue_free()
		
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
