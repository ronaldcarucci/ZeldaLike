extends KinematicBody2D

signal is_touched_signal

var _speed = 100
var _direction = 'up'
var _state = 'idle'
var _is_attacking = false
var _attack_speed = 0.25
var _stun_speed = 0.2
var _sword_scene = preload("res://Scenes/Sword/Sword.tscn")
var _sword_instance = null
var _is_stun = false

func getInput():
	var actions = {
		'left' : false,
		'right' : false,
		'up' : false,
		'down' : false,
		'attack' : false
	}
	if Input.is_action_just_pressed("ui_select"):
		actions.attack = true
	else:
		if Input.is_action_pressed("ui_down"):
			actions.down = true
		if Input.is_action_pressed("ui_right"):
			actions.right = true
		if Input.is_action_pressed("ui_left"):
			actions.left = true
		if Input.is_action_pressed("ui_up"):
			actions.up = true
	return actions

# Called when the node enters the scene tree for the first time.
func _ready():
	LinkData.link.heart = LinkData.link.heart_max
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var actions = getInput()
	var velocity = Vector2.ZERO
	var collised = null
	if (!_is_stun):
		if !actions.attack && !_is_attacking:
			_state = 'idle'
			if actions.down && !actions.up:
				velocity.y += _speed
				_state = 'walk'
				_direction = 'down'
			if actions.up && !actions.down:
				velocity.y -= _speed
				_state = 'walk'
				_direction = 'up'
			if actions.left && !actions.right:
				velocity.x -= _speed
				_state = 'walk'
				_direction = 'left'
			if actions.right && !actions.left:
				velocity.x += _speed
				_state = 'walk'
				_direction = 'right'
			collised = move_and_collide(velocity * delta)
			if collised != null:
				if (collised as KinematicCollision2D).collider.is_in_group("ennemy"):
					emit_signal("is_touched_signal", (collised as KinematicCollision2D).collider._damage)
			$AnimatedSprite.play(_state+"-"+_direction)
		else:
			if !_is_attacking:
				_sword_instance = _sword_scene.instance()
				_sword_instance.set_direction(_direction)
				$Weapon.add_child(_sword_instance)
				_is_attacking = true
				_state = 'attack'
				$AnimatedSprite.play(_state+"-"+_direction)
				$SlashSoundEffect.play()
				$Timer.start(_attack_speed)
	else:
		$AnimatedSprite.visible = !$AnimatedSprite.visible
		match _direction:
			"right":
				velocity.x -= 1.5 * _speed
			"left":
				velocity.x += 1.5 * _speed
			"up" :
				velocity.y += 1.5 * _speed
			"down" :
				velocity.y -= 1.5 * _speed
			_:
				pass
		var _t = move_and_collide(velocity * delta)


func _on_Timer_timeout():
	if _is_attacking:
		$Weapon.remove_child(_sword_instance) 
		_sword_instance = null
		_is_attacking = false
		_state = 'idle'
		$AnimatedSprite.play(_state+"-"+_direction)


func _on_Link_is_touched_signal(damage, direction = null):
	if !_is_stun:
		match direction:
			"right" :
				_direction = "left"
			"left" :
				_direction = "right"
			"up" :
				_direction = "down"
			"down" :
				_direction = "up"
			null:
				pass
		_state = 'idle'
		if LinkData.link.heart <= 2:
			$LowLifeSoundEffect.play()
		LinkData.link.heart -= damage
		$AnimatedSprite.play(_state+"-"+_direction)
		$HurtSoundEffect.play()
		$Timer2.start(_stun_speed)
		_is_stun = true
	
	if LinkData.link.heart < 1:
		var _e = get_tree().change_scene("res://Scenes/World/Test.tscn")


func _on_Timer2_timeout():
	_is_stun = false
	$AnimatedSprite.visible = true
