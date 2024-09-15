extends Control


@onready var total_money_node = get_parent().get_node("total_money")
@onready var o2_cost_node = $o2/o2_cost
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_upgrade_02_button_pressed() -> void:
	var o2_cost = int(o2_cost_node.text.substr(1))
	var total_money = int(total_money_node.text.substr(1))
	var result = total_money - o2_cost
	if result < 0:
		return
	total_money_node.text = "$" + str(result)
	o2_cost_node.text = "$" + str(o2_cost + 1)
	print(result)
