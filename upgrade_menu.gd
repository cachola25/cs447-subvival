extends Control


@onready var total_money_node = get_parent().get_node("total_money")
@onready var o2_cost_node = $o2/o2_cost
@onready var o2_upgrade_progress = $o2/o2_upgrade_progress
@onready var oxygen_bar = get_parent().get_node("oxygen_bar")
@onready var armor_cost_node = $armor/armor_cost
@onready var armor_upgrade_progress = $armor/armor_upgrade_progress
@onready var submarine_scene = get_parent().get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_if_valid_upgrade(cost_node, progress_bar):
	var cost = get_cost(cost_node)
	var total_money = int(total_money_node.text.substr(1))
	var result = total_money - cost
	var check = progress_bar.value + progress_bar.step
	if check > progress_bar.max_value:
		return -1
	return result
	
func update_labels_and_progress(cost_node, updated_total_money, cost_node_val, progress_node):
	total_money_node.text = "$" + str(updated_total_money)
	cost_node.text = "$" + str(cost_node_val + 1)
	progress_node.value += progress_node.step

func get_cost(cost_node) -> int:
	return int(cost_node.text.substr(1))
	
func _on_upgrade_02_button_pressed() -> void:
	print("o2 button pressed")
	var result = check_if_valid_upgrade(o2_cost_node, o2_upgrade_progress)
	if (result < 0):
		return
	update_labels_and_progress(o2_cost_node, result, get_cost(o2_cost_node), o2_upgrade_progress)
	
	# peform upgrade
	oxygen_bar.O2_REGENERATION_AMOUNT += oxygen_bar.BUBBLE_COST
	oxygen_bar.get_node("o2_regen_timer").wait_time -= 0.5

func _on_upgrade_armor_button_pressed() -> void:
	print("armor button pressed")
	var result = check_if_valid_upgrade(armor_cost_node, armor_upgrade_progress)
	if (result < 0):
		return
	update_labels_and_progress(armor_cost_node, result, get_cost(armor_cost_node), armor_upgrade_progress)
	
	# perform upgrade
	submarine_scene.ARMOR += 1


func _on_upgrade_health_button_pressed() -> void:
	print("Health button pressed")
