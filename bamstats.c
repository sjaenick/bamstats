
#include <stdio.h>
#include <string.h>
#include <zlib.h>
#include <errno.h>

#include <htslib/bgzf.h>
#include <htslib/sam.h>
#include <htslib/khash.h>

KHASH_MAP_INIT_STR(str, uint64_t) 

int bam_reader(char* bamfile, char* outfile) {

    FILE *out = stdout;
    if (outfile != NULL) {
        out = fopen(outfile, "w");
        if (!out) {
            fprintf(stderr, "cannot open outfile %s\n", outfile);
            return -1;
        }
    }

    int absent;
    khiter_t k;
    khash_t(str) *h = kh_init(str);

    BGZF *fp = bgzf_open(bamfile, "r");
    if (!fp) {
        fprintf(stderr, "cannot open input file %s: %s\n", bamfile, strerror(errno));
        return -1;
    }

    uint32_t i;
    bam_hdr_t *hdr = bam_hdr_read(fp);
    for (i=0; i< hdr->n_targets; i++) {
        //fprintf(stderr, "ref: %s\n", hdr->target_name[i]);
        char* refName = strdup(hdr->target_name[i]);
        k = kh_get(str, h, refName);
        if (k == kh_end(h)) { // miss
            k = kh_put(str, h, refName, &absent);
            if (absent) kh_key(h, k) = refName;
            kh_value(h, k) = 0;
        }
    }
    fprintf(stderr, "loaded %d references.\n", hdr->n_targets);

    uint64_t cnt;
    bam1_t *b = bam_init1();
    while (bam_read1(fp, b) >= 0) {
        if (((b->core.flag & 0x4) == 0) && ((b->core.flag & 0x400) == 0)) {
            int32_t tid = b->core.tid;
            char* ref = hdr->target_name[tid];
            k = kh_get(str, h, ref);
            if (k == kh_end(h)) { // miss
                fprintf(stderr, "error\n");
            } else {
                cnt = kh_val(h, k);
                kh_value(h, k) = ++cnt;
            }
        }
    }

    uint64_t total=0;
    for (k = kh_begin(h); k != kh_end(h); ++k) {
        if (kh_exist(h, k)) {
            const char* ref = kh_key(h, k);
            cnt = kh_val(h, k);
            total+=cnt;
            fprintf(out, "%s\t%ld\n", ref, cnt);
            free((void*)ref);
        }
    }

    fprintf(out, "total\t%ld\n", total);

    bam_hdr_destroy(hdr);
    bam_destroy1(b);
    bgzf_close(fp);

    return 0;
}



int main (int argc, char* argv[]) {
  if (argc == 1) {
    fprintf(stderr, "bamstats - collect mapping counts by reference\n");
    fprintf(stderr, "Usage: %s <file.bam> [ output.tsv ]\n", argv[0]);
    return 1;
  }

  return bam_reader(argv[1], argc > 1 ? argv[2] : NULL);
}
