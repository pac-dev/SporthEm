-- subset of soundpipe modules based on include/Soundpipe/config.def.mk
local soundpipe_modules = {
	"base",
	"ftbl",
	"osc",
	"randmt",
	"tevent",
	"adsr",
	"allpass",
	"atone",
	"autowah",
	"bal",
	"bar",
	"biquad",
	"biscale",
	"blsaw",
	"blsquare",
	"bltriangle",
	"fold",
	"bitcrush",
	"brown",
	"butbp",
	"butbr",
	"buthp",
	"butlp",
	"clip",
	"clock",
	"comb",
	"compressor",
	"count",
	"conv",
	"crossfade",
	"dcblock",
	"delay",
	"diode",
	"dist",
	"dmetro",
	"drip",
	"dtrig",
	"dust",
	"eqfil",
	"expon",
	"fof",
	"fog",
	"fofilt",
	"foo",
	"fosc",
	"gbuzz",
	"hilbert",
	"in",
	"incr",
	"jcrev",
	"jitter",
	"line",
	"lpf18",
	"maygate",
	"metro",
	"mincer",
	"mode",
	"moogladder",
	"noise",
	"oscmorph",
	"pan2",
	"panst",
	"pareq",
	"paulstretch",
	"pdhalf",
	"peaklim",
	"phaser",
	"phasor",
	"pinknoise",
	"pitchamdf",
	"pluck",
	"port",
	"posc3",
	"progress",
	"prop",
	"pshift",
	"ptrack",
	"randh",
	"randi",
	"random",
	"reverse",
	"reson",
	"revsc",
	"rms",
	"rpt",
	"rspline",
	"saturator",
	"samphold",
	"scale",
	"scrambler",
	"sdelay",
	"slice",
	"smoothdelay",
	"spa",
	"sparec",
	"streson",
	"switch",
	"tabread",
	"tadsr",
	"talkbox",
	"tblrec",
	"tbvcf",
	"tdiv",
	"tenv",
	"tenv2",
	"tenvx",
	"tgate",
	"thresh",
	"timer",
	"tin",
	"tone",
	"trand",
	"tseg",
	"tseq",
	"vdelay",
	"voc",
	"vocoder",
	"waveset",
	"wpkorg35",
	"zitarev",
}

-- subset of sporth modules based include/Sporth/config.def.mk
local sporth_modules = {
	"adsr",
	"allpass",
	"atone",
	"autowah",
	"bal",
	"basic",
	"biscale",
	"bitcrush",
	"bitwise",
	"blsaw",
	"blsquare",
	"bltriangle",
	"bpm",
	"brown",
	"butbp",
	"butbr",
	"buthp",
	"butlp",
	"changed",
	"clip",
	"clock",
	"comb",
	"conv",
	"count",
	"crossfade",
	"dcblock",
	"delay",
	"diode",
	"diskin",
	"dist",
	"dmetro",
	"drip",
	"dtrig",
	"dust",
	"eqfil",
	"eval",
	"expon",
	"f",
	"fm",
	"fof",
	"fofilt",
	"fog",
	"fosc",
	"ftsum",
	"gbuzz",
	"gen_eval",
	"gen_file",
	"gen_line",
	"gen_rand",
	"gen_sine",
	"gen_composite",
	"gen_sinesum",
	"gen_sporth",
	"gen_vals",
	"hilbert",
	"in",
	"incr",
	"jcrev",
	"jitter",
	"line",
	"loadspa",
	"lpf18",
	"lsys",
	"mark",
	"maygate",
	"maytrig",
	"metro",
	"mincer",
	"mode",
	"moogladder",
	"noise",
	"osc",
	"oscmorph",
	"p",
	"pan",
	"pareq",
	"paulstretch",
	"pdhalf",
	"peaklim",
	"phaser",
	"phasor",
	"pinknoise",
	"pluck",
	"polysporth",
	"port",
	"posc3",
	"print",
	"prop",
	"pshift",
	"ptrack",
	"rand",
	"randh",
	"randi",
	"ref",
	"render",
	"reson",
	"reverse",
	"revsc",
	"rpt",
	"rms",
	"rspline",
	"samphold",
	"saturator",
	"say",
	"scale",
	"scrambler",
	"sdelay",
	"slice",
	"slist",
	"smoothdelay",
	"spa",
	"sparec",
	"srand",
	"streson",
	"switch",
	"t",
	"tabread",
	"tadsr",
	"talkbox",
	"tblrec",
	"tdiv",
	"tenv",
	"tenv2",
	"tenvx",
	"tgate",
	"thresh",
	"tin",
	"tick",
	"timer",
	"tog",
	"tone",
	"tphasor",
	"trand",
	"tseg",
	"tseq",
	"v",
	"vdelay",
	"voc",
	"vocoder",
	"waveset",
	"writecode",
	"wpkorg35",
	"zeros",
	"zitarev",
}
--[[
	removed for emscripten:
	"cdb",
	"lpc",
	"nsmp",
	"load",
	"loadfile",
	"gen_padsynth",
--]]

-- create a minimal premake emscripten toolset based on the gcc toolset
premake.tools.emcc = {}
for key,val in pairs(premake.tools.gcc) do
	premake.tools.emcc[key] = premake.tools.gcc[key]
end
premake.tools.emcc.gettoolname = function (cfg, tool)
	return "emcc"
end


-- helper to generate source files as required by Soundpipe
function concat(sources)
	local ret = ""
	for _, source_path in ipairs(sources) do
		local source_file = io.open(source_path, "r")
		local source_contents = source_file:read("*all")
		source_file:close()
		ret = ret ..[[
	/*
	=============================================================
	File: ]] .. source_path:match("^.+/(.+)$") .. ".h" .. [[
	=============================================================
	*/
	]] .. source_contents
	end
	return ret
end

local ROOT = ""
local proj_action = _ACTION and _ACTION or "undefined"

local soundpipe_modules_dir = ROOT .. "include/Soundpipe/modules/"
local soundpipe_headers_dir = ROOT .. "include/Soundpipe/h/"
local sporth_modules_dir = ROOT .. "include/Sporth/ugens/"
local sporth_headers_dir = ROOT .. "include/Sporth/h/"

local soundpipe_h_sources = {}
local soundpipe_c_sources = {}
local sporth_c_sources = {}

for _, soundpipe_mod in ipairs(soundpipe_modules) do
	table.insert(soundpipe_h_sources, soundpipe_headers_dir .. soundpipe_mod .. ".h")
	table.insert(soundpipe_c_sources, soundpipe_modules_dir .. soundpipe_mod .. ".c")
end

for _, sporth_mod in ipairs(sporth_modules) do
	table.insert(sporth_c_sources, sporth_modules_dir .. sporth_mod .. ".c")
end

-- not sure how soundpipe's spa is supposed to be included
table.insert(soundpipe_h_sources, ROOT .. "include/Soundpipe/lib/spa/spa.h")

print("generating soundpipe.h...")
local soundpipe_h_file = io.open(ROOT .. "source/generated/soundpipe.h", "w")
soundpipe_h_file:write [[
#pragma once
#define SOUNDPIPE_H

]]
soundpipe_h_file:write(concat(soundpipe_h_sources))
soundpipe_h_file:close()

print("generating fft.c...")
local fft_dir = ROOT .. "include/Soundpipe/lib/fft/"
local fft_c_file = io.open(ROOT .. "source/generated/fft.c", "w")
fft_c_file:write(concat{fft_dir .. "fftlib.c", fft_dir .. "sp_fft.c"})
fft_c_file:close()

-- These don't have header guards, probably because of Sporth's weird header generation requirements
print("generating sporth.h...")
local sporth_h_file = io.open(ROOT .. "source/generated/sporth.h", "w")
sporth_h_file:write [[
#pragma once

]]
sporth_h_file:write(concat{sporth_headers_dir.."sporth.h"})
sporth_h_file:close()

print("generating plumber.h...")
local plumber_h_file = io.open(ROOT .. "source/generated/plumber.h", "w")
plumber_h_file:write [[
#pragma once

]]
plumber_h_file:write(concat{sporth_headers_dir.."plumber.h"})
plumber_h_file:close()


workspace "sporthem"
	configurations { "Debug", "Release" }
	location( ROOT .. "build/emscripten" )
	targetdir (ROOT .. "build/emscripten")
	toolset "emcc"
	targetextension ".js"
	-- ugly hack: short object dir prevents "long linker command" error on windows
	objdir (ROOT .. "build/o")

	filter "configurations:Debug"
		defines { "DEBUG" }
		symbols  "On"
	filter "configurations:Release"
		defines { "NDEBUG" }
		symbols "On" -- removes the -s linker flag (different meanings for emcc vs. gcc?)
		buildoptions "-O3"
		linkoptions "-O3"
	filter {}
	local emcc_opt = 
	[[-s EXPORTED_FUNCTIONS="['_sporthem_init', '_sporthem_compile', '_sporthem_process', '_sporthem_process_stereo', '_sporthem_setp', '_sporthem_getp']" --memory-init-file 0 -s EXTRA_EXPORTED_RUNTIME_METHODS="['cwrap']" -s WASM=1]]
	buildoptions(emcc_opt)
	linkoptions(emcc_opt)
	
	project "sporthem"
		kind "ConsoleApp"
		language "C++"
		targetname "sporthem"
		defines {
			"NO_LIBSNDFILE", 
			"kiss_fft_scalar=float", 
			"NO_LIBDL", 
			"NO_POLYSPORTH", 
			"usleep="
		}
		
		includedirs
		{
			ROOT,
			ROOT .. "source",
			ROOT .. "source/generated",
			ROOT .. "include/Soundpipe/h",
			ROOT .. "include/Soundpipe/lib/faust",
			ROOT .. "include/Soundpipe/lib/kissfft",
			ROOT .. "include/Soundpipe/lib/spa",
		}
		--[[
			ROOT .. "include/Soundpipe/lib/openlpc",
			ROOT .. "include/Soundpipe/lib/inih",
		--]]
		
		files
		{
			ROOT .. "source/*.cpp",
			ROOT .. "source/generated/fft.c",
			ROOT .. "include/Soundpipe/lib/kissfft/kiss_fft.c",
			ROOT .. "include/Soundpipe/lib/kissfft/kiss_fftr.c",
			ROOT .. "include/Soundpipe/lib/spa/spa.c",

			ROOT .. "include/Sporth/func.c",
			ROOT .. "include/Sporth/plumber.c",
			ROOT .. "include/Sporth/stack.c",
			ROOT .. "include/Sporth/parse.c",
			ROOT .. "include/Sporth/hash.c",
			ROOT .. "include/Sporth/ftmap.c",
		}
		files(soundpipe_c_sources)
		files(sporth_c_sources)
