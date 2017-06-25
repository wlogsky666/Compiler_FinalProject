%{
#include "y.tab.h"
#include <math.h>
%}

var [a-zA-Z][a-zA-Z0-9]*

%%
[ \t] ;
[\n] { ++num_lines; }
\%\%.*\n ;		// Comment


[Bb][Ee][Gg][Ii][Nn] 	{return 1;} 
[Ee][Nn][Dd] 		{return 2;}
[Rr][Ee][Aa][Dd] 	{return 3;}
[Ww][Rr][Ii][Tt][Ee] 	{return 4;}

(IF)|(if) 		{return 25;}
(THEN)|(then) 		{return 26;}
(ELSE)|(else) 		{return 27;}
(ENDIF)|(endif) 	{return 28;}
(FOR)|(for) 		{return 29;}
(TO)|(to) 		{return 30;}
(ENDFOR)|(endfor) 	{return 31;}
(WHILE)|(while) 	{return 32;}
(ENDWHILE)|(endwhile)	{return 33;}
(DECLARE)|(declare) 	{return 34;}
(AS)|(as)		{return 35;}
(INTERGER)|(interger)	{return 36;}
(REAL)|(real)		{return 37;}
(EOF)			{return 38;}


{var} {return 5;} 
[0-9]+ {return 6;}
([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+) {return 7;}
([0-9]+(\.)?[0-9]*)([Ee]-?[0-9]+)  {return 8;}
\"[^"\n]*["\n] {return 9;}

[(] {return 10;}   
[)] {return 11;}
[;] {return 12;}
[,] {return 13;}
:=  {return 14;}
[+] {return 15;}
[-] {return 16;}
[*] {return 17;}
[/] {return 18;}
!=  {return 19;}
[>] {return 20;}
[<] {return 21;}
>=  {return 22;}
\<= {return 23;}
==  {return 24;}

.  {return yytext[0];}

%%

main(int argc, char* argv[]){
	FILE* fp = fopen(argv[1], "r");
	yyin = fp;
	
	int i;
	while( i = yylex() ){
		if( i != -1 )
			printf("Token number = %-2d, value is %s\n", i, yytext);
		else
			printf("Unknown Token, value is %s\n", yytext);	
	}
	printf("\nEnd of the execution\n");
	fclose(fp);
}
