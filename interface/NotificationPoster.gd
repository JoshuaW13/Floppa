extends Control

var notificationQueue : Array = []
var isPosting = false
onready var notificationLabel = $notificationDisplayPath/PathFollow2D/TextureRect/Label
onready var notification = $notificationDisplayPath/PathFollow2D/TextureRect
onready var displayPath = $notificationDisplayPath/PathFollow2D

signal notification_added
signal notification_posting_finished

var speed = 0  # Control the speed at which the notifications move (in units per second)

func _ready() -> void:
	PlayerData.connect("character_unlocked", self, "on_character_unlocked")
	displayPath.unit_offset = 1  # Make sure the path starts from the beginning

func on_character_unlocked(text: String) -> void:
	notificationQueue.push_back(text)  # Add the new notification text to the queue
	emit_signal("notification_added")  # Emit signal to trigger the display of the notification

func _physics_process(delta: float) -> void:
	# Move the PathFollow2D node's offset along the path
	if speed != 0:
		displayPath.unit_offset += speed * delta
		calculate_alpha()

	# Loop the path when it reaches the end (offset >= 1)
	if displayPath.unit_offset >= 1:
		displayPath.unit_offset = 0  # Reset to the start of the path for the next notification
		speed = 0  # Stop moving after the notification has fully passed
		isPosting = false
		self.visible = false
		emit_signal("notification_posting_finished")

func _on_NotificationPoster_notification_added() -> void:
	start_posting_notification()

func calculate_alpha():
	var alpha = 1-displayPath.unit_offset
	print("The alpha is "+str(alpha))
	var new_color = notification.modulate
	new_color.a = alpha
	notification.modulate = new_color


func _on_NotificationPoster_notification_posting_finished() -> void:
	start_posting_notification()

func start_posting_notification():
	if notificationQueue.size() > 0 && !isPosting:
		isPosting = true
		notificationLabel.text = notificationQueue.pop_front()  # Get the next notification text
		self.visible = true  # Make the notification visible
		speed = 0.7  # Set a negative speed to move the notification to the left along the path
