%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "parser.tab.h"
extern FILE *yyin;
extern FILE *yyout;
%}

%%

[ \t\n]          /* Ignore whitespace */
"true"|"false"   { yylval.boolean = strdup(yytext); return BOOLEAN; }
[0-9]+           { yylval.integer = atoi(yytext); return INTEGER; }
[0-9]*\.[0-9]+   { yylval.doubleval = atof(yytext); return DOUBLE; }
'.'              { yylval.charval = yytext[1]; return CHAR; }
.                { return yytext[0]; }
print       { return PRINT; }
if                     { return IF; }
esmenor                { return LT; }
esmayor               { return GT; }
esmenoroigual                { return LTE; }
esmayoroigual                { return GTE; }
esigual                { return EQUAL; }
for                    { return FOR; }
\"[^"]*\"        { yylval.stringval = strdup(yytext); return STRING; }
<<EOF>>     {return EOF;}
%%

int yywrap() {
    return 1;
}