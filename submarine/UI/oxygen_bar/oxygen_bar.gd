extends ProgressBar

var BUBBLE_COST = 5
var O2_REGENERATION_RATE = 3
var O2_REGENERATION_AMOUNT = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 1)
	add_theme_stylebox_override("fill", style)
	$o2_regen_timer.wait_time = O2_REGENERATION_RATE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
	

func _on_o_2_regen_timer_timeout() -> void:
	if value >= max_value:
		return
	value += O2_REGENERATION_AMOUNT


func _on_upgrade_menu_infinite() -> void:
	value = 100
