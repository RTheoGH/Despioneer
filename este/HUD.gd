extends CanvasLayer

@export var score_label = Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_score(278)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score_label.text = "SCORE : " + create_score(PlayerInfo.score)

func create_score(score) -> String:
	var base = ""
	var new_score = str(score)
	for i in 5:
		if i - (4 - (new_score.length() -1)) >= 0:
			base += new_score[i-(4 - (new_score.length() -1))]
		else :
			base += "0"
	return base
