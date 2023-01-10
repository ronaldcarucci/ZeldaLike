extends KinematicBody2D

var _speed = 150
var _direction = "right"
var _damage = 1

func set_damage(damage : int):
	_damage = damage


func set_direction(direction : String):
	_direction = direction
	match direction :
		"right":
			rotation_degrees = 90
			position.y += 1
			position.x += 12
		"left":
			rotation_degrees = 270
			position.y += 2
			position.x -= 12
		"up" :
			rotation_degrees = 0
			position.y -= 12
			position.x -= 2
		"down" :
			rotation_degrees = 180
			position.y += 12
			position.x += 2
		_:
			pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !LinkData.is_reading:
		var velocity = Vector2.ZERO
		match _direction:
			"down" :
				velocity.y += _speed
			"up" :
				velocity.y -= _speed
			"left" :
				velocity.x -= _speed
			"right" :
				velocity.x += _speed
				
		var collised = move_and_collide(velocity * delta)
		if collised != null:
			if (collised as KinematicCollision2D).collider.is_in_group("player"):
				(collised as KinematicCollision2D).collider.emit_signal("is_touched_signal", _damage, _direction)
			queue_free()
