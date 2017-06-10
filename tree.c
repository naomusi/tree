#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>

typedef struct dirent DENT;
typedef struct {
  int   cnt;
  DENT *list;
} DENT_B;

int
comp(src,dst) 
DENT *src;
DENT *dst;
{
    return(strcmp(src->d_name,dst->d_name));
}

int
list_alloc(base)
DENT_B *base;
{
    if (!base->list) {
        base->list = malloc(sizeof(DENT)*base->cnt);
        if (!base->list) {
            return(1);
        }
    }
    else {
        base->list = realloc(base->list, sizeof(DENT)*base->cnt);
    } 

    return(0);
}

int
mklist(base,dir) 
DENT_B *base;
char   *dir;
{
    DIR  *dp   = NULL;
    int   cnt  = 0;
    DENT *dent = NULL;

    dp=opendir(dir);
    if (!dp) {
        fprintf(stderr,"Can't open directory(%s)\n",dir);
        return(1);
    }

    base->cnt = 0;
    while(dent = readdir(dp)) {
        if (dent == (struct dirent *)-1) {
            fprintf(stderr,"Can't read directory(%s)\n",dir);
            return(1);
        }

        if (!strcmp(dent->d_name,".") ||
            !strcmp(dent->d_name,"..")) {
            continue;
        }
        
        base->cnt++;
        if (list_alloc(base)) {
            fprintf(stderr,"Can't alloc memory\n");
            return(1);
        }

        memcpy(&base->list[base->cnt-1],dent,sizeof(DENT));
    }

    if (closedir(dp)) {
        fprintf(stderr,"Can't close directory(%s)\n",dir);
        return(1);
    }

    return(0);
}

int
tree(depth, dir)
char *depth;
char *dir;
{
    DENT_B  base;
    int     cnt;
    char    fullpath[512];
    char    depth_tmp[512];
    struct stat dstat;

    memset(&base,0x00,sizeof(base));

    if (mklist(&base,dir)) {
        fprintf(stderr,"mklist error(%s)\n",dir);
        return(1);
    }

    qsort(base.list,base.cnt,sizeof(DENT),comp);

    for(cnt=0;cnt<base.cnt;cnt++) {
        sprintf(fullpath,"%s/%s",dir,base.list[cnt].d_name);
        if (stat(fullpath,&dstat)) {
            fprintf(stderr,"stat error(%s)\n",fullpath);
            return(1);
        }
        if (dstat.st_mode & S_IFDIR) {
            if (cnt+1 == base.cnt) {
                printf("%s`-- %s\n",depth,base.list[cnt].d_name);
                sprintf(depth_tmp,"%s    ",depth);
                tree(depth_tmp,fullpath);
            }
            else {
                printf("%s|-- %s\n",depth,base.list[cnt].d_name);
                sprintf(depth_tmp,"%s|   ",depth);
                tree(depth_tmp,fullpath);
            }
        }
        else {
            if (cnt+1 == base.cnt) {
                printf("%s`-- %s\n",depth,base.list[cnt].d_name);
            }
            else {
                printf("%s|-- %s\n",depth,base.list[cnt].d_name);
            }
        }
    }

    free(base.list);

    return(0);
}

int
main(argc,argv)
int argc;
char *argv[];
{
    char *root_dir = NULL;

    root_dir = ".";
    if (argc > 1) {
        root_dir = argv[1];
    }
    printf("%s\n",root_dir);
    if (tree("",root_dir)!=0) {
       exit(1);
    }
    exit(0);
}
