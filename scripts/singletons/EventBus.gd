extends Node

# INPUT EVENTS
signal analogClick(stick: InputManager.AnalogSticks)
signal analogRotate(stick: InputManager.AnalogSticks)
signal analogFlick(stick: InputManager.AnalogSticks)

# VIEW EVENTS
signal changeAnimState(animState: int)
