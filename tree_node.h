#ifndef TREE_NODE_H
#define TREE_NODE_H

#include <iostream>
#include <string>
#include <vector>
#include <map>
using namespace std;

class TreeNode {

public:

    string name;
    int weight;
    string parent;
    vector<TreeNode*> children;

    //Constructor
    TreeNode(const string& name, int weight, const string& parent)
        : name(name), weight(weight), parent(parent) {}

    void addChild(TreeNode* child) {
        children.push_back(child);
    }

    void print() {
        cout << "Name: " << name << " Weight: " << weight << " Parent: " << parent << endl;
        for (int i = 0; i < children.size(); i++) {
            children[i]->print();
        }
    }

    //Destructor
    ~TreeNode() {
        for (int i = 0; i < children.size(); i++) {
            delete children[i];
        }
    }

    string getParentName() const {
        return parent;
    }


};

#endif // TREE_NODE_H