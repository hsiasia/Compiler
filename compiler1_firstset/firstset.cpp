#include<iostream>
#include<vector>
#include<cctype> //isupper(char)
#include<sstream>
#include<map>
#include<bits/stdc++.h> 

using namespace std;

string first(char name, string token);

map<char, string> mapPaser;
map<char, string> mapAns;
map<char, string>::iterator iter;

bool isTerminal(char c){
    bool special = (c == '!') || (c == '@') || (c == '#') || (c == '%') || (c == '^') || (c == '&') || (c == '*') || (c == '$') ;
    if( isupper(c) || special ) return true;
    else return false;
}

typedef struct{
    char name; //ex.s
    string token; //ex.abA
}Paser;

string deal_each_token_way(string token){// ex Da, cB -> c EF
    string ans;
    if(token == ";") ans = ";";
    else if(isTerminal(token[0])) ans.push_back(token[0]);
    else{
        for(int i = 0 ; i < token.length() ; i++){

            if(isTerminal(token[i])){
                ans.push_back(token[i]);
                break;
            }
            ans += first(token[i], mapPaser[token[i]]);

            string tempp = first(token[i], mapPaser[token[i]]);
            string::size_type check = tempp.find(";");

            bool flag = 0;
            for(int j = 0 ; j < tempp.length() ; j++){
                if(isTerminal(tempp[j])){
                    flag = 1;
                    break;
                }
            }

            //if no ; and have Teminal
            if(check == tempp.npos && flag == 1) break;
        }
    }

    if (ans[ans.length()-1] != ';') {
        string ans_;
        for (int i = 0; i < ans.length(); ++i) {
            if (ans[i] == ';') {
                continue;
            }
            ans_.push_back(ans[i]);
        }
        if (ans_.length() == 0) {
            ans_ = ";";
        }
        ans = ans_;
    }

    return ans;
}

string first(char name, string token){
    
    //find函数返回类型 size_type
    string::size_type check = token.find("|");

    string ans;

    if(token == ";") ans = ";";
    else if(check == token.npos){ //if not found
        string ttemp = deal_each_token_way(token);
        ans += ttemp;
    }
    else{
        vector<string> tt;
        string s = "";

        int j = 0;
        bool c = 0;
        while(j < token.length()){
            if(token[j] == '|'){
                tt.push_back(s);
                j++;
                s.clear();
                continue;
            } 
            s.push_back(token[j]);
            j++;
        }
        tt.push_back(s);

        //for(int i = 0 ; i < tt.size() ; i++) cout << tt[i] << endl;

        for(int i = 0 ; i < tt.size() ; i++){
            ans += deal_each_token_way(tt[i]);
        }

    }

    //mapAns[name] = ans;
    return ans;

}

string delete_mul(string s){

    string s1; //用来保存删除后的字符串
    
    int list[256]; //用来保存字符串s中所有字符的状态

    //初始化s中每个字符的状态，注意这里list数组的下标是用的s[i],事实上是s[i]的ASCII码
    for(int i = 0 ; i != s.size() ; i++) list[s[i]]=1;
    
    //将不重复的字符保存到s1中，保存过的字符状态设为0，状态为1的保存
    for(int i = 0 ; i != s.size() ; i++){
        if(list[s[i]]){
            list[s[i]] = 0;
            s1 += s[i];
        }
    }
    return s1;
}

void sortString(string &str){ 
   sort(str.begin(), str.end(), greater<char>()); 
   //cout << str; 
} 

int main(){

    string inputstr;
    vector<string> content;
    vector<Paser> paser;
    vector<Paser> correct_ans;

    char a;
    while((a = getchar()) != EOF){
        //cout<<"??? "<<inputstr<<endl;
        if(inputstr == "END_OF_GRAMMAR") break;
        else{
            if(a != '\r' && a != '\n') inputstr.push_back(a);
            else{
                content.push_back(inputstr);
                inputstr = ""; 
            }
        }
    }

    //for(int i = 0 ; i < content.size() ; i++) cout<<"!!! "<<content[i]<<endl;

    // last one is END_OF_GRAMMAR, no need to deal
    //content.push_back(inputstr);

    for(int i = 0 ; i < content.size() ; i++){

        //split with space
        string temp;
        for(int j = 2 ; j < content[i].length() ; j++) temp.push_back(content[i][j]);

        Paser p;
        p.name = content[i][0];
        p.token = temp;
        paser.push_back(p);

        mapPaser[content[i][0]] = temp;// for search correspond token
    }

    /*
    for(int i = 0 ; i < paser.size() ; i++){
        cout << paser[i].name << paser[i].token <<endl;
    }
    
    for(iter = mapPaser.begin(); iter != mapPaser.end(); iter++)
        cout<<iter->first<<" "<<iter->second<<endl;
    */

    //string ans = first(paser[2].name,paser[2].token);
    //cout<<ans<<endl;

    for(int i = 0 ; i < paser.size() ; i++){
        string ans = first(paser[i].name, paser[i].token);
        mapAns[paser[i].name] = ans;
    }

    /*
    for(iter = mapAns.begin(); iter != mapAns.end(); iter++)
        cout<<iter->first<<"?"<<iter->second<<endl;
    */

    //delete_mul characters & sort & save to correct_ans vector
    for(iter = mapAns.begin(); iter != mapAns.end(); iter++){
        //cout<<iter->first<<"."<<iter->second<<endl;

        mapAns[iter->first] = delete_mul(iter->second);

        sortString(mapAns[iter->first]);

        Paser tp;
        tp.name = iter->first;
        tp.token = iter->second;
        correct_ans.push_back(tp);
    }

    while (!correct_ans.empty()){
        cout << correct_ans.back().name << " " << correct_ans.back().token << endl;
        correct_ans.pop_back();
    }

    cout << "END_OF_FIRST" << endl;


}
