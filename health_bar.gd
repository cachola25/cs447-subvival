extends ProgressBar

var HEALTH_REGENERATION_RATE = 5
var HEALTH_REGENERATION_AMOUNT = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 0, 0)
	add_theme_stylebox_override("fill", style)
	$health_regen_timer.wait_time = HEALTH_REGENERATION_RATE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if value >= max_value:
		if not $health_regen_timer.is_stopped():
			$health_regen_timer.stop()
	else:
		if $health_regen_timer.is_stopped():
			$health_regen_timer.start()


func _on_health_regen_timer_timeout() -> void:
	if value >= max_value:
		return
	value += HEALTH_REGENERATION_AMOUNT
