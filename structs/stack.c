// create stack
#include "quadruplets.c"

typedef struct Stack
{
    Quadruplet *q;
    struct Stack *next;
} Stack;

Stack *create_stack(Quadruplet *q)
{
    Stack *s = malloc(sizeof(Stack));
    s->q = q;
    s->next = NULL;
    return s;
}

void push(Stack **s, Quadruplet *q)
{
    Stack *new = create_stack(q);
    if (*s == NULL)
    {
        *s = new;
    }
    else
    {
        new->next = *s;
        *s = new;
    }
}

Quadruplet *pop(Stack **s)
{
    if (*s == NULL)
    {
        return NULL;
    }
    else
    {
        Stack *aux = *s;
        Quadruplet *q = aux->q;
        *s = aux->next;
        free(aux);
        return q;
    }
}