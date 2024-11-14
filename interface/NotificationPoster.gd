extends Control

var notificationQueue : Array = []
onready var notificationLabel = $TextureRect/Label
signal notification_added

func _ready() -> void:
	PlayerData.connect("character_unlocked", self, "on_character_unlocked")

func on_character_unlocked(text):
	notificationQueue.push_back(text);
	emit_signal("notification_added")


func _on_NotificationPoster_notification_added() -> void:
	self.visible = true;
	notificationLabel.text = notificationQueue.pop_front()
	
