%{
#include "y.tab.h"

%}


%%
[ \t] ;
[\n] ;
\%\%.*\n ;		// Comment


[Pp][Rr][Oo][Gg][Rr][Aa][Mm]    {return PROGRAM;}
[Bb][Ee][Gg][Ii][Nn] 	{return BEGINT;} 
[Ee][Nn][Dd] 		{return END;}

[Dd][Ee][Cc][Ll][Aa][Rr][Ee]	{return DECLARE;}
[Aa][Ss]    {return AS;}
[Ii][Ff]    {return IF;}
[Tt][Hh][Ee][Nn]    {return THEN;}
[Ee][Ll][Ss][Ee]    {return ELSE;}
[Ee][Nn][Dd][Ii][Ff]    {return ENDIF;}
[Ff][Oo][Rr]    {return FOR;}
[Tt][Oo]    {return TO;}
[Dd][Oo][Ww][Nn][Tt][Oo]    {return DOWNTO;}
[Ee][Nn][Dd][Ff][Oo][Rr]    {return ENDFOR;}
[Ww][Hh][Ii][Ll][Ee]    {return WHILE;}
[Ee][Nn][Dd][Ww][Hh][Ii][Ll][Ee]    {return ENDWHILE;}
[Ss][Tt][Ee][Pp]	{ return STEP;}

[Ii][Nn][Tt][Ee][Gg][Ee][Rr] { strcpy(yylval.varname, yytext); return VARTYPE; }
[Ff][Ll][Oo][Aa][Tt]    { strcpy(yylval.varname, yytext); return VARTYPE; }
":=" {return ASSIGN;}
"!=" {return NE;}
">" {return G;}
"<" {return L;}
">=" {return GE;}
"<=" {return LE;}
"==" {return EQ;}


[a-zA-Z][a-zA-Z0-9_]* {	strcpy(yylval.varname,yytext);	return NAME;} 
[0-9]+ { yylval.val = atof(yytext);	return NUMBER;}
([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+) { yylval.val = atof(yytext); return NUMBER;}



.  {return yytext[0];}

%%


