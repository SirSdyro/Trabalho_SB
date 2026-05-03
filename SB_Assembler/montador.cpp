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

void solvePen(tuple<int,bool,string>& symbol, map<int,string>& objCodeEnd){
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
            for(int i=0;i<words.size();i++){
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
            for(int i=0;i<words.size();i++){
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
                else newLine += aux+" ";
            }
            objCodeEnd[end-1] = newLine;

        }
        end = newEnd;
        if(end == -1) break;
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
    bool skipFlag = false, ifFlag = false, equFlag = false, dataFlag = false;
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
                if(!line.empty()){
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

                    for(int i=0;i<words.size();i++){
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
                    for(int i=0;i<words.size();i++){
                        string aux = words[i];
                        if(directiveTB.count(aux)) aux = directiveTB[aux];
                        if(i == words.size()-1) pre_line += aux;
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
            while (getline(file, line)) {
                if(!line.empty()){
                    stringstream ss(line);
                    string word;
                    vector<std::string> words;
                    while (ss >> word) words.push_back(word);

                    for(int i=0;i<words.size();i++){
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
                    for(int i=0;i<words.size();i++){
                        string aux = words[i];
                        auto pos = aux.find(':');
                        if (pos != std::string::npos){
                            if(symbolTB.count(aux.substr(0,pos))){
                                get<0>(symbolTB[aux.substr(0,pos)]) = endCount;
                                get<1>(symbolTB[aux.substr(0,pos)]) = true;
                                solvePen(symbolTB[aux.substr(0,pos)],objCodeEnd);
                            }
                            else symbolTB[aux.substr(0,pos)] = make_tuple(endCount,true,"-1");
                            continue;
                        }
                        auto comma = aux.find(',');
                        if (comma != std::string::npos){
                            string p1 = aux.substr(0,comma),p2 = aux.substr(comma+1,aux.length()-1),auxp1,auxp2;
                            if(!isNumeric(p1) && symbolTB.count(p1)){
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
                            if(!isNumeric(p2) && symbolTB.count(p2)){
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
                            aux = auxp1+" "+auxp2;
                        }
                        else if (aux == "CONST"){
                            constSkip = true;
                            endAux = 1;
                        }
                        else if (aux == "SPACE"){
                            aux = "00";
                            endAux = 1;
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
                            symbolTB[aux] = make_tuple(-1,false,to_string(endCount+1));
                            aux = "-1";
                        }
                        if(constSkip){
                            constSkip = false;
                            continue;
                        }
                        if(i == words.size()-1){
                            pen_line += aux;
                            obj_line += aux;
                        }
                        else{
                            pen_line += aux+" ";
                            obj_line += aux+" ";
                        }
                    }
                    objCodeEnd[endCount] = obj_line;
                    penFile << "End "+to_string(endCount)+" "+pen_line << endl;
                    endCount += endAux;
                }
            }
            for (const auto& [id, line] : objCodeEnd) {
                outputFile << "End "+to_string(id)+" "+line << endl;
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