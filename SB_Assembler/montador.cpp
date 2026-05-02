#include <bits/stdc++.h>
using namespace std;

string constHxd(string a){
    cout << a << endl;
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
    ofstream outputFile(filename+outputExt);

    string auxLabel = "";
    bool skipFlag = false, ifFlag = false, equFlag = false, dataFlag = false;
    unordered_map<string,string> symbolTB;
    queue<string> dataQueue;
    
    if (file.is_open()) {
        if(extension == "asm"){
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
                    if(line[line.length()-1] == ':'){
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
                            if(stoi(symbolTB[words[i+1]]) == 0) skipFlag = true;
                        }
                        else if(words[i] == "EQU"){
                            equFlag = true;
                            symbolTB[words[i-1]] = words[i+1];
                        }
                        else if(words[i] == "CONST"){
                            symbolTB[words[i+1]] = constHxd(words[i+1]);
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
                        if(symbolTB.count(aux)) aux = symbolTB[aux];
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
        }
        else if(extension == "pre"){
            cout << "ronaldo";
        }

    } else {
        cerr << "Unable to open file" << endl;
    }

    return 0;
}