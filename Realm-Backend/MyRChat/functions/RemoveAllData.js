exports = function(){
  const messageCollection = context.services.get("mongodb-atlas").db("RChat").collection("ChatMessage");
  const userCollection = context.services.get("mongodb-atlas").db("RChat").collection("User");
  
  console.log(`Looking to delete all Atlas data`);
  
  messageCollection.deleteMany({})
  .then( result => {
    console.log(`Deleted ${result.deletedCount} ChatMessage documents`);
  }, error => {
    console.log(`Failed to delete recent ChatMessage documents: ${error}`);
  });
  userCollection.deleteMany({})
  .then( result => {
    console.log(`Deleted ${result.deletedCount} User documents`);
  }, error => {
    console.log(`Failed to delete recent User documents: ${error}`);
  });
};