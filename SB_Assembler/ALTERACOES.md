# Alterações para Tratamento de Expressões em Operandos

## Resumo
O código foi modificado para permitir operandos como expressões aritméticas (ex: `LOAD XY+2`, `COPY XY+2,XY+3`) tanto na fase de pré-processamento (.asm → .pre) quanto na tradução (.pre → .obj).

---

## 1. Novas Funções Implementadas

### `evaluateExpression()`
```cpp
int evaluateExpression(const string& expr, unordered_map<string,tuple<int,bool,string>>& symbolTB)
```
- **Propósito**: Avalia expressões aritméticas contendo labels e números
- **Operadores suportados**: `+`, `-`, `*`, `/`
- **Comportamento**: 
  - Procura pelo operador na expressão
  - Resolve cada operando (label ou número)
  - Executa a operação
  - Retorna -1 se algum label não estiver definido
- **Exemplos**:
  - `LABEL+2` → endereço de LABEL + 2
  - `LABEL-1` → endereço de LABEL - 1
  - `X*3` → endereço de X multiplicado por 3

### `containsArithmeticOp()`
```cpp
bool containsArithmeticOp(const string& str)
```
- **Propósito**: Verifica se uma string contém operadores aritméticos
- **Ignora**: Sinal inicial (+/-)
- **Uso**: Identificar operandos que são expressões

---

## 2. Modificações na Fase de Pré-Processamento (.asm → .pre)

### Antes
```cpp
// Tratava apenas LOAD com +
else if(pre_line.substr(0,4) == "LOAD" && pre_line.find('+') != std::string::npos){
    // ...normaliza LOAD XY+2
}
```

### Depois
Agora trata **todas as instruções de operando único** com expressões:
- `LOAD`, `STORE`, `ADD`, `SUB`, `MUL`, `MULT`, `DIV`
- `JMP`, `JMPN`, `JMPP`, `JMPZ`

E **COPY com dois operandos** contendo expressões:
```cpp
// COPY com expressões: COPY XY+2,XY+3
else if(pre_line.substr(0,4) == "COPY"){
    auto comma = pre_line.find(',');
    string aux1 = pre_line.substr(4,comma-4);
    string aux2 = pre_line.substr(comma+1);
    // Remove espaços mantendo a expressão: XY+2,XY+3
    aux1.erase(remove(aux1.begin(), aux1.end(), ' '), aux1.end());
    aux2.erase(remove(aux2.begin(), aux2.end(), ' '), aux2.end());
    pre_line = "COPY "+aux1+','+aux2;
}
```

**Ação**: Normaliza removendo espaços desnecessários de operandos com expressões

---

## 3. Modificações na Fase de Tradução (.pre → .obj)

### Para operandos com vírgula (COPY)
```cpp
auto comma = aux.find(',');
if (comma != std::string::npos){
    string p1 = aux.substr(0,comma);
    string p2 = aux.substr(comma+1);
    
    // Processa primeiro operando - AGORA COM SUPORTE A EXPRESSÕES
    if(containsArithmeticOp(p1)){
        int result = evaluateExpression(p1, symbolTB);
        auxp1 = (result != -1) ? to_string(result) : "-1";
    }
    else if(!isNumeric(p1) && symbolTB.count(p1)){
        // ... trata label
    }
    // Similar para p2
}
```

### Para operandos únicos
```cpp
else if(!isNumeric(words[i]) && symbolTB.count(words[i]) == 0){
    // NOVO: Tenta avaliar como expressão
    if(containsArithmeticOp(words[i])){
        int result = evaluateExpression(words[i], symbolTB);
        aux = (result != -1) ? to_string(result) : "-1";
    }
    else{
        // ... trata como label desconhecido
    }
}
```

---

## 4. Fluxo de Tratamento de Expressões

### Exemplo: `LOAD XY+2`

**Fase 1 - Pré-processamento (.asm → .pre)**
```
Entrada:   LOAD  XY + 2
Saída:     LOAD XY+2    (espaços removidos)
```

**Fase 2 - Tradução (.pre → .obj)**
```
1. Detecta que "XY+2" contém operador: +
2. Chama evaluateExpression("XY+2", symbolTB)
3. Separa em operandos: "XY" e "2"
4. Resolve "XY" → valor do label (ex: 100)
5. Resolve "2" → 2
6. Calcula: 100 + 2 = 102
7. Resultado final: 102
```

---

## 5. Casos Suportados

✅ **Operandos simples**:
- `LOAD 10` (número)
- `LOAD XY` (label)
- `LOAD XY+2` (expressão)

✅ **Dois operandos (COPY)**:
- `COPY 10,20` (números)
- `COPY XY,ZW` (labels)
- `COPY XY+2,ZW-1` (expressões)
- `COPY 10,XY+5` (misto)

✅ **Expressões**:
- Adição: `LABEL+5`
- Subtração: `LABEL-3`
- Multiplicação: `LABEL*2`
- Divisão: `LABEL/2`

---

## 6. Tratamento de Erros

Se um label em uma expressão não estiver definido:
- `evaluateExpression()` retorna `-1`
- Operando é representado como `-1` no código objeto
- Indica forward reference ou label indefinido

---

## 7. Exemplo Completo

### Arquivo entrada (exemplo.asm):
```asm
SECTION TEXT
LOOP:   LOAD DADOS+1
        ADD VALUE+2
        COPY LOOP+3, DADOS-1
        JMPN LOOP
```

### Após pré-processamento (exemplo.pre):
```
LOOP: LOAD DADOS+1
ADD VALUE+2
COPY LOOP+3,DADOS-1
JMPN LOOP
```

### Após tradução (exemplo.obj):
(com resolução de endereços conforme symbol table)

---

## Compilação

O código foi testado e compila corretamente com:
```bash
g++ -std=c++17 montador.cpp -o montador
```

✅ Sem erros de compilação
