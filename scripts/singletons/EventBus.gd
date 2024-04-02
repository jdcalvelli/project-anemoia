extends Node

# INPUT EVENTS
signal analogClick(stick: InputManager.AnalogSticks)
signal analogRotate(stick: InputManager.AnalogSticks)
signal analogFlick(stick: InputManager.AnalogSticks)
signal rightBumperPress()

# AUDIO EVENTS
signal actionStarted()
signal actionCompleted()

# SHOT ACTION EVENTS
signal totalActionsCompleted()

# VFX EVENTS
signal shutterComplete()
