%{
  char T_Comment [] = "T_COMMENT";

  char T_Html [] = "T_HTML";
  char T_Header [] = "T_HEADER";
  char T_Body [] = "T_BODY";
  char T_Paragraph [] = "T_P";
  char T_H1 [] = "T_H1";
  char T_H2 [] = "T_H2";
  char T_H3 [] = "T_H3";

  char T_Color [] = "T_COLOR";
  char T_Background [] = "T_BACKGROUND";
  char T_Margin [] = "T_MARGIN";
  char T_Padding [] = "T_PADDING";
  char T_Margin_Top [] = "T_MARGIN_TOP";
  char T_Margin_Bottom [] = "T_MARGIN_BOTTOM";
  char T_Font_Family [] =  "T_FONT_FAMILY";
  char T_Font_Size [] =  "T_FONT_SIZE";
  char T_Font_Weight [] =  "T_FONT_WEIGHT";
  char T_Font [] =  "T_FONT";
  char T_Line_Height [] =  "T_LINE_HEIGHT";
  char T_Letter_Spacing [] =  "T_LETTER_SPACING";
  char T_Text_Align [] =  "T_TEXT_ALIGN";

  char T_Value [] = "T_Value";
  char T_Url_Spec_Begin [] =  "T_URL_SPEC_BEGIN";
  char T_Filename [] = "T_FILENAME";
  char T_Normal [] = "T_NORMAL";

  char T_Hex_Constant [] = "T_HEX_CONSTANT";
  char T_Rgb_Spec_Begin [] = "T_RGB_SPEC_BEGIN";
  char T_Rgb_Constant [] = "T_RGB_CONSTANT";
  char T_Int_Constant [] = "T_INT_CONSTANT";
  char T_Double_Constant [] = "T_DOUBLE_CONSTANT";
  char T_Percentage [] = "T_PERCENTAGE";
  char T_Pixel_Unit [] = "T_PIXEL_UNIT";
  char T_Font_Size_Unit [] = "T_FONT_SIZE_UNIT";

  char O_Assignment [] = "O_ASSIGNMENT";
  char T_EOF [] = "T_EOF";
  char T_Open_CBrace [] = "T_OPEN_CBRACE";
  char T_Close_CBrace [] = "T_CLOSE_CBRACE";
  char T_Unary_Minus [] = "T_UNARY_MINUS";
  char T_Delimeter [] = "T_DELIMETER";
  char T_Open_Paran [] = "T_OPEN_PARAN";
  char T_Close_Paran [] = "T_CLOSE_PARAN";
  char T_Comma [] = "T_COMMA";

%}

%x CSS_COMMENT
DIGIT    [0-9]
FLOAT    [0-9]\.[0-9]*
ID       [a-zA-Z_][a-zA-Z0-9_]*
ALPHA    [a-fA-F]
HEXTAIL  ({DIGIT}|{ALPHA}){6}|({DIGIT}|{ALPHA}){3}
HEX      \#{HEXTAIL}
PIX      px
FONT     em
PER      {DIGIT}\%
RGB_STR  rgb
RGB_CNST [0-255]
NAME     """[a-z]+"""
URL      url
FILE     {ID}.[a-z]{5}
COMMA    ","
OCB      "{"
OP       "("
CCB      "}"
CP       ")"
UM       "-"
EOF      ";"
ASSG     :|=
HTML     html|HTML
BODY     body|BODY
HEADER   header|HEADER
P        p|P
H1       h1|H1
H2       h2|H2
H3       h3|H3
ATT_CLR color|COLOR
ATT_BGR background|BACKGROUND
ATT_MRG margin|MARGIN
ATT_PD  padding|PADDING
ATT_M_B margin-bottom|MARGIN-BOTTOM
ATT_M_T margin-top|MARGIN-TOP
ATT_FF  font-family|FONT-FAMILY
ATT_FS  font-size|FONT-SIZE
ATT_FW  font-weight|FONT-WEIGHT
ATT_LH  line-height|LINE-HEIGHT
ATT_TA  text-align|TEXT-ALIGN
ATT_LS  letter-spacing|LETTER-SPACING
ATT_F   font|FONT

%%

"/*"              { BEGIN(CSS_COMMENT); }
<CSS_COMMENT>"*/" { BEGIN(INITIAL); printf("%s\t", T_Comment);}
<CSS_COMMENT>.    { }

{HTML}        {printf("%s\n", T_Html);}
{BODY}        {printf("%s\n", T_Body);}
{HEADER}      {printf("%s\n", T_Header);}
{P}           {printf("%s\n", T_Paragraph);}
{H1}          {printf("%s\n", T_H1);}
{H2}          {printf("%s\n", T_H2);}
{H3}          {printf("%s\n", T_H3);}

{ASSG}        {printf("%s\t", O_Assignment);}
{EOF}         {printf("%s\t", T_EOF);}
{OCB}         {printf("%s\t", T_Open_CBrace);}
{CCB}         {printf("%s\n", T_Close_CBrace);}
{OP}          {printf("%s\n", T_Open_Paran);}
{CP}          {printf("%s\n", T_Close_Paran);}
{COMMA}       {printf("%s\t", T_Comma);}
{UM}          {printf("%s\t", T_Unary_Minus);}

{ATT_CLR}     {printf("%s\t", T_Color);}
{ATT_BGR}     {printf("%s\t", T_Background);}
{ATT_MRG}     {printf("%s\t", T_Margin);}
{ATT_PD}      {printf("%s\t", T_Padding);}
{ATT_M_B}     {printf("%s\t", T_Margin_Bottom);}
{ATT_M_T}     {printf("%s\t", T_Margin_Top);}
{ATT_FF}      {printf("%s\t", T_Font_Family);}
{ATT_FS}      {printf("%s\t", T_Font_Size);}
{ATT_FW}      {printf("%s\t", T_Font_Weight);}
{ATT_LH}      {printf("%s\t", T_Line_Height);}
{ATT_TA}      {printf("%s\t", T_Text_Align);}
{ATT_LS}      {printf("%s\t", T_Letter_Spacing);}
{ATT_F}       {printf("%s\t", T_Font);}

{RGB_STR}     {printf("%s\t", T_Rgb_Spec_Begin);}
{RGB_CNST}    {printf("%s\t", T_Rgb_Constant);}
{URL}         {printf("%s\t", T_Url_Spec_Begin);}
{PER}         {printf("%s\t", T_Percentage);}
{PIX}         {printf("%s\t", T_Pixel_Unit);}
{FONT}        {printf("%s\t", T_Font_Size_Unit);}
{DIGIT}       {printf("%s\t", T_Int_Constant);}
{FLOAT}       {printf("%s\t", T_Double_Constant);}
{HEX}         {printf("%s\t", T_Hex_Constant);}

%%

main()
{
  yylex();
}
