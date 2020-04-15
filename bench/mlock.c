#include <sys/mman.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void touch_pages(char *start, int n_pages) {
  int x;
  for (x=0; x < n_pages; x++) {
    *start = x;
    start += 4096;
  } 
}

int main(int argc, char **argv) {
  int mb_to_alloc;
  int mb_per_alloc;
  int m,x;
  int n_allocs;
  int n_pages;
  char **allocs;

  if (argc < 3) {
    fprintf(stderr, "need 2 args: gb to lock, mb per alloc\n");
    exit(-1);
  }

  mb_to_alloc = atoi(argv[1]);
  mb_per_alloc = atoi(argv[2]);

  fprintf(stdout, "Lock %d GB, malloc %d mb chunks\n", mb_to_alloc, mb_per_alloc);
  mb_to_alloc *= 1024;

  n_pages = (mb_per_alloc * 1024) / 4;           /* number of 4k pages per allocation */
  n_allocs = (mb_to_alloc / mb_per_alloc) + 1;
  allocs = malloc(sizeof(char*) * n_allocs);

  for (x=0, m=0; m < mb_to_alloc; x += 1, m += mb_per_alloc) {
    char *c = malloc(mb_per_alloc * 1024 * 1024);
    mlock(c, mb_per_alloc * 1024 * 1024);
    allocs[x] = c;
    touch_pages(c, n_pages);
  }

  x = 0;
  while (1) {
    touch_pages(allocs[x], n_pages);
    x++;
    if (x >= n_allocs)
      x = 0;
    sleep(1);
  }
}
