extends Area2D

var _direction = "right"
var _damage = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_direction(direction : String):
	_direction = direction
	match direction :
		"right":
			rotation_degrees = 0
			position.y += 1
			position.x += 12
		"left":
			rotation_degrees = 180
			position.y += 2
			position.x -= 12
		"up" :
			rotation_degrees = 270
			position.y -= 12
			position.x -= 2
		"down" :
			rotation_degrees = 90
			position.y += 12
			position.x += 2
		_:
			pass

func _on_Sword_body_entered(body):
	if body.is_in_group("ennemy"):
		match _direction :
			"right":
				body.setDirection("left")
			"left":
				body.setDirection("right")
			"up" :
				body.setDirection("down")
			"down" :
				body.setDirection("up")
		
		body.emit_signal("is_touched", _damage)
