// gave it livesplit as a "dummy" process, since we don't need to read any memory
state("LiveSplit")
{
}

gameTime
{	
	// needed to put it in a var before livesplit would let me use .Ticks
	vars.RTA = timer.CurrentTime.RealTime;
	
	return TimeSpan.FromTicks((long)(vars.RTA.Ticks * (60.0 * 70224.0 / 4194304.0)));
} 