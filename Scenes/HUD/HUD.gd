extends CanvasLayer

func printHearts():
	var remainingLifeToPrint = LinkData.link.heart
	var maxLifeToPrint = LinkData.link.heart_max
	while maxLifeToPrint > 0:
		var rect = TextureRect.new()
		if remainingLifeToPrint >= 1:
			rect.texture = load("Assets/HUD/Heart-full.png")
		else:
			if remainingLifeToPrint > 0:
				rect.texture = load("Assets/HUD/Heart-half.png")
			else:
				rect.texture = load("Assets/HUD/Heart-empty.png")
		$Control/GridContainer.add_child(rect)
		maxLifeToPrint -= 1
		remainingLifeToPrint -= 1
	

func _process(_delta):
	for n in $Control/GridContainer.get_children():
		$Control/GridContainer.remove_child(n)
		n.queue_free()
	printHearts()
