/* 
 * sporthem.cpp
 * Play Sporth scripts through emscipten.
 */
#include <assert.h>
#include <stdint.h>
#include <emscripten.h>

extern "C" {
	#include "soundpipe.h"
	#include "sporth.h"
	#include "plumber.h"

	int buffer_frames;
	float* buffer;
	float* bufferst;
	float outL, outR;
	plumber_data pd;
	sp_data *sp;
	bool compiled;

	static void process(sp_data *sp, void *udp)
	{
		plumber_data *pd = (plumber_data *)udp;
		plumber_compute(pd, PLUMBER_COMPUTE);
		outL = sporth_stack_pop_float(&pd->sporth.stack);
	}

	static void process_stereo(sp_data *sp, void *udp)
	{
		plumber_data *pd = (plumber_data *)udp;
		plumber_compute(pd, PLUMBER_COMPUTE);
		outL = sporth_stack_pop_float(&pd->sporth.stack);
		outR = sporth_stack_pop_float(&pd->sporth.stack);
	}

	int sporthem_init()
	{
		buffer_frames = 4096;
		buffer = new float[buffer_frames];
		bufferst = new float[buffer_frames*2];
		sp_create(&sp);
		plumber_register(&pd);
		plumber_init(&pd);
		pd.sp = sp;
		compiled = false;
		return 0;
	}

	int sporthem_compile(char *script)
	{
		if (compiled) {
			plumber_recompile_string(&pd, script);
			return 0;
		}
		plumber_parse_string(&pd, script);
		plumber_compute(&pd, PLUMBER_INIT);
		compiled = true;
		return 0;
	}

	EMSCRIPTEN_KEEPALIVE int sporthem_process(int num_frames) {
	    assert(buffer);
		assert(num_frames == buffer_frames);
		for (int i = 0; i < num_frames; ++i) {
			process(sp, &pd);
			buffer[i] = outL;
		}
	    return (int) buffer;
	}

	EMSCRIPTEN_KEEPALIVE int sporthem_process_stereo(int num_frames) {
	    assert(bufferst);
		assert(num_frames == buffer_frames);
		for (int i = 0; i < num_frames; ++i) {
			process_stereo(sp, &pd);
			bufferst[i*2] = outL;
			bufferst[i*2+1] = outR;
		}
	    return (int) bufferst;
	}

	int sporthem_setp(int id, float val)
	{
		pd.p[id] = val;
		return 0;
	}

	float sporthem_getp(int id)
	{
		return pd.p[id];
	}
}
