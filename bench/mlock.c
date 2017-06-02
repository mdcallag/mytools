#include <sys/mman.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv) {
  int mb_to_alloc;
  int mb_per_alloc;
  int m;

  if (argc < 3) {
    fprintf(stderr, "need 2 args: gb to lock, mb per alloc\n");
    exit(-1);
  }

  mb_to_alloc = atoi(argv[1]);
  mb_per_alloc = atoi(argv[2]);

  fprintf(stdout, "Lock %d GB, malloc %d mb chunks\n", mb_to_alloc, mb_per_alloc);
  mb_to_alloc *= 1024;

  for (m=0; m < mb_to_alloc; m += mb_per_alloc) {
    char *c = malloc(mb_per_alloc * 1024 * 1024);
    mlock(c, mb_per_alloc * 1024 * 1024);
  }

  while (1) {
    fprintf(stdout, "sleep after locking\n");
    sleep(60);
  }
}
