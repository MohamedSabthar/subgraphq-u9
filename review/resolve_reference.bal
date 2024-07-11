import ballerina/graphql.subgraph;

isolated function resolveProduct(subgraph:Representation representation) returns Product|error? {
    string id = check representation["id"].ensureType();
    lock {
        return products.hasKey(id) ? products.get(id).clone() : ();
    }
}
