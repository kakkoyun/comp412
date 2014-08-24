/*
Comp412 - Reduced CSS Lexer Project

Kemal Akkoyun
11076004

Following code, written considering given spesifications and examples.

*/

%{
  char T_Comment [] = "T_COMMENT";
  char T_Ident [] = "T_IDENT";
  char T_String [] = "T_STRING";
  char T_Number [] = "T_NUMBER";
  char T_EMS [] = "T_EMS";
  char T_EXS [] = "T_EXS";
  char T_Length [] = "T_LENGHT";
  char T_Hex_Color [] = "T_HEXCOLOR";
  char T_Rgb_Color [] = "T_RGB";
  char T_Url [] =  "T_URL";
  char T_Percantage [] = "T_PERCENTAGE";
  char T_Assignment [] = "T_ASSIGN";
  char T_Operator [] = "T_OPERATOR";
  char T_EOF [] = "T_EOF";

  int fromColumn = 0;
  int toColumn = 0;
  #define YY_USER_ACTION { fromColumn = toColumn; toColumn += yyleng; }

%}

%option   yylineno

%x CSS_COMMENT
%x CSS_INLINE_COMMENT
%x CSS_DECLARATION

INTEGER     [0-9]*
FLOAT       [0-9]\.[0-9]*
NUMBER      {FLOAT}|{INTEGER}
STRING      [a-zA-Z_][a-zA-Z0-9_]*
ALPHA       [a-fA-F]
HEXTAIL     ({INTEGER}|{ALPHA}){6}|({INTEGER}|{ALPHA}){3}
HEX         \#{HEXTAIL}
RGB         "rgb("[0-255]\,[0-255]\,[0-255]")"
URL         "url("{STRING}.[a-z]+")"
LENGTH      {INTEGER}" "?"px"
EMS         {NUMBER}" "?"em"
EXS         {NUMBER}" "?"ex"
PERCENTAGE  {INTEGER}\%
ELEMENT     html|body|header|p|h1|h2|h3
FONT        georgia|sans-serif
PROPERTY    color|background|margin|padding|margin-bottom|margin-top|font-family|font-size|font-weight|line-height|text-align|letter-spacing|font|{FONT}
IDENT       {ELEMENT}|{PROPERTY}
UNARY       "-"|"+"
OPERATOR    "/"|","
STARTBRACE  "{"
ENDBRACE    "}"
STARTCOMMENT "/*"
ENDCOMMENT  "*/"
EOF         ;
ASSG        :|=
NLINE       \n
SPC         " "
TERM        {NUMBER}|{STRING}|{HEX}|{RGB}|{URL}|{LENGTH}|{EMS}|{EXS}|{PERCENTAGE}|{IDENT}
EXPR        {TERM}[{OPERATOR}{TERM}]*
DECLARATION {PROPERTY}{SPC}*{ASSG}{SPC}*{EXPR}
SELECTOR    {ELEMENT}
RULESET     {SELECTOR}{STARTBRACE}{DECLARATION}[{EOF}{DECLARATION}]*{ENDBRACE}
SHEET       {RULESET}*

%%

{STARTCOMMENT}                         { BEGIN(CSS_COMMENT); }
<CSS_COMMENT>{ENDCOMMENT}              { BEGIN(INITIAL); printf("%s\n", T_Comment);}
<CSS_COMMENT>.                         { }

{STARTBRACE}                           { BEGIN(CSS_DECLARATION); }
<CSS_DECLARATION>{ENDBRACE}            { BEGIN(INITIAL);}

{SELECTOR}                             {printf("%s (Value = %s)\n", T_Ident, yytext);}

<CSS_DECLARATION>{STARTCOMMENT}        { BEGIN(CSS_INLINE_COMMENT); }
<CSS_INLINE_COMMENT>{ENDCOMMENT}       { BEGIN(CSS_DECLARATION); printf("%s\n", T_Comment);}
<CSS_INLINE_COMMENT>.

<CSS_DECLARATION>{IDENT}               {printf("%s (Value = %s)\n", T_Ident, yytext);}
<CSS_DECLARATION>{HEX}                 {printf("%s (Value = %s)\n", T_Hex_Color, yytext);}
<CSS_DECLARATION>{RGB}                 {printf("%s (Value = %s)\n", T_Rgb_Color, yytext);}
<CSS_DECLARATION>{URL}                 {printf("%s (Value = %s)\n", T_Url, yytext);}
<CSS_DECLARATION>{UNARY}?{PERCENTAGE}  {printf("%s (Value = %s)\n", T_Percantage, yytext);}
<CSS_DECLARATION>{UNARY}?{EMS}         {printf("%s (Value = %s)\n", T_EMS, yytext);}
<CSS_DECLARATION>{UNARY}?{EXS}         {printf("%s (Value = %s)\n", T_EXS, yytext);}
<CSS_DECLARATION>{LENGTH}              {printf("%s (Value = %s)\n", T_Length, yytext);}
<CSS_DECLARATION>{OPERATOR}            {printf("%s (Value = %s)\n", T_Operator, yytext);}
<CSS_DECLARATION>{STRING}              {printf("%s (Value = %s)\n", T_String, yytext);}
<CSS_DECLARATION>{UNARY}?{NUMBER}      {printf("%s (Value = %s)\n", T_Number, yytext);}
<CSS_DECLARATION>{EOF}                 {printf("T_EOF(%s)\n", yytext);}
<CSS_DECLARATION>{ASSG}                {printf("T_ASSIGN(%s)\n", yytext);}
<CSS_DECLARATION>{SPC}
<CSS_DECLARATION>{NLINE}               fromColumn = toColumn = 0;
<CSS_DECLARATION>.                     {printf("SyntaxError at line %d, column %d\n", yylineno, fromColumn);}

{SPC}
{NLINE}                                fromColumn = toColumn = 0;
{TERM}                                 {printf("Syntax Error at line %d, column %d\n", yylineno, fromColumn);}
.                                      {printf("Syntax Error at line %d, column %d\n", yylineno, fromColumn);}

%%

main()
{
  yylex();
}
