This project allows running [Sporth](https://paulbatchelor.github.io/proj/sporth.html) in Javascript / WebAssembly using emscripten. It does not use the emscripten-provided APIs such as OpenAL, but only provides a callback that generates audio into a buffer, to be called from JS using AudioContext script processor nodes or Web Audio worklets. Compared to the emscripten-provided APIs, this actually simplifies the glue code, and should result in fewer dropouts, also allowing the audio to keep playing in background tabs. This is based on the audio callback technique used in [Sokol](https://github.com/floooh/sokol).

## Building with emscripten
Make sure you have Premake5 and the emscripten SDK, then:

	premake5 gmake
	cd build/emscripten
	emsdk activate latest
	make config=release

