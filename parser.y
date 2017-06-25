%{
#include <string.h>
string vartmp[30];
int size = 0 ;
bool isProName = false;
%}

%union {
	int varno;
	int ival;
	float fval;
	string varname;
}


%token <varname> NAME 
%token <ival> NUMBER
%token <fval> FLOAT 
%token <varname> VARTYPE
%token PROGRAM BEGIN END DECLARE AS FOR TO IF THEN ELSE ENDIF  
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS




%%

Program : PROGRAM NAME BEGIN stmt_list END 	{printf("Compilation Done\n");}
	;

stmt_list :	stmt 	
	|	stmt_list stmt	
	;

stmt : 		vardeclare

	;

vardeclare :	DECLARE varlist AS VARTYPE 	
		{
	for( int i = 0; i < size; ++i ){
		printf("Declare %s, %s\n", vartmp[i].c_str(), VARTYPE.c_str());
	}		
	size = 0;		
							}
	;

varlist	:	NAME			{ 
		if( !isProName )
		{
			printf("Start %s\n", ($1).c_str());
			isProName = true;				
		}
		else
		{
			vartmp[size++] = $1; 	
		}
	}
	|	varlist ',' NAME	{ vartmp[size++] = $3; }
	;

	
