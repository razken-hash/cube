#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Quadruplet
{
    char op[10];
    char arg1[256];
    char arg2[256];
    char result[256];
    int num;
    struct Quadruplet *next;
} Quadruplet;

Quadruplet *create_quadruplet(char *op, char *arg1, char *arg2, char *result)
{
    Quadruplet *q = malloc(sizeof(Quadruplet));
    strcpy(q->op, op);
    strcpy(q->arg1, arg1);
    strcpy(q->arg2, arg2);
    strcpy(q->result, result);
    q->num = 1;
    q->next = NULL;
    return q;
}

Quadruplet *insert_quadruplet(Quadruplet **q, char *op, char *arg1, char *arg2, char *result)
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
        new->num = aux->num + 1;
    }
    return new;
}

void update_quadruplet_result(Quadruplet *q, char *result)
{
    strcpy(q->result, result);
}

void update_quadruplet_arg1(Quadruplet *q, char *arg1)
{
    strcpy(q->arg1, arg1);
}

void update_quadruplet_arg2(Quadruplet *q, char *arg2)
{
    strcpy(q->arg2, arg2);
}

Quadruplet *getLastQuad(Quadruplet *q)
{
    Quadruplet *aux = q;
    while (aux->next != NULL)
    {
        aux = aux->next;
    }
    return aux;
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
        fprintf(f, "%d - (%s , %s , %s , %s)\n", q->num, q->op, q->arg1, q->arg2, q->result);
        q = q->next;
    }
    fclose(f);
}
