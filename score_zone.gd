extends Area2D

var score_tracker
var curr_score = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_tracker = get_parent().get_node("score_tracker")
	score_tracker.text = "$" + str(curr_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("fish_captured"):
		curr_score += 1
		score_tracker.text = "$" + str(curr_score)
