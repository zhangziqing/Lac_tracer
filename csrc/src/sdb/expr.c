#include <regex.h>
#include <debug.h>
#include <common.h>
#include <memory/memory.h>
#include <isa/loongArch.h>

uintptr_t get_sym_addr(const char* name,bool *status);

enum
{
  TK_NOTYPE = 256,
  TK_EQ,
  TK_DECNUM,
  TK_HEXNUM,
  TK_OCTNUM,
  TK_REG,
  TK_NEQ,
  TK_AND,
  TK_OR,
  TK_DEREF,
  TK_NEG,
  TK_IDENT
  /* TODO: Add more token types */

};

static struct rule
{
  const char *regex;
  int token_type;
} rules[] = {

    /* TODO: Add more rules.
     * Pay attention to the precedence level of different rules.
     */

    {" +", TK_NOTYPE}, // spaces
    {"\\+", '+'},      // plus
    {"==", TK_EQ},     // equal
    {"!=", TK_NEQ},
    {"&&", TK_AND},
    {"\\|\\|", TK_OR},
    {"\\*", '*'},
    {"-", '-'},
    {"/", '/'},
    {"0x[0-9a-fA-F]*", TK_HEXNUM},
    {"0[0-7]+", TK_OCTNUM},
    {"[1-9][0-9]*|0", TK_DECNUM},
    {"\\(", '('},
    {"\\)", ')'},
    {"\\$[a-z0-9]+", TK_REG},
    {"[_1-9a-zA-Z][_0-9a-zA-Z]*", TK_IDENT},
};

#define NR_REGEX (int)sizeof(rules)/sizeof(rules[0])

static regex_t re[NR_REGEX] = {};

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex()
{
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i++)
  {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0)
    {
      regerror(ret, &re[i], error_msg, 128);
      panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }
}

typedef struct token
{
  int type;
  char str[32];
} Token;

// tokens: global variable, store the tokens
static Token tokens[32] __attribute__((used)) = {};

static int nr_token __attribute__((used)) = 0;

static volatile bool make_token(char *e)
{
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

  while (e[position] != '\0')
  {
    /* Try all rules one by one. */
    bool mktoken = true;
    for (i = 0; i < NR_REGEX; i++)
    {
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0)
      {
        // 1 means REG_EXTENDED: use POSIX Extended Regular Expression
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        // Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s",
        //     i, rules[i].regex, position, substr_len, substr_len, substr_start);

        position += substr_len;

        /* TODO: Now a new token is recognized with rules[i]. Add codes
         * to record the token in the array `tokens'. For certain types
         * of tokens, some extra actions should be performed.
         */

        switch (rules[i].token_type)
        {
        case TK_NOTYPE:
          mktoken = false;
          break;
        case TK_DECNUM:
          tokens[nr_token].type = TK_DECNUM;
          strncpy(tokens[nr_token].str, substr_start, substr_len);
          tokens[nr_token].str[substr_len] = '\0';
          break;
        case TK_HEXNUM:
          tokens[nr_token].type = TK_HEXNUM;
          strncpy(tokens[nr_token].str, substr_start, substr_len);
          tokens[nr_token].str[substr_len] = '\0';
          break;
        case TK_OCTNUM:
          tokens[nr_token].type = TK_OCTNUM;
          strncpy(tokens[nr_token].str, substr_start, substr_len);
          tokens[nr_token].str[substr_len] = '\0';
          break;
        case TK_REG:
          tokens[nr_token].type = TK_REG;
          strncpy(tokens[nr_token].str, substr_start, substr_len);
          tokens[nr_token].str[substr_len] = '\0';
          break;
        case TK_IDENT:
          tokens[nr_token].type = TK_IDENT;
          strncpy(tokens[nr_token].str, substr_start, substr_len);
          tokens[nr_token].str[substr_len] = '\0';
          break;
        case '-':
          if (nr_token == 0 || ((tokens[nr_token - 1].type != TK_HEXNUM) && (tokens[nr_token - 1].type != TK_OCTNUM) && (tokens[nr_token - 1].type != TK_DECNUM) && (tokens[nr_token - 1].type != TK_REG) && (tokens[nr_token - 1].type != ')')))
          {
            tokens[nr_token].type = TK_NEG;
          }
          else
          {
            tokens[nr_token].type = '-';
          }
          break;
        case '*':
          if (nr_token == 0 || ((tokens[nr_token - 1].type != TK_HEXNUM) && (tokens[nr_token - 1].type != TK_OCTNUM) && (tokens[nr_token - 1].type != TK_DECNUM) && (tokens[nr_token - 1].type != TK_REG) && (tokens[nr_token - 1].type != ')')))
          {
            tokens[nr_token].type = TK_DEREF;
          }
          else
          {
            tokens[nr_token].type = '*';
          }
          break;
        default:
          tokens[nr_token].type = rules[i].token_type;
        }
        break;
      }
    }
    if (i == NR_REGEX)
    {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }
    if (mktoken)
    {
      // Log("token type:%d,token str:%s", tokens[nr_token].type, tokens[nr_token].str);
      ++nr_token;
    }
  }
  return true;
}

inline static bool check_parentheses(int p, int q)
{
  return tokens[p].type == '(' && tokens[q].type == ')';
}

inline static bool check_unary(int p)
{
  return tokens[p].type == TK_DEREF || tokens[p].type == TK_NEG;
}
enum
{
  E_NORMAL,
  E_EXP,
  E_REG,
  E_DIVZ,
  E_IDENT,
  E_NUM
};

static char *(error)[] = {
    "success\n",
    "Invalid expression\n",
    "Invalid register name\n",
    "The divisor is zero\n",
    "Invalid Identifier\n",
    };
enum
{
  P_UNARY,
  P_MULDIV,
  P_ADDSUB,
  P_EQNEQ,
  P_AND,
  P_OR,
};
word_t static tokens_eval(int p, int q, int *status)
{
  if (p > q)
  {
    *status = E_EXP;
    return -1;
  }
  else if (p == q)
  {
    word_t data;
    bool sub_status;
    switch (tokens[p].type)
    {
    case TK_DECNUM:
      sscanf(tokens[p].str, "%d", &data);
      *status = E_NORMAL;
      return data;
    case TK_OCTNUM:
      sscanf(tokens[p].str, "%o", &data);
      *status = E_NORMAL;
      return data;
    case TK_HEXNUM:
      sscanf(tokens[p].str, "%x", &data);
      *status = E_NORMAL;
      return data;
    case TK_REG:
      data = isa_reg_str2val(tokens[p].str + 1, &sub_status);
      if (sub_status)
      {
        *status = E_NORMAL;
        return data;
      }
      else
      {
        *status = E_REG;
        return -1;
      }
    case TK_IDENT:
      data = get_sym_addr(tokens[p].str, &sub_status);
      if (!sub_status){
        *status = E_NORMAL;
        return data;
      } else {
        *status = E_IDENT;
        return -1;
      }
    }
  }
  else if (check_parentheses(p, q))
  {
    int sub_status;
    word_t val = tokens_eval(p + 1, q - 1, &sub_status);
    if (sub_status != E_NORMAL)
    {
      *status = sub_status;
      return -1;
    }
    *status = E_NORMAL;
    return val;
  }
  else
  {
    // find the main operation of the expression
    int op = 0;
    int level = -1;
    for (int i = p; i <= q; i++)
    {
      if (tokens[i].type == TK_OR && level <= P_OR)
      {
        op = i;
        level = P_OR;
      }
      else if (tokens[i].type == TK_AND && level <= P_AND)
      {
        op = i;
        level = P_AND;
      }
      else if ((tokens[i].type == TK_EQ || tokens[i].type == TK_NEQ) && level <= P_EQNEQ)
      {
        op = i;
        level = P_EQNEQ;
      }
      else if ((tokens[i].type == '+' || tokens[i].type == '-') && level <= P_ADDSUB)
      {
        op = i;
        level = P_ADDSUB;
      }
      else if ((tokens[i].type == '*' || tokens[i].type == '/') && level <= P_MULDIV)
      {
        op = i;
        level = P_MULDIV;
      }
      // else if ((tokens[i].type == TK_DEREF || tokens[i].type == TK_NEG) && level <= P_UNARY)
      // {
      //   op = i;
      //   level = P_UNARY;
      // }
      else if (tokens[i].type == '(')
      {
        int stack = 1;
        while (stack != 0)
        {
          ++i;
          if (tokens[i].type == ')')
            --stack;
          if (tokens[i].type == '(')
            ++stack;
          if (i > q)
          {
            *status = E_EXP;
            return -1;
          }
        }
      }
      else if (tokens[i].type == ')')
      {
        *status = E_EXP;
        return -1;
      }
    }

    if (op == 0)
    {
      int sub_status;
      word_t val = tokens_eval(p + 1, q, &sub_status);
      *status = E_NORMAL;
      if (sub_status != E_NORMAL)
      {
        *status = sub_status;
        return -1;
      }
      switch (tokens[p].type)
      {
      case TK_DEREF:
        if(!out_of_bound(val))return vaddr_read(val, sizeof(word_t));
        else printf(ASNI_FMT("Address out of bound", ASNI_BG_RED));
        printf("\n");
        break;
      case TK_NEG:
        return -val;
        break;
      default:
        panic("Why you are here!!!!");
        break;
      }
    }
    *status = E_NORMAL;
    int sub_status1, sub_status2;
    word_t val1 = tokens_eval(p, op - 1, &sub_status1);
    if (sub_status1 != E_NORMAL)
    {
      *status = sub_status1;
      return -1;
    }
    word_t val2 = tokens_eval(op + 1, q, &sub_status2);
    if (sub_status2 != E_NORMAL)
    {
      *status = sub_status2;
      return -1;
    }
    *status = E_NORMAL;
    switch (tokens[op].type)
    {
    case TK_AND:
      return val1 && val2;
    case TK_OR:
      return val1 || val2;
    case TK_NEQ:
      return val1 != val2;
    case TK_EQ:
      return val1 == val2;
    case '+':
      return val1 + val2;
    case '-':
      return val1 - val2;
    case '*':
      return val1 * val2;
    case '/':
      if (val2 == 0)
      {
        *status = E_DIVZ;
        return -1;
      }
      return val1 / val2;
    default:
      panic("%d,You are in the middle of nowhere", tokens[op].type);
      break;
    }
  }
  return false;
}

word_t expr(char *e, bool *success)
{
  if (!make_token(e))
  {
    *success = false;
    return 0;
  }
  int status = E_NORMAL;
  word_t res_val = tokens_eval(0, nr_token - 1, &status);
  if (status != 0)
  {
    Assert(status < E_NUM, "status = %d", status);
    printf("status:%d,%s", status, error[status]);
  }
  /* TODO: Insert codes to evaluate the expression. */
  // TODO();
  *success = status == E_NORMAL;
  return res_val;
}
