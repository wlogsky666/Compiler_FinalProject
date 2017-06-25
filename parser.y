%{
#include <stdio.h>
#include <string.h>

struct VARTMP{
	char name[30];	
	int size;
} vartmp[30];

int vsize = 0;
int label=0;

char fori[30];
int forend, forstep;
int isminus;

char pgnamet[30];

%}

%union {
	int varno;
	double val;
	char varname[30];
}


%token <varname> NAME VARTYPE
%token <val> NUMBER

%token PROGRAM BEGINT END 
%token DECLARE AS IF THEN ELSE ENDIF 
%token FOR TO DOWNTO ENDFOR
%token WHILE ENDWHILE
%token ASSIGN NE G L GE LE EQ



%left '-' '+'
%left '*' '/'
%nonassoc UMINUS



%%

Program : 	PROGRAM pgname BEGINT stmt_list END 	{ printf("\t\tHALT %s\n", pgnamet); printf("\n\n\n**Compilation Done**\n"); }
	;

pgname :	NAME
	{
		printf("\t\tSTART %s\n", $1);
		strcpy(pgnamet, $1);
	}
	;

stmt_list :	stmt 	
	|	stmt stmt_list 	
	;

stmt : 		vardeclare ';'
	|		forloop
	|		ifelse
	|		whileloop
	|		assign ';'
	;




vardeclare :	DECLARE varlist AS VARTYPE 	
	{
		int i;
		for( i = 0; i < vsize; ++i ){
			if( vartmp[i].size == 1 )
			{
				printf("\t\tDeclare %s, %s\n", vartmp[i].name, $4);
			}
			else
			{
				printf("\t\tDeclare %s, %s_array, %d\n", vartmp[i].name, $4, vartmp[i].size);
			}
		}		
		vsize = 0;		
	}
	;
varlist	:	var	| var ',' varlist ;
var :	NAME
	{		
		strcpy( vartmp[vsize].name, $1);
		vartmp[vsize].size =  1;
		vsize += 1;
	}
	| 	NAME '[' NUMBER ']'
	{
		strcpy( vartmp[vsize].name, $1);
		vartmp[vsize].size = $3;
		vsize += 1;
	}
	;

forloop :	FOR '(' RANGE ')' stmt_list ENDFOR
	{
		if( !isminus ){
			printf("\t\tINC %s\n", fori);
			printf("\t\tI_CMP %s,%d\n", fori, forend);
			printf("\t\tJL lb&%d\n", label);
		}
		else{
			printf("\t\tDEC %s\n", fori);
			printf("\t\tI_CMP %s,%d\n", fori, forend);
			printf("\t\tJG lb&%d\n", label);
		}
	}
	;

RANGE :	NAME ASSIGN NUMBER updown NUMBER
	{
		printf("\t\tISTORE %.0f,%s\n", $3, $1);
		strcpy(fori, $1);
		printf("lb&%d:", ++label);
		forend = $5;
	}
	;

updown : DOWNTO { isminus = 1;}
	|	 TO 	{ isminus = 0;}
	;



ifelse : IF '(' condition ')' THEN stmt_list ifsuffix 
	;

condition :	NAME G  NUMBER	{ printf("\t\tF_CMP %s, %f\n", $1, $3); printf("\t\tJLE lb&%d\n", label+1); }
	|		NAME L  NUMBER	{ printf("\t\tF_CMP %s, %f\n", $1, $3); printf("\t\tJGE lb&%d\n", label+1); }
	|		NAME GE NUMBER	{ printf("\t\tF_CMP %s, %f\n", $1, $3); printf("\t\tJL lb&%d\n", label+1); }
	|		NAME LE NUMBER	{ printf("\t\tF_CMP %s, %f\n", $1, $3); printf("\t\tJG lb&%d\n", label+1); }
	|		NAME EQ NUMBER	{ printf("\t\tF_CMP %s, %f\n", $1, $3); printf("\t\tJNE lb&%d\n", label+1); }
	|		NAME NE NUMBER	{ printf("\t\tF_CMP %s, %f\n", $1, $3); printf("\t\tJE lb&%d\n", label+1); }
	;

ifsuffix : 	eprefix stmt_list ENDIF
	{
		printf("lb&%d:", label+2);
		label += 2;

	}
	|		ENDIF
	{
		printf("lb&%d:", label+1);
		label += 1;
	}
	;

eprefix :	ELSE
	{
		printf("\t\tJ lb&%d\n", label+2);
		printf("lb&%d:", label+1);
	}
	;


assign : NAME ASSIGN NUMBER
	{
		printf("\t\tF_STORE %f,%s\n", $3, $1);
	}
	;


whileloop : WHILE '(' condition ')' stmt_list ENDWHILE
	{
		printf("lb&%d", label+1);
		lable += 1;
	}




%%

	
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *fopen(const char *filename, const char *mode);

int main(int argc ,char *argv[]){

    yyin = fopen(argv[1], "r");
    
    do{
		yyparse();

    }while(!feof(yyin));
    
    
    fclose(yyin);
    return 0;
}
