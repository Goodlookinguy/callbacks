
Import callbacks
Import mojo
#ASYNC_CALLBACKS = True

#If ASYNC_CALLBACKS
Global asyncBacklogID := New ArrayList<Int>()
Global asyncBacklogSource := New ArrayList<Object>()
Global asyncBacklogData := New ArrayList<Object>()
Global minimumCallThreshold:Int = 5
Global maxFrameTimeThreshold:Int = 3
#EndIf

'Summary: Sets the minimum number of callbacks to fire per frame.
Function SetAsyncMinimumCallbackThreshold:Void( minimumCalls:Int )
	#If ASYNC_CALLBACKS
	minimumCallThreshold = Max(minimumCalls, 1)
	#EndIf
End

'Summary: Sets the max time that async calls can be made this frame. The number should be low. A number between 3 and 6 is good.
Function SetAsyncMaxFrameTime:Void( maxTime:Int )
	#If ASYNC_CALLBACKS
	maxFrameTimeThreshold = Clamp(maxTime, 1, 1000)
	#EndIf
End

'Summary: Attempts as many async calls as the threshold allows this frame. This is required for async calls to work.
Function TryToUpdateAsyncCalls:Void()
	#If ASYNC_CALLBACKS
	If asyncBacklogID.count = 0 Then Return
	
	Local startTime:Int = Millisecs()
	Local itemsFired:Int = 0
	Local id:Int, source:Object, data:Object
	
	While asyncBacklogID.count > 0
		id = asyncBacklogID.RemoveFirst()
		source = asyncBacklogSource.RemoveFirst()
		data = asyncBacklogData.RemoveFirst()
		
		FireCallback(id, source, data)
		itemsFired += 1
		
		If itemsFired >= minimumCallThreshold
			If (Millisecs() - startTime) >= maxFrameTimeThreshold
				Exit
			End
		End
	End
	
	#EndIf
End

Function FireAsyncCallback:Void(id:Int, source:Object, data:Object)
	asyncBacklogID.AddLast(id)
	asyncBacklogSource.AddLast(source)
	asyncBacklogData.AddLast(data)
End

Function FireAsyncCallback:Void(id:Int, source:Object)
	FireAsyncCallback(id, source, Null)
End

Function FireAsyncCallback:Void(id:Int, source:Object, data:String)
	FireAsyncCallback(id, source, BoxString(data))
End

Function FireAsyncCallback:Void(id:Int, source:Object, data:Bool)
	FireAsyncCallback(id, source, BoxBool(data))
End

Function FireAsyncCallback:Void(id:Int, source:Object, data:int)
	FireAsyncCallback(id, source, BoxInt(data))
End

Function FireAsyncCallback:Void(id:Int, source:Object, data:Float)
	FireAsyncCallback(id, source, BoxFloat(data))
End

