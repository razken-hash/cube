#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Column
{
    char typeToken[256];
    char nameToken[256];
    struct Column *nextC;
} Column;

typedef struct Row
{
    Column *Columns;
    struct Row *nextL;
} Row;

Column *allocateColumn()
{
    Column *col = (Column *)malloc(sizeof(Column));

    col->nextC = NULL;

    return col;
}

Row *allocateRow()
{
    Row *li = (Row *)malloc(sizeof(Row));

    li->Columns = NULL;
    li->nextL = NULL;

    return li;
}

Row *insertRow(Row **row)
{
    Row *li;
    Row *newRow;
    if (*row == NULL)
    {
        newRow = allocateRow();
        return newRow;
    }
    else
    {
        li = *row;
        while (li->nextL != NULL)
        {
            li = li->nextL;
        }
        newRow = allocateRow();
        li->nextL = newRow;
        return newRow;
    }
}

void insertColumn(Row *row, char *typeToken, char *nameToken)
{
    Column *col, *c = row->Columns;
    if (c == NULL)
    {
        col = allocateColumn();
        strcpy(col->typeToken, typeToken);
        strcpy(col->nameToken, nameToken);
        row->Columns = col;
    }
    else
    {
        while (c->nextC != NULL)
        {
            c = c->nextC;
        }
        col = allocateColumn();
        strcpy(col->typeToken, typeToken);
        strcpy(col->nameToken, nameToken);
        c->nextC = col;
    }
}

Column *get_id(Row *Row, char id[])
{
    Column *col = Row->Columns;
    int stop = 0;
    while (stop == 0 && col != NULL)
    {
        if (strcmp(col->nameToken, id) == 0)
        {
            stop = 1;
        }
        else
        {
            col = col->nextC;
        }
    }
    return col;
}

void printSymboleTable(Row *row)
{
    Column *col = row->Columns;
    while (col != NULL)
    {
        printf("typeToken : %s\n", col->typeToken);
        printf("nameToken : %s\n", col->nameToken);
        col = col->nextC;
    }
}

void saveSymboleTable(Row *row, char *fileName)
{
    FILE *f = fopen(fileName, "w");
    Column *col = row->Columns;
    while (col != NULL)
    {
        fprintf(f, "typeToken : %s - ", col->typeToken);
        fprintf(f, "nameToken : %s \n", col->nameToken);
        col = col->nextC;
    }
    fclose(f);
}