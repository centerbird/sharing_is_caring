class_name LandingPage extends CanvasLayer
## This is the page that appears at the beginning of the game.
##
## This page contains some hints and instructions in the form of a poem.
## It also initializes the game.

## The script that will appear in the beginning of the game; each element appears on consecutive buttons.
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

# keeps track of parsing the [member intro_script]
var _slide = 1

## Signals the game to start
signal start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Introduction.text = intro_script[0]

# skips to the next text
# enables start game button, when necessary
func _on_next_text_button_up() -> void:
	$Introduction.text = intro_script[_slide]
	_slide += 1
	if _slide == 5:
		$IntroButton/NextTextButton.disabled = true
		$StartButtonImg.visible = true
		$StartButtonImg/StartButton.disabled = false

# starts the game
func _on_start_button_button_up() -> void:
	start.emit()
	$".".visible = false
	$StartButtonImg/StartButton.disabled = true
	queue_free()
