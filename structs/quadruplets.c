#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Quadruplet
{
    char op[10];
    char arg1[10];
    char arg2[10];
    char result[10];
    struct Quadruplet *next;
} Quadruplet;

Quadruplet *create_quadruplet(char *op, char *arg1, char *arg2, char *result)
{
    Quadruplet *q = malloc(sizeof(Quadruplet));
    strcpy(q->op, op);
    strcpy(q->arg1, arg1);
    strcpy(q->arg2, arg2);
    strcpy(q->result, result);
    q->next = NULL;
    return q;
}

void insert_quadruplet(Quadruplet **q, char *op, char *arg1, char *arg2, char *result)
{
    Quadruplet *new = create_quadruplet(op, arg1, arg2, result);
    if (*q == NULL)
    {
        *q = new;
    }
    else
    {
        Quadruplet *aux = *q;
        while (aux->next != NULL)
        {
            aux = aux->next;
        }
        aux->next = new;
    }
}

void print_quadruplets(Quadruplet *q)
{
    while (q != NULL)
    {
        printf("%s %s %s %s\n", q->op, q->arg1, q->arg2, q->result);
        q = q->next;
    }
}

void free_quadruplets(Quadruplet *q)
{
    Quadruplet *aux;
    while (q != NULL)
    {
        aux = q;
        q = q->next;
        free(aux);
    }
}

void save_quadruplets(Quadruplet *q, char *filename)
{
    FILE *f = fopen(filename, "w");
    while (q != NULL)
    {
        fprintf(f, "%s %s %s %s\n", q->op, q->arg1, q->arg2, q->result);
        q = q->next;
    }
    fclose(f);
}
