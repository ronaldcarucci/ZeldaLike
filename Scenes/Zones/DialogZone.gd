extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_DialogZone_body_entered(body):
	if body.is_in_group("player"):
		LinkData.is_reading = true
		$Dialog.startDialog()
