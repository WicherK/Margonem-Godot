extends Panel

var character_name: String
var boss_status: String
var level: String

@onready var character_name_label = $VBoxContainer/Name_Label
@onready var boss_status_label = $VBoxContainer/Boss_Status_Label
@onready var level_label = $VBoxContainer/Level_Label

func _ready() -> void:
	character_name_label.text = character_name
	boss_status_label.text = boss_status
	level_label.text = level + " level"
	
	if boss_status == "": boss_status_label.visible = false
	if level == "": level_label.visible = false
