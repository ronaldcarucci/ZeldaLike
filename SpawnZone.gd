extends Area2D

export (int) var COLUMN
export (int) var ROW

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawnEnemies():
	for i in range(0,Enemies.zone[ROW][COLUMN].size()):
		var enemy = Enemies.zone[ROW][COLUMN][i]
		var instance = enemy.type.instance()
		instance.position = enemy.position
		$Enemies.add_child(instance)

func freeEnemies():
	for n in $Enemies.get_children():
		$Enemies.remove_child(n)

func _on_SpawnZone_body_entered(body):
	if body.is_in_group("player"):
		call_deferred("spawnEnemies")

func _on_SpawnZone_body_exited(body):
	if body.is_in_group("player"):
		call_deferred("freeEnemies")
