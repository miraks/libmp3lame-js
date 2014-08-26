EMCC:=emcc
EMCC_OPTS:=-O1 -s LINKABLE=0 -s ASM_JS=1 -s ASSERTIONS=0 -s EXPORTED_FUNCTIONS="['_get_lame_version', '_lame_init', '_lame_init_params', '_lame_set_mode', '_lame_get_mode', '_lame_set_num_samples', '_lame_get_num_samples', '_lame_set_num_channels', '_lame_get_num_channels', '_lame_set_in_samplerate', '_lame_get_in_samplerate', '_lame_set_out_samplerate', '_lame_get_out_samplerate', '_lame_set_brate', '_lame_get_brate', '_lame_set_VBR', '_lame_get_VBR', '_lame_set_VBR_q', '_lame_get_VBR_q', '_lame_set_VBR_mean_bitrate_kbps', '_lame_get_VBR_mean_bitrate_kbps', '_lame_set_VBR_min_bitrate_kbps', '_lame_get_VBR_min_bitrate_kbps', '_lame_set_VBR_max_bitrate_kbps', '_lame_get_VBR_max_bitrate_kbps', '_lame_encode_buffer_ieee_float', '_lame_encode_flush', '_lame_close']"
EMCONFIGURE:=emconfigure
EMMAKE:=emmake
LAME_URL:="http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz"
TAR:=tar

LAME_VERSION:=3.99.5
LAME:=lame-$(LAME_VERSION)

all: dist/libmp3lame.js

dist/libmp3lame.js: $(LAME) pre.js post.js
	$(EMCC) $(EMCC_OPTS) --pre-js pre.js --post-js post.js $(wildcard $(LAME)/libmp3lame/*.o) -o $@

$(LAME): $(LAME).tar.gz
	$(TAR) xzvf $@.tar.gz && \
	cd $@ && \
	$(EMCONFIGURE) ./configure CFLAGS="-include xmmintrin.h" --disable-frontend && \
	$(EMMAKE) make

$(LAME).tar.gz:
	test -e "$@" || wget $(LAME_URL)

clean:
	$(RM) -rf $(LAME)

distclean: clean
	$(RM) $(LAME).tar.gz

.PHONY: clean distclean
