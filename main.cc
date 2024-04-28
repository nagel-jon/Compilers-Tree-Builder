#include "parse_tree.h"

int main() {
    ParseTree tree;
    TreeNode* node1 = new TreeNode("node1", 1, "");
    TreeNode* node2 = new TreeNode("node2", 2, "node1");
    TreeNode* node3 = new TreeNode("node3", 3, "node1");

    tree.addNode(node1);
    tree.addNode(node2);
    tree.addNode(node3);

    tree.printTree();
    return 0;
}