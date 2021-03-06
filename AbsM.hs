

module AbsM where

-- Haskell module generated by the BNF converter




newtype ID = ID String deriving (Eq, Ord, Show, Read)
newtype IVAL = IVAL String deriving (Eq, Ord, Show, Read)
newtype RVAL = RVAL String deriving (Eq, Ord, Show, Read)
newtype BVAL = BVAL String deriving (Eq, Ord, Show, Read)
data Prog = ProgBlock Block
  deriving (Eq, Ord, Show, Read)

data Block = Block1 Declarations Program_Body
  deriving (Eq, Ord, Show, Read)

data Declarations
    = Declarations1 Declaration Declarations | Declarations2
  deriving (Eq, Ord, Show, Read)

data Declaration
    = DeclarationVar_Declaration Var_Declaration
    | DeclarationFun_Declaration Fun_Declaration
  deriving (Eq, Ord, Show, Read)

data Var_Declaration = Var_Declaration1 ID Array_Dimensions Type
  deriving (Eq, Ord, Show, Read)

data Type = Type_int | Type_real | Type_bool
  deriving (Eq, Ord, Show, Read)

data Array_Dimensions
    = Array_Dimensions1 Expr Array_Dimensions | Array_Dimensions2
  deriving (Eq, Ord, Show, Read)

data Fun_Declaration
    = Fun_Declaration1 ID Param_List Type Fun_Block
  deriving (Eq, Ord, Show, Read)

data Fun_Block = Fun_Block1 Declarations Fun_Body
  deriving (Eq, Ord, Show, Read)

data Param_List = Param_List1 Parameters
  deriving (Eq, Ord, Show, Read)

data Parameters
    = Parameters1 Basic_Declaration More_Parameters | Parameters2
  deriving (Eq, Ord, Show, Read)

data More_Parameters
    = More_Parameters1 Basic_Declaration More_Parameters
    | More_Parameters2
  deriving (Eq, Ord, Show, Read)

data Basic_Declaration
    = Basic_Declaration1 ID Basic_Array_Dimensions Type
  deriving (Eq, Ord, Show, Read)

data Basic_Array_Dimensions
    = Basic_Array_Dimensions1 Basic_Array_Dimensions
    | Basic_Array_Dimensions2
  deriving (Eq, Ord, Show, Read)

data Program_Body = Program_Body1 Prog_Stmts
  deriving (Eq, Ord, Show, Read)

data Fun_Body = Fun_Body1 Prog_Stmts Expr
  deriving (Eq, Ord, Show, Read)

data Prog_Stmts = Prog_Stmts1 Prog_Stmt Prog_Stmts | Prog_Stmts2
  deriving (Eq, Ord, Show, Read)

data Prog_Stmt
    = Prog_Stmt1 Expr Prog_Stmt Prog_Stmt
    | Prog_Stmt2 Expr Prog_Stmt
    | Prog_Stmt3 Identifier
    | Prog_Stmt4 Identifier Expr
    | Prog_Stmt5 Expr
    | Prog_Stmt6 Block
  deriving (Eq, Ord, Show, Read)

data Identifier = Identifier1 ID Array_Dimensions
  deriving (Eq, Ord, Show, Read)

data Expr = Expr1 Expr BInt_Term | ExprBInt_Term BInt_Term
  deriving (Eq, Ord, Show, Read)

data BInt_Term
    = BInt_Term1 BInt_Term BInt_Factor
    | BInt_TermBInt_Factor BInt_Factor
  deriving (Eq, Ord, Show, Read)

data BInt_Factor
    = BInt_Factor1 BInt_Factor
    | BInt_Factor2 Int_Expr Compare_Op Int_Expr
    | BInt_FactorInt_Expr Int_Expr
  deriving (Eq, Ord, Show, Read)

data Compare_Op
    = Compare_Op1
    | Compare_Op2
    | Compare_Op3
    | Compare_Op4
    | Compare_Op5
  deriving (Eq, Ord, Show, Read)

data Int_Expr
    = Int_Expr1 Int_Expr Addop Int_Term | Int_ExprInt_Term Int_Term
  deriving (Eq, Ord, Show, Read)

data Addop = Addop1 | Addop2
  deriving (Eq, Ord, Show, Read)

data Int_Term
    = Int_Term1 Int_Term Mulop Int_Factor
    | Int_TermInt_Factor Int_Factor
  deriving (Eq, Ord, Show, Read)

data Mulop = Mulop1 | Mulop2
  deriving (Eq, Ord, Show, Read)

data Int_Factor
    = Int_Factor1 Expr
    | Int_Factor2 ID Basic_Array_Dimensions
    | Int_Factor3 Expr
    | Int_Factor4 Expr
    | Int_Factor5 Expr
    | Int_Factor6 ID Modifier_List
    | Int_FactorIVAL IVAL
    | Int_FactorRVAL RVAL
    | Int_FactorBVAL BVAL
    | Int_Factor7 Int_Factor
  deriving (Eq, Ord, Show, Read)

data Modifier_List
    = Modifier_List1 Arguments
    | Modifier_ListArray_Dimensions Array_Dimensions
  deriving (Eq, Ord, Show, Read)

data Arguments = Arguments1 Expr More_Arguments | Arguments2
  deriving (Eq, Ord, Show, Read)

data More_Arguments
    = More_Arguments1 Expr More_Arguments | More_Arguments2
  deriving (Eq, Ord, Show, Read)

