extends CanvasLayer

export (String) var TEXT 

var _is_start = false
var _is_printing = false

func _ready():
	pass # Replace with function body.

func startDialog():
	$Control/RichTextLabel.visible = true
	$Control/RichTextLabel.text = TEXT.to_upper()
	$Control/RichTextLabel.visible_characters = 0
	$Control/RichTextLabel.percent_visible = 0
	_is_start = true

func endDialog():
	$Control/RichTextLabel.visible = false
	_is_start = false
	LinkData.is_reading = false

func _process(_delta):
	if _is_start:
		if !_is_printing:
			if $Control/RichTextLabel.percent_visible < 1:
				_is_printing = true
				$Timer.start(0.1)
				$LetterInsertSoundEffect.play()
			else:
				if Input.is_action_just_pressed("ui_select"):
					endDialog()

func _on_Timer_timeout():
	$Control/RichTextLabel.visible_characters += 1
	
	_is_printing = false
