extends KinematicBody2D

signal is_touched

var _life = 6
var _damage = 1
var _direction = "down"
var _is_moving = false
var _move_started = false
var _move_end = false
var _move_time = 1
var _speed = 25
var _rock_scene = preload("res://Scenes/Enemies/OctorokRock.tscn")
var _is_attacking = false
var _is_touched = false

func setDirection(direction):
	_direction = direction

func _process(delta):
	if !LinkData.is_reading:
		if _life > 0 && !_is_touched:
			if !_move_started:
				_move_end = false
				if !_is_moving:
					match randi()%6+1:
						3:
							_is_attacking = true
					if !_is_attacking:
						_is_moving = true
						match randi()%4+1:
							1:
								_direction = "down"
							2:
								_direction = "up"
							3:
								_direction = "left"
							4:
								_direction = "right"
						$AnimatedSprite.play(_direction)
						$Timer.start(rand_range(0.5,2))
					else:
						$AnimatedSprite.play("attack-"+_direction)
				else:
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
			else:
				if !_move_end:
					_move_end = true
					$Timer2.start(rand_range(0.25,1))
		else:
			if _is_touched:
				var velocity = Vector2.ZERO
				match _direction:
					"down" :
						velocity.y -= 150
					"up" :
						velocity.y += 150
					"left" :
						velocity.x += 150
					"right" :
						velocity.x -= 150
				var _collised = move_and_collide(velocity * delta)
				if $AnimatedSprite.modulate == Color("#ff0000"):
					$AnimatedSprite.modulate = Color("#ffffff")
				else:
					$AnimatedSprite.modulate = Color("#ff0000")
	else:
		$AnimatedSprite.playing = false
		_move_started = false

func _ready():
	if _life <= 0:
		emit_signal("is_touched", 0)

func _on_Octorok_is_touched(damage):
	if !_is_touched:
		_life -= damage
		if _life > 0:
			_is_touched = true
			$Timer3.start(0.25)
			$HurtSoundEffect.play()
		else:
			$AnimatedSprite.play("death")
			$DieSoundEffect.play()

func _on_DieSoundEffect_finished():
	queue_free()

func _on_Timer_timeout():
	_move_started = true

func _on_Timer2_timeout():
	_move_started = false
	_is_moving = false
	$Timer2.stop()


func _on_AnimatedSprite_animation_finished():
	if _is_attacking:
		_is_attacking = false
		var rockInstance = _rock_scene.instance()
		rockInstance.position = position
		rockInstance.set_direction(_direction)
		rockInstance.set_damage(_damage)
		$Rocks.add_child(rockInstance)


func _on_Timer3_timeout():
	_is_touched = false
	$AnimatedSprite.modulate = Color("#ffffff")
