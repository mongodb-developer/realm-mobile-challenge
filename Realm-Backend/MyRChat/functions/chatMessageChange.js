exports = function(changeEvent) {
  if (changeEvent.operationType != "insert") {
    console.log(`ChatMessage ${changeEvent.operationType} event – currently ignored.`);
    return;
  }
  
  console.log(`ChatMessage Insert event being processed`);
  let userCollection = context.services.get("mongodb-atlas").db("RChat").collection("User");
  let chatMessage = changeEvent.fullDocument;
  let conversation = "";
  
  if (chatMessage.partition) {
    const splitPartition = chatMessage.partition.split("=");
    if (splitPartition.length == 2) {
      conversation = splitPartition[1];
      console.log(`Partition/conversation = ${conversation}`);
    } else {
      console.log("Couldn't extract the conversation from partition ${chatMessage.partition}");
      return;
    }
  } else {
    console.log("partition not set");
    return;
  }
};
