/*
* Trace dirty nif scheduling overhead
* the overhead is defined as = schedule dirty nif + dirty nif finalizer
* Taken mostly from: https://medium.com/@jlouis666/erlang-dirty-scheduler-overhead-6e1219dcc7
*
* To run:
* - Get the pid of your beam process: `ps aux | grep beam.smp`
* - sudo dtrace -q -s bench/trace_dirty_nif.d -p <beam pid>
*
* In your iex session run the function that you want to trace
* 
*/

pid$target:beam.smp:static_schedule_dirty_cpu_nif:return
{
	s = timestamp;
}

pid$target:beam.smp:erts_call_dirty_nif:entry
/s != 0/
{
	@SchedTime = lquantize(timestamp - s, 0, 10000, 250);
	s = 0;
  e = timestamp
}

pid$target:beam.smp:erts_call_dirty_nif:return
/e != 0/
{
	@ExecTime = lquantize(timestamp - e, 10000, 100000, 250);
	e = 0;
	r = timestamp;
}

pid$target:beam.smp:dirty_nif_finalizer:entry
/r != 0/
{
	@ReturnTime = lquantize(timestamp - r, 0, 10000, 250);
	r = 0;
}

END
{
	printa("Scheduling overhead (nanos):%@d\n", @SchedTime);
	printa("Return overhead (nanos):%@d\n", @ReturnTime);
	printa("Execution time (nanos):%@d\n", @ExecTime);
}
