#ifndef PARSE_TREE_H
#define PARSE_TREE_H

#include <string>
#include <vector>
#include "tree_node.h"


class ParseTree {

private:
    TreeNode* root;

public:
    //Constructor
    ParseTree() : root(nullptr) {}

    //Parser
    void parse(const std::string& input);

    //Print Tree
    void printTree() const;

    //Recursive helper function for parsing
    TreeNode* parseNode(const std::string& nodeContent);

    //Add Node
    void addNode(TreeNode* node);

};


#endif // PARSE_TREE_H