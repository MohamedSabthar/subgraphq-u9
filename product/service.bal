import ballerina/graphql;
import ballerina/graphql.subgraph;

@subgraph:Subgraph
service /product on new graphql:Listener(4001) {
    isolated resource function get product(string id) returns Product? {
        lock {
            return products.hasKey(id) ? products.get(id).clone() : (); 
        }
    }

    isolated resource function get products() returns Product[] {
        lock {
            return products.toArray().clone();
        }
    }
}
