extends enemy_fish

class_name octopus

var SPEED = 500
var DAMAGE_DEALT = 90
var ocean_scene
signal hit_sub
signal despawned
signal hit_by_torpedo

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func start(_transform, submarine_position, _SPEED, _DAMAGE_DEALT):
	global_transform = _transform
	var direction = (submarine_position - global_position).normalized()
	SPEED = _SPEED
	DAMAGE_DEALT = _DAMAGE_DEALT
	velocity = direction * SPEED
	ocean_scene = get_parent()
	enemy_fish_type = "octopus"

func _physics_process(delta):
	if not ocean_scene:
		return
	var submarine_position = ocean_scene.get_meta("SUBMARINE_POSITION")
	var direction = (submarine_position - global_position).normalized()
	velocity = direction * SPEED
	rotation = velocity.angle()
	position += SPEED * Vector2.RIGHT.rotated(rotation) * delta
	look_at(submarine_position)

func _on_body_entered(body: Node2D) -> void:
	if body is submarine:
		body.get_node("AnimatedSprite2D").play("damage_taken")
		body.get_node("CanvasLayer/health_bar").value -= (DAMAGE_DEALT - body.ARMOR)
	elif body is torpedo:
		$octopus_health_bar.value -= $octopus_health_bar.step
		body.queue_free()
		
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
