extends Control


@onready var o2_cost_node = $o2/o2_cost
@onready var o2_upgrade_progress = $o2/o2_upgrade_progress
@onready var armor_cost_node = $armor/armor_cost
@onready var armor_upgrade_progress = $armor/armor_upgrade_progress
@onready var health_cost_node = $health/health_cost
@onready var health_upgrade_progress = $health/health_upgrade_progress
@onready var luck_cost_node = $luck/luck_cost
@onready var luck_upgrade_progress = $luck/luck_upgrade_progress
@onready var total_money_node = get_parent().get_node("total_money")
@onready var oxygen_bar = get_parent().get_node("oxygen_bar")
@onready var health_bar = get_parent().get_node("health_bar")
@onready var submarine_scene = get_parent().get_parent()

signal luck_updated
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_if_valid_upgrade(cost_node, progress_bar):
	var cost = get_cost(cost_node)
	var total_money = get_cost(total_money_node)
	var result = total_money - cost
	var check = progress_bar.value + progress_bar.step
	if check > progress_bar.max_value:
		return -1
	return result
	
func update_labels_and_progress(cost_node, updated_total_money, cost_node_val, increment, progress_node):
	total_money_node.text = "$" + str(updated_total_money)
	cost_node.text = "$" + str(cost_node_val + increment)
	progress_node.value += progress_node.step

func get_cost(cost_node) -> int:
	return int(cost_node.text.substr(1))
	
func _on_upgrade_02_button_pressed() -> void:
	print("o2 button pressed")
	var result = check_if_valid_upgrade(o2_cost_node, o2_upgrade_progress)
	if (result < 0):
		return
	update_labels_and_progress(o2_cost_node, result, get_cost(o2_cost_node), 1, o2_upgrade_progress)
	
	# peform upgrade
	oxygen_bar.O2_REGENERATION_AMOUNT += oxygen_bar.BUBBLE_COST
	oxygen_bar.get_node("o2_regen_timer").wait_time -= 0.5

func _on_upgrade_armor_button_pressed() -> void:
	print("armor button pressed")
	var result = check_if_valid_upgrade(armor_cost_node, armor_upgrade_progress)
	if (result < 0):
		return
	update_labels_and_progress(armor_cost_node, result, get_cost(armor_cost_node), 2, armor_upgrade_progress)
	
	# perform upgrade
	submarine_scene.ARMOR += 1


func _on_upgrade_health_button_pressed() -> void:
	print("Health button pressed")
	var result = check_if_valid_upgrade(health_cost_node, health_upgrade_progress)
	if (result < 0):
		return
	update_labels_and_progress(health_cost_node, result, get_cost(health_cost_node), 3, health_upgrade_progress)
	
	health_bar.HEALTH_REGENERATION_AMOUNT += 5
	health_bar.get_node("health_regen_timer").wait_time -= 0.5

func _on_upgrade_luck_button_pressed() -> void:
	print("luck button pressed")
	var result = check_if_valid_upgrade(luck_cost_node, luck_upgrade_progress)
	if (result < 0):
		return
	update_labels_and_progress(luck_cost_node, result, get_cost(luck_cost_node), 10, luck_upgrade_progress)
	
	submarine_scene.LUCK += 0.2
	emit_signal("luck_updated", submarine_scene.LUCK)
