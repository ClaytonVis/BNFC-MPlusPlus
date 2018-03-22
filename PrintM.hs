{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}
module PrintM where

-- pretty-printer generated by the BNF converter

import AbsM
import Data.Char


-- the top-level printing method
printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 (map ($ "") $ d []) "" where
  rend i ss = case ss of
    "["      :ts -> showChar '[' . rend i ts
    "("      :ts -> showChar '(' . rend i ts
    "{"      :ts -> showChar '{' . new (i+1) . rend (i+1) ts
    "}" : ";":ts -> new (i-1) . space "}" . showChar ';' . new (i-1) . rend (i-1) ts
    "}"      :ts -> new (i-1) . showChar '}' . new (i-1) . rend (i-1) ts
    ";"      :ts -> showChar ';' . new i . rend i ts
    t  : "," :ts -> showString t . space "," . rend i ts
    t  : ")" :ts -> showString t . showChar ')' . rend i ts
    t  : "]" :ts -> showString t . showChar ']' . rend i ts
    t        :ts -> space t . rend i ts
    _            -> id
  new i   = showChar '\n' . replicateS (2*i) (showChar ' ') . dropWhile isSpace
  space t = showString t . (\s -> if null s then "" else (' ':s))

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- the printer class does the job
class Print a where
  prt :: Int -> a -> Doc
  prtList :: Int -> [a] -> Doc
  prtList i = concatD . map (prt i)

instance Print a => Print [a] where
  prt = prtList

instance Print Char where
  prt _ s = doc (showChar '\'' . mkEsc '\'' s . showChar '\'')
  prtList _ s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q s = case s of
  _ | s == q -> showChar '\\' . showChar s
  '\\'-> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  _ -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j<i then parenth else id


instance Print Integer where
  prt _ x = doc (shows x)


instance Print Double where
  prt _ x = doc (shows x)



instance Print ID where
  prt _ (ID i) = doc (showString ( i))


instance Print IVAL where
  prt _ (IVAL i) = doc (showString ( i))


instance Print RVAL where
  prt _ (RVAL i) = doc (showString ( i))


instance Print BVAL where
  prt _ (BVAL i) = doc (showString ( i))



instance Print Prog where
  prt i e = case e of
    ProgBlock block -> prPrec i 0 (concatD [prt 0 block])

instance Print Block where
  prt i e = case e of
    Block1 declarations programbody -> prPrec i 0 (concatD [prt 0 declarations, prt 0 programbody])

instance Print Declarations where
  prt i e = case e of
    Declarations1 declaration declarations -> prPrec i 0 (concatD [prt 0 declaration, doc (showString ";"), prt 0 declarations])
    Declarations2 -> prPrec i 0 (concatD [])

instance Print Declaration where
  prt i e = case e of
    DeclarationVar_Declaration vardeclaration -> prPrec i 0 (concatD [prt 0 vardeclaration])
    DeclarationFun_Declaration fundeclaration -> prPrec i 0 (concatD [prt 0 fundeclaration])

instance Print Var_Declaration where
  prt i e = case e of
    Var_Declaration1 id arraydimensions type_ -> prPrec i 0 (concatD [doc (showString "var"), prt 0 id, prt 0 arraydimensions, doc (showString ":"), prt 0 type_])

instance Print Type where
  prt i e = case e of
    Type_int -> prPrec i 0 (concatD [doc (showString "int")])
    Type_real -> prPrec i 0 (concatD [doc (showString "real")])
    Type_bool -> prPrec i 0 (concatD [doc (showString "bool")])

instance Print Array_Dimensions where
  prt i e = case e of
    Array_Dimensions1 expr arraydimensions -> prPrec i 0 (concatD [doc (showString "["), prt 0 expr, doc (showString "]"), prt 0 arraydimensions])
    Array_Dimensions2 -> prPrec i 0 (concatD [])

instance Print Fun_Declaration where
  prt i e = case e of
    Fun_Declaration1 id paramlist type_ funblock -> prPrec i 0 (concatD [doc (showString "fun"), prt 0 id, prt 0 paramlist, doc (showString ":"), prt 0 type_, doc (showString "{"), prt 0 funblock, doc (showString "}")])

instance Print Fun_Block where
  prt i e = case e of
    Fun_Block1 declarations funbody -> prPrec i 0 (concatD [prt 0 declarations, prt 0 funbody])

instance Print Param_List where
  prt i e = case e of
    Param_List1 parameters -> prPrec i 0 (concatD [doc (showString "("), prt 0 parameters, doc (showString ")")])

instance Print Parameters where
  prt i e = case e of
    Parameters1 basicdeclaration moreparameters -> prPrec i 0 (concatD [prt 0 basicdeclaration, prt 0 moreparameters])
    Parameters2 -> prPrec i 0 (concatD [])

instance Print More_Parameters where
  prt i e = case e of
    More_Parameters1 basicdeclaration moreparameters -> prPrec i 0 (concatD [doc (showString ","), prt 0 basicdeclaration, prt 0 moreparameters])
    More_Parameters2 -> prPrec i 0 (concatD [])

instance Print Basic_Declaration where
  prt i e = case e of
    Basic_Declaration1 id basicarraydimensions type_ -> prPrec i 0 (concatD [prt 0 id, prt 0 basicarraydimensions, doc (showString ":"), prt 0 type_])

instance Print Basic_Array_Dimensions where
  prt i e = case e of
    Basic_Array_Dimensions1 basicarraydimensions -> prPrec i 0 (concatD [doc (showString "["), doc (showString "]"), prt 0 basicarraydimensions])
    Basic_Array_Dimensions2 -> prPrec i 0 (concatD [])

instance Print Program_Body where
  prt i e = case e of
    Program_Body1 progstmts -> prPrec i 0 (concatD [doc (showString "begin"), prt 0 progstmts, doc (showString "end")])

instance Print Fun_Body where
  prt i e = case e of
    Fun_Body1 progstmts expr -> prPrec i 0 (concatD [doc (showString "begin"), prt 0 progstmts, doc (showString "return"), prt 0 expr, doc (showString ";"), doc (showString "end")])

instance Print Prog_Stmts where
  prt i e = case e of
    Prog_Stmts1 progstmt progstmts -> prPrec i 0 (concatD [prt 0 progstmt, doc (showString ";"), prt 0 progstmts])
    Prog_Stmts2 -> prPrec i 0 (concatD [])

instance Print Prog_Stmt where
  prt i e = case e of
    Prog_Stmt1 expr progstmt1 progstmt2 -> prPrec i 0 (concatD [doc (showString "if"), prt 0 expr, doc (showString "then"), prt 0 progstmt1, doc (showString "else"), prt 0 progstmt2])
    Prog_Stmt2 expr progstmt -> prPrec i 0 (concatD [doc (showString "while"), prt 0 expr, doc (showString "do"), prt 0 progstmt])
    Prog_Stmt3 identifier -> prPrec i 0 (concatD [doc (showString "read"), prt 0 identifier])
    Prog_Stmt4 identifier expr -> prPrec i 0 (concatD [prt 0 identifier, doc (showString ":="), prt 0 expr])
    Prog_Stmt5 expr -> prPrec i 0 (concatD [doc (showString "print"), prt 0 expr])
    Prog_Stmt6 block -> prPrec i 0 (concatD [doc (showString "{"), prt 0 block, doc (showString "}")])

instance Print Identifier where
  prt i e = case e of
    Identifier1 id arraydimensions -> prPrec i 0 (concatD [prt 0 id, prt 0 arraydimensions])

instance Print Expr where
  prt i e = case e of
    Expr1 expr bintterm -> prPrec i 0 (concatD [prt 0 expr, doc (showString "||"), prt 0 bintterm])
    ExprBInt_Term bintterm -> prPrec i 0 (concatD [prt 0 bintterm])

instance Print BInt_Term where
  prt i e = case e of
    BInt_Term1 bintterm bintfactor -> prPrec i 0 (concatD [prt 0 bintterm, doc (showString "&&"), prt 0 bintfactor])
    BInt_TermBInt_Factor bintfactor -> prPrec i 0 (concatD [prt 0 bintfactor])

instance Print BInt_Factor where
  prt i e = case e of
    BInt_Factor1 bintfactor -> prPrec i 0 (concatD [doc (showString "not"), prt 0 bintfactor])
    BInt_Factor2 intexpr1 compareop intexpr2 -> prPrec i 0 (concatD [prt 0 intexpr1, prt 0 compareop, prt 0 intexpr2])
    BInt_FactorInt_Expr intexpr -> prPrec i 0 (concatD [prt 0 intexpr])

instance Print Compare_Op where
  prt i e = case e of
    Compare_Op1 -> prPrec i 0 (concatD [doc (showString "=")])
    Compare_Op2 -> prPrec i 0 (concatD [doc (showString "<")])
    Compare_Op3 -> prPrec i 0 (concatD [doc (showString ">")])
    Compare_Op4 -> prPrec i 0 (concatD [doc (showString "=<")])
    Compare_Op5 -> prPrec i 0 (concatD [doc (showString ">=")])

instance Print Int_Expr where
  prt i e = case e of
    Int_Expr1 intexpr addop intterm -> prPrec i 0 (concatD [prt 0 intexpr, prt 0 addop, prt 0 intterm])
    Int_ExprInt_Term intterm -> prPrec i 0 (concatD [prt 0 intterm])

instance Print Addop where
  prt i e = case e of
    Addop1 -> prPrec i 0 (concatD [doc (showString "+")])
    Addop2 -> prPrec i 0 (concatD [doc (showString "-")])

instance Print Int_Term where
  prt i e = case e of
    Int_Term1 intterm mulop intfactor -> prPrec i 0 (concatD [prt 0 intterm, prt 0 mulop, prt 0 intfactor])
    Int_TermInt_Factor intfactor -> prPrec i 0 (concatD [prt 0 intfactor])

instance Print Mulop where
  prt i e = case e of
    Mulop1 -> prPrec i 0 (concatD [doc (showString "*")])
    Mulop2 -> prPrec i 0 (concatD [doc (showString "/")])

instance Print Int_Factor where
  prt i e = case e of
    Int_Factor1 expr -> prPrec i 0 (concatD [doc (showString "("), prt 0 expr, doc (showString ")")])
    Int_Factor2 id basicarraydimensions -> prPrec i 0 (concatD [doc (showString "size"), doc (showString "("), prt 0 id, prt 0 basicarraydimensions, doc (showString ")")])
    Int_Factor3 expr -> prPrec i 0 (concatD [doc (showString "float"), doc (showString "("), prt 0 expr, doc (showString ")")])
    Int_Factor4 expr -> prPrec i 0 (concatD [doc (showString "floor"), doc (showString "("), prt 0 expr, doc (showString ")")])
    Int_Factor5 expr -> prPrec i 0 (concatD [doc (showString "ceil"), doc (showString "("), prt 0 expr, doc (showString ")")])
    Int_Factor6 id modifierlist -> prPrec i 0 (concatD [prt 0 id, prt 0 modifierlist])
    Int_FactorIVAL ival -> prPrec i 0 (concatD [prt 0 ival])
    Int_FactorRVAL rval -> prPrec i 0 (concatD [prt 0 rval])
    Int_FactorBVAL bval -> prPrec i 0 (concatD [prt 0 bval])
    Int_Factor7 intfactor -> prPrec i 0 (concatD [doc (showString "-"), prt 0 intfactor])

instance Print Modifier_List where
  prt i e = case e of
    Modifier_List1 arguments -> prPrec i 0 (concatD [doc (showString "("), prt 0 arguments, doc (showString ")")])
    Modifier_ListArray_Dimensions arraydimensions -> prPrec i 0 (concatD [prt 0 arraydimensions])

instance Print Arguments where
  prt i e = case e of
    Arguments1 expr morearguments -> prPrec i 0 (concatD [prt 0 expr, prt 0 morearguments])
    Arguments2 -> prPrec i 0 (concatD [])

instance Print More_Arguments where
  prt i e = case e of
    More_Arguments1 expr morearguments -> prPrec i 0 (concatD [doc (showString ","), prt 0 expr, prt 0 morearguments])
    More_Arguments2 -> prPrec i 0 (concatD [])


