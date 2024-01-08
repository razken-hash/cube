#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Column
{
    char typeToken[256];
    char nameToken[256];
    char valeurToken[256];
    int numColumn;
    struct Column *nextC;
} Column;

typedef struct Row
{
    int numRow;
    Column *Columns;
    struct Row *nextL;
} Row;

Column *allocateColumn()
{
    Column *col = (Column *)malloc(sizeof(Column));

    col->numColumn = 1;
    col->nextC = NULL;

    return col;
}

Row *allocateRow()
{
    Row *li = (Row *)malloc(sizeof(Row));

    li->Columns = NULL;
    li->numRow = 1;
    li->nextL = NULL;

    return li;
}

Row *insertRow(Row **row, int numRow)
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
        newRow->numRow = numRow;
        return newRow;
    }
}

void insertColumn(Row *row, char *typeToken, char *nameToken, char *valeurToken, int numColumn)
{
    Column *col, *c = row->Columns;
    if (c == NULL)
    {
        col = allocateColumn();
        strcpy(col->typeToken, typeToken);
        strcpy(col->nameToken, nameToken);
        strcpy(col->valeurToken, valeurToken);
        col->numColumn = numColumn;
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
        strcpy(col->valeurToken, valeurToken);
        col->numColumn = numColumn;
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
