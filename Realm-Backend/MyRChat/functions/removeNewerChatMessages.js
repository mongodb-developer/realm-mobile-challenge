exports = function(){
  const messageCollection = context.services.get("mongodb-atlas").db("RChat").collection("ChatMessage");
  const sixHours = 6 * 60 * 60 * 1000;
  const sixHoursAgo = new Date(Date.now() - sixHours);
  
  console.log(`Looking to delete ChatMessages with timestamp more recent than ${JSON.stringify(sixHoursAgo)}`);
  
  messageCollection.deleteMany({"timestamp": {$gt: sixHoursAgo}})
  .then( result => {
    console.log(`Deleted ${result.deletedCount} ChatMessage documents that were more recent than 6 hours ago`);
  }, error => {
    console.log(`Failed to delete recent ChatMessage documents: ${error}`);
  });
};