extends AnimatedSprite2D
	
func PlayAnim(animName):
	if(animName == "Stop"):
		set_frame_and_progress(0, 0)
	else:
		play(animName)
