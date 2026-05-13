#include <bits/stdc++.h>
using namespace std;

string constHxd(string a){
    transform(a.begin(), a.end(), a.begin(), ::tolower);
    if(a.substr(0,2) == "0x"){
            int value;
            std::stringstream ss;
            ss << std::hex << a.substr(2,a.length());
            ss >> value;

            return to_string(value);
    }
    return a;
}

bool matchesPattern(const std::string& s) {
    regex pattern("^\\s*$");
    return regex_match(s, pattern);
}

bool isNumeric(const std::string& str) {
    if (str.empty()) return false;

    size_t start = (str[0] == '-' || str[0] == '+') ? 1 : 0;

    if (start == str.length()) return false;

    for (size_t i = start; i < str.length(); ++i) {
        if (!std::isdigit(static_cast<unsigned char>(str[i]))) {
            return false;
        }
    }
    return true;
}

int evaluateExpression(const string& expr, unordered_map<string,tuple<int,bool,string>>& symbolTB) {
    string operators = "+-*/";
    int operatorPos = -1;
    char op = ' ';

    for (int i = expr.length() - 1; i > 0; --i) {
        if (operators.find(expr[i]) != string::npos) {
            operatorPos = i;
            op = expr[i];
            break;
        }
    }

    if (operatorPos == -1) {
        if (isNumeric(expr)) {
            return stoi(expr);
        } else if (symbolTB.count(expr) && get<1>(symbolTB[expr])) {
            return get<0>(symbolTB[expr]);
        }
        return -1;
    }

    string operand1 = expr.substr(0, operatorPos);
    string operand2 = expr.substr(operatorPos + 1);

    operand1.erase(remove(operand1.begin(), operand1.end(), ' '), operand1.end());
    operand2.erase(remove(operand2.begin(), operand2.end(), ' '), operand2.end());

    int val1;
    if (isNumeric(operand1)) {
        val1 = stoi(operand1);
    } else if (symbolTB.count(operand1) && get<1>(symbolTB[operand1])) {
        val1 = get<0>(symbolTB[operand1]);
    } else {
        return -1;
    }

    int val2;
    if (isNumeric(operand2)) {
        val2 = stoi(operand2);
    } else if (symbolTB.count(operand2) && get<1>(symbolTB[operand2])) {
        val2 = get<0>(symbolTB[operand2]);
    } else {
        return -1;
    }

    switch(op) {
        case '+': return val1 + val2;
        case '-': return val1 - val2;
        case '*': return val1 * val2;
        case '/': return val2 != 0 ? val1 / val2 : -1;
        default: return -1;
    }
}

bool containsArithmeticOp(const string& str) {
    string operators = "+-*/";
    for (int i = 1; i < (int)str.length(); ++i) {
        if (operators.find(str[i]) != string::npos) {
            return true;
        }
    }
    return false;
}

bool containsLabel(const string& expr, const string& label) {
    return expr.find(label) != string::npos;
}

void solvePen(tuple<int,bool,string>& symbol, map<int,string>& objCodeEnd,
              map<int,string>& pendingExpressions, const string& labelName,
              unordered_map<string,tuple<int,bool,string>>& symbolTB){
    int value = get<0>(symbol);
    int end = stoi(get<2>(symbol)),newEnd;
    bool copyFlag = false;
    while(true){
        if(objCodeEnd.count(end-2)){
            string line = objCodeEnd[end-2];
            stringstream ss(line);
            string word;
            vector<std::string> words;
            while (ss >> word) words.push_back(word);
            string newLine = "";
            for(int i=0;i<(int)words.size();i++){
                string aux = words[i];
                if(i == 2){
                    newEnd = stoi(aux);
                    aux = to_string(value);
                    newLine += aux;
                }
                else newLine += aux+" ";
            }
            objCodeEnd[end-2] = newLine;
        }
        else if(objCodeEnd.count(end-1)){
            string line = objCodeEnd[end-1];
            stringstream ss(line);
            string word;
            vector<std::string> words;
            while (ss >> word) words.push_back(word);
            string newLine = "";
            for(int i=0;i<(int)words.size();i++){
                string aux = words[i];
                if(aux == "09") copyFlag = true;
                if(i == 1){
                    newEnd = stoi(aux);
                    aux = to_string(value);
                    if(copyFlag){
                        copyFlag = false;
                        newLine += aux+" ";
                    }
                    else newLine += aux;
                }
				else if(i == 2){
                    newLine += aux;
                }
                else newLine += aux+" ";
            }
            objCodeEnd[end-1] = newLine;

        }
        end = newEnd;
        if(end == -1) break;
    }

    for(auto& [address, line] : objCodeEnd){
        if(pendingExpressions.count(address)){
            string expr = pendingExpressions[address];

            if(containsLabel(expr, labelName)){
                stringstream ss(line);
                string word;
                vector<string> words;
                while (ss >> word) words.push_back(word);

                if(words.size() == 2 && words[0] != "09"){
                    if(words[1] == "-1"){
                        int result = evaluateExpression(expr, symbolTB);
                        if(result != -1){
                            words[1] = to_string(result);

                            string newLine = words[0] + " " + words[1];
                            objCodeEnd[address] = newLine;
                        }
                    }
                }
                else if(words.size() == 3 && words[0] == "09"){
                    bool changed = false;

                    if(words[1] == "-1"){
                        size_t commaPos = expr.find(',');
                        string expr1 = (commaPos != string::npos) ? expr.substr(0, commaPos) : expr;
                        expr1.erase(remove(expr1.begin(), expr1.end(), ' '), expr1.end());

                        if(containsLabel(expr1, labelName)){
                            int result = evaluateExpression(expr1, symbolTB);
                            if(result != -1){
                                words[1] = to_string(result);
                                changed = true;
                            }
                        }
                    }

                    if(words[2] == "-1"){
                        size_t commaPos = expr.find(',');
                        string expr2 = (commaPos != string::npos) ? expr.substr(commaPos + 1) : "";
                        expr2.erase(remove(expr2.begin(), expr2.end(), ' '), expr2.end());

                        if(containsLabel(expr2, labelName)){
                            int result = evaluateExpression(expr2, symbolTB);
                            if(result != -1){
                                words[2] = to_string(result);
                                changed = true;
                            }
                        }
                    }

                    if(changed){
                        string newLine = words[0] + " " + words[1] + " " + words[2];
                        objCodeEnd[address] = newLine;
                    }
                }
            }
        }
    }

    return;
}

int main(int argc, char* argv[]){
    if (argc < 2) {
        cerr << "Usage: " << argv[0] << " <filename>" << endl;
        return 1;
    }
    string aux = (string)argv[1];
    string filename = aux.substr(0,aux.length()-4);
    string extension = aux.substr(aux.length()-3,aux.length());

    ifstream file(argv[1]);
    if (!file.is_open()) {
        cerr << "Error: Could not open " << argv[1] << endl;
        return 1;
    }

    string line;
    string outputExt;
    if(extension == "asm") outputExt = ".pre";
    else if(extension == "pre") outputExt = ".obj";

    string auxLabel = "";
    bool skipFlag = false, ifFlag = false, equFlag = false, dataFlag = false, spaceFlag = false;
    unordered_map<string,string> directiveTB;
    queue<string> dataQueue;
    unordered_map<string,tuple<int,bool,string>> symbolTB;
    map<int,string> objCodeEnd;
    unordered_map<string,pair<string,int>> instructionTB =
    {{"ADD",make_pair("01",2)},{"SUB",make_pair("02",2)},{"MUL",make_pair("03",2)},{"MULT",make_pair("03",2)},
    {"DIV",make_pair("04",2)},{"JMP",make_pair("05",2)},{"JMPN",make_pair("06",2)},{"JMPP",make_pair("07",2)},
    {"JMPZ",make_pair("08",2)},{"COPY",make_pair("09",3)},{"LOAD",make_pair("10",2)},{"STORE",make_pair("11",2)},
    {"INPUT",make_pair("12",2)},{"OUTPUT",make_pair("13",2)},{"STOP",make_pair("14",2)}};
    if (file.is_open()) {
        if(extension == "asm"){
            ofstream outputFile(filename+outputExt);
            while (getline(file, line)) {
                auto pos = line.find(';');
                if (pos != std::string::npos){
                    line = line.substr(0,pos);
                }
                if(!line.empty() && !matchesPattern(line)){
                    transform(line.begin(), line.end(), line.begin(), ::toupper);
                    if(skipFlag){
                        skipFlag = false;
                        continue;
                    }
                    auto auxLab = line.find(':');
                    if(auxLab != std::string::npos &&
                    line.substr(auxLab+1,line.length()-1).find_first_not_of(line.substr(auxLab+1,line.length()-1)[0]) == std::string::npos){
                        auxLabel = line;
                        continue;
                    }
                    stringstream ss(auxLabel+" "+line);
                    auxLabel = "";
                    string word;
                    vector<std::string> words;
                    while (ss >> word) words.push_back(word);

                    for(int i=0;i<(int)words.size();i++){
                        if(words[i] == "IF"){
                            ifFlag = true;
                            if(stoi(directiveTB[words[i+1]]) == 0) skipFlag = true;
                        }
                        else if(words[i] == "EQU"){
                            equFlag = true;
                            directiveTB[words[i-1]] = words[i+1];
                        }
                        else if(words[i] == "CONST"){
                            directiveTB[words[i+1]] = constHxd(words[i+1]);
                        }
                    }
                    if(ifFlag){
                        ifFlag = false;
                        continue;
                    }
                    if(equFlag){
                        equFlag = false;
                        continue;
                    }
                    string pre_line = "";
                    for(int i=0;i<(int)words.size();i++){
                        string aux = words[i];
                        if(directiveTB.count(aux)) aux = directiveTB[aux];
                        if(i == (int)words.size()-1) pre_line += aux;
                        else pre_line += aux+" ";
                    }
                    if(pre_line == "SECTION DATA"){
                        dataFlag = true;
                        continue;
                    }
                    else if(pre_line == "SECTION TEXT"){
                        dataFlag = false;
                        continue;
                    }
                    else if(pre_line.substr(0,4) == "COPY"){
                        auto comma = pre_line.find(',');
                        string aux1 = pre_line.substr(4,comma-4), aux2 = pre_line.substr(comma+1,pre_line.length());
                        aux1.erase(remove(aux1.begin(), aux1.end(), ' '), aux1.end());
                        aux2.erase(remove(aux2.begin(), aux2.end(), ' '), aux2.end());
                        pre_line = "COPY "+aux1+','+aux2;
                    }
					else if(pre_line.substr(0,5) == "LOAD " && containsArithmeticOp(pre_line)){
                        size_t spacePos = pre_line.find(' ');
                        string operand = pre_line.substr(spacePos+1);
                        // Remove espaços do operando (pode conter expressão)
                        operand.erase(remove(operand.begin(), operand.end(), ' '), operand.end());
                        pre_line = "LOAD "+operand;
                    }
                    else if(pre_line.substr(0,6) == "STORE " && containsArithmeticOp(pre_line)){
                        size_t spacePos = pre_line.find(' ');
                        string operand = pre_line.substr(spacePos+1);
                        operand.erase(remove(operand.begin(), operand.end(), ' '), operand.end());
                        pre_line = "STORE "+operand;
                    }
                    else if(pre_line.substr(0,4) == "ADD " && containsArithmeticOp(pre_line)){
                        size_t spacePos = pre_line.find(' ');
                        string operand = pre_line.substr(spacePos+1);
                        operand.erase(remove(operand.begin(), operand.end(), ' '), operand.end());
                        pre_line = "ADD "+operand;
                    }
                    else if(pre_line.substr(0,4) == "SUB " && containsArithmeticOp(pre_line)){
                        size_t spacePos = pre_line.find(' ');
                        string operand = pre_line.substr(spacePos+1);
                        operand.erase(remove(operand.begin(), operand.end(), ' '), operand.end());
                        pre_line = "SUB "+operand;
                    }
                    else if((pre_line.substr(0,4) == "MUL " || pre_line.substr(0,5) == "MULT ") && containsArithmeticOp(pre_line)){
                        size_t spacePos = pre_line.find(' ');
                        string instr = pre_line.substr(0, spacePos);
                        string operand = pre_line.substr(spacePos+1);
                        operand.erase(remove(operand.begin(), operand.end(), ' '), operand.end());
                        pre_line = instr + " " + operand;
                    }
                    else if(pre_line.substr(0,4) == "DIV " && containsArithmeticOp(pre_line)){
                        size_t spacePos = pre_line.find(' ');
                        string operand = pre_line.substr(spacePos+1);
                        operand.erase(remove(operand.begin(), operand.end(), ' '), operand.end());
                        pre_line = "DIV "+operand;
                    }
                    else if(pre_line.substr(0,4) == "JMP " && containsArithmeticOp(pre_line)){
                        size_t spacePos = pre_line.find(' ');
                        string operand = pre_line.substr(spacePos+1);
                        operand.erase(remove(operand.begin(), operand.end(), ' '), operand.end());
                        pre_line = "JMP "+operand;
                    }
                    else if(pre_line.substr(0,5) == "JMPN " && containsArithmeticOp(pre_line)){
                        size_t spacePos = pre_line.find(' ');
                        string operand = pre_line.substr(spacePos+1);
                        operand.erase(remove(operand.begin(), operand.end(), ' '), operand.end());
                        pre_line = "JMPN "+operand;
                    }
                    else if(pre_line.substr(0,5) == "JMPP " && containsArithmeticOp(pre_line)){
                        size_t spacePos = pre_line.find(' ');
                        string operand = pre_line.substr(spacePos+1);
                        operand.erase(remove(operand.begin(), operand.end(), ' '), operand.end());
                        pre_line = "JMPP "+operand;
                    }
                    else if(pre_line.substr(0,5) == "JMPZ " && containsArithmeticOp(pre_line)){
                        size_t spacePos = pre_line.find(' ');
                        string operand = pre_line.substr(spacePos+1);
                        operand.erase(remove(operand.begin(), operand.end(), ' '), operand.end());
                        pre_line = "JMPZ "+operand;
                    }
                    auto lab = pre_line.find(':');
                    if (lab != std::string::npos){
                        string aux1 = pre_line.substr(0,lab), aux2 = pre_line.substr(lab,pre_line.length());
                        aux1.erase(remove(aux1.begin(), aux1.end(), ' '), aux1.end());
                        pre_line = aux1+aux2;
                    }
                    if(dataFlag) dataQueue.push(pre_line);
                    else outputFile << pre_line << endl;
                }
            }
            while(!dataQueue.empty()){
                string aux = dataQueue.front();
                dataQueue.pop();
                outputFile << aux << endl;
            }

            file.close();
            outputFile.close();
        }
        else if(extension == "pre"){
            ofstream outputFile(filename+outputExt);
            ofstream penFile(filename+".pen");
            int endCount = 0;
            map<int,string> pendingExpressions;
            while (getline(file, line)) {
                if(!line.empty()){
                    stringstream ss(line);
                    string word;
                    vector<std::string> words;
                    while (ss >> word) words.push_back(word);

                    for(int i=0;i<(int)words.size();i++){
                        if(words[i] == "IF"){
                            ifFlag = true;
                            if(stoi(directiveTB[words[i+1]]) == 0) skipFlag = true;
                        }
                        else if(words[i] == "EQU"){
                            equFlag = true;
                            directiveTB[words[i-1]] = words[i+1];
                        }
                        else if(words[i] == "CONST"){
                            directiveTB[words[i+1]] = constHxd(words[i+1]);
                        }
                    }
                    string obj_line = "";
                    string pen_line = "";
                    int endAux;
                    bool constSkip = false;
                    for(int i=0;i<(int)words.size();i++){
                        string aux = words[i];
                        auto pos = aux.find(':');
                        if (pos != std::string::npos){
                            if(symbolTB.count(aux.substr(0,pos))){
                                get<0>(symbolTB[aux.substr(0,pos)]) = endCount;
                                get<1>(symbolTB[aux.substr(0,pos)]) = true;
                                solvePen(symbolTB[aux.substr(0,pos)],objCodeEnd,pendingExpressions,
                                        aux.substr(0,pos),symbolTB);
                            }
                            else symbolTB[aux.substr(0,pos)] = make_tuple(endCount,true,"-1");
                            continue;
                        }
                        auto comma = aux.find(',');
                        if (comma != std::string::npos){
                            string p1 = aux.substr(0,comma),p2 = aux.substr(comma+1,aux.length()-1),auxp1,auxp2;

                            if(containsArithmeticOp(p1)){
                                int result = evaluateExpression(p1, symbolTB);
                                auxp1 = (result != -1) ? to_string(result) : "-1";
                                if(result == -1) pendingExpressions[endCount] = p1+","+p2;
                            }
                            else if(!isNumeric(p1) && symbolTB.count(p1)){
                                if(get<1>(symbolTB[p1])) auxp1 = to_string(get<0>(symbolTB[p1]));
                                else{
                                    auxp1 = get<2>((symbolTB[p1]));
                                    get<2>((symbolTB[p1])) = to_string(endCount+1);
                                }
                            }
                            else if(!isNumeric(p1) && symbolTB.count(p1) == 0){
                                symbolTB[p1] = make_tuple(-1,false,to_string(endCount+1));
                                auxp1 = "-1";
                            }
                            else {
                                auxp1 = p1;
                            }

                            if(containsArithmeticOp(p2)){
                                int result = evaluateExpression(p2, symbolTB);
                                auxp2 = (result != -1) ? to_string(result) : "-1";
                                if(result == -1) pendingExpressions[endCount] = p1+","+p2;
                            }
                            else if(!isNumeric(p2) && symbolTB.count(p2)){
                                if(get<1>(symbolTB[p2])) auxp2 = to_string(get<0>(symbolTB[p2]));
                                else{
                                    auxp2 = get<2>((symbolTB[p2]));
                                    get<2>((symbolTB[p2])) = to_string(endCount+2);
                                }
                            }
                            else if(!isNumeric(p2) && symbolTB.count(p2) == 0){
                                symbolTB[p2] = make_tuple(-1,false,to_string(endCount+2));
                                auxp2 = "-1";
                            }
                            else {
                                auxp2 = p2;
                            }

                            aux = auxp1+" "+auxp2;
                        }
                        else if (aux == "CONST"){
                            constSkip = true;
                            endAux = 1;
                        }
                        else if (aux == "SPACE"){
							if(i != (int)words.size()-1){
								int times = stoi(words[i+1]), spaceAux = endCount;
								for(int j=0;j<times;j++){
									objCodeEnd[spaceAux] = "00";
									penFile << "00 ";
									spaceAux++;
								}
								endAux = times;
								spaceFlag = true;
							}
                            else{
								aux = "00";
                            	endAux = 1;
							}
                        }
                        else if(instructionTB.count(words[i])){
                            pair<string,int> pair = instructionTB[words[i]];
                            aux = pair.first;
                            endAux = pair.second;
                        }
                        else if(!isNumeric(words[i]) && symbolTB.count(words[i])){
                            if(get<1>(symbolTB[words[i]])) aux = to_string(get<0>(symbolTB[words[i]]));
                            else{
                                aux = get<2>((symbolTB[words[i]]));
                                get<2>((symbolTB[words[i]])) = to_string(endCount+1);
                            }
                        }
                        else if(!isNumeric(words[i]) && symbolTB.count(words[i]) == 0){
                            if(containsArithmeticOp(words[i])){
                                int result = evaluateExpression(words[i], symbolTB);
                                if(result == -1){
                                    pendingExpressions[endCount] = words[i];
                                    aux = "-1";
                                } else {
                                    aux = to_string(result);
                                }
                            }
                            else{
                                symbolTB[aux] = make_tuple(-1,false,to_string(endCount+1));
                                aux = "-1";
                            }
                        }
                        if(constSkip){
                            constSkip = false;
                            continue;
                        }
						if(spaceFlag){
							spaceFlag = false;
							pen_line = "skip";
							break;
						}
                        if(i == (int)words.size()-1){
                            pen_line += aux;
                            obj_line += aux;
                        }
                        else{
                            pen_line += aux+" ";
                            obj_line += aux+" ";
                        }
                    }
					if(pen_line != "skip"){
						objCodeEnd[endCount] = obj_line;
						penFile << pen_line+" ";
					}
					endCount += endAux;
                }
            }
            for (const auto& [id, line] : objCodeEnd) {
                outputFile << line+" ";
            }
			penFile << endl << endl << "Lista de pendencias regulares" << endl;
			penFile << "Simbolo - Valor - Def - Lista" << endl;
			for (const auto& [id, symbol] : symbolTB) {
				penFile << id << " - " << get<0>(symbol) << " - " << get<1>(symbol) << " - " << get<2>(symbol) << endl;
			}
			if(!pendingExpressions.empty()){
				penFile << endl << "Lista de pendencias de expressões" << endl;
				penFile << "Simbolo - Lista" << endl;
				for (const auto& [id, endereco] : pendingExpressions) {
					penFile << endereco << " - " << id << endl;
				}
			}
            file.close();
            outputFile.close();
            penFile.close();
        }
        else if(extension == "obj"){
            while (getline(file, line)) {
                cout << line << endl;
            }
        }

    } else {
        cerr << "Unable to open file" << endl;
    }

    return 0;
}
