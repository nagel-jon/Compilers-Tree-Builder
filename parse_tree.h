#ifndef PARSE_TREE_H
#define PARSE_TREE_H

#include <string>
#include <vector>
#include <map>
using namespace std;
#include "tree_node.h"

class ParseTree {
public:
    // Constructor
    ParseTree() : root(nullptr) {}

    // Parser
    void parse(const std::string& input);

    TreeNode* getRoot() const {
        return root;
    }

    void addNode(TreeNode* node) {
        // Implementation of addNode function
        // ...
    }

    void printTree() const {
        // Implementation of printTree function
        // ...
    }

    // Recursive helper function for parsing
    TreeNode* parseNode(const std::string& nodeContent);

    // Find Node Via String Name
    TreeNode* findNode(const std::string& name) const;

    TreeNode* root;
    std::vector<TreeNode*> nodes;
};

#endif // PARSE_TREE_H

class ParseTree;







TreeNode* ParseTree::findNode(const string& name) const {
    for (const auto& node : nodes)
    {
        if (node->name == name)
        {
            return node;
        }
    }
    {

    }
    return nullptr;
}

void ParseTree::printTree() const {
    for (const auto& node : nodes)
    {
        cout << "Name: " << node->name << " Weight: " << node->weight << " Parent: " << node->parent << endl;
    }

}

void ParseTree::parse(const string& input) {
    istringstream iss(input);
    string line;
    while (getline(iss, line))
    {
        TreeNode* node = parseNode(line);
        addNode(node);
    }
}
//Store list of strings
class StringList {
public:
    char* string;
    StringList* next;
};


//Starting Class Delclarations of nested classes used to parse the grammar


//Evaluates expression to string
//Other classes will inherit from this
class Expression {
public:
    virtual string evaluate_expression(map<string, string>& symbol_table) = 0;
};





class Variable : public Expression {
public:
    Variable(char* integer_value) {
        saved_val = integer_value;
    }
    //overload evaulate_expression
    virtual string evaluate_expression(map<string, string>& symbol_table) {
        //find matching variable in symbol table
        map<string, string>::iterator it = symbol_table.find(saved_val);
        //if found, return value
        if (it != symbol_table.end()) {
            return it->second;
        }
        exit(-1);
    }

private:
    string saved_val;
};

//Problems with Overlaoding here
//When i change mapping type to string, 
//it breaks something, when i change to int it breaks something else
//issue with overloading/inheriting from Expression

class IntegerExpression {
public:
    virtual int evaluate_expression(map<string, string>& symbol_table) = 0;
};

class IntegerVariable : public IntegerExpression {
public:
    IntegerVariable(string integer_value) {
        saved_val = integer_value;
    }
    //overload evaulate_expression
    virtual int evaluate_expression(map<string, string>& symbol_table) {
        //find matching variable in symbol table
        map<string, string>::iterator it = symbol_table.find(saved_val);
        //if found, return value
        if (it != symbol_table.end()) {
            return stoi(it->second);        //convert string to int
        }
        else { return -1; }
    }
private:
    string saved_val;

};

class StringConstant : public Expression {
public:
    StringConstant(string value) { saved_val = value; }

    virtual string evaluate_expression(map<string, string>& symbol_table) {
        return saved_val;
    }
private:
    string saved_val;

};

class IntegerConstant : public IntegerExpression {
public:
    IntegerConstant(int value) { saved_val = value; }

    virtual int evaluate_expression(map<string, string>& symbol_table) {
        return saved_val;
    }
private:
    int saved_val;

};


//Plus Operator for Integer Expressions
class AdditionOperator : public IntegerExpression {
public:
    AdditionOperator(IntegerExpression* left, IntegerExpression* right) {
        left_operand = left;
        right_operand = right;
    }

    virtual int evaluate_expression(map<string, string>& symbol_table) {
        return left_operand->evaluate_expression(symbol_table) + right_operand->evaluate_expression(symbol_table);
    }
private:
    IntegerExpression* left_operand;
    IntegerExpression* right_operand;
};

//Plus Operator for String Expressions
class ConcatenationOperator : public Expression {
public:
    ConcatenationOperator(Expression* left, Expression* right) {
        left_operand = left;
        right_operand = right;
    }

    virtual string evaluate_expression(map<string, string>& symbol_table) {
        string left_string = left_operand->evaluate_expression(symbol_table);
        string right_string = right_operand->evaluate_expression(symbol_table);
        return left_string + right_string;
    }

private:
    Expression* left_operand;
    Expression* right_operand;

};


//End of Expression Classes
//Start of Statement Classes

class Statement {
public:
    //Needs to have Tree passed to it!!
    virtual void evaluate_statement(map<string, string>& symbol_table, ParseTree& tree) = 0;
};

//Classes Inheriting from Statement

class CompoundStatement : public Statement {
public:
    CompoundStatement(Statement* left, CompoundStatement* right) {
        left = left_statement;
        right = right_statement;
    }

    virtual void evaluate_statement(map<string, string>& symbol_table, ParseTree& tree) {
        if (left_statement != nullptr) {
            left_statement->evaluate_statement(symbol_table, tree);
        }

        if (right_statement != nullptr) {
            right_statement->evaluate_statement(symbol_table, tree);
        }
    }
private:
    Statement* left_statement;
    CompoundStatement* right_statement;
};


//Build Statement Class
class BuildStatement : public Statement {
public:
    BuildStatement(Expression* nameExpression, IntegerExpression* weightExpression, Expression* parentExpression = nullptr) {
        name = nameExpression;
        weight = weightExpression;
        parent = parentExpression;
    }

    virtual void evaluate_statement(map<string, string>& symbol_table, ParseTree& tree) {
        //Evaluate Expressions
        if (parent == NULL) {
            TreeNode* node = new TreeNode(name->evaluate_expression(symbol_table), weight->evaluate_expression(symbol_table), "");
            tree.addNode(node);
        }
        else {
            TreeNode* node = new TreeNode(name->evaluate_expression(symbol_table), weight->evaluate_expression(symbol_table), parent->evaluate_expression(symbol_table));
            tree.addNode(node);
        }
    }
private:
    Expression* name;
    IntegerExpression* weight;
    Expression* parent;
};

//For Statement, needs to be separate from for IN
class ForStatement : public Statement {
public:
    ForStatement(string variable, int start, int end, CompoundStatement* loop_body) {
        this->variable = variable;
        this->start = start;
        this->end = end;
        this->loop_body = loop_body;
    }

    virtual void evaluate_statement(map<string, string>& symbol_table, ParseTree& tree) {
        //Evaluate Expressions
        for (int i = start; i < end; i++) {
            symbol_table[variable] = to_string(i);
            loop_body->evaluate_statement(symbol_table, tree);
        }
        //remember to remove from table once evaluated
        symbol_table.erase(variable);
    }

private:
    string variable;
    int start;
    int end;
    CompoundStatement* loop_body;
};




class for_in_statement : public Statement {
public:
    for_in_statement(string variable, StringList* list, CompoundStatement* loop_body) {
        this->variable = variable;
        this->list = list;
        this->loop_body = loop_body;
    }
    virtual void evaluate_statement(map<string, string>& symbol_table, ParseTree& tree) {

        while (list != NULL) {
            symbol_table[variable] = list->string;
            loop_body->evaluate_statement(symbol_table, tree);
            list = list->next;
        }

    }
private:
    string variable;
    StringList* list;
    CompoundStatement* loop_body;
};





#endif // PARSE_TREE_H