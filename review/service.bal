import ballerina/graphql;
import ballerina/graphql.subgraph;
import ballerina/uuid;

@subgraph:Subgraph
service /review on new graphql:Listener(4002) {
    resource function get reviews(string productId) returns Review[]|error {
        lock {
            if (!products.hasKey(productId)) {
                return error(string `No product found for the given product id: ${productId}`);
            }
            return products.get(productId).reviews.clone();
        }
    }

    remote function addReview(ReviewInput reviewInput) returns Review|error {
        readonly & ReviewInput revIn = reviewInput.cloneReadOnly();
        lock {
            if (!products.hasKey(revIn.productId)) {
                return error(string `No product found with product id: ${revIn.productId}`);
            }
            Review[] reviews = products.get(revIn.productId).reviews;
            Review review = {...revIn, id: uuid:createType1AsString()};
            reviews.push(review);
            return review.clone();
        }
    }
}
