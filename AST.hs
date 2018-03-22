module AST where
{-
The AST was laid out by Dr. Cockett in his documentation for the M+ specs
-}

data M_prog = M_prog ([M_decl],[M_stmt])
  deriving (Eq, Ord, Show, Read)

data M_decl = M_var (String,[M_expr],M_type)
    | M_fun (String,[(String,Int,M_type)],M_type,[M_decl],[M_stmt])
  deriving (Eq, Ord, Show, Read)

data M_stmt = M_ass (String,[M_expr],M_expr)
    | M_while (M_expr,M_stmt)
    | M_cond (M_expr,M_stmt,M_stmt)
    | M_read (String,[M_expr])
    | M_print M_expr
    | M_return M_expr
    | M_block ([M_decl],[M_stmt])
  deriving (Eq, Ord, Show, Read)

data M_type = M_int | M_bool | M_real 
  deriving (Eq, Ord, Show, Read)

data M_expr = M_ival Int
    | M_rval Float
    | M_bval Bool
    | M_size (String,Int)
    | M_id (String,[M_expr])
    | M_app (M_operation,[M_expr])
  deriving (Eq, Ord, Show, Read)

data M_operation = M_fn String
    | M_add | M_mul | M_sub | M_div | M_neg
    | M_lt | M_le | M_gt | M_ge | M_eq | M_not | M_and | M_or
    | M_float | M_floor | M_ceil
  deriving (Eq, Ord, Show, Read)

ind :: Int -> String
ind 0 = ""
ind n = ". " ++ (ind $ n - 1)

ppProg :: M_prog -> String
ppProg (M_prog (decls, stmts)) = "M_prog(\n" ++ (ind 1) ++ "[\n" ++ (concat (map (ppDec 2) decls)) ++ (ind 1) ++ "],\n" ++ (ind 1) ++ "[\n" ++ (concat (map (ppStmt 2) stmts)) ++ (ind 1) ++ "]\n)"

ppDec :: Int -> M_decl -> String
ppDec n (M_var (str, exprs, type_)) = (ind n) ++ "M_var(" ++ str ++ ",\n" ++ (ind (n + 1)) ++ "[\n"  ++ (concat (map (ppExpr (n + 2)) exprs)) ++ (ind (n + 1)) ++ "],\n" ++ (ppType (n + 1) type_) ++ "\n"  ++ (ind n) ++ ")\n"
ppDec n (M_fun (str, trip, type_, decs, stmts)) = (ind n) ++ "M_fun(" ++ str ++ ",\n" ++ (ind (n + 1)) ++ "[\n" ++ (concat (map (ppTrip (n + 2)) trip)) ++ (ind (n + 1)) ++ "],\n" ++ (ppType (n + 1) type_) ++ ",\n" ++ (ind (n + 1)) ++ "[\n" ++ (concat (map (ppDec (n + 2)) decs)) ++ (ind (n + 1)) ++ "],\n" ++ (ind (n + 1)) ++ "[\n" ++ (concat (map (ppStmt (n + 2)) stmts)) ++ (ind (n + 1)) ++ "]\n" ++ (ind n) ++ ")\n"

ppTrip :: Int -> (String, Int, M_type) -> String
ppTrip n (str, num, type_) = (ind n) ++ "(" ++ str ++ ", " ++ (show num) ++ ", " ++ (ppType 0 type_) ++ ")\n"

ppStmt :: Int -> M_stmt -> String
ppStmt n st = case st of
  M_ass (str, exprs, expr) -> (ind n) ++ "M_ass(" ++ str ++ ",\n" ++ (ind (n + 1)) ++ "[\n" ++ (concat (map (ppExpr (n + 2)) exprs)) ++ (ind (n + 1)) ++ "],\n" ++ (ppExpr (n + 1) expr) ++ (ind n) ++ ")\n"
  M_while (expr, stmt) -> (ind n) ++ "M_while(\n" ++ (ppExpr (n + 1) expr) ++ (ind (n + 1)) ++ ",\n" ++ (ppStmt (n + 1) stmt) ++ (ind n) ++ ")\n"
  M_cond (expr, stmt1, stmt2) -> (ind n) ++ "M_cond(\n" ++ (ppExpr (n + 1) expr) ++ (ind (n + 1)) ++ ",\n" ++ (ppStmt (n + 1) stmt1) ++ (ind (n + 1)) ++ ",\n" ++ (ppStmt (n + 1) stmt2) ++ (ind n) ++ ")\n"
  M_read (str, exprs) -> (ind n) ++ "M_read(" ++ str ++ ",\n" ++ (ind (n + 1)) ++ "[\n" ++ (concat (map (ppExpr (n + 2)) exprs)) ++ (ind (n + 1)) ++ "]\n" ++ (ind n) ++ ")\n"
  M_print expr -> (ind n) ++ "M_print(\n" ++ (ppExpr (n + 1) expr) ++ (ind n) ++ ")\n"
  M_return expr -> (ind n) ++ "M_return(\n" ++ (ppExpr (n + 1) expr) ++ (ind n) ++ ")\n"
  M_block (decs, stmts) -> (ind n) ++ "M_block(\n" ++ (ind (n + 1)) ++ "[\n" ++ (concat (map (ppDec (n + 2)) decs)) ++ "],\n" ++ (ind (n + 1)) ++ "[\n" ++ (concat (map (ppStmt (n + 2)) stmts)) ++ (ind (n + 1)) ++ "]\n" ++ (ind n) ++ ")\n"

ppType :: Int -> M_type -> String
ppType n ty = case ty of
  M_int -> (ind n) ++ "M_int"
  M_bool -> (ind n) ++ "M_bool"
  M_real -> (ind n) ++ "M_real"

ppExpr :: Int -> M_expr -> String
ppExpr n exp = case exp of
  M_ival num -> (ind n) ++ "M_ival(" ++ (show num) ++ ")\n"
  M_rval flo -> (ind n) ++ "M_rval(" ++ (show flo) ++ ")\n"
  M_bval bl -> (ind n) ++ "M_bval(" ++ (show bl) ++ ")\n"
  M_size (str, num) -> (ind n) ++ "M_size(" ++ str ++ ", " ++ (show num) ++ ")\n"
  M_id (str, exprs) -> (ind n) ++ "M_id(" ++ str ++ ",\n" ++ (ind (n + 1)) ++  "[\n" ++ (concat (map (ppExpr (n + 2)) exprs)) ++ (ind (n + 1)) ++ "]\n" ++ (ind n) ++ ")\n"
  M_app (op, exprs) -> (ind n) ++ "M_app(" ++ (ppOp (n + 1) op) ++ ",\n" ++ (ind (n + 1)) ++ "[\n" ++ (concat (map (ppExpr (n + 2)) exprs)) ++ (ind (n + 1)) ++ "]\n" ++ (ind n) ++ ")\n"

ppOp :: Int -> M_operation -> String
ppOp n op = case op of
  M_fn str -> "M_fn(" ++ str ++ ")"
  M_add -> "M_add"
  M_sub -> "M_sub"
  M_mul -> "M_mul"
  M_div -> "M_div"
  M_neg -> "M_neg"
  M_lt -> "M_lt"
  M_gt -> "M_gt"
  M_le -> "M_le"
  M_ge -> "M_ge"
  M_eq -> "M_eq"
  M_not -> "M_not"
  M_and -> "M_and" 
  M_or -> "M_or"
  M_float -> "M_float"
  M_floor -> "M_floor"
  M_ceil -> "M_ceil"

