//
//  main.swift
//  CourseParser
//
//  Created by Maksim Tochilkin on 4/5/22.
//

import Foundation

struct Node: Decodable, Hashable {
    enum NodeType: String {
        case and, or
    }
    
    var type: NodeType
    var name: String = ""
    var children: [Node] = []
    
    enum CondingKeys: String, CodingKey {
        case type, children = "courses"
    }
    
    var leaf: Bool {
        return self.children.isEmpty
    }
    
    func satisfied(nodes: Set<Node>) -> Bool {
        if self.leaf {
            return nodes.contains(where: { $0.name == self.name})
        }
        
        if self.type == .or {
            return self.children.map { $0.satisfied(nodes: nodes) }.contains(true)
        } else {
            return self.children.allSatisfy { $0.satisfied(nodes: nodes) }
        }
    }
    
    func printNode() {
        print(getNodeDesc(node:self, offset: 0))
    }

    func getNodeDesc(node: Node, offset: Int) -> String {
        if node.children.isEmpty {
            return node.name + "\n"
        } else {
            var desc = node.type.rawValue + ":" + "\n"
            let strOffset = String(repeating: "  ", count: offset)
            for child in node.children {
                desc += strOffset + getNodeDesc(node: child, offset: offset + 1)
            }
            return desc
        }
    }



    func splitNode(node: Node) -> [Node] {
        precondition(node.type == .and)
        
        var nodes: [Node] = []
        for child in node.children {
            if child.type == .and {
                nodes += splitNode(node: child)
            } else {
                nodes.append(child)
            }
        }
        return nodes
    }
}

extension Node {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CondingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        self.type = NodeType(rawValue: type)!
        
        var childContainer = try container.nestedUnkeyedContainer(forKey: .children)
        
        while !childContainer.isAtEnd {
            if let courseName = try? childContainer.decodeIfPresent(String.self) {
                children.append(Node(type: .or, name: courseName, children: []))
            } else if let child = try? childContainer.decodeIfPresent(Node.self) {
                children.append(child)
            } else {
                throw DecodingError.typeMismatch(Node.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "courses[] contains item that is not a course, like ECE 2020 or another list of courses, like {{type : or}, {courses : [ECE 2020, ECE 3020]}}"))
            }
        }
    }
}




//func flatten(node: Node) -> Node {
//    var newChildren: [Node] = []
//
//    for child in node.children {
//        if child.children.isEmpty || child.type == .or {
//            newChildren.append(child)
//        } else {
//            newChildren += splitNode(node: child)
//        }
//    }
//
//    return Node(type: node.type, name: node.name, children: newChildren)
//}
