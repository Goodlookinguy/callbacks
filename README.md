callbacks
=========

Monkey Callbacks Module

The Async Callback module requires mojo and requires my [fixed version of skn3.arraylist](https://github.com/Goodlookinguy/arraylist) . It also requires you to call the function TryToUpdateAsyncCalls() at every update to attempt updating calls that don't need an immediate update. The async callback module uses FIFO for handling backed callbacks.
