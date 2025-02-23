extends CanvasLayer

var intro_script = ["Lo! A village, proud yet lone,
Its fate rests on land of unknowns.",
"Beyond the hills, mist and pine,
Wilds stir and churn—dance of crones.",
"Shall all be fed, or shadows grow,
Will thou bring light, or deeper woe?",
"Maps yet blank, paths unseen,
Beyond the veil, beneath the snow.",
"When roads do cross, heed this sign,
Where doom or fortune intertwine."]
var slide = 1

## Signals the game to start
signal start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Introduction.text = intro_script[0]

# skips to the next text
func _on_next_text_button_up() -> void:
	$Introduction.text = intro_script[slide]
	slide += 1
	if slide == 5:
		$IntroButton/NextTextButton.disabled = true

# starts the game
func _on_start_button_button_up() -> void:
	start.emit()
	$".".visible = false
	$StartButtonImg/StartButton.disabled = true
	# Other game start code goes here
