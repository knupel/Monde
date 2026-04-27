/**
MISC
v 0.0.6
*/
/**
stop trhead draw by using loop and noLoop()
*/
boolean freeze_is ;
void freeze() {
	freeze_is = (freeze_is)? false:true ;
	if (freeze_is)  {
		noLoop();
	} else {
		loop();
	}
}