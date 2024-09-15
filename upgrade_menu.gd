extends Control


@onready var total_money_node = get_parent().get_node("total_money")
@onready var o2_cost_node = $o2/o2_cost
@onready var oxygen_bar = get_parent().get_node("oxygen_bar")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_upgrade_02_button_pressed() -> void:
	print("o2 button pressed")
	var o2_cost = int(o2_cost_node.text.substr(1))
	var total_money = int(total_money_node.text.substr(1))
	var result = total_money - o2_cost
	var check = $o2/o2_upgrade_progress.value + $o2/o2_upgrade_progress.step
	if result < 0 or check > $o2/o2_upgrade_progress.max_value:
		return
	total_money_node.text = "$" + str(result)
	o2_cost_node.text = "$" + str(o2_cost + 1)
	$o2/o2_upgrade_progress.value += $o2/o2_upgrade_progress.step
	
	oxygen_bar.O2_REGENERATION_AMOUNT += oxygen_bar.BUBBLE_COST
	oxygen_bar.get_node("o2_regen_timer").wait_time -= 0.5
	oxygen_bar.flag2 = true


func _on_upgrade_armor_button_pressed() -> void:
	print("armor button pressed")
