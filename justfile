sources := "src/common.c src/parser.c src/tac.c src/text.c src/to_c.c src/to_cpp.c src/to_cs.c src/to_ex.c src/to_java.c src/to_json.c src/to_lua.c src/to_py.c src/to_swift.c src/to_ts.c src/to_wat.c"

gcc_flags := "-std=c99 -pedantic -Wall"

emcc_flags := "-s WASM=0 -O3 --memory-init-file 0"

all: co emlib

co:
    gcc {{sources}} src/waxc.c -o waxc -O3 {{gcc_flags}}

c:
    gcc -g {{sources}} src/waxc.c -DEBUG -o waxc {{gcc_flags}}

em:
    ../emsdk/upstream/emscripten/emcc {{sources}} src/waxc.c {{emcc_flags}} -lnodefs.js -s NODERAWFS=1 -o waxc_cli.js

emlib:
    ../emsdk/upstream/emscripten/emcc {{sources}} src/waxc_lib.c {{emcc_flags}} -o site/waxc.js \
        -s EXPORTED_FUNCTIONS='["_transpile"]' \
        -s EXPORTED_RUNTIME_METHODS='["cwrap"]' \
        -s MODULARIZE=1 -s 'EXPORT_NAME="WAXC"'

text:
    cd tools && python3 concat.py && cd ..

test:
    waxfn=examples/traceskeleton && valgrind ./waxc \
        --c $waxfn.c \
        --cpp $waxfn.cpp \
        --cs $waxfn.cs \
        --ex $waxfn.ex \
        --java $waxfn.java \
        --json $waxfn.json \
        --lua $waxfn.lua \
        --py $waxfn.py \
        --swift $waxfn.swift \
        --ts $waxfn.ts \
        --wat $waxfn.wat \
        $waxfn.wax
