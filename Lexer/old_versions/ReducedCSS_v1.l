%{
  char T_Comment [] = "T_Comment";
  char T_Selector [] = "T_Selector";
  char O_Assignment [] = "O_Assignment";
  char T_EOF [] = "T_EOF";
  char T_Open_Bracket [] = "T_Open_Bracket";
  char T_Close_Bracket [] = "T_Close_Bracket";
  char T_Attribute [] = "T_Attribute";
  char T_Color [] = "T_Color";
  char T_Hex_Color [] = "T_Hex_Color";
  char T_Rgb_Color [] = "T_Rgb_Color";
  char T_Int_Number [] = "T_Int_Number";
  char T_Float_Number [] = "T_Float_Number";
  char T_Percantage [] = "T_Percantage";
  char T_Value [] = "T_Value";
  char T_Url [] =  "T_Url";
  char T_Delimeter [] = "T_Delimeter";
  char T_Pixel [] = "T_Pixel";
%}

%x CSS_COMMENT

DIGIT    [0-9]
FLOAT    [0-9]\.[0-9]*
ID       [a-zA-Z_][a-zA-Z0-9_]*
ALPHA    [a-fA-F]
HEXTAIL  ({DIGIT}|{ALPHA}){6}|({DIGIT}|{ALPHA}){3}
HEX      \#{HEXTAIL}
PIX      {DIGIT}" "*"px"
PER      {DIGIT}\%
RGB      "rgb("[0-255]\,[0-255]\,[0-255]")"
NAME     """[a-z]+"""
URL      "url("{ID}.[a-z]+")"
COLOR    {HEX}|{RGB}|{NAME}
SELECT   html|body|header|p|h1|h2|h3
ATTR     color|background|margin|padding|margin-bottom|margin-top|font-family|font-size|font-weight|line-height|text-align|letter-spacing|font
DELIM     ,
START     "{"
END       "}"
EOF       ;
ASSG      :|=
NLINE       \n
SPC         " "

%%

"/*"              { BEGIN(CSS_COMMENT); }
<CSS_COMMENT>"*/" { BEGIN(INITIAL); printf("%s\t", T_Comment);}
<CSS_COMMENT>.    { }

{SELECT}      {printf("%s\n", T_Selector);}

{ASSG}        {printf("%s ", O_Assignment);}
{EOF}         {printf("%s ", T_EOF);}
{START}       {printf("%s ", T_Open_Bracket);}
{END}         {printf("%s\n", T_Close_Bracket);}
{DELIM}       {printf("%s ", T_Delimeter);}

{ATTR}        {printf("%s ", T_Attribute);}
{COLOR}       {printf("%s ", T_Color);}
{URL}         {printf("%s ", T_Url);}
{PER}         {printf("%s ", T_Percantage);}
{PIX}         {printf("%s ", T_Pixel);}
{DIGIT}       {printf("%s ", T_Int_Number);}
{FLOAT}       {printf("%s ", T_Float_Number);}
{ID}\-*{ID}   {printf("%s ", T_Value);}

{SPC}
{NLINE}

%%

main()
{
  yylex();
}
