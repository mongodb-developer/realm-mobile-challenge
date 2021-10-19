// This function is the webhook's request handler.
exports = function(payload, response) {
    const body = payload.body;
    const userCollection = context.services.get("mongodb-atlas").db("RChat").collection("User");
    const doc = EJSON.parse(payload.body.text());
    
    return userCollection.insertOne(doc)
    .then ( result => {
      console.log("Added User");
      response.setStatusCode(200);
      response.setBody("Sucessfully added User");
      return "Added User";
      
    }, error => {
      console.log(`Failed to insert User doc: ${error}`);
      response.setStatusCode(400);
      response.setBody(`Failed to insert User doc: ${error}`);
      return `Failed to insert User doc: ${error}`;
    });
};