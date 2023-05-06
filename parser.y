%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern FILE *yyout;
extern int lineno;
extern int yylex();
void return_function(char* line);
void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

%}

%union {
    int integer;
    char charval;
    char* stringval;
    double doubleval;
    char* boolean;
}

%token <integer> INTEGER
%token <charval> CHAR
%token <stringval> STRING
%token <doubleval> DOUBLE
%token <boolean> BOOLEAN
%token <stringval> TYPE
%token <stringval> IDENTIFIER
%token PRINT
%token FOR
%token IF
%token LT
%type <stringval> value
%type <stringval> line
%type <integer> exp
%type <integer> condition

%%

input:
    /* empty */
    | input line
line:
    value { return $1; }
    | PRINT '(' value ')' { printf("%s\n", $3); }
    | PRINT '(' exp ')' { printf("%d\n", $3); }
    | error { printf("Error\n"); }
    | IF '(' condition ')' '{' line '}' {
        if ($3) {
            $$ = $6;
        } else {
            printf("Conditional error.\n");
        }
    }
    |FOR '(' INTEGER ';' INTEGER ';' INTEGER ')' '{' line '}' {
        for(int i = $3; i < $5; i = i + $7){
            return_function($10);
        }
    }
    |TYPE ' ' IDENTIFIER '=' value ';'  { printf($2);}
    

condition:
    INTEGER LT INTEGER {
        $$ = ($1 < $3);
        printf("VALOR BOOL: %d\n", $$);
    }
    ;

value:
    INTEGER { char buf[12]; sprintf(buf, "%d", $1); $$ = strdup(buf); }
    | CHAR { char buf[2]; buf[0] = $1; buf[1] = '\0'; $$ = strdup(buf); }
    | STRING { $$ = $1; }
    | DOUBLE { char buf[50]; sprintf(buf, "%.2lf", $1); $$ = strdup(buf); }
    | BOOLEAN { $$ = ($1); }

exp:
    INTEGER {$$ = $1;}
    | exp '+' exp { $$ = $1 + $3; }
    | exp '-' exp { $$ = $1 - $3; }
    | exp '*' exp { $$ = $1 * $3; }
    | exp '/' exp { $$ = $1 / $3; }
    | exp '^' exp { $$=  $1 * $3; }
    ;



%%

void return_function(char* line){
    printf("%s\n", line);
}

int main(void) {
    yyparse();
    return 0;
}