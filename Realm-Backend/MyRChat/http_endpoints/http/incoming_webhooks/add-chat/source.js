exports = function(payload, response) {
    const body = payload.body;
    const chatCollection = context.services.get("mongodb-atlas").db("RChat").collection("ChatMessage");
    const doc = EJSON.parse(payload.body.text());
    
    return chatCollection.insertOne(doc)
    .then ( result => {
      console.log("Added ChatMessage");
      response.setStatusCode(200);
      response.setBody("Sucessfully added ChatMessage");
      return "Added ChatMessage";
      
    }, error => {
      console.log(`Failed to insert ChatMessage doc: ${error}`);
      response.setStatusCode(400);
      response.setBody(`Failed to insert ChatMessage doc: ${error}`);
      return `Failed to insert ChatMessage doc: ${error}`;
    });
};