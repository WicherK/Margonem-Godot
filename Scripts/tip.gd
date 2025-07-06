extends Panel
class_name Tip

var name_text : String
var boss_status_text : String
var level_text : String

@onready var name_label = $VBoxContainer/Name_Label
@onready var boss_status_label = $VBoxContainer/Boss_status_Label
@onready var level_label = $VBoxContainer/Level_Label

@onready var container = $VBoxContainer

func _process(delta: float) -> void:
	name_label.text = name_text
	
	if boss_status_text == "":
		boss_status_label.visible = false;
		
	if level_text == "":
		level_label.visible = false;
		
	boss_status_label.text = boss_status_text
	level_label.text = level_text
