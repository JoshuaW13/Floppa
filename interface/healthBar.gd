extends HBoxContainer

var heartScene = preload("res://interface/Heart.tscn")
var healthBar = Array()

func _ready() -> void:
	var playerHealth = PlayerData.health
	print("The player health is "+str(playerHealth))
	for i in range(playerHealth):
		healthBar.append(heartScene.instance())
		add_child(healthBar[-1])

func _on_PLayer_health_update(health) -> void:
	print("The health in here is "+str(health))
	if health ==0:
		queue_free()
	elif health < healthBar.size():
		for i in range(healthBar.size()):
			if i >= health:
				remove_child(healthBar[health])
				healthBar.remove(health)
	
